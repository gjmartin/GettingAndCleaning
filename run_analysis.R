setwd("~/R/R/UCI HAR Dataset")
test <- read.table("./test/X_test.txt")
test.labels <- read.table("./test/y_test.txt")
test.subjects <- read.table("./test/subject_test.txt")
test.complete <- cbind(test.subjects, test, test.labels)

train <- read.table("./train/X_train.txt")
train.labels <- read.table("./train/y_train.txt")
train.subjects <- read.table("./train/subject_train.txt")
train.complete <- cbind(train.subjects, train, train.labels)

combo.data <- rbind(test.complete,train.complete)
colnames(combo.data) <- c("subject",1:561,"activity")

features <- read.table("features.txt")
colnames(features) <- c("variable","feature")
vars.to.keep <- rbind(features[grepl("mean|std",features$feature),], data.frame(variable=c("activity","subject"), feature=c("activity","subject")))

clean.data <- combo.data[,vars.to.keep$variable]
colnames(clean.data) <- vars.to.keep$feature

activity.labels <- read.table("activity_labels.txt")
colnames(activity.labels) <- c("level","label")

final.data <- aggregate(clean.data, by=list(clean.data$activity,clean.data$subject), FUN=mean, na.rm=TRUE)
final.data$activity <- factor(final.data$activity,levels=activity.labels$level,labels=activity.labels$label)

write.table(final.data,"tidydataset.txt",row.name=FALSE,sep=",")
