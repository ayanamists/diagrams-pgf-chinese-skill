# Paper Figure Corpus

This corpus grounds the benchmark in figures from papers instead of examples invented for this repository. The benchmark does not copy the original figures. It records each source figure and renders a small simplified topology inspired by that figure, so regressions are tested against paper-like diagram patterns while avoiding reuse of copyrighted artwork.

At least three entries are programming-languages, compilers, or program-analysis papers; these are marked `[PL]`.

## Sources

1. **[PL] egg: Fast and Extensible Equality Saturation**
   Page: https://arxiv.org/abs/2004.03082
   Figure: paper examples of equality saturation with e-graphs and rewrite rules.
   Pattern: expression-to-e-graph pipeline with rewrite and analysis side nodes.

2. **[PL] Build Systems a la Carte**
   Page: https://arxiv.org/abs/1802.05365
   Figure: build dependency examples and scheduler/store structure.
   Pattern: task dependency DAG plus scheduler/store relation.

3. **[PL] MLIR: A Compiler Infrastructure for the End of Moore's Law**
   Page: https://arxiv.org/abs/2002.11054
   Figure: MLIR compiler/dialect organization diagrams.
   Pattern: stacked dialect/lowering layers.

4. **[PL] LLVM: A Compilation Framework for Lifelong Program Analysis & Transformation**
   Page: https://llvm.org/pubs/2004-01-30-CGO-LLVM.html
   Figure: LLVM compiler framework overview.
   Pattern: front end, IR, optimizer, and target back end pipeline.

5. **Attention Is All You Need**
   Page: https://arxiv.org/abs/1706.03762
   Figure: Figure 1, Transformer model architecture.
   Pattern: encoder-decoder architecture with input/output embeddings.

6. **Deep Residual Learning for Image Recognition**
   Page: https://openaccess.thecvf.com/content_cvpr_2016/html/He_Deep_Residual_Learning_CVPR_2016_paper.html
   Figure: residual learning block.
   Pattern: sequential convolution blocks with identity skip connection.

7. **U-Net: Convolutional Networks for Biomedical Image Segmentation**
   Page: https://arxiv.org/abs/1505.04597
   Figure: U-Net architecture.
   Pattern: symmetric encoder-decoder path with skip connection.

8. **BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding**
   Page: https://arxiv.org/abs/1810.04805
   Figure: pre-training and fine-tuning overview.
   Pattern: token encoder feeding multiple training objectives.

9. **Highly accurate protein structure prediction with AlphaFold**
   Page: https://www.nature.com/articles/s41586-021-03819-2
   Figure: AlphaFold network and structure-module overview.
   Pattern: sequence/MSA input, trunk processing, and structure output.

10. **MapReduce: Simplified Data Processing on Large Clusters**
    Page: https://research.google/pubs/mapreduce-simplified-data-processing-on-large-clusters/
    Figure: execution overview.
    Pattern: input, map, shuffle, reduce, and master coordination.

11. **In Search of an Understandable Consensus Algorithm**
    Page: https://raft.github.io/raft.pdf
    Figure: Raft server states.
    Pattern: follower, candidate, and leader state machine.

12. **D3: Data-Driven Documents**
    Page: https://doi.org/10.1109/TVCG.2011.185
    Figure: D3 data binding and document transformation concepts.
    Pattern: data, join, DOM, and view pipeline.

13. **PRISMA 2020 statement**
    Page: https://journals.plos.org/plosmedicine/article/figure?id=10.1371/journal.pmed.1003583.g001
    Figure: Fig 1, PRISMA 2020 flow diagram template for systematic reviews.
    Pattern: lane-based screening flowchart with exclusions and final inclusion.

14. **CONSORT 2010 Statement**
    Page: https://journals.plos.org/plosmedicine/article?id=10.1371/journal.pmed.1000251
    Figure: participant flow diagram.
    Pattern: assessed, randomized, allocated, and analyzed trial flow.

15. **The EBM-DPSER Conceptual Model**
    Page: https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0070766
    Figure: Figure 2, the EBM-DPSER model.
    Pattern: causal chain with ecosystem-services emphasis and feedback response.

16. **Engaging in the Good with Technology**
    Page: https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2023.1175740/full
    Figure: Figure 1, Engagement in the Good with Technology framework.
    Pattern: triadic model with a central technology-use node.

17. **The Applications of Implementation Science in WASH Research and Practice**
    Page: https://pmc.ncbi.nlm.nih.gov/articles/PMC8207965/
    Figure: Figure 1, conceptual framework of implementation science research.
    Pattern: staged implementation pipeline from intervention to population impact.

18. **The Digital Therapeutics Real-World Evidence Framework**
    Page: https://pmc.ncbi.nlm.nih.gov/articles/PMC10951831/
    Figure: Figure 1, digital therapeutics real-world evidence framework flowchart.
    Pattern: lifecycle phases with decision/review nodes.

19. **User-Centered Framework for Implementation of Technology (UFIT)**
    Page: https://pmc.ncbi.nlm.nih.gov/articles/PMC11150893/
    Figure: Figure 1, conceptual integration of models and theories.
    Pattern: central user-centered design node connected to surrounding theory domains.

20. **Empirical Application of the NASSS Framework**
    Page: https://bmcmedicine.biomedcentral.com/articles/10.1186/s12916-018-1050-6
    Figure: Figure 1, NASSS framework.
    Pattern: multi-domain technology implementation framework.

## Benchmark Markers

The runnable benchmark checks that all twenty paper-derived topology markers appear in the generated PGF:

- egg
- Build Systems
- MLIR
- LLVM
- Transformer
- ResNet
- U-Net
- BERT
- AlphaFold
- MapReduce
- Raft
- D3
- PRISMA 2020
- CONSORT 2010
- EBM-DPSER
- EGT
- WASH
- DTx RWE
- UFIT
- NASSS

The generated diagram also includes Chinese subtitles in every panel to keep the Chinese text path under test.
