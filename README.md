# diagrams-pgf-chinese

Claude Code skill/plugin for rendering Haskell `diagrams-pgf` diagrams that contain Chinese text.

The default workflow is non-invasive: it does not copy a `flake.nix`, Makefile, TeX wrapper, or template tree into the target project. The bundled render script creates the Nix environment and XeLaTeX wrapper in a temporary directory, then writes only the requested output files.

## Install

Add this repository as a Claude Code plugin marketplace, then install the plugin:

```sh
claude plugin marketplace add https://github.com/ayanamists/diagrams-pgf-chinese-skill
claude plugin install diagrams-pgf-chinese@diagrams-pgf-chinese-tools
```

For a local checkout, use the checkout path instead:

```sh
claude plugin marketplace add /path/to/diagrams-pgf-chinese-skill
claude plugin install diagrams-pgf-chinese@diagrams-pgf-chinese-tools
```

## Use

Ask Claude Code to use the installed skill:

```text
Use $diagrams-pgf-chinese to render diagram.hs with Chinese text.
```

The skill writes or updates a Haskell diagram source file such as:

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

Then it can render without adding project scaffolding:

```sh
${CLAUDE_SKILL_DIR}/scripts/render-diagrams-pgf.sh diagram.hs -o build/diagram.pdf --pgf build/diagram.pgf
```

## Requirements

- Nix with a usable `NIX_PATH` entry for `<nixpkgs>`, for example a nixpkgs channel
- Network or cache access for first-time dependency realization
- A Haskell `diagrams-pgf` source file using `mainWith`

The render environment includes GHC, `diagrams-pgf`, `ctex`, `pgf`, `standalone`, and XeLaTeX.

## Why This Exists

`diagrams-pgf` is useful when diagrams need reproducible, code-generated structure and LaTeX-quality output. It is a better fit than Mermaid or drawio for diagrams that should be parameterized, typechecked, or visually consistent with a paper.

Chinese text is handled through XeLaTeX and `ctex`. The skill intentionally avoids forcing external TTC font collection files by default, because XeTeX and the PDF driver can disagree about TTC face indexes.
