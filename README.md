# Seeing Things: The Museum of Patterns
 
> A data museum where every exhibit pairs a real dataset, a beautiful visual,
> a statistical technique, and the psychological bias that makes us misread it.
> We're brilliant at spotting patterns, and just as good at seeing things that aren't there.
> Lift the **Looking Glass** on any exhibit to see the exact code building what you see.
 
*(Formerly "Pattern Lab"; renamed 1 Nov 2026.)*
 
## The three promises
1. **See it:** every exhibit has one hero visual that works at a glance.
2. **Understand it:** the technique is explained in plain English, with the maths optional.
3. **Question it:** each exhibit names the brain trap involved, so visitors learn to doubt their own pattern-spotting.
## Core features
| Feature | What it is |
|---|---|
| **Exhibits** | One Quarto doc per story, built from `docs/EXHIBIT_TEMPLATE.qmd` |
| **Wings** | Themed galleries grouping exhibits by technique family: **The Cabinet of Coincidences**, **Mostly Noise**, **Decision Corridor**, **The Lab** (see `docs/DESIGN_SYSTEM.md`) |
| **Looking Glass** | A lens/panel on each visual revealing the SQL, Python and R that produced it |
| **Double Take** | "Guess first" prompts: visitors guess, then take a second look at the real answer |
| **Brain Atlas** | An interactive illustrated brain; hotspots zoom into cognitive biases and the studies/exhibits tied to them |
| **Verdict badges** | Causal, Confounded, Coincidence, Reverse Causation, Inconclusive |
| **Map Room** | Obsidian-style concept graph built from the `vault/` notes (see `docs/CONCEPT_GRAPH.md`) |
| **Echo pairs** | Each exhibit links to an unrelated one with the same pattern shape (F1 tyre wear and seed decay are both decay curves) |
| **Bring Your Own Data** | Later phase: upload a file, get recommended charts and tests (`python/recommend_chart.py` is the seed) |
| **The Engine Room** | Back-of-house wing: pipeline map, published dbt docs, the Power BI twin, "Same model, three engines", Airflow write-up, agent demo |
| **Spurious** | The outbound series: Spurious Sunday posts, later a newsletter |
 
## Stack and the job of each tool
| Tool | Job |
|---|---|
| DuckDB / SQL | Local warehouse behind the live site |
| dbt | Transformation layer: sources → staging → story marts, with tests, docs, lineage and exposures |
| Microsoft Fabric / Snowflake | Same dbt project on cloud warehouses: portability proofs, never live dependencies (Engine Room). BigQuery optional |
| Power BI | A twin of one exhibit (Power Query, star schema, DAX) built on the same dbt marts |
| Airflow | Local orchestration of ingest → dbt build/test (Astro CLI + Cosmos) |
| Agent platforms | "Ask the Curator" on Databricks Agent Bricks; Snowflake CoCo as a coding agent under the tutor protocol |
| Python | Ingestion, APIs (FastF1), simulation, ML, chart recommender |
| R / ggplot2 | Statistical tests and publication-quality visuals |
| Quarto | Glue: mixes SQL, Python and R, publishes the site |
| D3 / Observable Plot | Custom interactivity later (brain atlas, sankey, lens) |
| GitHub Pages | Free hosting and visible commit history |
 
## Repo structure
```
seeing-things/
├── README.md
├── PROJECT_INSTRUCTIONS.md   # rules for every output
├── docs/                     # design system, techniques, concept graph, R+Python workflow, AI and tech radar
├── vault/                    # Obsidian vault: concept, technique, bias and exhibit notes
├── data/raw/                 # untouched source files (never edit)
├── data/processed/           # cleaned outputs
├── dbt/                      # dbt project (seeing_things): sources, staging, story marts, tests, exposures
├── orchestration/            # Airflow (Astro CLI) DAGs
├── powerbi/                  # the Power BI twin (.pbix, theme JSON)
├── python/                   # ingestion, simulation, recommender
├── r/                        # models and ggplot scripts
├── stories/                  # one .qmd per exhibit
└── assets/                   # palette, fonts, brain SVG, logo
```
 
## Roadmap (dated detail in `plan/SCHEDULE.md`; NZ job market first, global later)
- **Phase 1 (2–29 Nov 2026):** repo, dbt + DuckDB, Quarto site, template, hub site + CV, 2 exhibits (F1 qualifying vs finish; seed probability simulator)
- **Phase 2 (30 Nov 2026 – 31 Jan 2027):** 7 exhibits across 4 wings, brand style, Power BI twin. Job-ready 20 Dec; applications live 11 Jan
- **Engine Room (1 Feb – 7 Mar 2027):** Microsoft Fabric, Airflow, Snowflake 30-day sprint (from 15 Feb), agents; "Same model, three engines" exhibit
- **Phase 3 (8 Mar – 18 Apr 2027):** Looking Glass lens, Map Room, Double Take prompts, sankey and treemap exhibits
- **Phase 4 (19 Apr – 30 May 2027):** Brain Atlas (or the Bias Constellation fallback); museum launch 30 May
- **Phase 5 (from 31 May 2027):** Bring Your Own Data (Shinylive first), runnable Looking Glass, backlog exhibits, live Curator decision
## Skill rebuild tracker
- [ ] SQL: window functions, CTEs, joins (one real query per exhibit)
- [ ] Python: scripted ingestion (not notebook-only)
- [ ] R: ggplot2 hero chart or model per exhibit
- [ ] dbt: staging + marts with tests and an exposure per exhibit
- [ ] Power BI: Power Query, star schema and DAX on the twin exhibit
- [ ] Cloud warehouses: same dbt project green on Fabric and Snowflake
- [ ] Airflow: idempotent DAG with retries and a backfill
- [ ] Agents: grounded Curator agent with a published evaluation set
- [ ] Learning journal entry per exhibit (doubles as blog content)
 
