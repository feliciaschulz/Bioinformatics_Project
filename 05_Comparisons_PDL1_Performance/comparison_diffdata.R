# This script is for comparing the ml predictions for the H&E stained data and
# the PDL1 stained data. Not in comparison to the pathologist's labels
# but only about the predictions of the ml model itself.

rm(list = ls())
library(dplyr)
library(ggplot2)

pdl1stained <- read.csv("merged_PDL1stained.csv")
hestained <- read.csv("merged_HEstained.csv")


ml_pdl1 <- select(pdl1stained, uid, score_predicted, class_predicted)
ml_he <- select(hestained, uid, score_predicted, class_predicted)
all_ml_results %>% 
  left_join(ml_pdl1, ml_he, by="uid")
  all_ml_results$pdl1_score <- all_ml_results$score_predicted.x
  all_ml_results$pdl1_class <- all_ml_results$class_predicted.x
  all_ml_results$he_score <- all_ml_results$score_predicted.y
  all_ml_results$he_class <- all_ml_results$class_predicted.y
  all_ml_results[, 2:5] <- NULL

#write.csv(all_ml_results, "ML_results_PDL1vsHEstained.csv", row.names = FALSE, quote = FALSE)
  
# create a confusion matrix for the two predictions
conf_table <- table(all_ml_results$he_class, all_ml_results$pdl1_class)
conf_df <- as.data.frame.matrix(conf_table)
percent_common <- (202+100) / (202+44+86+100)
sprintf("Agreement is %f percent.", percent_common)

# create a scatterplot for the two predictions
ggplot(data=all_ml_results, mapping=aes(x=he_score, y=pdl1_score)) +
  geom_point(size=2) +
  geom_smooth(method='lm') +
  ggtitle("ML predictions for H&E vs PDL1-stained TNBC images")









