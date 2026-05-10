#!/usr/bin/env sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
render_script=$root/skills/diagrams-pgf-chinese/scripts/render-diagrams-pgf.sh
cases_dir=$root/benchmarks/cases

tmp_root=$(mktemp -d "${TMPDIR:-/tmp}/diagrams-pgf-chinese-bench.XXXXXX")

cleanup() {
  if [ "${KEEP_BENCH_WORKDIR:-0}" = "1" ]; then
    printf 'Keeping benchmark workdir: %s\n' "$tmp_root"
  else
    rm -rf "$tmp_root"
  fi
}
trap cleanup EXIT INT TERM

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

assert_file_nonempty() {
  [ -s "$1" ] || fail "missing or empty file: $1"
}

assert_no_scaffold() {
  workdir=$1
  if find "$workdir" -maxdepth 1 \( -name flake.nix -o -name Makefile -o -name wrapper.tex \) | grep -q .; then
    fail "scaffold file copied into $workdir"
  fi
}

run_case() {
  case_name=$1
  shift
  src_dir=$cases_dir/$case_name
  workdir=$tmp_root/$case_name

  [ -f "$src_dir/diagram.hs" ] || fail "case source missing: $src_dir/diagram.hs"

  mkdir -p "$workdir"
  cp "$src_dir/diagram.hs" "$workdir/diagram.hs"

  printf 'case: %s\n' "$case_name"
  (
    cd "$workdir"
    "$render_script" diagram.hs -o build/diagram.pdf --pgf build/diagram.pgf -w 1200
  )

  assert_file_nonempty "$workdir/build/diagram.pdf"
  assert_file_nonempty "$workdir/build/diagram.pgf"
  for marker in "$@"; do
    grep -q "$marker" "$workdir/build/diagram.pgf" ||
      fail "marker not found in generated PGF for $case_name: $marker"
  done
  assert_no_scaffold "$workdir"
}

run_case paper-figure-corpus \
  "egg" \
  "Build Systems" \
  "MLIR" \
  "LLVM" \
  "Transformer" \
  "ResNet" \
  "U-Net" \
  "BERT" \
  "AlphaFold" \
  "MapReduce" \
  "Raft" \
  "D3" \
  "PRISMA 2020" \
  "CONSORT 2010" \
  "EBM-DPSER" \
  "EGT" \
  "WASH" \
  "DTx RWE" \
  "UFIT" \
  "NASSS" \
  "等式饱和" \
  "编译器流水线" \
  "注意力架构" \
  "综述流程" \
  "多域框架"

printf 'PASS: diagrams-pgf-chinese micro-benchmark\n'
