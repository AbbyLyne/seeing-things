# Technique Catalogue

The lookup behind every exhibit's "which technique, and why does it fit?" Grow it as exhibits ship: each technique should eventually have a vault note (`type: technique`) and at least one exhibit.

## Step 1: what kind of variables do you have?
| Type | Examples | Watch out |
|---|---|---|
| **Continuous** | Lap time, temperature, income | Skew and outliers; consider logs |
| **Ordinal** | Grid position, survey 1–5, league rank | Gaps between ranks aren't equal → rank-based methods |
| **Categorical** | Team, region, yes/no | Small cell counts |
| **Count** | Goals, germinated seeds | Can't be negative; variance often grows with the mean |
| **Time / duration** | Date, time-to-failure | Autocorrelation; censoring (things that haven't "failed" yet) |
| **Text** | Reviews, speeches | Needs turning into numbers first |

## Step 2: pick by question × variable types
| Question | Variables | Technique | Family | Wing |
|---|---|---|---|---|
| Do two things move together? | continuous × continuous | Pearson correlation (+ scatter) | Association | The Cabinet of Coincidences |
| | ordinal × ordinal/continuous | Spearman's rank correlation | Association | The Cabinet of Coincidences |
| | categorical × categorical | Chi-square test of independence + Cramér's V | Association | The Lab |
| Is this group different? | continuous × 2 groups | Welch's t-test (or Mann–Whitney if skewed/ordinal) | Group comparison | The Lab |
| | continuous × 3+ groups | ANOVA (or Kruskal–Wallis) | Group comparison | The Lab |
| | proportion × 2 groups | Two-proportion test / A/B test; power analysis | Group comparison | The Lab |
| Can I predict one from others? | continuous outcome | Linear regression | Modelling | Decision Corridor |
| | yes/no outcome | Logistic regression | Modelling | Decision Corridor |
| | count outcome | Poisson / negative binomial regression | Modelling | Decision Corridor |
| How long until it happens? | time-to-event (with censoring) | Kaplan–Meier curve, Cox model | Survival / decay | Decision Corridor |
| Is the extreme just luck? | any | Regression to the mean (repeated measures) | Modelling | Decision Corridor |
| How surprising is this by chance? | any | Simulation (Monte Carlo), permutation test | Chance & simulation | Mostly Noise |
| How sure am I of this number? | any statistic | Bootstrap confidence interval | Chance & simulation | Mostly Noise |
| Did scanning many things fool me? | many tests | Bonferroni / false discovery rate | Multiple comparisons | The Cabinet of Coincidences |
| Does the trend flip in subgroups? | outcome × group × confounder | Stratified analysis (Simpson's paradox) | Confounding | The Cabinet of Coincidences |
| What's trend vs season vs noise? | time series | Decomposition (STL), autocorrelation | Time series | Decision Corridor |
| Does the tool change the answer? | runtime/cost across engines | Benchmarking (repeat runs, report spread) | Measurement | The Engine Room |
| Did X cause Y? (later) | panel / policy change | Difference-in-differences, regression discontinuity, DAGs | Causal inference | Decision Corridor |
| Are there natural groups? (later) | many continuous | k-means, PCA | Structure | – |
| How are things connected? (later) | nodes and links | Network analysis | Structure | Map Room |

## Step 3: effect sizes to report
| Technique | Effect size | Say it in real terms like… |
|---|---|---|
| Correlation | r or ρ with 95% CI | "A strong, positive association (ρ = 0.6, CI 0.5–0.7)" |
| Chi-square | Cramér's V | "A weak association (V = 0.12)" |
| t-test | Mean difference + CI, Cohen's d | "On average 1.8 s slower (CI 1.2–2.4)" |
| Proportions | Risk difference, relative risk | "Pole sitters win 4× as often" |
| Linear regression | Coefficient + CI, R² | "Each place further back costs about 0.7 finishing places" |
| Logistic regression | Odds ratio + CI | "Odds of finishing are 2× higher…" |
| Benchmarking | Median + spread across runs | "Median 2.1 s (range 1.9–2.6 s over 10 runs)" |

*(The numbers in this column are illustrative phrasing only; real exhibit numbers come from executed code.)*

## Chart pairings (one message per chart)
| Pattern | Hero chart |
|---|---|
| Association | Scatter with trend line (+ marginal distributions) |
| Group difference | Dot/strip plot with means and CIs (not bar + error bar) |
| Part-to-whole | Bar chart first; treemap only as the "area lies" exhibit |
| Change over time | Line chart, annotated events |
| Flow | Sankey |
| Survival/decay | Step curve (Kaplan–Meier) |
| Chance | Histogram of simulated outcomes with the real value marked |
