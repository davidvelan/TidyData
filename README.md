# Introduction

This file explains the how the run_analysis.R script functions. The script is designed to produce a tidy dataset from data provided in the study: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

# Background

The dataset is a set of measurements from cellphone accelorometers for 30 participants in 
a study. The measurements are in 6 categories of movement: laying, sitting, standing, walking, walking_downstairs and walking_upstairs. 
The measurements have been divided into two groups: test and train. This was done by randomly placing some participants in the test set and others in the train set. 
Each set (test and train) has three files comprising the measurements (X), the activities (Y) and the participants (subject). 
The output tidy dataset combines the 6 files, filtered such that only the mean and std (standard deviation) measurements are presented for each participant and each measurement.
As there are 30 participants and 6 activities, the dataset must have 180 rows.

# Script procedure

The run_analysis script assumes that the 6 datasets, along with features (i.e. col names in the X measurement files) and activity_labels file are input parameters. Each file can be loaded into R using read.table. For example train_X <- read.table("./UCI HAR Dataset/train/X_train.txt"). 

The script modifies each individual file before combining them. The first step is to add column names to the subject and Y data.frames. Then the activities in the Y data.frames are transformed from numbers to the activity names the numbers represent. 

The grep function is used on the features data.frame to find the index of each column with either mean() or std in its text. The grep function prodcues an integer vector for each of the mean and std searches, indicating the indicies in which this subset of text is in the label. The vectors for mean and std indices are then combined and sorted so that there is a single vector of incides for either mean or std, in the order they appear in the features dataframe. This is used to subset the features dataframe with a new dataframe that only contains the mean and std labels. This is used to make new dataframes which subset X_train and X_test with only the mean and std columns, and column names are modified for each of these sets using the names in the subsetted features dataframe. 

The modified dataframes for subject, Y and X are then combined using cbind, for each of the train and test datasets such that the six original sets becomes two. The two sets are then combined using the rbind such that the total number of rows is the sum of the rows in two sets. The combined set is then ordered by participant number. 

The output dataset is then created using the aggregate function. 

# Summary

This readme file explains the procedure for the transformation and combination of multiple dataframes containing movement measurements on cellphones for 30 participants. The output is a single data set with the averages of the mean and std of measurements for each participant for each activity. 
