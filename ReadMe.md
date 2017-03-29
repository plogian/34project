The script opens and unzips all the files in into a 34Proj folder. This part is commented out to comply with the assignment (but can be run if needed).

First, the script binds the subject numbers (1-30) to both the training and test datasets.
Then, the script changes all of the column names to descriptive variable names (using the features.txt) in both datasets.
The script then adds the activity labels (1-6) to the test and train datasets. The activities are labelled 1-6, however to make this more readable, the script changes these activity numbers to appropriate labels (walking, walking upstairs, walking downstairs, standing, sitting, and laying. )

Next, I removed columns that don't reflect the mean and standard deviation for each variable.
Both datasets can now be merged together. 

After merging the datasets, I melt them down, and I recast so that the resulting datasets reflects the average of each variable for each subject (1-30) for each of the six activities. 


