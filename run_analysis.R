# This program takes as input data from three files (subject, x, y) for two sets of 
# data (test and train)in which subject lists the study pariticipants by number,
# y is the activity type (1 WALKING, 2 WALKING_UPSTAIRS, 3 WALKING_DOWNSTAIRS
# 4 SITTING, 5 STANDING, 6 LAYING) in number format and x is the measurement data.
# The program transforms the Y labels from numbers to the activity the number represents. 
# It then filters the X data to include only the categories that are mean or std (standard deviation)
# values. The subject, Y, X datasets for each of test and train data are combined using cbind and
# then the combined train and test datasets are combined using rbind such that 
# the number of rows in the combined dataset is the sum of rows in the test and train sets. 
# The data is ordered by participant number. 
# An output dataset is produced which takes the mean value for each measurement for 
# each pariticipant and each activity. 
# NOTE: run_analysis assumes that the data will be inputed into the program using
# read.table() for each of the input parameters (train_X, train_Y, subject_train, test_X, 
# test_Y, subject_test, features, activity_labels) using the data supplied in the zip file. 
# for example train_X <- read.table("./UCI HAR Dataset/train/X_train.txt")


run_analysis <- function(train_X, train_Y, subject_train, test_X, test_Y, subject_test, features, activity_labels) {
  
  names(subject_train)  <- "Participant"
  names(subject_test)   <- "Participant"
  names(test_Y)         <- "Activity"
  names(train_Y)         <- "Activity"
  
  actLabs <- activity_labels$V2  #create a vector with the activity labels in order
  
  # transform the values in each row from a number to the activty label that corresponds to the number
  for (i in 1:length(actLabs)) {test_Y$Activity[test_Y$Activity == i] <- actLabs[i] } 
  for (i in 1:length(actLabs)) {train_Y$Activity[train_Y$Activity == i] <- actLabs[i] } 
  
  
  
  # filter for mean and std
  meanIndices <- grep("\\bmean()\\b",features$V2) #indices of features with exactly 'mean()'
  stdIndices  <- grep("\\bstd()\\b", features$V2) #indices of features with exactly 'std()'
  combinedIndices <- c(meanIndices, stdIndices)
  sortedIndices   <- sort(combinedIndices) # sort indices so that order matches cols in train_X/test_X
  featuresSubset  <- features[features$V1 %in% sortedIndices,] 
  colLabels <- featuresSubset$V2 
  
  
  filteredTestX <- test_X[,sortedIndices]
  names(filteredTestX) <- colLabels
  filteredTrainX <- train_X[,sortedIndices]
  names(filteredTrainX) <- colLabels
  
  # merge train subject, y, x
  bindTrain   <- cbind(subject_train, train_Y, filteredTrainX)
  
  # merge test subject, y, x
  bindTest    <- cbind(subject_test, test_Y, filteredTestX)
  
  # merge train and test
  mergedData  <- rbind(bindTrain, bindTest)
  
  mergedData <- mergedData[order(mergedData$Participant),]
  
  #average by pariticipant and activity
  aveByPartActivity <- aggregate(mergedData[3:length(mergedData)], by=list(mergedData$Participant, mergedData$Activity), FUN = mean)
  colnames(aveByPartActivity)[1] <- "Participant"
  colnames(aveByPartActivity)[2] <- "Activity"
  
  write.table(aveByPartActivity, file ="movement.txt")
  
  
  
}
