-- stg_f1__results: one row per driver per race, typed and renamed.
-- Staging cleans and renames; it does NOT drop rows (that's the mart's job).
WITH source AS (
    SELECT *
      FROM {{ source('f1', 'race_results') }}
),

renamed AS (
    SELECT 
      CONCAT(CAST(season AS VARCHAR), '-', CAST(round AS VARCHAR), '-', driverId) AS result_id, -- Unique key - one row per driver per race
        -- Race
        CAST(season AS INTEGER) AS season,
        CAST(round AS INTEGER) AS round,
        -- Who
        driverId AS driver_id,
        driverCode AS driver_code,
        constructorName AS team,
        -- Start and Finish
        CAST(grid as INTEGER) AS grid,                                       -- 0 = started from the pit lane
        CAST(position AS INTEGER) AS classified_order,                       -- everyone gets one, even DNFs
        positionText AS position_text,                                       -- a number = classified; R, D, W... = not 
        TRY_CAST(positionText AS INTEGER) AS finish_position,                -- finish_position: the finishing position for classified drivers, NULL for everyone else  
        status,
        CAST(points AS DECIMAL(5, 1)) AS points
        FROM source
)

SELECT *
  FROM renamed
