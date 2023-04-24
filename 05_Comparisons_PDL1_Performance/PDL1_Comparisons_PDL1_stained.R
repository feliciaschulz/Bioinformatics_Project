rm(list = ls())
library(ggplot2)
library(tidyverse)


# new PDL1 stained ml results
ml_results <- read.csv("output_hematoxylin.txt", sep=" ", header=FALSE)
colnames(ml_results) <- c("Name", "PDL1score_sp142")
ml_results$PDL1class_sp142 <- ifelse(ml_results$PDL1score_sp142 >= 0.5, 1, 0)
ml_results$Name <- gsub(".*/(TNBC[^/]*)\\.jpg:.*|_TNBC_2A", "\\1", ml_results$Name)
# adding PDIDs
id_matching <- read.csv("PDL1sp142_PDidmap.csv", sep=";")
id_matching$Name <- id_matching$PDL1_SP142_image
id_matching$Name <- gsub("\\.png|\\.jpg| ", "\\1", id_matching$Name)
ml_results_merged <- inner_join(ml_results, id_matching, by="Name")
ml_results_merged$X <- NULL
ml_results_merged$PDL1_SP142_image <- NULL



# pathologist labelled data
data <- read.csv("PDL1scores.csv")
data$Name <- gsub("\\.png|\\.jpg| ", "\\1", data$Name)
data$Name <- gsub("_HTX|_HE| ", "\\1", data$Name)
data <- drop_na(data)
sum(is.na(data$PDL1class_sp142)) # there were 4 NA predictions in data, now 0


# old HTX ml results
old_ml_results <- read.csv("output.txt", sep=" ", header=FALSE)
colnames(old_ml_results) <- c("Name", "PDL1score_sp142")
old_ml_results$PDL1class_sp142 <- ifelse(old_ml_results$PDL1score_sp142 >= 0.5, 1, 0)






# checking if names align, they do
present <- 0
for (rown in ml_results_merged$uid) {
  if (rown %in% data$uid) {
    #print(rown)
    present = present + 1 # 436, so all in data also in ml_results
  }
}

summary(ml_results)

# merge the data sets based on the "uid" column
merged_PDL1stained <- inner_join(ml_results_merged, data, by = "uid")
merged_PDL1stained$ImageName <- merged_PDL1stained$Name.x
merged_PDL1stained$PathologistName <- merged_PDL1stained$Name.y
merged_PDL1stained$score_predicted <- merged_PDL1stained$PDL1score_sp142.x
merged_PDL1stained$score_true <- merged_PDL1stained$PDL1score_sp142.y / 100
merged_PDL1stained$class_predicted <- merged_PDL1stained$PDL1class_sp142.x
merged_PDL1stained$class_true <- merged_PDL1stained$PDL1class_sp142.y
merged_PDL1stained$PD_ID <- merged_PDL1stained$PDid.x
# Find the indices of columns to be removed
cols_to_remove <- grep("\\.(x|y)$", names(merged_PDL1stained))
merged_PDL1stained <- merged_PDL1stained[, -cols_to_remove]

median(merged_PDL1stained$PDL1_SP142) # 38.5
merged_PDL1stained$cell_counts_class <- ifelse(merged_PDL1stained$PDL1_SP142>=median(merged_PDL1stained$PDL1_SP142), "above_median", "below_median")

#write.csv(merged_PDL1stained, "merged_PDL1stained.csv", row.names=FALSE, quote=FALSE) 


# create confusion matrices
conf_mat <- table(merged_PDL1stained$class_predicted, merged_PDL1stained$class_true)
conf_df <- as.data.frame.matrix(conf_mat)
conf_df$predicted <- rownames(conf_df)
rownames(conf_df) <- NULL
conf_df <- tidyr::pivot_longer(conf_df, -predicted, names_to = "true", values_to = "count")

# Plot the heatmap
ggplot(conf_df, aes(x = predicted, y = true, fill = count)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "steelblue") +
  geom_text(aes(label = count), color = "black", size = 3) +  # add text to the plot
  labs(title = "Confusion Matrix PDL1-stained", x = "Predicted", y = "True") +
  theme_minimal()




# load ggplot2
library(ggplot2)
library(hrbrthemes)

merged_PDL1stained$class <- ifelse(merged_PDL1stained$class_predicted == 1 & merged_PDL1stained$class_true == 0, 1, 
                   ifelse(merged_PDL1stained$class_predicted == 0 & merged_PDL1stained$class_true == 1, 2, 
                          ifelse(merged_PDL1stained$class_predicted == 0 & merged_PDL1stained$class_true == 0, 3, 0)))



# A basic scatterplot with color depending on Species
ggplot(merged_PDL1stained, aes(x=score_predicted, y=score_true, color=class)) + 
  ggtitle("PDL1 stained images") +
  geom_point(size=4) +
  geom_vline(xintercept = 0.5, color = "black") +
  geom_hline(yintercept = 0.01, color = "black")













