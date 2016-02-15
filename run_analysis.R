      #read in data
      dtTest<-read.table('./test/Y_test.txt',header=F)
      dtTrain<-read.table('./train/Y_train.txt',header=F)
      dtSubTest<-read.table('./test/subject_test.txt',header=F)
      dtTrainTest<-read.table('./train/subject_train.txt',header=F)
      dtFeatTest<-read.table('./test/X_test.txt',header=FALSE)
      dtFeatTrain<-read.table('./train/X_train.txt',header=F)
      #merge
      dtSub<-rbind(dtSubTrain,dtSubTest)
      dtAct<-rbind(dtTest,dtTrain)
      dtFeat<-rbind(dtFeatTrain,dtFeatTest)
      names(dtSub)<-'subject'
      names(dtAct)<-'activity'
      dtFeatNames<-read.table('./features.txt',header=F)
      names(dtFeat)<-dtFeatNames$V2
      dtCombine<-cbind(dtSub,dtAct)
      dt<-cbind(dtFeat,dtCombine)
      #extract relevant data
      subsetFeatNames<-dtFeatNames$V2[grep('mean\\(\\)|std\\(\\)',dtFeatNames$V2)]
      desiredNames<-c(as.character(subsetFeatNames),'subject','activity')
      dt<-subset(dt,select=desiredNames)
      #Change activity column to factor
      activityLabels<-read.table('./activity_labels.txt',header=T)
      dt$activity<-factor(dt$activity,activityLabels[[1]],activityLabels[[2]])
      #relabel cols with appropriate variable names
      names(dt)<-gsub("^t", "time", names(dt))
      names(dt)<-gsub("^f", "frequency", names(dt))
      names(dt)<-gsub("Acc", "Accelerometer", names(dt))
      names(dt)<-gsub("Gyro", "Gyroscope", names(dt))
      names(dt)<-gsub("Mag", "Magnitude", names(dt))
      names(dt)<-gsub("BodyBody", "Body", names(dt))
      #create an independent tidy data set and output it in a file
      library(plyr)
      dt2<-aggregate(.~subject + activity,dt,mean)
      dt2<-dt2[order(dt2$subject,dt2$activity),]
      write.table(dt2,file='tidydata.txt',row.name=F)