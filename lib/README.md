# Project 2: 
### Code lib Folder


lib includes:

NN.R / NN.Rmd: is the neural network R or Rmd files including model, data transformation, training, testing, tunning, and some visualization. 

cross_validation.R: validation function

feature_* (HOG, sift): feature extraction functions for different features

features.R: includes all feature extraction functions (color, LBP, HOG) except sift

rotate_HOG: generate more HOG features by rotating pictures, but it does not improve the accuracy

train.R: the wrap function includes all the training function called in the main.Rmd

test.R: the wrap function includes all the test function called in the main.Rmd

train_rf.Rmd: random forest function model
