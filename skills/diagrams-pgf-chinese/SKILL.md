---
name: diagrams-pgf-chinese
description: Create and maintain Haskell diagrams-pgf diagrams that render Chinese text through PGF/XeLaTeX. Use when Codex needs to render PGF/PDF diagrams non-invasively, handle Chinese labels, use the bundled Nix-backed render script, or choose between diagrams-pgf, Mermaid, and drawio for code-generated diagrams.
---

# Diagrams PGF Chinese

Use this skill to produce code-generated diagrams with Haskell `diagrams-pgf` and compile them through XeLaTeX with `ctex`. Prefer it when the diagram needs LaTeX-quality vector output, paper-consistent typography, formulas, reproducible layout, or programmatic generation.

Keep the target repository non-invasive by default. Do not copy a `flake.nix`, TeX wrapper, Makefile, or template tree into a user project unless the user explicitly asks for committed project scaffolding.

Resolve the skill directory before running bundled scripts. In Codex this is normally `${CODEX_HOME:-$HOME/.codex}/skills/diagrams-pgf-chinese`; in Claude Code it may be exposed as `${CLAUDE_SKILL_DIR}`. Do not assume `CLAUDE_SKILL_DIR` exists in Codex.

## Quick Start

For a repo that already has a diagram source file, render it without adding Nix files:

```sh
"${CODEX_HOME:-$HOME/.codex}/skills/diagrams-pgf-chinese/scripts/render-diagrams-pgf.sh" diagram.hs -o build/diagram.pdf
```

The script creates a temporary Nix environment and TeX wrapper outside the repo. It writes only the requested output path. Use `--pgf build/diagram.pgf` when the intermediate PGF should be kept.

When creating a new diagram, add only a source file such as `diagram.hs` unless the user asks for more project files.

If a repo already has its own `flake.nix`, `Makefile`, or build system, integrate with that local convention instead of replacing it.

## Workflow

1. Write the diagram as Haskell. Annotate ambiguous diagrams with a concrete PGF type:

```haskell
import Diagrams.Backend.PGF
import Diagrams.Backend.PGF.CmdLine
import Diagrams.Prelude

dia :: Diagram PGF
dia = text "汉字测试" # fontSizeL 0.22
   <> roundedRect 2.4 0.8 0.08 # lwG 0.02

main :: IO ()
main = mainWith dia
```

2. Render non-invasively:

```sh
"${CODEX_HOME:-$HOME/.codex}/skills/diagrams-pgf-chinese/scripts/render-diagrams-pgf.sh" diagram.hs -o build/diagram.pdf --pgf build/diagram.pgf
```

3. If the user needs to embed the PGF manually, wrap it with XeLaTeX:

```tex
\documentclass[border=2pt]{standalone}
\usepackage{ctex}
\usepackage{pgf}
\begin{document}
\input{build/diagram.pgf}
\end{document}
```

4. Validate with an end-to-end build. For the bundled script:

```sh
"${CODEX_HOME:-$HOME/.codex}/skills/diagrams-pgf-chinese/scripts/render-diagrams-pgf.sh" diagram.hs -o build/diagram.pdf
```

When modifying this skill repository itself, run `benchmarks/run.sh` before declaring the change complete. The benchmark verifies Chinese rendering, PGF/PDF output, and non-invasive behavior.

## Chinese Text Rules

Use `ctex` with XeLaTeX as the default Chinese path. Do not start by forcing external Noto or Source Han TTC collection fonts unless the user explicitly needs a specific font.

If `xdvipdfmx` reports `Invalid TTC index number`, remove the explicit TTC font selection and let `ctex` use its default TeX Live font setup. TTC files are font collections; XeTeX may find them while the PDF driver fails to embed the selected face.

## Diagram Design Guidance

Use `diagrams-pgf` when layout should be reproducible, parameterized, typechecked, or paper-native. Use Mermaid for quick flowcharts with common syntax. Use drawio when manual visual editing and ad hoc layout are more important than reproducibility.

Keep the Haskell diagram small and compositional. Define reusable helpers for repeated boxes, arrows, and labels. Add type annotations early; many failures that look like backend problems are Haskell ambiguity errors.
