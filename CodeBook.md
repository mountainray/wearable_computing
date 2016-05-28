# CodeBook


## UCI Human Activity Research Coursera Project

###### author: Ray Bem
###### date: May 27, 2016

### Project Summary
This project intends to demonstrate the R programming skills I used to manipulate, merge, subset, and summarize _Samsung Galaxy S II Smartphone_ generated data.  

###Original Data information
The original data collection is attributed to the following **citation**:  
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

Highlights from the study team's online documentation [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]:

"The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING-UPSTAIRS, WALKING-DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low- pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details."

The study creates several estimates around a group of core variables, all of which began with the Accelerometer and Gyroscope signal data.   The estimates:

  + mean(): Mean value
  + std(): Standard deviation
  + mad(): Median absolute deviation 
  + max(): Largest value in array
  + min(): Smallest value in array
  + sma(): Signal magnitude area
  + energy(): Energy measure. Sum of the squares divided by the number of values. 
  + iqr(): Interquartile range 
  + entropy(): Signal entropy
  + arCoeff(): Autorregresion coefficients with Burg order equal to 4
  + correlation(): correlation coefficient between two signals
  + maxInds(): index of the frequency component with largest magnitude
  + meanFreq(): Weighted average of the frequency components to obtain a mean frequency
  + skewness(): skewness of the frequency domain signal 
  + kurtosis(): kurtosis of the frequency domain signal 
  + bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
  + angle(): Angle between to vectors.

And the basic core variables:

  + tBodyAcc-XYZ
  + tGravityAcc-XYZ
  + tBodyAccJerk-XYZ
  + tBodyGyro-XYZ
  + tBodyGyroJerk-XYZ
  + tBodyAccMag
  + tGravityAccMag
  + tBodyAccJerkMag
  + tBodyGyroMag
  + tBodyGyroJerkMag
  + fBodyAcc-XYZ
  + fBodyAccJerk-XYZ
  + fBodyGyro-XYZ
  + fBodyAccMag
  + fBodyAccJerkMag
  + fBodyGyroMag
  + fBodyGyroJerkMag

Original data can be found here: [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]


