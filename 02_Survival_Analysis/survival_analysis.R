### Felicia Schulz
### This script creates survival plots for two different .csv files
### The input data must be a merged PDL1 output scores and classes file as well
### as a survival file
rm(list=ls())
library(survminer)
require("survival")
require(gridExtra)


survival_data <- read.csv("survData.csv")
df <- subset(survival_data, Include_ACT_OS_Analysis==1) # only those that received chemotherapy
survival_data$OS <- survival_data$Include_ACT_OS_Analysis
survival_data$Include_ACT_OS_Analysis <- NULL


#merged <- read.csv("merged_data.csv")
merged_he <- read.csv("../01_PDL1_Performance_Analysis/merged_HEstained.csv")
merged_ihc <- read.csv("../01_PDL1_Performance_Analysis/merged_PDL1stained.csv")
surv_merged_he <- inner_join(df, merged_he, by = "PD_ID")
surv_merged_ihc <- inner_join(df, merged_ihc, by="PD_ID")

## 1. Plot with cell counts
# median = 38.5
fit1 <- survfit(Surv(IDFS, IDFSbin) ~ cell_counts_class, data=surv_merged_he)
plot1 <- ggsurvplot(fit1, conf.int = TRUE, pval=TRUE, risk.table = "abs_pct", risk.table.y.text.col = TRUE,
           legend.title = "Cell counts", legend.labs = c("high", "low"), 
           title = "Survival plot TNBC data\ndivided by median of cell counts")


## 2. Plot with pathologist predictions
# threshold = 0.01
fit2 <- survfit(Surv(IDFS, IDFSbin) ~ class_true, data=surv_merged_he)
plot2 <- ggsurvplot(fit2, conf.int=TRUE, pval=TRUE, linetype = "strata", risk.table = TRUE, risk.table.y.text.col = TRUE,
           legend.title = "Pathologist label", legend.labs = c("0", "1"),
           title = "Survival plot TNBC data\ndivided by pathologist's labels of presence of PDL1")


## 3. Plot with ml predictions H&E-stained data
# threshold = 0.5
fit3 <- survfit(Surv(IDFS, IDFSbin) ~ class_predicted, data=surv_merged_he)
plot3 <- ggsurvplot(fit3, conf.int=TRUE, pval=TRUE, linetype = "strata", risk.table = TRUE, risk.table.y.text.col = TRUE,
           legend.title = "ML prediction", legend.labs = c("0", "1"),
           title = "Survival plot TNBC data divided by ML model\npredictions of presence of PDL1 in H&E-stained data")


## 4. Plot with ml predictions IHC-stained data
# threshold = 0.5
fit4 <- survfit(Surv(IDFS, IDFSbin) ~ class_predicted, data=surv_merged_ihc)
plot4 <- ggsurvplot(fit4, conf.int=TRUE, pval=TRUE, linetype = "strata", risk.table = TRUE, risk.table.y.text.col = TRUE,
           legend.title = "ML prediction", legend.labs = c("0", "1"),
           title = "Survival plot TNBC data divided by ML model\npredictions of presence of PDL1 in IHC-stained data")


# To get the output as a .jpg image with all four plots, run this below section
# Otherwise, just print the plots by running "plot4", and then save them manually.

plotlist <- list()
# The "ggsurvplot" functions here can also be replaced with the "plot1", "plot2" etc
# defined earlier. Here I redefined them so that the captions and styles could be altered
# so that in the grouping, it looks less messy.
plotlist[[1]] <- ggsurvplot(fit3, conf.int=TRUE, pval=TRUE, linetype = "strata", risk.table = TRUE, risk.table.y.text.col = TRUE,
                            legend.title = "ML prediction", legend.labs = c("0", "1"),
                            title = "H&E-stained data",
                            ggtheme = theme_grey())

plotlist[[2]] <-  ggsurvplot(fit4, conf.int=TRUE, pval=TRUE, linetype = "strata", risk.table = TRUE, risk.table.y.text.col = TRUE,
                             legend.title = "ML prediction", legend.labs = c("0", "1"),
                             title = "IHC-stained data",
                             ggtheme = theme_grey())

plotlist[[3]] <- ggsurvplot(fit1, conf.int = TRUE, pval=TRUE, risk.table = TRUE, risk.table.y.text.col = TRUE,
                            legend.title = "Cell counts", legend.labs = c("high", "low"), 
                            title = "Cell counts",
                            ggtheme = theme_grey())

plotlist[[4]] <- ggsurvplot(fit2, conf.int=TRUE, pval=TRUE, linetype = "strata", risk.table = TRUE, risk.table.y.text.col = TRUE,
                            legend.title = "Pathologist label", legend.labs = c("0", "1"),
                            title = "Pathologist's labels",
                            ggtheme = theme_grey())

# Arrange all plots into one
res <- arrange_ggsurvplots(plotlist, print=FALSE, ncol=2, nrow=2, risk.table.height = 0.3, 
                           title = "Survival plot TNBC data divided by ML model predictions of presence of PDL1")
# Save plots
ggsave("all_survival_plots.png", res, device="png", width=12, height=12, units="in")





