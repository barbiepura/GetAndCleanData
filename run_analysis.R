library(plyr)
library(Hmisc)

# Set up working directory

setwd("/Users/Pura/Desktop/CourseraR/Getting and Cleaning Data/Project/DataSet")

## Read features and activity labels

allfeatures<-read.table("features.txt", col.names = c("ID", "Features"),stringsAsFactors = F)
activitynames<-read.table("activity_labels.txt", col.names = c("ID", "Activity"))


## read test/training dataset and add activity labels as column names

Ytest<-read.table("./test/y_test.txt", col.names = "ActivityID", stringsAsFactors = F)
testdata<-read.table("./test/X_test.txt", col.names = as.vector(allfeatures$Features), stringsAsFactors = F)
subtest<-read.table("./test/subject_test.txt", header=F, stringsAsFactors = F)

Ytrain<-read.table("./train/y_train.txt", col.names = "ActivityID")
traindata<-read.table("./train/X_train.txt", col.names = as.vector(allfeatures$Features), stringsAsFactors = F)
subtrain<-read.table("./train/subject_train.txt", header=F, stringsAsFactors = F)

## Extract only mean and std related fileds and combine datasets

colname<-colnames(testdata)
colname2<-colnames(traindata)
trainmeanstd<-cbind(traindata[, which(grepl("mean", colname2))], traindata[, which(grepl("std", colname2))])
testmeanstd<-cbind(testdata[, which(grepl("mean", colname))], testdata[, which(grepl("std", colname))])

testmeanstd$Identifier<-subtest$V1
trainmeanstd$Identifier<-subtrain$V1
testactivity<-merge(activitynames, Ytest, by.x = "ID", by.y = "ActivityID")
trainactivity<-merge(activitynames, Ytrain, by.x = "ID", by.y = "ActivityID")
testmeanstd$ActivityNames<-testactivity$Activity
testmeanstd$ActivityID<-testactivity$ID
trainmeanstd$ActivityNames<-trainactivity$Activity
trainmeanstd$ActivityID<-trainactivity$ID

onedata<-rbind(testmeanstd, trainmeanstd)
tidydata<-arrange(onedata[, c(80, 81, c(1:79))], Identifier)
tidydata$actIndex<-paste(tidydata$Identifier, "_", tidydata$ActivityNames)
tidydata<-tidydata[, c(82, c(1:81))]

##  Group dataset by subject and activity
index<-interaction(tidydata$Identifier, tidydata$ActivityNames)
s<-split(tidydata, index, drop = TRUE)
means<-as.data.frame(t(sapply(s, function(x) colMeans(x[, c(4:82)]))))

## make new descriptive column names for new dataset
newcolnames<-lapply(as.vector(colnames(means)), function(x) paste("Avg_", x))
colnames(means)<-newcolnames

## add columns for subjects and activity
newrownames<-strsplit(row.names(means), "[.]")
newID<-lapply(newrownames, function(x) x[[1]][1])
means$Identifier<-unlist(newID)
newact<-as.vector(c(newrownames[[1]][2],newrownames[[2]][2],newrownames[[3]][2],newrownames[[4]][2],newrownames[[5]][2],newrownames[[6]][2],newrownames[[7]][2],newrownames[[8]][2],newrownames[[9]][2],newrownames[[10]][2],newrownames[[11]][2],newrownames[[12]][2],newrownames[[13]][2],newrownames[[14]][2],newrownames[[15]][2],newrownames[[16]][2],newrownames[[17]][2],newrownames[[18]][2],newrownames[[19]][2],newrownames[[20]][2],newrownames[[21]][2],newrownames[[22]][2],newrownames[[23]][2],newrownames[[24]][2],newrownames[[25]][2],newrownames[[26]][2],newrownames[[27]][2],newrownames[[28]][2],newrownames[[29]][2],newrownames[[30]][2],newrownames[[31]][2],newrownames[[32]][2],newrownames[[33]][2],newrownames[[34]][2],newrownames[[35]][2],newrownames[[36]][2],newrownames[[37]][2],newrownames[[38]][2],newrownames[[39]][2],newrownames[[40]][2] ))
means$Activity<-newact
meanstable<-means[, c(80, 81, c(1:79))]
meanstable<-arrange(meanstable, as.numeric(Identifier))

## Export final table to same working directory
write.table(meanstable, "tidyDS.txt", row.names = FALSE)
