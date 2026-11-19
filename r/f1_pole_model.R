# r/f1_pole_model.R
# Exibit 1: Does pole position decide the race?
# Reads the dbt story mart, measures how strongly grid and finish move together,
# then checks how much of that is really the car (team).
# Must run from repo root (paths below are relative to it)

# Tidyverse: Opinionated suite of R packages for clean, consistent data science
library(tidyverse)       # wrangling (dplyr), iteration (purrr), & modern data frames (tibble)
library(arrow)           # reads Parquet files = Parquet files: Compact, high-speed tabular data files (much faster and smaller than CSVs)
library(broom)           # turns the model output into tidy tables

set.seed(2026)           # the bootstrap samples at random; a seed makes the result repeatable

# ---- 1. Read the mart ---------------------------------------------------------
f1 <- read_parquet("data/processed/f1_grid_vs_finish.parquet")
glimpse(f1)                 # every column, its type, and the fist few values
stopifnot(nrow(f1)== 1609)  # Total data points as checked in stg_f1__results.sql

# ---- 2. Spearman's rank correlation ---------------------------------------------------------
# Spearman's rank correlation: measures how closely starting grid position
# and finishing position agree in rank order (-1 to +1). A value near +1
# means drivers tend to finish roughly where they start; near 0 means grid
# position tells us little about the result. Used instead of Pearson because
# positions are ranks and the relationship needn't be linear.
spearman <- cor.test(
  f1$grid,f1$finish_position,
  method = "spearman",
  exact = FALSE          # positions repeat across races (lots of ties), so use the approximation
)
spearman                 # rho is the effect size; the p-value is close to useless here (as below)
# rho: Rank correlation coefficient (-1 to 1) measuring how closely two rankings align

# ---- 3. Bootstrap 95% intervalfor rhop, resamples who races ---------------------------------------------------------
races <- f1 |> distinct(season, round)     # one row per race
nrow(races)

boot_rho <- function() {
  # draws as many races in the dataset, with replacement
  picked <- races |> slice_sample(prop = 1, replace = TRUE)

  # return every driver row for each picked race
  sample_rows <- picked |>
    inner_join(f1, by = c("season", "round"), relationship = "many-to-many")

  # return the Spearman correlation of grid and finish_position in sample_rows
  cor(sample_rows$grid, sample_rows$finish_position, method = "spearman")
}

rhos <- replicate(2000, boot_rho())        # 2,000 resamples: will take a few seconds
quantile(rhos, c(0.025, 0.975))

# ---- 4. Regression: grid alone, then grid + car ---------------------------------------------------------
# A "car" is a team in a given season: 2022 and 2025 cars differ, even for the same team.
f1 <- f1 |> mutate(team_season = paste(season, team))

m_grid <- lm(finish_position ~ grid, data = f1) # "~" = "explained by"

m_team <- lm(finish_position ~ grid + team_season, data = f1) # m_team, same model with team_season added as secondary predictor

# pull out just the grid coefficient, with a 95% confidence interval
tidy(m_grid, conf.int = TRUE) |> filter(term == "grid")
tidy(m_team, conf.int = TRUE) |> filter(term == "grid")

# R²: the share of the variation in finishing position each model explains.
glance(m_grid)$r.squared
glance(m_team)$r.squared

# How much of grid's effect disappears once the car is held constant? (%)
b_grid <- coef(m_grid)["grid"]
b_team <- coef(m_team)["grid"]
(b_grid - b_team) / b_grid * 100

# Residuals vs fitted: red line near zero = a straight line is a fair summary
plot(m_team, which = 1)