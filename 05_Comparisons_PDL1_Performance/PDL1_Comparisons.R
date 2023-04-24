rm(list = ls())
library(ggplot2)
library(tidyverse)

ml_results <- read.csv("output.txt", sep=" ", header=FALSE)
data <- read.csv("PDL1scores.csv")
View(data)
View(ml_results)

### TASKS ### DONE
# 1. Modify ml_results:
#   - Add column names
#   - Change names of images
#   - Add column for binary classes
#
# 2. Modify data:
#   - Change names of images
#   - Remove NAs


# 1: modifying ml_results
colnames(ml_results) <- c("Name", "PDL1score_sp142")
ml_results$PDL1class_sp142 <- ifelse(ml_results$PDL1score_sp142 >= 0.5, 1, 0)
ml_results$Name <- gsub(".*/(TNBC[^/]*)\\.jpg:.*", "\\1", ml_results$Name)

# 2: modifying data
data$Name <- gsub("\\.png|\\.jpg| ", "\\1", data$Name)
data <- drop_na(data)
sum(is.na(data$PDL1class_sp142)) # there were 4 NA predictions in data, now 0

# checking if names align, they do
present <- 0
for (rown in ml_results$Name) {
  if (rown %in% data$Name) {
    #print(rown)
    present = present + 1 # 436, so all in data also in ml_results
  }
}



# making a new data frame ml_results_filtered with only those images that are also in data
namecols <- as.data.frame(data$Name)
colnames(namecols) <- "Name"
ml_results_filtered <- inner_join(ml_results, namecols, by="Name")

data <- data[order(data$Name),]
ml_results_filtered <- ml_results_filtered[order(ml_results_filtered$Name),]


# merge the data sets based on the "Name" column
merged <- inner_join(ml_results_filtered, data, by = "Name")
merged$score_predicted <- merged$PDL1score_sp142.x
merged$score_true <- merged$PDL1score_sp142.y / 100
merged$class_predicted <- merged$PDL1class_sp142.x
merged$class_true <- merged$PDL1class_sp142.y
merged[, 2:9] <- NULL

# count the number of matches and mismatches
counts <- merged %>%
  summarise(
    same_class = sum(score_predicted == score_true),
    different_class = sum(score_predicted != score_true)
  )
print(counts)



# create confusion matrices
conf_mat <- table(merged$class_predicted, merged$class_true)
conf_df <- as.data.frame.matrix(conf_mat)
conf_df$predicted <- rownames(conf_df)
rownames(conf_df) <- NULL
conf_df <- tidyr::pivot_longer(conf_df, -predicted, names_to = "true", values_to = "count")

# Plot the heatmap
ggplot(conf_df, aes(x = predicted, y = true, fill = count)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "steelblue") +
  geom_text(aes(label = count), color = "black", size = 3) +  # add text to the plot
  labs(title = "Confusion Matrix H&E stained", x = "Predicted", y = "True") +
  theme_minimal()



# load ggplot2
library(ggplot2)
library(hrbrthemes)

merged$class <- ifelse(merged$class_predicted == 1 & merged$class_true == 0, 1, 
                   ifelse(merged$class_predicted == 0 & merged$class_true == 1, 2, 
                          ifelse(merged$class_predicted == 0 & merged$class_true == 0, 3, 0)))



# A basic scatterplot with color depending on Species
ggplot(merged, aes(x=score_predicted, y=score_true, color=class)) + 
  geom_point(size=4) +
  geom_vline(xintercept = 0.5, color = "black") +
  geom_hline(yintercept = 0.01, color = "black") +
  ggtitle("H&E stained images")













