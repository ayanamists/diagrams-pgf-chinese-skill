#!/usr/bin/env sh
set -eu

usage() {
  echo "usage: $0 [--force] <target-directory>" >&2
}

force=0
if [ "${1:-}" = "--force" ]; then
  force=1
  shift
fi

if [ "$#" -ne 1 ]; then
  usage
  exit 2
fi

target=$1
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
skill_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
template_dir="$skill_dir/assets/diagrams-pgf-project"

mkdir -p "$target"

for name in flake.nix diagram.hs wrapper.tex Makefile; do
  src="$template_dir/$name"
  dst="$target/$name"
  if [ -e "$dst" ] && [ "$force" -ne 1 ]; then
    echo "refusing to overwrite $dst; rerun with --force" >&2
    exit 1
  fi
  cp "$src" "$dst"
done

mkdir -p "$target/build"
echo "Created diagrams-pgf Chinese project in $target"
echo "Build with: cd $target && nix develop path:\$PWD -c make"
