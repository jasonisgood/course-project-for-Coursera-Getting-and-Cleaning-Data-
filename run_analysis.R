library(data.table)
##download data and unzip
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "data.zip")
data <- unzip("data.zip")
##read the text data into table
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt") 
X_test<-read.table("./UCI HAR Dataset/test/X_test.txt")                             
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")                             
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")                     
X_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
##grep mean and sd features
features=read.table("./UCI HAR Dataset/features.txt")
rawnumbers<-grep(".*mean.*|.*std.*", as.character(features[,2]))
colnames=as.character(features[rawnumbers,2])
colnames=gsub('[-()]', '', colnames)
##naming with descriptive activity names 
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")
activity_numbers_test=as.numeric(y_test$V1)
activity_labels_test<-activity_labels[activity_numbers_test,2]
activity_numbers_train=as.numeric(y_train$V1)
activity_labels_train<-activity_labels[activity_numbers_train,2]
##binding train and test data
##labels the data set
testdata<-cbind(subject_test,activity_labels_test,X_test[,rawnumbers])
traindata<-cbind(subject_train,activity_labels_train,X_train[,rawnumbers])
colnames(testdata) <- c("subject", "activity", colnames)
colnames(traindata) <- c("subject", "activity", colnames)
alldata<-rbind(testdata,traindata)
##tidy data set with the average of each variable for each activity and each subject
alldata$subject <- as.factor(alldata$subject)
alldata.melted <- melt(alldata, id = c("subject", "activity"))
alldata.mean <- dcast(alldata.melted, subject + activity ~ variable, mean)
##write the table
write.table(alldata.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