###General Approach taken
A great deal of background research was done around the topic, including reading the submitted work of the original authors [http://www.icephd.org/sites/default/files/IWAAL2012.pdf], as well as several papers cited in this original work.  

However for this Coursera project, data manipulation and tidying is the point...

###Computing Environment Details

* **iMac Computer**
   + OS X El Capitan, Version 10.11.5
   + 4 GHz Intel Core i7 Processor
   + 32 GB 1867 MHz DDR3 Memory
   + AMD Radeon R9 M395X, 4096 MB Graphics

* **R Version**
   + platform       x86_64-apple-darwin13.4.0   
   + arch           x86_64                      
   + os             darwin13.4.0                
   + system         x86_64, darwin13.4.0        
   + major          3                           
   + minor          2.4                         
   + year           2016                        
   + month          03                          
   + day            10                          
   + svn rev        70301                       
   + language       R                           
   + version.string R version 3.2.4 (2016-03-10)
   + nickname       Very Secure Dishes    


###Raw Data
Incoming were 561 features covering the time domain accelerometer and gyroscope output (denoted by "t" prefix of variable name), as well as results from the Fast Fourier Transform of these time series (denoted by "f" prefix of variable name).  Accompanying -- and in the same record order as the main data -- were separate files holding subject id's and experiment activities.  Other support files included a 6 record Activity decode (e.g., "1 WALKING", "4 SITTING"), and a list of the 561 labels (variable names).  The following table summarizes the inputs:

File Name             | Record Count | Description
----------------------|--------------|----------------
activity_labels.txt   | 6            | activity decode
features.txt          | 561          | variable names
subject_test.txt      | 2947         | test subject data
X_test.txt            | 2947         | test main data
y_test.txt            | 2947         | test activities
subject_train.txt     | 7352         | train subject data
X_train.txt           | 7352         | train main data
y_train.txt           | 7352         | train activities


###Processing:  run_analysis.R overview
Instructions were to subset the original 561 variables (described as "features" by the authors), selectingonly the estimates the mean and standard deviation.  Examples of variablres not considered in-scope included those related to IQR, skewness, kurtosis, etc.  Other noteworthy exclusions were the "meanFreq" estimates, as well as the "angle" estimates -- these I considered out of scope.  

Original variable names came coded with a variety of characters, surely intended to keep everything straight for the study leadership.  Per instructions, including class slides, characters such as ")", "-", "," were removed.  I did choose to leave two underscores, in the beginning of each variable name will be "mean_"; at the end I left the _X, _Y, _Z denoting the axes, as appropriate.  

After adjusting variable names, the code translates the raw activity codes to their label, reads in the subject records, and column-binds the three sets of data.  This was repeated for the train and test data sets, then train and test were row-binded, forming a final dataset -- wearable_computing.

The wearable_computing dataset was next grouped by subject and activity, then summarized by taking the mean of each column (which were already means and standard deviations).  This produces the final R data wearable_computing_tidy, which gets written to a wearable_computing_tidy.csv in the final step.


###Processing:  run_analysis.R, detailed steps in process:

1. Install packages used in code
2. Load librarys of packages in #1
3. Check for "data" folder, if not found then make it
4. Assign to R variables the source dataset names
5. Read in and create features (variable names in original format)
6. Modify names in features relating to "energyBands" to make distinct (though these are not selected later, their non-uniqueness causes problems)
7. Remove most non-alpha characters in features, and fix "BodyBody" typo (make "Body")
8. Read in and left join activities to activity labels
9. Read in subject ID's for train data group
10. Apply variable names, prefix with "mean_"
11. Read main train data, column bind subject ID's, activity labels, and subset of columns having "mean" or "std" in feature name
12. Repeat steps 8 through 11 for test data group
13. Row-bind train and test data, turn into tbl_df, this makes wearable_computing
14. Drop "meanFreq" and "angle" fields, not in scope
15. Group by subject_id and activity
16. Summarize by subject_id and activity, generate mean, this makes wearable_computing_tidy
17. Write wearable_computing_tidy to .csv file, used row.names = FALSE option


###Tidy data:  some choices made
After much consideration, I chose to *leave the variable names basically intact*, including the original case.  I felt I could not really improve on these names, and justify it further by assuming most people who (might) run my code will find it easier to track back to the original .txt data (for example, to verify something).  This will save them time figuring out how my variable names map back...at least that was the thinking here.

Another "style" choice around the data that would not strictly fit a "tidy" definition (per Hadley Wickham) -- one could argue the variable names contain more than one specific variable.  For example, their are the "time domain" and "frequency domain" variables; another example, the instruments used are in the names ("Acc" for accelerometer, "Gyro" for gyroscope). Axes information as well.  After permuting through various structures -- and seeing a great deal of incompleteness, I chose to go with what is described in more detail below.  I strongly feel this would be the easiest format for doing exploratory analyses on a per-subject and/or per-activity level (as opposed to lengthy subsetting logic).  For example, to obtain the mean frequency body acceleration, one simply takes the mean of that variable.

Final output is to a csv-delimited text file names "wearable_computing_tidy.csv".  Note there are no NA's in the final tidy dataset.


###Final Variable List (wearable_computing_tidy.csv, 180 rows x 68 columns):  

Variable Name              | Units                 | Description
---------------------------|-----------------------|------------------------------------------------------------------------
1. subject_id                 |individual person      |Integer distinguishing 30 study participants
2. activity                   |labels                 |Label describing activity (e.g., WALKING, SITTING) 
3. mean_tBodyAccMean_X        |standard gravity       |Mean Body acceleration Mean, X axis
4. mean_tBodyAccMean_Y        |standard gravity       |Mean Body acceleration Mean, Y axis
5. mean_tBodyAccMean_Z        |standard gravity       |Mean Body acceleration Mean, Z axis
6. mean_tBodyAccStd_X         |standard gravity       |Mean Body acceleration Standard Deviation, X axis
7. mean_tBodyAccStd_Y         |standard gravity       |Mean Body acceleration Standard Deviation, Y axis
8. mean_tBodyAccStd_Z         |standard gravity       |Mean Body acceleration Standard Deviation, Z axis
9. mean_tGravityAccMean_X     |standard gravity       |Mean Gravity acceleration Mean, X axis
10. mean_tGravityAccMean_Y     |standard gravity       |Mean Gravity acceleration Mean, Y axis
11. mean_tGravityAccMean_Z     |standard gravity       |Mean Gravity acceleration Mean, Z axis
12. mean_tGravityAccStd_X      |standard gravity       |Mean Gravity acceleration Standard Deviation, X axis
13. mean_tGravityAccStd_Y      |standard gravity       |Mean Gravity acceleration Standard Deviation, Y axis
14. mean_tGravityAccStd_Z      |standard gravity       |Mean Gravity acceleration Standard Deviation, Z axis
15. mean_tBodyAccJerkMean_X    |standard gravity/second|Mean Body Jerk Mean, X axis
16. mean_tBodyAccJerkMean_Y    |standard gravity/second|Mean Body Jerk Mean, Y axis
17. mean_tBodyAccJerkMean_Z    |standard gravity/second|Mean Body Jerk Mean, Z axis
18. mean_tBodyAccJerkStd_X     |standard gravity/second|Mean Body Jerk Standard Deviation, X axis
19. mean_tBodyAccJerkStd_Y     |standard gravity/second|Mean Body Jerk Standard Deviation, Y axis
20. mean_tBodyAccJerkStd_Z     |standard gravity/second|Mean Body Jerk Standard Deviation, Z axis
21. mean_tBodyGyroMean_X       |radians/second         |Mean Body Gyroscope angular velocity Mean, X axis
22. mean_tBodyGyroMean_Y       |radians/second         |Mean Body Gyroscope angular velocity Mean, Y axis
23. mean_tBodyGyroMean_Z       |radians/second         |Mean Body Gyroscope angular velocity Mean, Z axis
24. mean_tBodyGyroStd_X        |radians/second         |Mean Body Gyroscope angular velocity Standard Deviation, X axis
25. mean_tBodyGyroStd_Y        |radians/second         |Mean Body Gyroscope angular velocity Standard Deviation, Y axis
26. mean_tBodyGyroStd_Z        |radians/second         |Mean Body Gyroscope angular velocity Standard Deviation, Z axis
27. mean_tBodyGyroJerkMean_X   |radians/second^2^      |Mean Body Jerk Gyroscope angular velocity Mean, X axis
28. mean_tBodyGyroJerkMean_Y   |radians/second^2^      |Mean Body Jerk Gyroscope angular velocity Mean, Y axis
29. mean_tBodyGyroJerkMean_Z   |radians/second^2^      |Mean Body Jerk Gyroscope angular velocity Mean, Z axis
30. mean_tBodyGyroJerkStd_X    |radians/second^2^      |Mean Body Jerk Gyroscope angular velocity Mean, X axis
31. mean_tBodyGyroJerkStd_Y    |radians/second^2^      |Mean Body Jerk Gyroscope angular velocity Mean, Y axis
32. mean_tBodyGyroJerkStd_Z    |radians/second^2^      |Mean Body Jerk Gyroscope angular velocity Mean, Z axis
33. mean_tBodyAccMagMean       |standard gravity       |Mean Body acceleration, Euclidean norm Magnitude Mean
34. mean_tBodyAccMagStd        |standard gravity       |Mean Body acceleration, Euclidean norm Magnitude Standard Deviation
35. mean_tGravityAccMagMean    |standard gravity       |Mean Gravity acceleration, Euclidean norm Magnitude Mean
36. mean_tGravityAccMagStd     |standard gravity       |Mean Gravity acceleration, Euclidean norm Magnitude Standard Deviation
37. mean_tBodyAccJerkMagMean   |standard gravity/second|Mean Body Jerk acceleration, Euclidean norm Magnitude Mean
38. mean_tBodyAccJerkMagStd    |standard gravity/second|Mean Body Jerk acceleration, Euclidean norm Magnitude Mean
39. mean_tBodyGyroMagMean      |radians/second         |Mean Gyroscope angular velocity, Euclidean norm Magnitude Mean
40. mean_tBodyGyroMagStd       |radians/second         |Mean Gyroscope angular velocity, Euclidean norm Magnitude Std Deviation
41. mean_tBodyGyroJerkMagMean  |radians/second^2^      |Mean Body Jerk Gyroscope angular velocity, Euclidean norm Magnitude Mean
42. mean_tBodyGyroJerkMagStd   |radians/second^2^      |Mean Body Jerk Gyroscope angular velocity, Euclidean norm Magnitude Mean
43. mean_fBodyAccMean_X        |Hz                     |Mean Body acceleration frequency Mean, X axis
44. mean_fBodyAccMean_Y        |Hz                     |Mean Body acceleration frequency Mean, Y axis
45. mean_fBodyAccMean_Z        |Hz                     |Mean Body acceleration frequency Mean, Z axis
46. mean_fBodyAccStd_X         |Hz                     |Mean Body acceleration frequency Standard Deviation, X axis
47. mean_fBodyAccStd_Y         |Hz                     |Mean Body acceleration frequency Standard Deviation, Y axis
48. mean_fBodyAccStd_Z         |Hz                     |Mean Body acceleration frequency Standard Deviation, Z axis
49. mean_fBodyAccJerkMean_X    |Hz                     |Mean Body Jerk frequency Mean, X axis
50. mean_fBodyAccJerkMean_Y    |Hz                     |Mean Body Jerk frequency Mean, Y axis
51. mean_fBodyAccJerkMean_Z    |Hz                     |Mean Body Jerk frequency Mean, Z axis
52. mean_fBodyAccJerkStd_X     |Hz                     |Mean Body Jerk frequency Standard Deviation, X axis
53. mean_fBodyAccJerkStd_Y     |Hz                     |Mean Body Jerk frequency Standard Deviation, Y axis
54. mean_fBodyAccJerkStd_Z     |Hz                     |Mean Body Jerk frequency Standard Deviation, Z axis
55. mean_fBodyGyroMean_X       |Hz                     |Mean Body Gyroscope angular velocity frequency Mean, X axis
56. mean_fBodyGyroMean_Y       |Hz                     |Mean Body Gyroscope angular velocity frequency Mean, Y axis
57. mean_fBodyGyroMean_Z       |Hz                     |Mean Body Gyroscope angular velocity frequency Mean, Z axis
58. mean_fBodyGyroStd_X        |Hz                     |Mean Body Gyroscope angular velocity frequency Mean, X axis
59. mean_fBodyGyroStd_Y        |Hz                     |Mean Body Gyroscope angular velocity frequency Mean, Y axis
60. mean_fBodyGyroStd_Z        |Hz                     |Mean Body Gyroscope angular velocity frequency Mean, Z axis
61. mean_fBodyAccMagMean       |Hz                     |Mean Body acceleration frequency, Euclidean norm Magnitude Mean
62. mean_fBodyAccMagStd        |Hz                     |Mean Body acceleration frequency, Euclidean norm Magnitude Mean
63. mean_fBodyAccJerkMagMean   |Hz                     |Mean Body Jerk frequency, Euclidean norm Magnitude Mean
64. mean_fBodyAccJerkMagStd    |Hz                     |Mean Body Jerk frequency, Euclidean norm Magnitude Mean
65. mean_fBodyGyroMagMean      |Hz                     |Mean Body Gyroscope angular velocity frequency, Euclidean norm Magnitude Mean
66. mean_fBodyGyroMagStd       |Hz                     |Mean Body Gyroscope angular velocity frequency, Euclidean norm Magnitude Mean
67. mean_fBodyGyroJerkMagMean  |Hz                     |Mean Body Gyroscope Jerk angular velocity frequency, Euclidean norm Magnitude Mean
68. mean_fBodyGyroJerkMagStd   |Hz                     |Mean Body Gyroscope Jerk angular velocity frequency, Euclidean norm Magnitude Mean