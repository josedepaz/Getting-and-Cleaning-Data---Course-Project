library(dplyr)

#STEP 1

subject_train <- read.table("UCI HAR Dataset//train//subject_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_all <- rbind(subject_train, subject_test)

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
x_all <- rbind(x_train, x_test)

y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_all <- rbind(y_train, y_test)

#STEP 2

raw_features <- read.table("UCI HAR Dataset/features.txt")
features <- raw_features[grep("mean\\(\\)|std\\(\\)", raw_features$V2),]
x_all <- x_all[,features$V1]
ncol(x_all);

#STEP 3

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_names <- inner_join(y_all, activity_labels)

data <- cbind(x_all, activity_names$V2, subject_all)

#STEP 4
names(data) <- c(as.character(features$V2), "activity", "subject")

#STEP 5
data2 <- data
final_data <- data2 %>% group_by(activity,subject) %>% summarise_each(funs(mean))

write.table(final_data, file = "tidy_data.txt", row.names = FALSE)

