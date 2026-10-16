# Seminar 3 practical - simulated Trial B data (trial_b.csv), for the Part 3 exercises.
#
# Same columns as trial_a.csv (id, group, sex, age, baseline_kg, loss_kg).
# 4,000 per group. Weight loss is rescaled within each group so that the SD is 5 kg and the
# group means are 1.000 kg (control) and 1.243 kg (programme): a difference of 0.243 kg, d = 0.049,
# matching Trial B as reported in Seminar 2 (t(7998) = 2.17, p = .030).
# As in Trial A, weight loss rises a little with baseline weight.
# Run from this folder. Base R only.

set.seed(2027)
n <- 4000
trial_b <- data.frame(
  id          = sprintf("B%04d", 1:(2 * n)),
  group       = rep(c("control", "programme"), each = n),
  sex         = sample(c("female", "male"), 2 * n, replace = TRUE),
  age         = round(runif(2 * n, 25, 60)),
  baseline_kg = round(rnorm(2 * n, 92, 12), 1)
)
trial_b$loss_kg <- 0.12 * (trial_b$baseline_kg - 92) + rnorm(2 * n, 0, 4.8)

# fix each group's mean and SD exactly
target_mean <- c(control = 1.000, programme = 1.243)
for (g in names(target_mean)) {
  k <- trial_b$group == g
  z <- (trial_b$loss_kg[k] - mean(trial_b$loss_kg[k])) / sd(trial_b$loss_kg[k])
  trial_b$loss_kg[k] <- target_mean[g] + 5 * z
}
trial_b$loss_kg <- round(trial_b$loss_kg, 2)
write.csv(trial_b, "trial_b.csv", row.names = FALSE)

# check against Seminar 2's numbers
print(aggregate(loss_kg ~ group, trial_b, function(x) c(mean = mean(x), sd = sd(x))))
print(t.test(loss_kg ~ group, trial_b, var.equal = TRUE))
