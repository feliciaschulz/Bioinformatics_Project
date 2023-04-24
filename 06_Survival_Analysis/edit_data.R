# this code edits and merges the two dfs output.txt and PDL1scores.csv and saves
# them as the new df merged_data.csv to the directory 06

ml_results <- read.csv("../05_Comparisons_PDL1_Performance/output.txt", sep=" ", header=FALSE)
colnames(ml_results) <- c("Name", "PDL1score_sp142")
ml_results$PDL1class_sp142 <- ifelse(ml_results$PDL1score_sp142 >= 0.5, 1, 0)
ml_results$Name <- gsub(".*/(TNBC[^/]*)\\.jpg:.*", "\\1", ml_results$Name)


pathologist_data <- read.csv("../05_Comparisons_PDL1_Performance/PDL1scores.csv")
pathologist_data$Name <- gsub("\\.png|\\.jpg| ", "\\1", pathologist_data$Name)
pathologist_data <- drop_na(pathologist_data)

# merge the data sets based on the "Name" column
merged <- inner_join(ml_results, pathologist_data, by = "Name")
merged$score_predicted <- merged$PDL1score_sp142.x
merged$score_true <- merged$PDL1score_sp142.y
merged$class_predicted <- merged$PDL1class_sp142.x
merged$class_true <- merged$PDL1class_sp142.y
merged[, 2:4] <- NULL
merged[, 5:6] <- NULL
merged$score_true <- merged$score_true / 100
merged$PD_ID <- merged$PDid
merged$PDid <- NULL


median(merged$PDL1_SP142) # 38.5
merged$cell_counts_class <- ifelse(merged$PDL1_SP142>=median(merged$PDL1_SP142), "above_median", "below_median")
write.csv(merged, "merged_HEstained.csv", row.names=FALSE, quote=FALSE) 


