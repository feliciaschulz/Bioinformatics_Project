rm(list=ls())
library(survminer)
require("survival")


survival_data <- read.csv("survData.csv")
df <- subset(survival_data, Include_ACT_OS_Analysis==1) # only those that received chemotherapy
survival_data$OS <- survival_data$Include_ACT_OS_Analysis
survival_data$Include_ACT_OS_Analysis <- NULL

### Plot with ml predictions (threshold=0.5)

merged <- read.csv("../05_Comparisons_PDL1_Performance/merged_PDL1stained.csv")
surv_merged <- inner_join(df, merged, by = "PD_ID")


fit4 <- survfit(Surv(IDFS, IDFSbin) ~ class_predicted, data=surv_merged)
ggsurvplot(fit4, conf.int=TRUE, pval=TRUE, linetype = "strata", risk.table = TRUE, risk.table.y.text.col = TRUE,
           legend.title = "ML prediction", legend.labs = c("0", "1"),
           title = "Survival plot PDL1-stained data\ndivided by ML model predictions of presence of PDL1")



