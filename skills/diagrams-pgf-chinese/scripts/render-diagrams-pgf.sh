#!/usr/bin/env sh
set -eu

usage() {
  cat >&2 <<'EOF'
usage: render-diagrams-pgf.sh [options] [diagram.hs]

Render a Haskell diagrams-pgf source file to PDF without adding Nix files to the
target project.

Options:
  -o, --output PDF     PDF output path (default: build/diagram.pdf)
      --pgf PGF        also copy the generated PGF to this path
  -w, --width WIDTH    diagrams-pgf width argument (default: 420)
  -h, --help           show this help
EOF
}

source_file=diagram.hs
output_pdf=build/diagram.pdf
output_pgf=
width=420

while [ "$#" -gt 0 ]; do
  case "$1" in
    -o|--output)
      [ "$#" -ge 2 ] || { usage; exit 2; }
      output_pdf=$2
      shift 2
      ;;
    --pgf)
      [ "$#" -ge 2 ] || { usage; exit 2; }
      output_pgf=$2
      shift 2
      ;;
    -w|--width)
      [ "$#" -ge 2 ] || { usage; exit 2; }
      width=$2
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo "unknown option: $1" >&2
      usage
      exit 2
      ;;
    *)
      source_file=$1
      shift
      ;;
  esac
done

case "$source_file" in
  /*) source_abs=$source_file ;;
  *) source_abs=$(pwd)/$source_file ;;
esac

case "$output_pdf" in
  /*) pdf_abs=$output_pdf ;;
  *) pdf_abs=$(pwd)/$output_pdf ;;
esac

if [ ! -f "$source_abs" ]; then
  echo "source file not found: $source_abs" >&2
  exit 1
fi

pdf_dir=$(dirname "$pdf_abs")
mkdir -p "$pdf_dir"

if [ -n "$output_pgf" ]; then
  case "$output_pgf" in
    /*) pgf_abs=$output_pgf ;;
    *) pgf_abs=$(pwd)/$output_pgf ;;
  esac
  mkdir -p "$(dirname "$pgf_abs")"
fi

tmpdir=$(mktemp -d)
cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT INT TERM

cat > "$tmpdir/wrapper.tex" <<'EOF'
\documentclass[border=2pt]{standalone}
\usepackage{ctex}
\usepackage{pgf}

\begin{document}
\input{diagram.pgf}
\end{document}
EOF

nix_expr='
let
  pkgs = import <nixpkgs> {};
  haskellEnv = pkgs.haskellPackages.ghcWithPackages (ps: with ps; [
    diagrams
    diagrams-contrib
    diagrams-lib
    diagrams-pgf
  ]);
  texEnv = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-small;
    inherit (pkgs.texlivePackages)
      ctex
      dvisvgm
      latexmk
      pgf
      preview
      standalone
      xecjk
      xetex
      ;
  };
in
pkgs.buildEnv {
  name = "diagrams-pgf-chinese-env";
  paths = [
    haskellEnv
    pkgs.bash
    pkgs.coreutils
    texEnv
  ];
}
'

export DIAGRAM_SOURCE=$source_abs
export DIAGRAM_WIDTH=$width
export DIAGRAM_WORKDIR=$tmpdir

if ! nix shell --impure --expr "$nix_expr" -c sh -c '
  set -eu
  runghc "$DIAGRAM_SOURCE" -o "$DIAGRAM_WORKDIR/diagram.pgf" -w "$DIAGRAM_WIDTH"
  cd "$DIAGRAM_WORKDIR"
  xelatex -halt-on-error -interaction=batchmode wrapper.tex
'; then
  if [ -f "$tmpdir/wrapper.log" ]; then
    cat "$tmpdir/wrapper.log" >&2
  fi
  exit 1
fi

cp "$tmpdir/wrapper.pdf" "$pdf_abs"

if [ -n "${pgf_abs:-}" ]; then
  cp "$tmpdir/diagram.pgf" "$pgf_abs"
fi

echo "Wrote $pdf_abs"
