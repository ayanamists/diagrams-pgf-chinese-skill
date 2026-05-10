# Agent Baseline

This directory defines the agent-style baseline for the installed `diagrams-pgf-chinese` skill.

The deterministic smoke test in `../run.sh` checks the renderer with a fixed diagram source. This baseline is different: it asks Claude Code to act as an agent, use the currently installed skill, create a fresh diagram for each of the 20 paper-figure tasks, render it, and leave auditable artifacts.

## Method

- **Task set:** `tasks.tsv` contains 20 paper-derived diagram tasks, including 4 PL/compiler tasks.
- **Paper briefs:** `briefs/` gives each task enough local context to draw the intended concept: paper purpose, figure role, concepts, relationships, Chinese labels, and design notes.
- **Environment:** each task runs in an isolated workspace under `runs/<run-id>/task-XX-*`.
- **Skill condition:** the runner loads this checkout as a Claude Code plugin and points `CLAUDE_SKILL_DIR` at the current skill directory. The prompt explicitly asks Claude to use `$diagrams-pgf-chinese`.
- **Allowed work:** Claude may create `diagram.hs`, run the bundled render script, and iterate until `build/diagram.pdf` and `build/diagram.pgf` exist.
- **Execution scoring:** `score-run.sh` uses execution artifacts, not the model's self-report. It checks source, PDF, PGF, marker text, Chinese text, and non-invasive behavior.
- **Visual scoring:** `visual-rubric.md` is the separate quality rubric for hierarchy, spacing, typography, line routing, density, and paper fit.
- **Artifacts:** each task keeps the prompt, Claude stream log, stderr log, generated source, rendered files, and score summary.

This follows the common agent-benchmark shape: fixed tasks, real tool use in a controlled environment, execution-based scoring, preserved trajectories, and repeatable runs. Use multiple run ids with the same tasks when measuring reliability.

The current renderer skill baseline is expected to pass some execution checks while producing weak visual results. That is the point of this baseline: it separates "can render" from "can design a paper-quality figure".

Do not reduce a task to only a one-line topology prompt. The brief is part of the benchmark input because paper figures depend on domain context, not just shape vocabulary.

## Run

From the repository root:

```sh
benchmarks/agent-baseline/run-claude.sh
```

Score an existing run:

```sh
benchmarks/agent-baseline/score-run.sh benchmarks/agent-baseline/runs/<run-id>
```

Useful environment variables:

- `CLAUDE_MODEL=sonnet` selects the Claude model alias.
- `MAX_TASKS=3` runs only the first three tasks for a cheap smoke run.
- `RUN_ID=my-run` sets the output directory name.
- `CLAUDE_MAX_BUDGET_USD=2` sets the per-invocation Claude budget.
- `PREPARE_ONLY=1` writes task prompts without invoking Claude.

Run outputs are intentionally ignored by git; commit a compact metrics summary only after inspecting a run.
