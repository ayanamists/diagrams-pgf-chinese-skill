#!/usr/bin/env sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
baseline_dir=$root/benchmarks/agent-baseline
tasks_file=$baseline_dir/tasks.tsv
skill_dir=$root/skills/diagrams-pgf-chinese
model=${CLAUDE_MODEL:-sonnet}
run_id=${RUN_ID:-$(date -u +%Y%m%dT%H%M%SZ)}
run_dir=$baseline_dir/runs/$run_id
max_tasks=${MAX_TASKS:-}
budget=${CLAUDE_MAX_BUDGET_USD:-2}

mkdir -p "$run_dir"

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

[ -f "$tasks_file" ] || fail "missing tasks file: $tasks_file"
[ -d "$skill_dir" ] || fail "missing skill directory: $skill_dir"

cat > "$run_dir/run.env" <<EOF
RUN_ID=$run_id
CLAUDE_MODEL=$model
CLAUDE_MAX_BUDGET_USD=$budget
SKILL_DIR=$skill_dir
EOF

task_count=0
tail -n +2 "$tasks_file" | while IFS="$(printf '\t')" read -r id marker category title page pattern; do
  [ -n "$id" ] || continue
  task_count=$((task_count + 1))
  if [ -n "$max_tasks" ] && [ "$task_count" -gt "$max_tasks" ]; then
    break
  fi

  slug=$(printf '%s' "$marker" | tr '[:upper:] ' '[:lower:]-' | tr -cd '[:alnum:]-')
  task_dir=$run_dir/task-$id-$slug
  mkdir -p "$task_dir"

  cat > "$task_dir/task.env" <<EOF
id=$id
marker=$marker
category=$category
title=$title
page=$page
pattern=$pattern
EOF

  cat > "$task_dir/prompt.md" <<EOF
Use \$diagrams-pgf-chinese.

You are running an agent benchmark task for the currently installed diagrams-pgf Chinese rendering skill. Work in the current directory only.

Create a Haskell \`diagrams-pgf\` source file at \`diagram.hs\` and render it to:

- \`build/diagram.pdf\`
- \`build/diagram.pgf\`

Use the installed skill's non-invasive render workflow. Do not create \`flake.nix\`, \`Makefile\`, \`wrapper.tex\`, or copied project scaffolding in this workspace.

Paper task:

- ID: $id
- Marker that must appear in the diagram: $marker
- Category: $category
- Title: $title
- Source page: $page
- Figure pattern to simplify: $pattern

Diagram requirements:

- Do not copy the original figure. Draw a simplified topology sketch inspired by the pattern.
- Include the exact marker text \`$marker\`.
- Include at least one meaningful Chinese label or subtitle.
- Keep the result readable as a compact paper-style diagram.
- Use only code and local rendering; no external images or network fetching.
- Iterate until both requested output files exist and are non-empty.

When finished, briefly state the files created.
EOF

  printf 'task %s: %s\n' "$id" "$marker"
  (
    cd "$task_dir"
    CLAUDE_SKILL_DIR=$skill_dir claude -p \
      --no-session-persistence \
      --plugin-dir "$root" \
      --add-dir "$skill_dir" \
      --permission-mode bypassPermissions \
      --model "$model" \
      --max-budget-usd "$budget" \
      --verbose \
      --output-format stream-json \
      < prompt.md \
      > claude-stream.jsonl \
      2> claude-stderr.log
  ) || printf 'task %s failed during Claude run; scoring will record artifacts\n' "$id" >&2
done

"$baseline_dir/score-run.sh" "$run_dir"
printf 'baseline run: %s\n' "$run_dir"
