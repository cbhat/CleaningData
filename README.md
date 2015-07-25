Run_analysis_2.r is a script implementing the course Project for the
"Getting and Cleaning Data" course.

The script has to be downloaded to the same location as the data..
IT should be colocated with the activity_labels.txt file.

The script initially loads all the data into global variables in the R environment.

The following functions are executed to merge and format the data and finally calculate the mean

merge_test_train - merges test and train datasets
add_label - adds labels to the merged dataset
filter_mean_sd - filters out columns holding mean and stf variables
expand_activity_code - expands activity code values with the actual activity name
activity_summary - Summarize the data per subject and per activity. The summary function we are interested in is the MEAN.

Finally the results of the summary action is written out to the file tidy_dats.txt file# CleaningData
