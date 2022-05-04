path=file.path("./UCI HAR Dataset")
files=list.files(path,recursive=TRUE)
files
#Training
xtrain<-read.table(file.path(path,"train","X_train.txt"),header = F)
ytrain<-read.table(file.path(path,"train","y_train.txt"),header=F)
subject_train<-read.table(file.path(path,"train","subject_train.txt"),header=F)
#Test
xtest<-read.table(file.path(path,"test","X_test.txt"),header = F)
ytest<-read.table(file.path(path,"test","y_test.txt"),header=F)
subject_test<-read.table(file.path(path,"test","subject_test.txt"),header=F)
#features
features<-read.table(file.path(path,"features.txt"),header=F)
activity_labels<-read.table(file.path(path,"activity_labels.txt"),header=F)
#Creating Columns
colnames(xtrain)<-features[,2]
colnames(ytrain)<-"activityId"
colnames(subject_train)<-"subjectId"
colnames(xtest)<-features[,2]
colnames(ytest)<-"activityId"
colnames(subject_test)<-"subjectId"
colnames(activity_labels)<-c("activityId","activityType")

train_main<-cbind(subject_train,ytrain,xtrain)
test_main<-cbind(subject_test,ytest,xtest)
data<-rbind(train_main,test_main)

####Extracts only the measurements on the mean and standard deviation for each measurement. ####
colNames<-colnames(data)
mean_std<-(grepl("activityId",colNames)|grepl("subjectId",colNames)|grepl("mean..",colNames)|grepl("std..",colNames))
data_sub<-data[,mean_std]
data_sub

####Uses descriptive activity names to name the activities in the data set####
data_sub_labels<-merge(data_sub,activity_labels,by="activityId",all.x = T)

####From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.####
data_sub_last <- aggregate(data_sub_labels$subjectId + data_sub_labels$activityId, data_sub_labels, mean)
data_sub_last <- data_sub_last[order(data_sub_last$subjectId, data_sub_last$activityId),]


