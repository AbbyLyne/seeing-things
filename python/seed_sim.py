# python/seed_sim.Py
# Exibit 2, "Seed probability simulator" (Mostly Noise). SYNTHETIC data.
# Question: if a packet pays "80% germinate", how far off can one packet be
# by pure chnace, and how does that depend on how many seeds are in it?

import numpy as np                 # fast maths and random numbers
import pandas as pd                # tables (DataFrames), like a SQL table result set
from pathlib import Path           # file paths that work on Windows and Mac

# ---- Settings: all assumptions in one place, so the page can quote them ----
SEED = 2026                        # fixed seed = the same "random" draws every run
P_GERMINATE = 0.8                  # the packet's claim (an assumption not real data)
PACKET_SIZES = [5, 10, 20, 50, 100, 500]
N_PACKETS = 2000                   # simulated packets per size
OUT = Path("data/raw/sim/seed_germination.parquet")

rng = np.random.default_rng(SEED)  # the random number generator

# ---- Simulate: one row per packet ----
pieces = []                        # collect one small table per size
for n in PACKET_SIZES:
    # binomial(n, p, size): plant n seeds, each grows with probaility p,
    # count how many grew: do that for N_PACKETS packets at once
    germinated = rng.binomial(n, P_GERMINATE, size=N_PACKETS)
    pieces.append(pd.DataFrame({
        "packet_size": n,                            # one value, repeated down the column
        "packet_id": np.arange(1, N_PACKETS + 1),   # 1, 2, ... 2000
        "germinated": germinated, 
    }))

sim = pd.concat(pieces, ignore_index=True)           # stack them, like SQL UNION ALL
sim["prop_germinated"] = sim["germinated"] / sim["packet_size"]

# ---- Checks: stop loudly if something if off (like stopifnot() in R) ----
assert len(sim) == len(PACKET_SIZES) * N_PACKETS
assert sim["germinated"].between(0, sim["packet_size"]).all()

# ---- Compare the simulation with maths ----
# Theory: the spread (standard deviation) of a proportion is sqrt(p(1-p)/n).
summary =  (
    sim.groupby("packet_size")["prop_germinated"]   # GROUP BY packet_size
        .agg(sim_sd="std", worst="min")             # tow aggregates per group
        .reset_index()
)
summary["theory_sd"] = np.sqrt(P_GERMINATE * (1 - P_GERMINATE) / summary["packet_size"])
print(summary.round(3))

# ---- Save for dbt (a source) and R (the plot) ----
OUT.parent.mkdir(parents=True, exist_ok=True)      # make data/raw/sim/ if its missing, skips if exists
sim.to_parquet(OUT, index=False)
print(f"Wrote {len(sim):,} rows to {OUT}") 