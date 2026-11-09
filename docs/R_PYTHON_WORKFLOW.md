# Mixing R and Python (and SQL) Without Pain

## Principle
Let each language do what it's best at, and **hand data over through a neutral format**, not by cramming both
languages into one script. This keeps every step testable, and it's how polyglot data teams work.

## Division of labour
| Stage | Language | Why |
|---|---|---|
| Ingest (APIs, scraping, FastF1) | Python | Best library coverage for pulling data |
| Shape, aggregate and test | SQL (dbt on DuckDB) | Fast, declarative, reviewable; builds story tables with tests |
| Simulation, ML, text, networks | Python | scikit-learn, networkx, etc. |
| Statistical tests, models, diagnostics | R | Test output and modelling ecosystems are strong |
| Publication-quality static charts | R (ggplot2) | Grammar of graphics, annotation control |
| Interactive charts | Python (Plotly) or JS (D3 / Observable Plot) | Web-native |
| Orchestration and publishing | Quarto | One site, many languages |

## Three ways to combine them (use in this order)
1. **Hand-off via DuckDB or Parquet (default).** dbt (or a Python script) writes a cleaned table; R reads the same table. Cleanest and language-neutral.
   - Python: `con.sql("CREATE TABLE story AS SELECT ...")`, or `df.to_parquet("data/processed/story.parquet")`
   - R: `arrow::read_parquet("data/processed/story.parquet")` or `DBI::dbGetQuery(con, "SELECT * FROM story")`
2. **Script per language, same exhibit.** `python/<exhibit>_ingest.py`, `r/<exhibit>_model.R`, then a Quarto page that reads the outputs.
3. **In-session bridging (advanced, use sparingly).** The `reticulate` R package lets R call Python objects. In Quarto, a knitr-engine
   document can run both R and Python chunks. It's powerful but harder to debug; use it for exhibits *about* the two languages
   or for the Looking Glass "same analysis, two languages" tabs.

## "Same analysis, two languages" feature
A teaching exhibit idea: show a chi-square test in R and Python side by side, with outputs matching.
It turns relearning into content, and it's a genuine skill signal.

## Environment setup
- **IDE:** Positron, Posit's data-science IDE built on the VS Code foundation, supports Python and R in one place, with a
  Data Explorer, Plots pane, database connections and Quarto support. RStudio and VS Code are alternatives.
- **Python:** manage with `uv`; pinned in `pyproject.toml`, `uv.lock` and `.python-version`.
- **R:** pinned with `renv` (`renv.lock`); `pak` for fast installs.
- **Database:** DuckDB file at `data/seeing_things.duckdb`, readable from both languages. It's git-ignored because `dbt build` recreates it.
- **Reproducibility:** fixed random seeds in both languages (`set.seed(2026)`, `numpy.random.default_rng(2026)`); commit lock files.

> **Gotcha:** DuckDB allows one process to write at a time. If Python holds the file open, R can't. Close connections,
> open R with `read_only = TRUE`, or read the Parquet instead.

## Folder convention per exhibit
```
python/f1_ingest.py                          # pull data into data/raw/
dbt/models/staging/f1/_f1__sources.yml       # declare the raw data
dbt/models/staging/f1/stg_f1__results.sql    # raw -> staging (typed, renamed, tested)
dbt/models/marts/story/f1_grid_vs_finish.sql # staging -> story table, written to data/processed/*.parquet
r/f1_model.R                                 # test + ggplot
stories/f1-qualifying.qmd                    # narrative + Looking Glass
```

## Learning order (rebuild plan)
1. SQL on DuckDB, through dbt (joins, CTEs, window functions)
2. R: tidyverse + ggplot2 + one test per exhibit
3. Python: pandas/Polars + one simulation per exhibit
4. Then the hand-offs above
