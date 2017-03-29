#Download and unzip folders
zipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(zipURL, destfile="./data/Dataset.zip")
unzip("./data/Dataset.zip", exdir="./data/34Proj")

#read test and train data into R as tables
trainfile <- "./data/34Proj/UCI HAR Dataset/train/X_train.txt"
testfile <- "./data/34Proj/UCI HAR Dataset/test/X_test.txt"
traindata <- read.table(trainfile)
testdata <- read.table(testfile)

#the subject_test and subject_train files tell me who performed each activity, so I will read that into R and bind the subject numbers to the appropriate files
subjecttrain <-  "./data/34Proj/UCI HAR Dataset/train/subject_train.txt"
subjecttest <- "./data/34Proj/UCI HAR Dataset/test/subject_test.txt"
trainsubject <- read.table(subjecttrain)
testsubject <- read.table(subjecttest)

traindata <- cbind(trainsubject, traindata)
colnames(traindata)[1]<-"Subject"
testdata <- cbind(testsubject, testdata)
colnames(testdata)[1]<-"Subject"

#features.txt has the names for all the relevant column names
features <- "./data/34Proj/UCI HAR Dataset/features.txt"
variablenames <- read.table(features)
variablenamevector <- c("subject", as.vector(variablenames$V2))

#rename columns in test and train
colnames(testdata) <- variablenamevector
colnames(traindata) <- variablenamevector

#y_train and y_test have the activity labels. I need to add them to the test and train datasets, 
activitytrain <-  "./data/34Proj/UCI HAR Dataset/train/y_train.txt"
activitytest <- "./data/34Proj/UCI HAR Dataset/test/y_test.txt"
trainactivity <- read.table(activitytrain)
testactivity <- read.table(activitytest)
testdata <- cbind(testactivity, testdata)
colnames(testdata)[1]<-"Activity Label"
traindata <- cbind(trainactivity, traindata)
colnames(traindata)[1]<-"Activity Label"

#Now I'm going to merge Activity Labels with Activity Names. There's got to be a better way (lapply? Tried for loop and merge didn't work as intended), but this works for now. 

testdata$'Activity Label' <- replace(testdata$'Activity Label', testdata$'Activity Label'==1, "Walking")
testdata$'Activity Label' <- replace(testdata$'Activity Label', testdata$'Activity Label'==2, "Walking Upstairs")
testdata$'Activity Label' <- replace(testdata$'Activity Label', testdata$'Activity Label'==3, "Walking Downstairs")
testdata$'Activity Label' <- replace(testdata$'Activity Label', testdata$'Activity Label'==4, "Sitting")
testdata$'Activity Label' <- replace(testdata$'Activity Label', testdata$'Activity Label'==5, "Standing")
testdata$'Activity Label' <- replace(testdata$'Activity Label', testdata$'Activity Label'==6, "Laying")


traindata$'Activity Label' <- replace(traindata$'Activity Label', traindata$'Activity Label'==1, "Walking")
traindata$'Activity Label' <- replace(traindata$'Activity Label', traindata$'Activity Label'==2, "Walking Upstairs")
traindata$'Activity Label' <- replace(traindata$'Activity Label', traindata$'Activity Label'==3, "Walking Downstairs")
traindata$'Activity Label' <- replace(traindata$'Activity Label', traindata$'Activity Label'==4, "Sitting")
traindata$'Activity Label' <- replace(traindata$'Activity Label', traindata$'Activity Label'==5, "Standing")
traindata$'Activity Label' <- replace(traindata$'Activity Label', traindata$'Activity Label'==6, "Laying")

#remove columns that aren't mean and sd from each
colindexes <- grep("mean\\()|std\\()", colnames(testdata))
testdata <- testdata[c(1,2, colindexes)]
traindata <- traindata[c(1,2, colindexes)]

#merge test and train together. Don't need merge command. Can just rbind to the bottom. But first want to add a variable telling us whether each observation was test or train
testdata$source <- "test"
traindata$source <- "train"
mergedset <- rbind(testdata, traindata)

#create second data set with the average of each variable for each activity and subject
library(reshape2)
names(mergedMelt)[1] <- "activity"
mergedMelt<- melt(mergedset, id= c("activity", "subject", "source"), measure.vars=c(colnames(mergedset)[3:68]))
mergedCast <- dcast(mergedMelt, activity + subject~ variable, mean)
write.csv(mergedCast, file="34tidydata.csv")

