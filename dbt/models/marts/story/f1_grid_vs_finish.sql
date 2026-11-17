-- f1_grid_vs_finish: this table is used/read by Exhibit 1
-- one row per classified finisher who started from the grid, 2022-2025
--
-- Config notes (kept out here because SQL comments can't go inside the braces):
--   materialized: on DuckDB, write a Parquet file that R and Power BI read directly;
--                 on Fabric/Snowflake (February), build an ordinary table. No forked SQL.
--   location:     relative to where dbt runs (the dbt\ folder), like the profile's db path.

{{ config(
    materialized = ('external' if target.type =='duckdb' else 'table'),
    location = '../data/processed/f1_grid_vs_finish.parquet'
) }}

WITH finishers AS (

    SELECT
        result_id,     -- carrying through so the mart has a unique key to test
        season,
        round,
        driver_code,
        team,
        grid,
        finish_position
      FROM {{ ref('stg_f1__results')}}    -- ref() is what draws the lineage arrow
     WHERE grid > 0                       -- pit-lane starts have no grid slot to compare - removing
       AND finish_position IS NOT NULL    -- only classified finishers; this is exhibit logic
)

SELECT
    result_id,
    season,
    round,
    driver_code,
    team,
    grid,
    finish_position,
    -- positive = progressed forward, negative = lost places
    grid - finish_position AS places_gained,
    -- average gain per team in the season, repeated on all rows for that team and season
    avg(grid - finish_position) OVER (PARTITION BY season, team) AS team_avg_grid
  FROM finishers  

  -- Test: uv run dbt show --inline "select count(*) as all_rows, count(*) filter (where grid = 0) as pit_lane, count(*) filter (where finish_position is null) as not_classified from {{ ref('stg_f1__results') }}"