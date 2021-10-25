# Codebook

The script `run_analysis.R` execute the steps required by course project.

## Step by Step

* All the files needes are extracted to folder `UCI HAR Dataset`
* The variables are assigned to `features`
* Import data X (records for each subject) get `data train X` and `data test X` and merge data to `dataX` with `rbind` and assinging variable names from `features` with `colnames`
* Import data Y (each kind of activity) get `data train Y` and `data test Y` and merge data to `dataY` with `rbind` and assinging variable name to `Activity` with `colnames`
* Import `subject data` to `subjectTest` and `subjectTrain` and merge in `subject` with `rbind`, naming column with `colnames` to `Subject`
* Make final dataset merging `subject`, `dataY`, `dataX` to `dataFinal`
* Select only mean and std from dataFinal with `select`
* Change code activity by activity with `gsub` to use descriptive activity names
* Making more readable variable names with `gsub` to label data with more descriptive names.
* Convert `dataFinal` to `Tibble` to visualize better.
* Grouping by activiy and calculating mean of each variable with `group_by`
* Writing independent Tidy Data Set `TidyData_Final.txt`