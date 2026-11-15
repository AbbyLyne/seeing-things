"""Pull F1 race results from the Jolpica API (via FastF1) into data/raw/f1/.

Run from the repo root:  uv run python python/f1_ingest.py
Data licence: CC BY-NC-SA 4.0 (Jolpica). See data/DATA_SOURCES.md.
"""

from pathlib import Path
import time 

import fastf1 
import pandas as pd
from fastf1.ergast import Ergast

# Settings defined here, at the top, so everything below can use them
SEASONS = [2022, 2023, 2024, 2025]
CACHE_DIR = Path("data/raw/fastf1_cache")
OUT_FILE = Path("data/raw/f1/race_results.parquet")

def main() -> None:
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    OUT_FILE.parent.mkdir(parents=True, exist_ok=True)

    fastf1.Cache.configure(cache_dir=str(CACHE_DIR))

    ergast = Ergast(result_type="pandas", auto_cast=True)
    frames = []                                                       # One table per race
    
    # For each season, fetch results
    for season in SEASONS:
        schedule = ergast.get_race_schedule(season=season)

        for rnd in schedule["round"]:
            resp = ergast.get_race_results(season=season, round=int(rnd))
            time.sleep(1)

            if len(resp.content) == 0:                          # Skips passed cancelled race. No data
                print(f"{season} round {rnd}: no results, skipped")
                continue

            race = pd.DataFrame(resp.content[0])                # results table
            race["season"] = season                             # Label all rows in season
            race["round"] = int(rnd)                            # and its rounds
            frames.append(race)
        
        print(f"{season}: {len(schedule)} races on the calendar")

    #put all races into table and save
    results = pd.concat(frames, ignore_index=True)
    results.to_parquet(OUT_FILE, index=False)

    print(f"\n{len(results)} rows written to {OUT_FILE}")
    print(results.groupby("season").size())

if __name__ == "__main__":
    main()