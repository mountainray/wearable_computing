install.packages("tidyr")
install.packages("plyr")
install.packages("dplyr")
install.packages("stringi")
install.packages("data.table")
library(tidyr)
library(plyr)
library(dplyr)
library(stringi)
library(data.table)

setwd("/Users/rb/Desktop/Data Science course/Getting_and_Cleaning_data/wearable_computing/data")

# check for expected folder, create if it does not exist
if(!file.exists("./data")) {dir.create("./data")}

# raw data file names and locations, from "UCI HAR Dataset" zip file...these get read in below
# these two apply to all of the data...
features_raw <- "./data/UCI HAR Dataset/features.txt"  # these are the original variable names
activity_labels_raw <- "./data/UCI HAR Dataset/activity_labels.txt" # what each activity code means

# these files are specific to TEST or TRAIN data...
train_subject_file_name = "./data/UCI HAR Dataset/train/subject_train.txt" # subject ids, train
train_activity_file_name = "./data/UCI HAR Dataset/train/y_train.txt"      # subject activities, train
train_measures_file_name = "./data/UCI HAR Dataset/train/X_train.txt"      # measures data, train

test_subject_file_name = "./data/UCI HAR Dataset/test/subject_test.txt"    # subject ids, test
test_activity_file_name = "./data/UCI HAR Dataset/test/y_test.txt"         # subject activities, test
test_measures_file_name = "./data/UCI HAR Dataset/test/X_test.txt"         # measures data, test

# column names from features_info.txt...these apply to both test and train data...
features <- read.table(features_raw, col.names=c("feature_number", "feature"), stringsAsFactors = FALSE)
head(features)

# "bandsEnergy" type variables are a set of intervals, n=14 to each set, appear to repeat for X, Y, Z axes
# causes problems when dplyr selects from variables later in code, the variables are not unique
# rename each set, keeping original variable name but attaching -X, -Y, -Z for each "bandsEnergy" set (3 sets)
axis_vector <- rep(c("-X", "-Y", "-Z"), each = 14)
features$feature <-
        ifelse(stri_detect_regex(features$feature, "bandsEnergy")==TRUE,
               paste0(features$feature, axis_vector),
               features$feature)

# remove extraneous charactars from feature names data
features$feature <- sub("()","",features$feature, fixed = T)
features$feature <- sub("(","_",features$feature, fixed = T)
features$feature <- sub(")","_",features$feature, fixed = T)
features$feature <- gsub(",","_",features$feature, fixed = T)
features$feature <- gsub("-","_",features$feature, fixed = T)
features$feature <- gsub("__","_",features$feature, fixed = T)
features$feature <- gsub("[_)]$","",features$feature)
features$feature <- sub("_mean", "Mean", features$feature)
features$feature <- sub("_std", "Std", features$feature)
# change what appears to be a typo...
features$feature <- gsub("BodyBody","Body",features$feature, ignore.case = FALSE)
head(features, 10)

# get the activity labels
activity_labels <- read.table(activity_labels_raw, col.names=c("activity_id", "activity"), stringsAsFactors = FALSE)
head(activity_labels, 10)

# get subject data, join activities with labels, add to the main data
train_subject_ids <- read.table(train_subject_file_name, col.names=c("subject_id"))
train_activity <- read.table(train_activity_file_name, col.names=c("activity_id"))
train_activity <- left_join(train_activity, activity_labels)
train_measures <- fread(train_measures_file_name)
names(train_measures) <- features$feature
names(train_measures) <- paste0("mean_", names(train_measures))
train_data <- cbind(train_subject_ids, activity = train_activity$activity, 
                    select(train_measures, matches("mean|std")))

# get subject data, join activities with labels, add to the main data
test_subject_ids <- read.table(test_subject_file_name, col.names=c("subject_id"))
test_activity <- read.table(test_activity_file_name, col.names=c("activity_id"))
test_activity <- left_join(test_activity, activity_labels)
test_measures <- fread(test_measures_file_name)
names(test_measures) <- features$feature
names(test_measures) <- paste0("mean_", names(test_measures))
test_data <- cbind(test_subject_ids, activity = test_activity$activity, select(test_measures, matches("mean|std")))

# row-bind train and test data, set up for dplyr with tbl_df
wearable_computing <- tbl_df(rbind(train_data, test_data))

#dropping the meanFreq and angle_ variables, these are not in scope...
wearable_computing <- select(wearable_computing, -contains("meanFreq"))
wearable_computing <- select(wearable_computing, -contains("angle_"))
str(wearable_computing)

# set up groups for summary, output tidy dataset
wearable_computing <- group_by(wearable_computing, subject_id, activity)
wearable_computing_tidy <- wearable_computing %>%
        summarize_each(funs(mean))
str(wearable_computing_tidy)

#write out the final tidy dataset
write.table(wearable_computing_tidy, file = "wearable_computing_tidy.txt", sep = ",", row.names = FALSE)
