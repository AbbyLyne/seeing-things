# Seeing Things: The Museum of Patterns

> A data museum where every exhibit pairs a real dataset, a beautiful visual,
> a statistical technique, and the psychological bias that makes us misread it.
> We're brilliant at spotting patterns, and just as good at seeing things that aren't there.
> Lift the **Looking Glass** on any exhibit to see the exact code building what you see.

**Status: under construction.** This is a public build that started on 2 Nov 2026. The first exhibits land in late November.
Live site: [abbylyne.github.io/seeing-things](https://abbylyne.github.io/seeing-things/)

Built by **Abby Brazell**, data analyst in the Bay of Plenty, Aotearoa New Zealand. This is a personal project, built on my own time with openly licensed public data.

## The three promises
1. **See it:** every exhibit has one hero visual that works at a glance.
2. **Understand it:** the technique is explained in plain English, with the maths optional.
3. **Question it:** each exhibit names the brain trap involved, so visitors learn to doubt their own pattern-spotting.

## Core features
| Feature | What it is |
|---|---|
| **Exhibits** | One Quarto doc per story, built from `docs/EXHIBIT_TEMPLATE.qmd` |
| **Wings** | Themed galleries grouping exhibits by technique family: **The Cabinet of Coincidences**, **Mostly Noise**, **Decision Corridor**, **The Lab** |
| **Looking Glass** | A lens/panel on each visual revealing the SQL, Python and R that produced it |
| **Double Take** | "Guess first" prompts: visitors guess, then take a second look at the real answer |
| **Brain Atlas** | An interactive illustrated brain; hotspots zoom into cognitive biases and the studies/exhibits tied to them |
| **Verdict badges** | Causal, Confounded, Coincidence, Reverse causation, Inconclusive |
| **Map Room** | Obsidian-style concept graph built from the `vault/` notes (see `docs/CONCEPT_GRAPH.md`) |
| **Echo pairs** | Each exhibit links to an unrelated one with the same pattern shape (F1 tyre wear and seed decay are both decay curves) |
| **Bring Your Own Data** | Later phase: upload a file, get recommended charts and tests |
| **The Engine Room** | Back-of-house wing: pipeline map, published dbt docs, the Power BI twin, "Same model, three engines", Airflow write-up, agent demo |
| **Spurious** | The outbound series: Spurious Sunday posts, later a newsletter |

## Stack and the job of each tool
| Tool | Job |
|---|---|
| DuckDB / SQL | Local warehouse behind the live site |
| dbt | Transformation layer: sources → staging → story marts, with tests, docs, lineage and exposures |
| Microsoft Fabric / Snowflake | Same dbt project on cloud warehouses: portability proofs, never live dependencies |
| Power BI | A twin of one exhibit (Power Query, star schema, DAX) built on the same dbt marts |
| Airflow | Local orchestration of ingest → dbt build/test |
| Agent platforms | An "Ask the Curator" agent, grounded in exhibit content, with numbers from SQL tool calls |
| Python | Ingestion, APIs (FastF1), simulation, ML |
| R / ggplot2 | Statistical tests and publication-quality visuals |
| Quarto | Glue: mixes SQL, Python and R, publishes the site |
| D3 / Observable Plot | Custom interactivity (Brain Atlas, Sankey, lens) |
| GitHub Pages | Free hosting and visible commit history |

## Repo structure
```
seeing-things/
├── README.md
├── LICENSE                   # MIT, for the code
├── _quarto.yml               # site config
├── _freeze/                  # saved code results, so the site publishes without re-running R/Python
├── index.qmd, about.qmd      # entrance and about pages
├── pyproject.toml, uv.lock   # Python environment (uv)
├── renv.lock                 # R environment (renv)
├── docs/                     # exhibit template, technique catalogue, concept graph, R + Python workflow, learning log
├── vault/                    # Obsidian vault: concept, technique, bias and exhibit notes
├── data/raw/                 # untouched source files (never edited)
├── data/processed/           # story tables as Parquet
├── data/graph/               # graph.json for the Map Room
├── data/DATA_SOURCES.md      # licence register for every dataset
├── dbt/                      # dbt project (seeing_things): sources, staging, story marts, tests, exposures
├── python/                   # ingestion, simulation, graph builder
├── r/                        # models and ggplot scripts
├── stories/                  # one .qmd per exhibit
├── wings/                    # wing landing pages
├── orchestration/            # Airflow DAGs
├── powerbi/                  # the Power BI twin
└── assets/                   # styles, fonts, images
```

## Roadmap
- **Phase 1 (Nov 2026):** repo, dbt + DuckDB, Quarto site, first 2 exhibits
- **Phase 2 (Dec 2026 – Jan 2027):** 7 exhibits across 4 wings, brand style, Power BI twin
- **Engine Room (Feb – early Mar 2027):** Microsoft Fabric, Airflow, Snowflake, agents; "Same model, three engines"
- **Phase 3 (Mar – Apr 2027):** Looking Glass lens, Map Room, Double Take prompts, Sankey and treemap exhibits
- **Phase 4 (Apr – May 2027):** Brain Atlas; museum launch 30 May
- **Phase 5 (from June 2027):** Bring Your Own Data, runnable Looking Glass, more exhibits

## Skill rebuild tracker
- [ ] SQL: window functions, CTEs, joins (one real query per exhibit)
- [ ] Python: scripted ingestion (not notebook-only)
- [ ] R: ggplot2 hero chart or model per exhibit
- [ ] dbt: staging + marts with tests and an exposure per exhibit
- [ ] Power BI: Power Query, star schema and DAX on the twin exhibit
- [ ] Cloud warehouses: same dbt project green on Fabric and Snowflake
- [ ] Airflow: idempotent DAG with retries and a backfill
- [ ] Agents: grounded Curator agent with a published evaluation set
- [ ] Learning Log entry per exhibit (`docs/LEARNING_LOG.md`)

## Licence
- **Code:** MIT (see `LICENSE`).
- **Text and charts:** © Abby Brazell, licensed CC BY 4.0 unless stated.
- **Data** keeps its own licence; every dataset is listed in `data/DATA_SOURCES.md`.
