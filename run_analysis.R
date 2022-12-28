if(!file.exists("./getcleandata")){dir.create("./getcleandata")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./getcleandata/projectdataset.zip")
unzip(zipfile = "./getcleandata/projectdataset.zip", exdir = "./getcleandata")

x_train=read.table("./getcleandata/UCI HAR Dataset/train/X_train.txt")
y_train=read.table("./getcleandata/UCI HAR Dataset/train/y_train.txt")

x_test=read.table("./getcleandata/UCI HAR Dataset/test/X_test.txt")
y_test=read.table("./getcleandata/UCI HAR Dataset/test/y_test.txt")

activity_labels=read.table("./getcleandata/UCI HAR Dataset/activity_labels.txt")
features=read.table("./getcleandata/UCI HAR Dataset/features.txt")

subject_train=read.table("./getcleandata/UCI HAR Dataset/train/subject_train.txt")
subject_test=read.table("./getcleandata/UCI HAR Dataset/test/subject_test.txt")

x_data=rbind(x_test,x_train)
y_data=rbind(y_test,y_train)

subject_data=rbind(subject_test,subject_train)

dim(x_data)
colnames(x_data)=features[,2]
colnames(y_data) <- "activityID"
colnames(subject_data) <- "subjectID"
all_data=cbind(subject_data,y_data,x_data)
name=colnames(all_data)
a=name[ grep("mean",name)]
b=name[grep("std",name)]
subset_all_data=all_data[,c("activityID","subjectID",a,b)]

merge_data=merge(subset_all_data,activity_labels,all=T, by =1 )
merge_data=rename(merge_data, "activity_name"=V2)

tidy_data=aggregate(merge_data,list(merge_data$activity_name,merge_data$subjectID),mean)
tidy_data=rename(tidy_data, "Activity"="Group.1" )
tidy_data=rename(tidy_data, "Subject"="Group.2" )
write.table(tidy_data,file="tidy_data.txt",row.name=FALSE)

