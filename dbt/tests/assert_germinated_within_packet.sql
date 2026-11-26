-- Fails if any packet grew fewer than 0 seeds, or more seeds than it held.
-- A singular test: any rows returned = failure.
select packet_key, packet_size, seeds_germinated
from {{ ref('stg_sim__seed_germination') }}
where seeds_germinated < 0
   or seeds_germinated > packet_size