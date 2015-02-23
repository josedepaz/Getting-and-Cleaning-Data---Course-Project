#Course Project

Script that contains the steps to create tidy data from raw data.

The five steps are:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#Load the dplyr library
```
library(dplyr)
```

#STEP 1

* Load the data of the subject_train and subject_test and then merge the data in subject_all dataframe.

```
subject_train <- read.table("UCI HAR Dataset//train//subject_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_all <- rbind(subject_train, subject_test)
```

* Load the data of the x_train and x_test and then merge the data in  x_all dataframe.

```
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
x_all <- rbind(x_train, x_test)
```

* Load the data of the y_train and y_test and then merge the data in y_all dataframe.

```
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_all <- rbind(y_train, y_test)
```

#STEP 2

* Load de features data  and find only the rows that contains mean() or std(), then load only the data of the columns that exists in the features dataframe, in de x_all dataframe.

```
raw_features <- read.table("UCI HAR Dataset/features.txt")
features <- raw_features[grep("mean\\(\\)|std\\(\\)", raw_features$V2),]
x_all <- x_all[,features$V1]
ncol(x_all);
```

#STEP 3

* Load and merge the data of activity_labels with the y_all dataframe, and next, merge the second column that contains the activity names with the x_all and subject_all dataframes.

```
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_names <- inner_join(y_all, activity_labels)

data <- cbind(x_all, activity_names$V2, subject_all)
```

#STEP 4

* Fix the names of the dataset, setting the names of features, activity and subject columns.

```
names(data) <- c(as.character(features$V2), "activity", "subject")
```

#STEP 5

* Create the final data, grupping the data by activity and subject, and calculating the mean with the summarise function.

```
data2 <- data
final_data <- data2 %>% group_by(activity,subject) %>% summarise_each(funs(mean))
```

* Create the tidy_data.txt file with the final data.

```
write.table(final_data, file = "tidy_data.txt", row.names = FALSE)
```