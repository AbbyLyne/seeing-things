-- stg_sim__seed_germination: one row per simulated seed packet, typed and renamed.
-- SYNTHETIC: made by python/seed_sim.py. Staging doesn't filter or summarise.
WITH source AS (
    SELECT * FROM {{ source('sim', 'seed_germination') }}
),

renamed AS (
    SELECT
     concat(cast(packet_size AS VARCHAR), '-', cast(packet_id AS VARCHAR)) AS packet_key,
     cast(packet_size AS INT) AS packet_size,
     cast(packet_id AS INT) AS packet_id,
     cast(germinated AS INT) AS seeds_germinated,
     cast(germinated AS DECIMAL(10, 4)) / cast(packet_size AS DECIMAL(10, 4)) AS germination_rate
    FROM source
)

SELECT * FROM renamed

-- test run from \dbt terminal: uv run dbt show --select stg_sim__seed_germination --limit 5