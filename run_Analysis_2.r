setwd("C:/CleaningData/Project/UCI HAR Dataset")


 
 
 merge_test_train <- function(subject_test, x_test,y_test,subject_train,x_train,y_train)
 {
 
# Merge both test data set and the training data set to create a common data set.

merged_test2 <- merge_datasets(y_test, x_test)
merge_test <- merge_datasets(subject_test, merged_test2)

merge_train2 <- merge_datasets(y_train, x_train)
merge_train <- merge_datasets(subject_train,merge_train2)

merge_combined <- rbind(merge_test, merge_train)

return(merge_combined)

 
 }
 
 merge_datasets <- function( d1, d2) {
 
 rows <- nrow(d1)
 cols <- ncol(d1) + ncol(d2)
 
 merged_data <- data.frame(matrix(nrow = rows, ncol=cols))
 for ( i in 1:rows) {
   myrow <- c(d1[i,] ,d2[i,])
   merged_data[i,] <- myrow
 
 }
 return(merged_data)
 }
 
 
 
add_label  <- function(dataset)
 {
 
# Add a descriptive label to the input dataset and return it

features_raw <- read.table("features.txt")

rows <- nrow(features_raw)

merged_label <- c("SUBJECT", "ACTIVITY") 

for ( i in 1:rows){

merged_label <- c(merged_label , as.character(features_raw[i,2]))
}

colnames(dataset) <- merged_label

return(dataset)

 
 }
 
 
filter_mean_sd <- function(dataset)
 {
# Filter out mean and standard deviation
 
# Use regular expression to retrieve all mean and sd variables
 
 features_raw <- read.table("features.txt")
 
 rows <- nrow(features_raw)
 mean_sd_vars <- c("SUBJECT", "ACTIVITY") 

 
 for ( i in 1:rows){

 if ( (regexpr( "*mean*", as.character(features_raw[i,2])) != -1) || (regexpr("*std*", as.character(features_raw[i,2])) != -1)) {

			mean_sd_vars <- c(mean_sd_vars , as.character(features_raw[i,2]))
#						print (  as.character(features_raw[i,2]))

			
}
 
 }
 filtered_dataset <- dataset[ mean_sd_vars]
 
 return( filtered_dataset);
 
 }
 
 expand_activity_code <- function(dataset){
 
 a_label <- read.table("activity_labels.txt")
 
 rows <- nrow( dataset)
 
 for ( i in 1:rows) {
 
 dataset[i,2] <- as.character(a_label[dataset[i,2],2])
 
 }
 
 return(dataset)
 
 }
 
 
activity_summary <- function( dataset)
 {
 
# creates a second, independent tidy data set with the average of each variable for each activity and each subject 
 
  
  summary_data <- aggregate(dataset[,3:length(names(dataset))], by=dataset[c("SUBJECT","ACTIVITY")], FUN=mean)

 
 return(summary_data)

 
 }
 
 
#load_data()

#Load all the data

activity_labels <- read.table("activity_labels.txt",sep="\t")

features_raw <- read.table("features.txt")

 
 
 X_test <-read.table("test/X_test.txt")
 
 Y_test <-read.table("test/Y_test.txt")
 
 subject_test <- read.table("test/subject_test.txt")
 
 X_train <-read.table("train/X_train.txt")
 
 Y_train <-read.table("train/Y_train.txt")
 
subject_train <- read.table("train/subject_train.txt")


# Merges the training and the test sets to create one data set.

mdata <- merge_test_train(subject_test, X_test,Y_test,subject_train,X_train,Y_train)

#Appropriately labels the data set with descriptive variable names

mdata_label <- add_label(mdata)

# Extracts only the measurements on the mean and standard deviation for each measurement. 

filtered_mdata_label <- filter_mean_sd(mdata_label)

#  Uses descriptive activity names to name the activities in the data set

filtered_mdata_label_activity <-  expand_activity_code(filtered_mdata_label)

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

sum_data <- activity_summary(filtered_mdata_label_activity)




 write.table(sum_data, file= "tidy_data.txt",row.name=FALSE)