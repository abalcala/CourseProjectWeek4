#Getting and Cleaning Data Week 4 Project Assignment
#download and extract ZIP file
url <- download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "M3.zip")
unzip(zipfile="M3.zip",exdir=getwd())
#set file path
path <- file.path(getwd(), "UCI HAR Dataset")
list.files(path, recursive = TRUE)
test <- file.path(path, "test") 
train <- file.path (path, "train")
#read files
#train
xt <- read.table(file.path(train, "X_train.txt"), header = FALSE)
yt <- read.table(file.path(train, "Y_train.txt"), header = FALSE)
sub_t <- read.table(file.path(train, "subject_train.txt"), header = FALSE)
#test
xtest <- read.table(file.path(test, "X_test.txt"), header = FALSE)
ytest <- read.table(file.path(test, "Y_test.txt"), header = FALSE)
sub_test <- read.table(file.path(test, "subject_test.txt"), header = FALSE)
#features
feat <- read.table(file.path(path, "features.txt"), header = FALSE)
#activity
activity <- read.table(file.path(path, "activity_labels.txt"), header = FALSE)
#fix variable names
colnames(xt) = feat[,2]
colnames(yt) = "activityID"
colnames(sub_t) = "subjectID"
colnames(xtest) = feat[,2]
colnames(ytest) = "activityID"
colnames(sub_test) = "subjectID"
colnames(activity) = c("activityID", "activityType")    
#merge files
#bind trainsets
X_set <- rbind(xt, xtest) #binding all X sets
y_set <- rbind(yt, ytest) #binding all y sets
sub_set <- rbind(sub_t, sub_test) #binding all subject sets
#extracting mean and std
extract_mean <- X_set[grep("mean", names(X_set))]
extract_std <- X_set[grep("std", names(X_set))]
#combine all sets
AllInOne <- cbind(extract_mean,extract_std, sub_set, y_set)
AllInOne <- merge(AllInOne, activity, by = "activityID") 
#
names(AllInOne) <- gsub("^t", "Time", names(AllInOne))
names(AllInOne) <- gsub("^f", "FrequencyDomain", names(AllInOne)) 
names(AllInOne) <- gsub("Acc", "Accelerometer", names(AllInOne))
names(AllInOne) <- gsub("mean()", "Mean", names(AllInOne))
names(AllInOne) <- gsub("Gyro", "Gryoscope", names(AllInOne)) 
names(AllInOne) <- gsub("Mag", "Magnitude", names(AllInOne))
names(AllInOne) <- gsub("BodyBody", "Body", names(AllInOne))
names(AllInOne) <- gsub("Freq()", "Frequency", names(AllInOne))
names(AllInOne) <- gsub("std", "StandardDeviation", names(AllInOne))
names(AllInOne) <- gsub("Frequencyuency", "Frequency", names(AllInOne))

#aggregate values to create new dataset
TidyData <- aggregate(. ~subjectID + activityType, AllInOne, mean)
TidyData <- TidyData[order(TidyData$subjectID,TidyData$activityType),]
write.table(TidyData, file = "tidydata.txt",row.name=FALSE)
#