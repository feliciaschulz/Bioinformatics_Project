# Felicia Schulz
rm(list = ls())
library(ggplot2)
library(tidyverse)
library(hrbrthemes)
require(gridExtra)

### This script assumes that the PDL1 machine learning output file is already merged with 
### the file containing the pathologist's PDL1 scores and classes.

### If they are not merged into one data set yet, this can be done by using the script "edit_data.R"

# Load data
merged_PDL1stained <- read.csv("merged_PDL1stained.csv")

# Create column with cell count median
median(merged_PDL1stained$PDL1_SP142) # 38.5
merged_PDL1stained$cell_counts_class <- ifelse(merged_PDL1stained$PDL1_SP142>=median(merged_PDL1stained$PDL1_SP142), "above_median", "below_median")

# Create confusion matrices
conf_mat <- table(merged_PDL1stained$class_predicted, merged_PDL1stained$class_true)
conf_df <- as.data.frame.matrix(conf_mat)
conf_df$predicted <- rownames(conf_df)
rownames(conf_df) <- NULL
conf_df <- tidyr::pivot_longer(conf_df, -predicted, names_to = "true", values_to = "count")

# Plot the heatmap
conf_heatmap <- ggplot(conf_df, aes(x = predicted, y = true, fill = count)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "darkgreen") +
  geom_text(aes(label = count), color = "black", size = 3) +  # add text to the plot
  labs(title = "B: Predicted classes of IHC-stained images", x = "Predicted class", y = "True class") +
  theme_minimal()


# Create "classes" in the data to colour points on scatterplot
merged_PDL1stained$class <- ifelse(merged_PDL1stained$class_predicted == 1 & merged_PDL1stained$class_true == 0, 1, 
                   ifelse(merged_PDL1stained$class_predicted == 0 & merged_PDL1stained$class_true == 1, 2, 
                          ifelse(merged_PDL1stained$class_predicted == 0 & merged_PDL1stained$class_true == 0, 3, 0)))


# Scatterplot
scatterplot <- ggplot(merged_PDL1stained, aes(x=score_predicted, y=score_true, color=class)) + 
  geom_point(size=4) +
  ggtitle("A: Predicted scores of IHC-stained images") +
  xlab("Predicted score")+
  ylab("True score")+
  theme(legend.position = "none")  


# Arrange both plots into one
grid.arrange(scatterplot, conf_heatmap, ncol = 2)











