rm(list=ls())
library(survminer)
require("survival")


survival_data <- read.csv("survData.csv")
df <- subset(survival_data, Include_ACT_OS_Analysis==1) # only those that received chemotherapy
survival_data$OS <- survival_data$Include_ACT_OS_Analysis
survival_data$Include_ACT_OS_Analysis <- NULL




# plot with only OS positive
fit1 <- survfit(Surv(IDFS, IDFSbin) ~ 1, data = df)
ggsurvplot(fit1, conf.int = TRUE, risk.table = "abs_pct", risk.table.y.text.col = TRUE, censor = TRUE, title = "Survival plot H&E stained data\nInclude_ACT_OS_Analysis=1")
# can't add median survival because survival > 0.5 at all times

# plot with both OS=1 and OS=2
fit2 <- survfit(Surv(IDFS, IDFSbin) ~ OS, data = survival_data)
ggsurvplot(fit2, pval = TRUE, linetype = "strata", conf.int = TRUE, risk.table = TRUE, risk.table.y.text.col = TRUE,
           title = "Survival plot H&E stained data")


### 1. Plot with cell counts (set threshold at median)
### 2. Plot with ml predictions (threshold=0.5)

merged <- read.csv("merged_data.csv")
surv_merged <- inner_join(df, merged, by = "PD_ID")

merged <- read.csv("../05_Comparisons_PDL1_Performance/merged_HEstained.csv")


## 1. Plot with cell counts
# median = 38.5
fit3 <- survfit(Surv(IDFS, IDFSbin) ~ cell_counts_class, data=surv_merged)
ggsurvplot(fit3, conf.int = TRUE, pval=TRUE, risk.table = "abs_pct", risk.table.y.text.col = TRUE,
           legend.title = "Cell counts", legend.labs = c("high", "low"), 
           title = "Survival plot H&E stained data\ndivided by median of cell counts")

## 2. Plot with ml predictions
# threshold = 0.5
fit4 <- survfit(Surv(IDFS, IDFSbin) ~ class_predicted, data=surv_merged)
ggsurvplot(fit4, conf.int=TRUE, pval=TRUE, linetype = "strata", risk.table = TRUE, risk.table.y.text.col = TRUE,
           legend.title = "ML prediction", legend.labs = c("0", "1"),
           title = "Survival plot H&E stained data\ndivided by ML model predictions of presence of PDL1")

## 3. Plot with pathologist predictions
# threshold = 0.01
fit5 <- survfit(Surv(IDFS, IDFSbin) ~ class_true, data=surv_merged)
ggsurvplot(fit5, conf.int=TRUE, pval=TRUE, linetype = "strata", risk.table = TRUE, risk.table.y.text.col = TRUE,
           legend.title = "Pathologist label", legend.labs = c("0", "1"),
           title = "Survival plot H&E stained data\ndivided by pathologist's labels of presence of PDL1")




