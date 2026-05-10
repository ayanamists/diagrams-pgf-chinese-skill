# Micro Benchmark

This benchmark checks the deterministic parts of the skill. It is intentionally small and fast enough to run before changing the skill.

It is not a full aesthetic benchmark. It catches regressions in:

- Rendering Haskell `diagrams-pgf` sources through the bundled script
- Preserving Chinese labels in the generated PGF
- Producing non-empty PDF and PGF outputs
- Avoiding invasive project files such as `flake.nix`, `Makefile`, or `wrapper.tex`

Run from the repository root:

```sh
benchmarks/run.sh
```

Pass criteria:

1. Every case renders successfully.
2. `build/diagram.pdf` and `build/diagram.pgf` are non-empty.
3. The generated PGF contains the expected Chinese marker text.
4. The case workspace has no copied scaffold files.

Future visual benchmarks should add PNG rendering plus a small rubric for typography, hierarchy, density, alignment, and print suitability.
