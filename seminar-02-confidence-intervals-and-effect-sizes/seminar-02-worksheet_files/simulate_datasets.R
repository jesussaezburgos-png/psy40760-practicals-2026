# Seminar 2 practical - simulated data sets for the worksheet
#
# 1. weight_trial.csv          one row per participant (used in Part 3)
#    A fictional 12-week weight-loss trial, programme vs control, run at three sites.
#    True effects: programme loses 3 kg more than control (between-person SD 5 kg, d = 0.6);
#    wellbeing (0-40 questionnaire) 2 points higher in the programme group (SD 6, d = 0.33).
#    Four wellbeing scores are missing (questionnaire not returned).
# 2. weight_followup_wide.csv  wide format, weight at weeks 0, 4, 8, 12 (used in the challenges only)
#    A smaller follow-up study; each person's weight is measured four times.
#
# Base R only; seeded. Run from this folder:  Rscript simulate_datasets.R

set.seed(2026)

# ---- 1. weight_trial.csv --------------------------------------------------------------
site_n <- c(Dublin = 60, Cork = 40, Galway = 20)          # participants per site (half per group)
site   <- rep(names(site_n), site_n)
group  <- unlist(lapply(site_n, function(k) rep(c("control", "programme"), each = k / 2)), use.names = FALSE)
n      <- length(site)

sex    <- sample(c("female", "male"), n, replace = TRUE, prob = c(0.6, 0.4))
age    <- round(pmin(pmax(rnorm(n, 38, 10), 18), 65))
weight_start_kg <- round(rnorm(n, 82, 12), 1)

true_loss <- ifelse(group == "programme", 4, 1)          # mean kg lost over 12 weeks
loss      <- rnorm(n, true_loss, 5)
weight_end_kg <- round(weight_start_kg - loss, 1)

wellbeing <- round(rnorm(n, ifelse(group == "programme", 24, 22), 6))
wellbeing <- pmin(pmax(wellbeing, 0), 40)
wellbeing[sample(which(group == "control"), 2)]   <- NA
wellbeing[sample(which(group == "programme"), 2)] <- NA

trial <- data.frame(id = sprintf("P%03d", seq_len(n)), site, group, sex, age,
                    weight_start_kg, weight_end_kg, wellbeing)
trial <- trial[sample(n), ]                               # rows in random order, as recruited
trial$id <- sprintf("P%03d", seq_len(n))
write.csv(trial, "weight_trial.csv", row.names = FALSE)

# ---- 2. weight_followup_wide.csv ------------------------------------------------------
m     <- 40
grp2  <- rep(c("control", "programme"), each = m / 2)
base  <- rnorm(m, 84, 11)
slope <- rnorm(m, ifelse(grp2 == "programme", -0.30, -0.05), 0.12)   # kg per week
weeks <- c(0, 4, 8, 12)
wts   <- sapply(weeks, function(w) round(base + slope * w + rnorm(m, 0, 0.8), 1))
colnames(wts) <- sprintf("weight_wk%02d", weeks)
followup <- data.frame(id = sprintf("F%02d", seq_len(m)), group = grp2, wts)
write.csv(followup, "weight_followup_wide.csv", row.names = FALSE)

# ---- Check against the intended effects ----------------------------------------------
trial$loss <- trial$weight_start_kg - trial$weight_end_kg
print(aggregate(cbind(loss, wellbeing) ~ group, trial, function(x) round(c(mean = mean(x), sd = sd(x)), 2)))
print(t.test(loss ~ group, data = trial)$conf.int)
print(table(trial$site, trial$group))
