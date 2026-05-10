# Baseline Notes

## 2026-05-10 Partial Run

Condition:

- Claude Code `sonnet`
- Current installed `diagrams-pgf-chinese` renderer skill
- No design-oriented diagram skill
- Runner: `run-claude.sh`
- Run id: `claude-sonnet-skill-0.1.0-20260510`

Execution result before manual stop:

- Completed/scored tasks: 8
- Execution pass: 7/8
- Failed task: `task-08-bert`, stopped before artifacts were produced

Observed visual quality:

- The generated diagrams are mostly execution successes, not design successes.
- Common weaknesses: weak hierarchy, ad hoc spacing, literal box-and-arrow layouts, connector clutter, labels that feel mechanically placed, and little evidence of paper-figure composition.
- This confirms the renderer skill is a useful baseline but not enough for an Anthropic frontend-design-like diagram skill.

Implication:

- Keep `score-run.sh` as the non-regression gate for rendering and Chinese text.
- Use `visual-rubric.md` as the quality target for the future design skill.
- Compare future skill runs against both execution pass rate and visual-rubric score.
