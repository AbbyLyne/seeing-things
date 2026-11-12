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
| 11 Nov | PowerShell | Rename-Item failed: “file already exists” | Week 1 skeleton had already created an empty dbt/	Check the target with Get-ChildItem before renaming; remove placeholders without -Recurse |
|11 Nov | Git | Files showed “modified” with no visible changes	Obsidian saves LF | Git on Windows converts to CRLF	Run git diff --stat before committing; line-ending-only changes show no lines changed |