#!/usr/bin/env sh
set -eu

run_dir=${1:-}

fail() {
  printf 'usage: %s benchmarks/agent-baseline/runs/<run-id>\n' "$0" >&2
  exit 2
}

[ -n "$run_dir" ] || fail
[ -d "$run_dir" ] || fail

summary=$run_dir/scores.tsv
jsonl=$run_dir/scores.jsonl

printf 'task\tmarker\tdiagram_hs\tpdf\tpgf\tmarker_text\tchinese_text\tnon_invasive\tpass\n' > "$summary"
: > "$jsonl"

total=0
passed=0

for task_dir in "$run_dir"/task-*; do
  [ -d "$task_dir" ] || continue
  total=$((total + 1))

  marker=$(sed -n 's/^marker=//p' "$task_dir/task.env")
  task=$(basename "$task_dir")

  diagram_hs=0
  pdf=0
  pgf=0
  marker_text=0
  chinese_text=0
  non_invasive=0
  pass=0

  [ -s "$task_dir/diagram.hs" ] && diagram_hs=1
  [ -s "$task_dir/build/diagram.pdf" ] && pdf=1
  [ -s "$task_dir/build/diagram.pgf" ] && pgf=1

  if [ "$pgf" -eq 1 ] && grep -q "$marker" "$task_dir/build/diagram.pgf"; then
    marker_text=1
  fi

  if [ "$pgf" -eq 1 ] && python3 - "$task_dir/build/diagram.pgf" <<'PY'
import sys
text = open(sys.argv[1], encoding="utf-8", errors="ignore").read()
raise SystemExit(0 if any("\u4e00" <= ch <= "\u9fff" for ch in text) else 1)
PY
  then
    chinese_text=1
  fi

  if ! find "$task_dir" -maxdepth 1 \( -name flake.nix -o -name Makefile -o -name wrapper.tex \) | grep -q .; then
    non_invasive=1
  fi

  if [ "$diagram_hs" -eq 1 ] &&
     [ "$pdf" -eq 1 ] &&
     [ "$pgf" -eq 1 ] &&
     [ "$marker_text" -eq 1 ] &&
     [ "$chinese_text" -eq 1 ] &&
     [ "$non_invasive" -eq 1 ]; then
    pass=1
    passed=$((passed + 1))
  fi

  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$task" "$marker" "$diagram_hs" "$pdf" "$pgf" "$marker_text" "$chinese_text" "$non_invasive" "$pass" \
    >> "$summary"

  printf '{"task":"%s","marker":"%s","diagram_hs":%s,"pdf":%s,"pgf":%s,"marker_text":%s,"chinese_text":%s,"non_invasive":%s,"pass":%s}\n' \
    "$task" "$marker" "$diagram_hs" "$pdf" "$pgf" "$marker_text" "$chinese_text" "$non_invasive" "$pass" \
    >> "$jsonl"
done

printf 'passed=%s\ntotal=%s\n' "$passed" "$total" > "$run_dir/summary.env"
printf 'PASS %s/%s\n' "$passed" "$total"
