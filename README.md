All files are provided as encrypted 7z archives (AES-256): code.7z, data.7z and results.7z. They can be opened with 7-Zip (Windows) or Keka / The Unarchiver (macOS). The password is given in the Data availability statement of the article or can be requested from the corresponding author.

# Data, code and results: human vs AI interpersonal emotion regulation (Studies 1–3)

Everything needed to reproduce the statistics, tables and figures of the manuscript and its supplementary material.

## Folder structure

```
data/      raw data, one workbook per study; each workbook starts with a Codebook sheet describing every variable
code/      analysis scripts (see below)
results/   output of the code, one folder per study plus Figures/ (rebuilt by run_all.R)
run_all.R  runs every script in order
```

## Data

| File | Content |
|---|---|
| `prior study.xlsx` | Pilot rating of the vignettes (valence, arousal and emotion intensity), used as the stimulus check of Study 1 |
| `Study 1.xlsx` | Study 1: demographics and social-relational ratings, trial-level PRE and response liking, strategy coding of the responses, coder demographics |
| `Study 2.xlsx` | Study 2: demographics, PRE and evaluations, coding of response quality, emotion recognition accuracy, human regulator assignment and demographics |
| `Study 3.xlsx` | Study 3: demographics and individual differences, per-session and per-trial (per-round) assessments, regulator perspective, strategy coding, fNIRS cortical activation (11 ROIs) and functional connectivity during response reading, ROI definitions |
| `channel_MNI.csv` | fNIRS channel MNI coordinates with Brodmann areas and assignment probabilities (Supplementary Table S15) |

PRE = perceived regulation effectiveness. Participants are identified only by study-specific codes.

In line with the journal's and the ethics committee's requirements, the fNIRS data are shared at the ROI level only: `Study 3.xlsx` contains the activation (β) of each ROI and the functional connectivity of each ROI pair for every participant, session and round. The raw optical signals and channel-level time series are not shared. Preprocessing and ROI construction are described in Supplementary Note S5.

## Code

One script per study, plus the functions they share:

| Script | Content | Output |
|---|---|---|
| `Study1.R` | All analyses of Study 1 (and the pilot stimulus check); Figures S1, S3 | `results/Study1/`, `results/Figures/` |
| `Study2.R` | All analyses of Study 2, including the serial mediation; Figures 2 (with Study 1), 3, S2; Tables S9–S11 | `results/Study2/`, `results/Figures/` |
| `Study3.R` | Part 1 behaviour (workbooks 01–05), Part 2 fNIRS activation and connectivity (06, 07), Part 3 brain–behaviour correlations (08), Part 4 human regulator ratings (09); Figures 4, 5b, S4, S5; ROI activation (β) per condition with MNI coordinates for the brain renderings of Figure 5a | `results/Study3/`, `results/Figures/` |
| `common.R` | Shared functions: effect-size CIs, power, Excel repair, and the figure helpers | — |

## Running the analyses

Requires R. The results were produced with R 4.6.1 on Windows 10 and the following package versions (the full session information is in `results/sessionInfo.txt`):

| Package | Version | Package | Version |
|---|---|---|---|
| car | 3.1-5 | openxlsx | 4.2.9 |
| emmeans | 2.0.4 | openxlsx2 | 1.30 |
| ggplot2 | 4.0.3 | patchwork | 1.3.2 |
| irr | 0.85 | psych | 2.6.9 |
| lme4 | 2.1-0 | readxl | 1.6.0 |
| lmerTest | 3.2-1 | zip | 3.0.2 |

To install them:

```
install.packages(c("car", "emmeans", "ggplot2", "irr", "lme4", "lmerTest", "openxlsx", "openxlsx2", "patchwork", "psych", "readxl", "zip"))
```

To install these exact versions instead, use `remotes::install_version()`, for example `remotes::install_version("lme4", "2.1-0")`. Then, from this folder:

```
Rscript run_all.R
```

`run_all.R` runs the three scripts in order and writes the console output of each to `results/logs/`. A script can also be run alone from `code/` (`Rscript Study1.R`, etc.); `Study2.R` needs the Study 1 models saved by `Study1.R`. The full run took about 10 minutes on a standard desktop computer.

## Results

| Path | Content | Manuscript |
|---|---|---|
| `results/Study1/Study1_results.xlsx` | All statistics of Study 1, one sheet per analysis | Study 1 results |
| `results/Study2/Study2_results.xlsx` | All statistics of Study 2, one sheet per analysis | Study 2 results |
| `results/Study2/Table_S9.xlsx`, `Table_S10.xlsx`, `Table_S11.xlsx` | Day 1 to Day 2 change in affect, serial mediation (path coefficients and indirect effects), emotion recognition error | Tables S9–S11 |
| `results/Study1/`, `results/Study2/` `*.rds` | Fitted models and tables (R objects) | — |
| `results/Study3/01_` – `05_*.xlsx` | Sample and design, manipulation checks, PRE, per-round ratings, relational evaluations | Study 3 behavioural results |
| `results/Study3/06_fnirs_activation.xlsx`, `07_functional_connectivity.xlsx` | fNIRS activation and connectivity models | Study 3 fNIRS results, Table S16 |
| `results/Study3/08_brain_behavior.xlsx` | Brain–behaviour correlations | Figures S4, S5 |
| `results/Study3/09_human_regulator.xlsx` | Ratings by the human regulators | Study 3 regulator results |
| `results/Study3/ROI_beta_by_condition.csv`, `lDLPFC_channels_by_condition.csv` | Model-estimated activation (β) of each ROI and condition with MNI coordinates (`x, y, z, beta, condition`) | Figure 5a |
| `results/Figures/` | Figures 2, 3, 4, 5b, S1–S5 (TIFF, 600 dpi) | Figures |
| `results/logs/` | Console output of each script (for Studies 1–2, with the code that produced it) | — |

Each Study 3 workbook opens with an overview sheet followed by the full tables.

## Analysis notes

- Linear mixed models were fitted with `lme4`/`lmerTest` (REML; Type III tests with Satterthwaite degrees of freedom; sum-to-zero contrasts). Means reported in the text are estimated marginal means (`emmeans`).
- Study 3 primary model: Group × Regulator × Round with random intercepts for participants and for sessions within participants.
- Study 3 variable names: `Visit` in `Study3.R` is not in the raw data. It is created from `session_order` in `Study 3.xlsx` (1 = first session, 2 = second session) and corresponds to "session" in the manuscript. Each participant had one AI and one human session, so the random term `(1 | ID:Visit)` is the session intercept, written as (1 | participant:session) in the Supplementary Material. As a fixed effect in the sensitivity analyses, `Visit` is session order. `ID` = participant; `Writer` and `HumanRegulator` = the human regulator who wrote the responses.
- fNIRS: β values more than 5 SD from the mean of their ROI (or ROI pair) were set to missing before modelling.
- Multiple comparisons: Benjamini–Hochberg FDR across ROIs or outcomes; Bonferroni within families of follow-up comparisons, as stated in each table.
- Wilcoxon tests use the normal approximation (`exact = FALSE`), so p values do not depend on the R version's default.
- Brain map coordinates: each ROI is placed at the probability-weighted mean of the MNI coordinates of its channels, the same weights used to form the ROI signal.

## License

Code: MIT License. Data and results: CC BY 4.0. See `LICENSE`.
