# Learning Log

| Date | Language | What I got wrong | Why | Rule I learned |
|---|---|---|---|---|
| 2 Nov 2026 | Git | Nearly ran `git init` and `git remote add` on a cloned repo | Cloning already creates the repo and the `origin` remote; the guide assumed starting from scratch | Run `git remote -v` first; a clone is already wired to GitHub |
| 3 Nov 2026 | PowerShell | `R --version` errored | `r` is a built-in PowerShell alias for `Invoke-History`, and PowerShell ignores case | In PowerShell, call R as `R.exe` or `Rscript` |
| 3 Nov 2026 | Python | Nearly built the project on Python 3.15 | New Python releases run ahead of library support; dbt v1.12 lists 3.14 as its newest | Pin the project's Python with uv to a version the key libraries support |
| 3 Nov 2026 | PowerShell | Nearly made `.gitignore` with `echo > .gitignore` | Windows PowerShell's `>` writes UTF-16, which Git can't read properly | Create text files in the editor, not with shell redirects |
| 3 Nov 2026 | R | `install.packages()` failed: library not writable | R lives in Program Files, which normal users can't write to | Use a personal library (`R_LIBS_USER`); renv keeps project packages inside the repo anyway |
| 3 Nov 2026 | R | Installed packages before renv was active, so they went to my personal library | `renv::init()` only takes effect after R restarts and runs `.Rprofile` | After `renv::init()`, restart R and check that `.libPaths()[1]` is inside the project |
| 9 Nov 2026 | Git | Tried to publish GitHub Pages from a private repo | GitHub Free only serves Pages from public repos | Check repo visibility first; on the free plan, Pages needs a public repo |
| 9 Nov 2026 | Git | Looked for the Pages setting in my account settings | GitHub has account settings (avatar menu) and repo settings (repo's Settings tab); Pages lives in the repo's | Repo-level options are on the repo's Settings tab, not under my avatar |
| 11 Nov 2026 | PowerShell | `Rename-Item` failed: "file already exists" | The Week 1 skeleton had already created an empty `dbt/` | Check the target with `Get-ChildItem` before renaming; remove placeholders without `-Recurse` |
| 11 Nov 2026 | Git | Files showed "modified" with no visible changes | Obsidian saves LF line endings; Git on Windows converts to CRLF | Run `git diff --stat` before committing; line-ending-only changes show no lines changed |
| 14 Nov 2026 | Python | Script ran but printed nothing | Bare expressions only display in the console | Use `print()` in scripts; explore in the console |
| 14 Nov 2026 | Python | `NameError: CACHE_DIR is not defined` | Used a name before creating it | Python runs top to bottom: define settings before using them |
| 14 Nov 2026 | Python | `ErgastInvalidRequestError: Too Many Requests` | Requests went faster than Jolpica's rate limit | Throttle API loops (`time.sleep`) and cache, so re-runs resume rather than restart |
| 15 Nov 2026 | SQL (dbt) | Used `::VARCHAR` cast shorthand | `::` is DuckDB/Postgres only; Fabric T-SQL rejects it | Use `cast(x as type)` / `try_cast` in dbt models so they run on every warehouse |
| 17 Nov 2026 | dbt (Jinja) | Uppercase `IF`, `ELSE`, `LOCATION` inside `{{ }}` | Jinja is case-sensitive; SQL isn't | SQL keywords any case; everything inside braces lowercase |
| 17 Nov 2026 | dbt (Jinja) | SQL `--` comments inside `{{ config() }}` | Inside braces isn't SQL | Comments go outside the braces |
| 17 Nov 2026 | SQL | Alias `team_avg_grid` on a places-gained average | Carried over from the practice query | Name a column for what it measures, and re-read aliases after copying a pattern |
| 17 Nov 2026 | dbt (YAML) | Added a second `models:` block instead of extending the first | YAML keeps only one copy of a repeated key and drops the other without an error | Add to the existing block; read deprecation warnings, they can mean settings were dropped |
| 17 Nov 2026 | dbt (YAML) | `+materialized: VIEW` | dbt setting values are case-sensitive | Config values lowercase: `view`, `table`, `external` |
| 17 Nov 2026 | dbt / Git | Root `logs/` reappeared | dbt was run from the repo root | Run dbt from `dbt\` only; `/logs/` is now ignored as a backstop |
| 17 Nov 2026 | PowerShell | Created `data\processed\` from inside `dbt\`, so it landed in `dbt\data\` | Relative paths start from the current folder | Check the prompt shows the repo root before creating folders; `pwd` if unsure |
| 19 Nov 2026 | dbt | Mart still had `team_avg_grid` after the planned rename | A description-only YAML entry doesn't check the column exists | `glimpse()` the output after every mart change; the column names you see are the truth |
| 19 Nov 2026 | Positron | Ran dbt on an unsaved file | Tools read the file on disk, not the editor | Ctrl+S before every run; the `Found ... tests` line is a quick check |
| 19 Nov 2026 | Statistics | Guessed rho 0.37 (got 0.73) and an 8% drop in grid's effect once the car was added (got 36.3%) | Under-weighted car pace, a confounder that drives both grid and finish | Write a numeric guess before running anything; the gap is the lesson (and the Double Take) |
