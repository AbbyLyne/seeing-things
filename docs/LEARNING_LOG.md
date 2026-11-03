# Learning Log

| Date | Language | What I got wrong | Why | Lesson |
|---|---|---|---|---|
| 2 Nov 2026 | Git | Nearly ran the guide's `git init` / `quarto create ... seeing-things` steps in a repo I'd already cloned | A clone is already a Git repo with a remote; `quarto create` with a folder name builds a folder inside it | In a clone, skip `git init` and `git remote add`; use `quarto create project website .` |
| 2 Nov 2026 | Quarto | `quarto check` warned that knitr, rmarkdown and Jupyter were missing | It checks the global installs, but this project keeps packages in renv (R) and uv (Python) | Install project packages per project, not globally; those warnings are expected |
| 3 Nov 2026 | PowerShell | `R --version` errored | `r` is a built-in PowerShell alias for `Invoke-History`, and PowerShell ignores case | In PowerShell, call R as `R.exe` or `Rscript` |
| 3 Nov 2026 | Python | Global Python is 3.15, but dbt's support table tops out at 3.14 | New Python versions arrive before libraries catch up | Pin each project's Python (`uv init --python 3.14`) and check the library's support table first |