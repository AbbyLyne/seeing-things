# r/f1_pole_plot.R
# Exhibit 1 hero chart: median finishing position for each grid slot,
# with the middle half of finishes, against a "finish where you start" line.
# Run r/f1_pole_model.R first: this script uses f1, m_grid and m_team that are generated from it.

library(tidyverse)

 # ---- 1. Summarise each grid slot (SQL's GROUP BY, in dplyr) ---------------------------------------------------------
by_grid <- f1 |>
  group_by(grid) |>
  summarise(
    starts        = n(),                                  # how many finishes from this slot
    median_finish = median(finish_position),              # the typical finishing position
    q25           = quantile(finish_position, 0.25),      # 25th percentile: better finishes
    q75           = quantile(finish_position, 0.75),      # 75th percentile: worse finishes
    .groups = "drop"                                      # return an ordinary table, not a grouped one
  )
by_grid                                                   # check: 20 rows, one per grid slot, and starts in the 70s–80s each

# ---- 2. Numbers for the title, computed here so they're never typed ---------------------------------------------------------
rho      <- cor(f1$grid, f1$finish_position, method = "spearman")
drop_pct <- (coef(m_grid)["grid"] - coef(m_team)["grid"])/ coef(m_grid)["grid"] *100

hero_title    <- "Start further back, finish further back"
hero_subtitle <- sprintf(
  "Grid and finishing order agree strongly (rank correlation %.2f).\nComparing team-mates in the same car, grid's effect is %.0f%% smaller: much of it is the car.",
  rho, drop_pct)

# ---- 3. The chart, one layer at a time ---------------------------------------------------------
diagonal <- tibble(grid = c(1,20), finish = c(1,20))      # the "finish where you start" line

hero <- ggplot(by_grid, aes(x = grid)) +
  # reference line: drawn from data points, so it stays correct with the reversed axis
  geom_line(data = diagonal, aes(y = finish),
            linetype = "dashed", colour = "grey60", linewidth = 0.5) +
  annotate("text", x = 19.5, y = 19.8, label = "Finish where you start",
           colour = "#52514e", size = 3.5, hjust = 1) +
  # middle half of finishes for each slot
  geom_linerange(aes(ymin = q25, ymax = q75),
                 colour = "#2a78d6", alpha = 0.35, linewidth = 1.6) +
  # the typical finish for each slot
  geom_point(aes(y = median_finish), colour = "#2a78d6", size = 2.6) +
  scale_x_continuous(breaks = c(1, 5, 10, 15, 20)) +
  scale_y_reverse(breaks = c(1, 5, 10, 15, 20)) +         # 1st at the top
labs(
  title    = hero_title,
  subtitle = hero_subtitle,
  x        = "Start grid position",
  y        = "Finishing position",
  caption  = sprintf(
      "Dots: median finish. Bars: middle half of finishes (25th to 75th percentile).\n%s classified finishes, 2022–2025. Data: Jolpica F1 API, CC BY-NC-SA 4.0.",
      format(nrow(f1), big.mark = ","))
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title.position = "plot",                         # title aligns with the chart's left edge
    plot.title          = element_text(face = "bold"),
    plot.subtitle       = element_text(colour = "#52514e"),
    plot.caption        = element_text(colour = "#52514e", hjust = 0),
    panel.grid.minor    = element_blank()                 # fewer lines, quieter background
  )

hero                                                      # draws it in the Plots pane

# ---- 4. Save a PNG for listing cards and LinkedIn previews ---------------------------------------------------------
ggsave("stories/images/f1-pole-hero.png", hero, width = 8, height = 5, dpi = 200, bg = "white")
