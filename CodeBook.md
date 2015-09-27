# Code Book

## This file explains the variables and steps in "run_analysis.R"

## Packages used:

* library(plyr)
* library(Hmisc)

## Output Variables

* Identifier: characters from 1 to 30; Identification for each voulenteers 
* Activity: 6 activities
* 79 numeric variables as the average value of each features for each activity and each voulenteers

## Data Cleaning Process

* Read features and activity labels as 'allfeatures' and 'activitynames'
* read test/training datasets into 'testdata' and 'traindata'
* add activity labels as column names
* Extract only mean and std related fileds and combine datasets into 'onedata' for all observations 

## Calculating Average for Activities and Voulenteers

* Use 'activity' and 'Identifier' as index to split data 
* Calculate column means for the grouped data and name as 'means'
* Rename variables by adding "Avg_" as prefix of each features
* Add 'activity' and 'Identifier' for voulenteers as two new variables
* Arrange table by 'Identifier'

## Exporting final dataset to same working directory

* "tidyDS.txt"


