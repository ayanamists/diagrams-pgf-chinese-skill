# Micro Benchmark

This benchmark checks the deterministic parts of the skill. It is intentionally small and fast enough to run before changing the skill.

The runnable case is grounded in `references/paper-figure-corpus.md`, a 20-paper corpus of figure references, including at least three programming-languages papers. The benchmark does not copy the source figures; it renders a compact topology suite inspired by their paper-figure structures.

It is not a full aesthetic benchmark. It catches regressions in:

- Rendering a Haskell `diagrams-pgf` paper-figure corpus through the bundled script
- Exercising Chinese labels while using paper-like topology markers
- Preserving text labels in the generated PGF
- Producing non-empty PDF and PGF outputs
- Avoiding invasive project files such as `flake.nix`, `Makefile`, or `wrapper.tex`

Run from the repository root:

```sh
benchmarks/run.sh
```

Pass criteria:

1. Every case renders successfully.
2. `build/diagram.pdf` and `build/diagram.pgf` are non-empty.
3. The generated PGF contains the expected paper-corpus marker text.
4. The case workspace has no copied scaffold files.

Future visual benchmarks should add PNG rendering plus a small rubric for typography, hierarchy, density, alignment, and print suitability.

For agent-level evaluation of the installed skill, see `agent-baseline/`. That harness asks Claude Code to solve the 20 paper-derived tasks in isolated workspaces and scores execution artifacts separately from visual quality.
