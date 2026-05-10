---
name: diagrams-pgf-chinese
description: Create and maintain Haskell diagrams-pgf diagrams that render Chinese text through PGF/XeLaTeX. Use when Codex needs to set up a Nix-backed diagrams-pgf environment, generate PGF/PDF diagrams for papers, render labels containing Chinese characters, or choose between diagrams-pgf, Mermaid, and drawio for code-generated diagrams.
---

# Diagrams PGF Chinese

Use this skill to produce code-generated diagrams with Haskell `diagrams-pgf` and compile them through XeLaTeX with `ctex`. Prefer it when the diagram needs LaTeX-quality vector output, paper-consistent typography, formulas, reproducible layout, or programmatic generation.

## Quick Start

For a new project, run the bundled initializer from the skill directory:

```sh
${CLAUDE_SKILL_DIR}/scripts/init-diagrams-pgf-project.sh /path/to/project
```

It copies a working template containing:

- `flake.nix`: GHC with `diagrams-pgf`, plus XeLaTeX/PGF/CTeX.
- `diagram.hs`: minimal Haskell diagram with Chinese text.
- `wrapper.tex`: `standalone + ctex + pgf` wrapper for the generated PGF.
- `Makefile`: `make` builds `build/diagram.pgf` and `build/diagram.pdf`.

For an existing repo, copy only the files that match the local conventions. Keep user files and unrelated build systems untouched.

## Workflow

1. Ensure the project has a working Nix shell with `diagrams-pgf`, `xelatex`, `ctex`, `pgf`, and `standalone`. Reuse `assets/diagrams-pgf-project/flake.nix` when no local Nix convention exists.
2. Write the diagram as Haskell and render to `.pgf`, not directly to bitmap. Annotate ambiguous diagrams with a concrete PGF type:

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

3. Wrap the generated PGF with XeLaTeX:

```tex
\documentclass[border=2pt]{standalone}
\usepackage{ctex}
\usepackage{pgf}
\begin{document}
\input{build/diagram.pgf}
\end{document}
```

4. Validate with an end-to-end build:

```sh
nix develop -c make
```

If the flake files are new and the project is a Git repo, `nix develop` may not see untracked files. Use `nix develop path:$PWD -c make` until the files are added to Git.

## Chinese Text Rules

Use `ctex` with XeLaTeX as the default Chinese path. Do not start by forcing external Noto or Source Han TTC collection fonts unless the user explicitly needs a specific font.

If `xdvipdfmx` reports `Invalid TTC index number`, remove the explicit TTC font selection and let `ctex` use its default TeX Live font setup. TTC files are font collections; XeTeX may find them while the PDF driver fails to embed the selected face.

## Diagram Design Guidance

Use `diagrams-pgf` when layout should be reproducible, parameterized, typechecked, or paper-native. Use Mermaid for quick flowcharts with common syntax. Use drawio when manual visual editing and ad hoc layout are more important than reproducibility.

Keep the Haskell diagram small and compositional. Define reusable helpers for repeated boxes, arrows, and labels. Add type annotations early; many failures that look like backend problems are Haskell ambiguity errors.
