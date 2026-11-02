# Pattern Lab: The Museum of Patterns (working title)

> A data museum where every exhibit pairs a real dataset, a beautiful visual,
> a statistical technique, and the psychological bias that makes us misread it.
> Lift the **Looking Glass** on any exhibit to see the exact code building what you see.

## The three promises
1. **See it:** every exhibit has one hero visual that works at a glance.
2. **Understand it:** the technique is explained in plain English, with the maths optional.
3. **Question it:** each exhibit names the brain trap involved, so visitors learn to doubt their own pattern-spotting.

## Core features
| Feature | What it is |
|---|---|
| **Exhibits** | One Quarto doc per story, built from `docs/EXHIBIT_TEMPLATE.qmd` |
| **Wings** | Themed galleries grouping exhibits by technique family (see `docs/DESIGN_SYSTEM.md`) |
| **Looking Glass** | A lens/panel on each visual revealing the SQL, Python and R that produced it |
| **Brain Atlas** | An interactive illustrated brain; hotspots zoom into cognitive biases and the studies/exhibits tied to them |
| **Verdict badges** | Causal, Confounded, Coincidence, Reverse Causation, Inconclusive |
| **Map Room** | Obsidian-style concept graph built from the `vault/` notes (see `docs/CONCEPT_GRAPH.md`) |
| **Echo pairs** | Each exhibit links to an unrelated one with the same pattern shape (F1 tyre wear and seed decay are both decay curves) |
| **Bring Your Own Data** | Later phase: upload a file, get recommended charts and tests (`python/recommend_chart.py` is the seed) |

## Stack and the job of each tool
| Tool | Job |
|---|---|
| DuckDB / SQL | Warehouse: raw tables, cleaning views, story tables |
| Python | Ingestion, APIs (FastF1), simulation, ML, chart recommender |
| R / ggplot2 | Statistical tests and publication-quality visuals |
| Quarto | Glue: mixes SQL, Python and R, publishes the site |
| D3 / Observable Plot | Custom interactivity later (brain atlas, sankey, lens) |
| GitHub Pages | Free hosting and visible commit history |

## Repo structure
```
pattern-lab/
├── README.md
├── PROJECT_INSTRUCTIONS.md   # rules for every output
├── docs/                     # design system, techniques, concept graph, R+Python workflow, AI and tech radar
├── vault/                    # Obsidian vault: concept, technique, bias and exhibit notes
├── data/raw/                 # untouched source files (never edit)
├── data/processed/           # cleaned outputs
├── sql/                      # numbered queries per exhibit: 01_load.sql, 02_clean.sql...
├── python/                   # ingestion, simulation, recommender
├── r/                        # models and ggplot scripts
├── stories/                  # one .qmd per exhibit
└── assets/                   # palette, fonts, brain SVG, logo
```

## Roadmap
- **Phase 1 (weeks 1-4):** repo, DuckDB, Quarto site, template, 2 exhibits (F1 qualifying vs finish; seed probability simulator)
- **Phase 2 (weeks 5-10):** 8 exhibits across 4 wings, brand style, Illusions gallery
- **Phase 3 (weeks 11-16):** Looking Glass component, "guess first" prompts, sankey and treemap exhibits
- **Phase 4 (weeks 17-24):** Brain Atlas
- **Phase 5:** Bring Your Own Data app (Streamlit or Shiny)

## Skill rebuild tracker
- [ ] SQL: window functions, CTEs, joins (one real query per exhibit)
- [ ] Python: scripted ingestion (not notebook-only)
- [ ] R: ggplot2 hero chart or model per exhibit
- [ ] Learning journal entry per exhibit (doubles as blog content)
