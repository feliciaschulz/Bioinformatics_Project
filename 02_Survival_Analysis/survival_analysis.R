rm(list=ls())
library(survminer)
require("survival")
require(gridExtra)


survival_data <- read.csv("survData.csv")
df <- subset(survival_data, Include_ACT_OS_Analysis==1) # only those that received chemotherapy
survival_data$OS <- survival_data$Include_ACT_OS_Analysis
survival_data$Include_ACT_OS_Analysis <- NULL



### don't need these two ###
# plot with only OS positive
fitx <- survfit(Surv(IDFS, IDFSbin) ~ 1, data = df)
ggsurvplot(fitx, conf.int = TRUE, risk.table = "abs_pct", risk.table.y.text.col = TRUE, censor = TRUE, title = "Survival plot H&E stained data\nInclude_ACT_OS_Analysis=1")
# can't add median survival because survival > 0.5 at all times
# plot with both OS=1 and OS=2
fity <- survfit(Surv(IDFS, IDFSbin) ~ OS, data = survival_data)
ggsurvplot(fity, pval = TRUE, linetype = "strata", conf.int = TRUE, risk.table = TRUE, risk.table.y.text.col = TRUE,
           title = "Survival plot H&E stained data")


### 1. Plot with cell counts (set threshold at median)
### 2. Plot with ml predictions (threshold=0.5)

#merged <- read.csv("merged_data.csv")
merged_he <- read.csv("../05_Comparisons_PDL1_Performance/merged_HEstained.csv")
merged_ihc <- read.csv("../05_Comparisons_PDL1_Performance/merged_PDL1stained.csv")
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


#grid.arrange(plot1, plot2, plot3, plot4, nrow=2, ncol=2)
plotlist <- list()
plotlist[[1]] <- ggsurvplot(fit3, conf.int=TRUE, pval=TRUE, linetype = "strata", risk.table = TRUE, risk.table.y.text.col = TRUE,
                            legend.title = "ML prediction", legend.labs = c("0", "1"),
                            title = "H&E-stained data",
                            ggtheme = theme_minimal())

plotlist[[2]] <-  ggsurvplot(fit4, conf.int=TRUE, pval=TRUE, linetype = "strata", risk.table = TRUE, risk.table.y.text.col = TRUE,
                             legend.title = "ML prediction", legend.labs = c("0", "1"),
                             title = "IHC-stained data",
                             ggtheme = theme_grey())

#plotlist[[3]] <- plot3
#plotlist[[4]] <- plot4

res <- arrange_ggsurvplots(plotlist, print=FALSE, ncol=2, nrow=1, risk.table.height = 0.3, 
                           title = "Survival plot TNBC data divided by ML model predictions of presence of PDL1")
ggsave("myfile.pdf", res, width=10, height=5, units="in")





