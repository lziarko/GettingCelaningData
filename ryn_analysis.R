# Data Science Specialization | Getting and Cleaning Data | Project 1/1

# Getting data
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile<-"data.zip"
download.file(url=url, destfile=destfile)
# Unpacking data
unzip(destfile)

# Reading files requred to produce a tidy dataset
xtest<-read.table("UCI HAR Dataset/test/X_test.txt")
xtrain<-read.table("UCI HAR Dataset/train/X_train.txt")
ytest<-read.table("UCI HAR Dataset/test/y_test.txt")
ytrain<-read.table("UCI HAR Dataset/train/y_train.txt")
activitylabels<-read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("id", "name"))
features<-read.table("UCI HAR Dataset/features.txt")
trainsubject<-read.table("UCI HAR Dataset/train/subject_train.txt", col.names= "subject")
testsubject<-read.table("UCI HAR Dataset/test/subject_test.txt", col.names="subject")


# Merges the training and the test sets to create one data set
testset<-cbind(xtest,ytest)
trainset<-cbind(xtrain,ytrain)
traintestset<-rbind(testset,trainset)

# Merges the training and the test sets to create one data set
traintestsubject <- rbind(trainsubject, testsubject)
colnames(traintestset)<-features$V2
dataset<-cbind(traintestset,traintestsubject)
names(dataset)

## Droping unnecessary column
dataset[562]<-NULL

# Extracts only the measurements on the mean and standard deviation for each measurement
mean<-grep("mean()", colnames(dataset),fixed=T)
std<-grep("std()", colnames(dataset), fixed=T)
meanstd<-sort(c(mean,std))
subsetData<-dataset[, meanstd]
subsetData<-cbind(subsetData,traintestsubject)

# Appropriately labels the data set with descriptive variable names
activitylabels$name<-sub("_","",activitylabels$name)
activitylabels$name<-tolower(activitylabels$name)

# Uses descriptive activity names to name the activities in the data set
subsetDataNames<-merge(subsetData,activitylabels, by.x="subject", by.y="id", all=TRUE)
subsetDataNames<-subsetDataNames[,c(1,68,2:67)]

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidyData<-aggregate(subsetDataNames[,3:ncol(subsetDataNames)], list(Subject=subsetDataNames$subject, Activity=subsetDataNames$name), mean)
tidyData<-tidyData[order(tidyData$Subject),]
write.table(tidyData, file="./tidyData.txt", sep=",", row.names=FALSE)
getwd()
