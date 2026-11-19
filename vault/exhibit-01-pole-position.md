# Exhibit 1: Does pole position decide the race?

## Check figures (from dbt show, 17 Nov 2026)
- All results 2022–2025: 1,838
- Pit-lane starts (grid = 0): 15
- Not classified: 216 (11.8%)
- Overlap (pit lane and not classified): 2
- Mart rows: 1,609 (= 1,838 − 15 − 216 + 2)

## How to reproduce (run from `dbt\`)
```powershell
uv run dbt show --inline "select count(*) as all_rows, count(*) filter (where grid = 0) as pit_lane, count(*) filter (where finish_position is null) as not_classified, count(*) filter (where grid = 0 and finish_position is null) as overlap, count(*) filter (where grid > 0 and finish_position is not null) as expected_mart_rows from {{ ref('stg_f1__results') }}"
uv run dbt show --inline "select count(*) as mart_rows from {{ ref('f1_grid_vs_finish') }}"
```

## Rule
The exhibit page computes these in code. Before publishing, its numbers must match the ones above.


## Double Take: my guess (19 Nov 2026, before running any code)
- Guess: rho = 0.37
- Why: grid position matters, but its effect wears off over a race distance. Tyres, weather,
  the driver's state on the day and car pace (how well the car holds speed through corners)
  all pull the finishing order away from the grid order.

- Prediction for Regression: grid coefficient goes down slightly when team_season is added, est 8%
  Why: track conditions, different drivers in the same car.

## Results (r/f1_pole_model.R)
- Spearman rho: 0.73 (95% bootstrap CI 0.69 to 0.77, resampling 92 races, 2,000 draws)
- Grid coefficient, grid only: 0.65 (95% CI 0.62 to 0.68), R² 0.52
- Grid coefficient, with team-season: 0.42 (95% CI 0.38 to 0.45), R² 0.64
- Drop in grid coefficient once the car is held constant: 36.3% (predicted 8%)
- Guess vs result: guessed rho 0.37, got 0.73; under-weighted the car twice
- Provisional verdict: Confounded (car inflates grid's effect; driver form may explain some of the rest)
- Caveat: lm intervals too narrow (rows within a race aren't independent)

## Assumptions and checks
| Assumption | How I checked | Result |
|---|---|---|
| Rows are independent | Rows within a race are linked (only one driver finishes 1st) | Spearman: handled by resampling 92 races. Regression: intervals too narrow; caveat on the page |
| Finishing positions bounded at 1 and 20 | By design | Limitation; noted on the page |
| Only classified finishers included | 216 non-finishers dropped; some late retirements still classified | Survivorship risk; stretch check Saturday: do front-runners retire less often? |
| Relationship is roughly a straight line | Residuals vs fitted plot, `plot(m_team, which = 1)` | Red line stays near zero: a straight line is a fair summary. Lower-left edge shows the floor at 1st place; the biggest misses (e.g. row 19) are front-runners classified near the back after late retirements |