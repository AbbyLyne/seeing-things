# Data sources register

One row per dataset. Check the licence before pulling any data.
Details for each dataset are in its own section below the table.

| Dataset | Source URL | Licence | Commercial use OK? | Pulled on | Rows | Notes |
|---|---|---|---|---|---|---|
| F1 race results | https://api.jolpi.ca/ergast/f1/ (via FastF1) | CC BY-NC-SA 4.0 | No | 14 Nov 2026 | 1838 | Seasons 2022–2025. See [F1 race results](#f1-race-results) |

---

## F1 race results

**Source**
- Jolpica F1 API: https://api.jolpi.ca/ergast/f1/ (repo: https://github.com/jolpica/jolpica-f1)
- Accessed with FastF1 (`fastf1.ergast`). FastF1 is MIT-licensed: that covers the code, not the data.
- Ingest script: `python/f1_ingest.py` → `data/raw/f1/race_results.parquet`

**Licence and use**
- CC BY-NC-SA 4.0, per Jolpica's Terms of Use (updated 27 Aug 2025; checked 12 Nov 2026): https://github.com/jolpica/jolpica-f1/blob/main/TERMS.md
- Non-commercial only. Contact admin@jolpi.ca for commercial use.
- Share-alike: derived tables, charts and the Power BI twin carry CC BY-NC-SA 4.0 with attribution.
- Unofficial; not affiliated with Formula 1. F1 names and marks are trademarks of Formula One Licensing B.V.

**Attribution wording (for exhibit pages)**
> Race results from the [Jolpica F1 API](https://github.com/jolpica/jolpica-f1), licensed [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). Filtered and aggregated for this exhibit; the derived data and charts on this page are shared under the same licence.

**Coverage**
- Seasons 2022–2025: one rules era. 2026 is excluded (new rules; season incomplete until December).
- 1,838 rows, one per driver per race: 2022 = 440, 2023 = 440, 2024 = 479, 2025 = 479.

**Known quirks**
- 2024 round 3 and 2025 round 9 have 19 starters: a driver didn't take the start.
- Every driver gets a `position` number, even retirements. `positionText` is the truth: a number if classified, otherwise a code (R = retired, D = disqualified, W = withdrawn). Handled in `stg_f1__results` (`finish_position` is NULL unless classified).
- Grid 0 = pit-lane start.

**Access**
- Rate limits: 4 requests a second (burst), 500 an hour (sustained). The ingest caches replies and pauses one second between requests.
- Volunteer-run: no uptime or accuracy guarantee.