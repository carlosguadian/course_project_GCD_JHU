## First check if the needed libraries exist, if not, install and load.

if (!require("dplyr")) {
  install.packages("dplyr")
}

if (!require("tibble")) {
  install.packages("tibble")
}

require("dplyr")
require("tibble")

# 1 MERGES THE TRAINING AND THE TEST SETS TO CREATE ONE DATA SET.

# Downloading data
file <- "Coursera_DS3_Final.zip"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
directory <- "UCI HAR Dataset"

# Check if the file exists
if(!file.exists(file)){
  download.file(fileURL,file, method="curl") 
}

# Check if you unzip the data previously
if(!file.exists(directory)){
  unzip(file)
}

# import features
features <- read.table("~/course_project_GCD_JHU/UCI HAR Dataset/features.txt", 
                       quote="\"", comment.char="")

# import data X
data_trainX <- read.table("~/course_project_GCD_JHU/UCI HAR Dataset/train/X_train.txt", 
                         quote="\"", comment.char="")
data_testX <- read.table("~/course_project_GCD_JHU/UCI HAR Dataset/test/X_test.txt", 
                         quote="\"", comment.char="")

# Merge X
dataX <- rbind(data_trainX, data_testX)

# Naming X
colnames(dataX) <- features$V2

# import data Y
data_trainY <- read.table("~/course_project_GCD_JHU/UCI HAR Dataset/train/Y_train.txt", 
                          quote="\"", comment.char="")
data_testY <- read.table("~/course_project_GCD_JHU/UCI HAR Dataset/test/Y_test.txt", 
                         quote="\"", comment.char="")

# Merge Y
dataY <- rbind(data_trainY, data_testY)

# Naming Y
colnames(dataY) <- "Activity"

# import subject data
subjectTest <- read.table("~/course_project_GCD_JHU/UCI HAR Dataset/test/subject_test.txt", 
                      quote="\"", comment.char="")
subjectTrain <- read.table("~/course_project_GCD_JHU/UCI HAR Dataset/train/subject_train.txt", 
                       quote="\"", comment.char="")

subject <- rbind(subjectTest, subjectTrain)
colnames(subject) <- "Subject"

# Final data
dataFinal <- cbind(subject, dataY, dataX)

# 2 EXTRACTS ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT. 

# Select only mean and std from dataFinal
filter_data <- dataFinal %>% select(Subject, Activity, contains("mean"), contains("std"))

# 3 USES DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET

# Change code activity by activity
filter_data$Activity <-gsub("1", "WALKING", filter_data$Activity)
filter_data$Activity <-gsub("2", "WALKING_UPSTAIRS", filter_data$Activity)
filter_data$Activity <-gsub("3", "WALKING_DOWNSTAIRS", filter_data$Activity)
filter_data$Activity <-gsub("4", "SITTING", filter_data$Activity)
filter_data$Activity <-gsub("5", "STANDING", filter_data$Activity)
filter_data$Activity <-gsub("6", "LAYING", filter_data$Activity)

# 4 APPROPRIATELY LABELS THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES.

# Making more readable variable names
names(filter_data) <-gsub("Acc", "Accelerometer", names(filter_data))
names(filter_data) <-gsub("Gyro", "Gyroscope", names(filter_data))
names(filter_data) <-gsub("BodyBody", "Body", names(filter_data))
names(filter_data) <-gsub("Mag", "Magnitude", names(filter_data))
names(filter_data) <-gsub("^t", "Time", names(filter_data))
names(filter_data) <-gsub("^f", "Frequency", names(filter_data))
names(filter_data) <-gsub("tBody", "TimeBody", names(filter_data))
names(filter_data) <-gsub("-mean()", "Mean", names(filter_data), ignore.case = TRUE)
names(filter_data) <-gsub("-std()", "STD", names(filter_data), ignore.case = TRUE)
names(filter_data) <-gsub("-freq()", "Frequency", names(filter_data), ignore.case = TRUE)
names(filter_data) <-gsub("angle", "Angle", names(filter_data))
names(filter_data) <-gsub("gravity", "Gravity", names(filter_data))

# To tibble to visualize better

dataFinal <- as_tibble(filter_data)
dataFinal

# 5 FROM THE DATA SET IN STEP 4, CREATES A SECOND, INDEPENDENT TIDY DATA SET WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT.

# Grouping by activiy and calculating mean of each variable
TidyData_Final <- dataFinal %>% group_by(Subject, Activity) %>%
  summarise_all(funs(mean))

# Writing independent Tidy Data Set
write.table(TidyData_Final, "TidyData_Final.txt", row.name=FALSE)

# Check final result
TidyData_Final
