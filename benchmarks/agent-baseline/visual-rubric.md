# Visual Rubric

`score-run.sh` is an execution gate. It answers: did the agent create a Haskell source file, render PDF/PGF, preserve marker text, preserve Chinese text, and avoid invasive scaffold files?

It does not answer whether the diagram is good. Use this rubric to score rendered PDFs when comparing the current renderer skill baseline against a future design-oriented skill.

Score each dimension from 0 to 2:

- `0`: fails or distracts from the diagram's purpose
- `1`: usable but visibly weak
- `2`: paper-ready for a compact explanatory figure

## Dimensions

1. **Semantic Fidelity**  
   The topology matches the paper-derived pattern without copying the original figure.

2. **Hierarchy**  
   Titles, major nodes, secondary labels, and annotations have clear visual priority.

3. **Layout Discipline**  
   Nodes align to a visible grid; spacing is consistent; related items are grouped.

4. **Line Routing**  
   Arrows and connectors avoid avoidable crossings, ambiguous attachment points, and dead-end visual paths.

5. **Density Control**  
   The figure is compact but not cramped; labels have enough room; no element feels pasted in.

6. **Typography**  
   English, Chinese, and symbolic labels are readable, consistently sized, and not competing with structural marks.

7. **Paper Fit**  
   The figure looks appropriate for a technical paper: restrained palette, high contrast, reproducible vector output, and no decorative noise.

## Interpretation

- `0-5`: execution-only success; visually poor baseline.
- `6-10`: usable sketch; still needs design iteration.
- `11-14`: strong paper-style figure.

The current renderer skill is expected to score poorly here because it teaches rendering mechanics, not visual judgment. A frontend-design-like diagram skill should improve this rubric without reducing execution pass rate.
