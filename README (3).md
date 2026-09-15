# SkwOBA & OOE: A Skill-Based Decomposition of Pitcher xwOBA

A statistical decomposition of pitcher xwOBA focused on repeatable, skill-based inputs — strikeout-minus-walk rate, weak-contact rate, and barrel rate — built to separate what a pitcher actually controls from outcome noise and defense-dependent luck.

Most outcome-based metrics (xwOBA included) are powerful but hard to act on, since they're built from results rather than the underlying skills that produce them. SkwOBA (Skill-Based Weighted On-Base Average) regresses a pitcher's real xwOBA on a small set of repeatable, largely defense-independent inputs, then uses the resulting weights to build a standalone skill score. A companion metric, OOE (Outcome Over Expected — the gap between a pitcher's actual xwOBA and their SkwOBA), proxies for how much of a season's results were "earned" versus lucky.

**Data:** 2015–2025 MLB seasons (2019 excluded due to the COVID-shortened 2020 season disrupting the year-over-year comparison), with the 2025 writeup focused on the 107 qualified starting pitchers that season. Source: Baseball Savant. All coding and calculations performed in Stata.

**Headline results:**
- SkwOBA explains 93.6% of the variance in 2025 xwOBA (R² = 0.936), with every input significant beyond the 1% level.
- Tested as a year-over-year predictor of next season's xwOBA against a pitcher's own lagged xwOBA, SkwOBA won in 5 of 8 seasons tested.

## A note on naming

Both metrics went through name changes during development, and those earlier names still show up in some of the code:

- **SkwOBA** was originally called **CAPS** (Contact-Adjusted Pitching Skill) — variables named `caps` in the code are SkwOBA.
- **OOE** was originally called **skill gap** — variables named `skill_gap` (or, briefly, `ooa`) in the code are OOE.

## Pipeline

| File | What it does |
|---|---|
| `01_skwoba_formula_2025.do` | Builds the core SkwOBA formula: regresses z-scored weak-contact rate (poorly-topped, poorly-under), K%−BB%, and barrel rate against z-scored xwOBA for the 2025 season. This is the source of the published formula and R² = 0.936 result. |
| `02_skwoba_2024_ooe_and_predict2425.do` | Rebuilds the same regression on 2024 data to get that season's formula, derives OOE (actual xwOBA minus SkwOBA) for 2024, then reshapes the panel to test 2024 SkwOBA as a predictor of 2025 xwOBA — the 2024→2025 leg of the predictive validation. |
| `03_predict_1516.do` | Same predictive test, 2015→2016. |
| `03_predict_1617.do` | Same predictive test, 2016→2017. |
| `03_predict_1718.do` | Same predictive test, 2017→2018. |
| `03_predict_1819.do` | Same predictive test, 2018→2019. |
| `03_predict_2122.do` | Same predictive test, 2021→2022. |
| `03_predict_2223.do` | Same predictive test, 2022→2023. |
| `03_predict_2324.do` | Same predictive test, 2023→2024. |

Each `03_predict_XXYY.do` file follows an identical pattern: build that season's SkwOBA formula, reshape the panel to line up the predictor year against the following year's actual xwOBA, then compare `reg xwoba_nextyear skwoba_thisyear` against `reg xwoba_nextyear xwoba_thisyear` — the "does SkwOBA out-predict lagged xwOBA itself" test. Together with `02_...`, these 8 files reproduce every season-pair in the paper's predictive validation section, and their formulas match the year-by-year coefficients reported in the writeup's appendix.

## Requirements

Stata (all scripts use `egen`, `xtset`, and `reshape` — standard Stata/BE or higher). No external packages required.

## Data

Pulled from Baseball Savant; raw per-season CSVs aren't included in this repo. Each script's `import delimited` line at the top shows the expected column set — regenerate by pulling the equivalent season(s) of qualified-pitcher rate stats (K%, BB%, poorly-topped%, poorly-under%, barrel rate, xwOBA) from Baseball Savant's pitcher leaderboard export.

## Full writeup

The complete methodology — including the full variable-selection reasoning, the OOE leaderboard analysis, and all individual regression outputs — is written up in full [here](https://bgratz1.github.io/skwoba-writeup.pdf), or on the [project portfolio site](https://bgratz1.github.io).
