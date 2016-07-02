#setwd("D:/R/getcleandata_project")
#fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#filename <- "sp_data.zip"
#download.file(fileURL, filename, mode = "wb")
#unzip("sp_data.zip")

setwd("D:/R/getcleandata_project/UCI HAR Dataset")

## I. Read Data

# Read features and activity description from the files

featureNames <- read.table('features.txt',header=FALSE)
activityLabels <- read.table('activity_labels.txt',header=FALSE)

# Read in the train data

subjectTrain <- read.table('train/subject_train.txt',header=FALSE)
featuresTrain <- read.table('train/X_train.txt',header=FALSE)
activityTrain <- read.table('train/Y_train.txt',header=FALSE)

# Read in the test data

subjectTest <- read.table('test/subject_test.txt',header=FALSE)
featuresTest <- read.table('test/X_test.txt',header=FALSE)
activityTest <- read.table('test/Y_test.txt',header=FALSE)

## II. Combine  and merge data

# Concatenate by rows
Subject <- rbind(subjectTrain, subjectTest)
Activity <- rbind(activityTrain, activityTest)
Features <- rbind(featuresTrain, featuresTest)

# Name Variables
names(Subject)<-c("subject")
names(Activity)<- c("activity")
names(Features)<- FeaturesNames$V2

# Merge by Columns subject and activity plus features

sub_actvt <- cbind(Subject, Activity)
sub_actvt_feat <- cbind(Features, sub_actvt)

## III. Subset of Features taking mean and Std Dev for each feature

# Take names of features with "mean()"and "std()" in the description

sub_featureNames <- featureNames$V2[grep("mean\\(\\)|std\\(\\)", featureNames$V2)]

# Subset the data frame sub_actvt_feat by selected names of Features

selectNames <- c(as.character(sub_featureNames), "subject", "activity" )

sub_actvt_feat <- subset(sub_actvt_feat, select = selectNames)

# Factorize variable activity in data frame sub_actvt_feat using activityNames

sub_actvt_feat$activity<- factor(sub_actvt_feat$activity,labels=as.character(activityLabels$V2))

## IV. Labelling the data set with expanded names

names(sub_actvt_feat)<-gsub("^t", "time", names(sub_actvt_feat))
names(sub_actvt_feat)<-gsub("^f", "frequency", names(sub_actvt_feat))
names(sub_actvt_feat)<-gsub("Acc", "Accelerometer", names(sub_actvt_feat))
names(sub_actvt_feat)<-gsub("Gyro", "Gyroscope", names(sub_actvt_feat))
names(sub_actvt_feat)<-gsub("Mag", "Magnitude", names(sub_actvt_feat))
names(sub_actvt_feat)<-gsub("BodyBody", "Body", names(sub_actvt_feat))
names(sub_actvt_feat) <- gsub("([Gg]ravity)","Gravity", names(sub_actvt_feat))

## V. Creating the second data set that is Tidy <- sub_actvt_feat

Tidy_data<-aggregate(. ~subject + activity, sub_actvt_feat, mean)
Tidy_data<-Tidy_data[order(Tidy_data$subject,Tidy_data$activity),]

# Write the tidy data file to /UCI HAR Dataset directory

write.table(Tidy_data, file = "tidy_data.txt",row.name=FALSE)

# While openeing tidy_data.txt in Excel use space as delimiter.

