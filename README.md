# Columbia University, Department of Statistics STAT GU4243 Applied Data Science, Spring, 2018
# Project 2: Cat or Dog: Predictive Modelling and Computation Time Optimization

### [Project Description](doc/project2_desc.md)

Term: Spring 2018

+ Project title: Cat or Dog: Predictive Modelling and Computation Time Optimization
+ Team Number: 6
+ Team Members: Wanting Cheng, Mingkai Deng, Jiongjiong Li, Kai Li, Daniel Parker
+ Project summary: [a short summary] 

Contribution statement (to expand): 
+ All team members approve our work presented in this GitHub repository including this contributions statement. 
+ Feature extraction: WC (feature list), JL (feature list), MD (feature list). 
+ Model cross validation and training: WC (neural network), MD (logistic regression, AdaBoost), JL (gradient boosting machine baseline reproduction), KL (TensorFlow), DP (random forests).
+ Code review and clean-up, and overall architecture finalization: ?
+ Project management and planning, and GitHub repository organization: DP.
+ Project writeup: DP.

This folder is organized as follows.

### Project and Data Description


#### Data Description
In the training data, 2000 raw pictures including dogs and cats with labels. 

### Feature selection
We choose to generate four kinds of features: HOG, LBP, color, and SIFT. 
+ SIFT: Scale-Invariant Feature Transform (SIFT): Generate key points that describe images irrespective of scale, rotation, illumination or viewpoints. Each key point is described by a 128x1 vector. To utilize these points, we group them using k-means algorithms, and then use the bag-of-words approach to aggregate them and transform them into feature vectors.
+ Histogram of Oriented Gradients(HOG): HOG denotes the Histogram of Oriented Gradient. It extracts features by investigating the appearance and shape, computing the targets' HOG values and finding the statistic data of gradients.
+ Local Binary Patterns (LBP): is a typical visual descriptor used for computer vision. It divides the window into cells. For each cell, the center cells compared with other 8 cells around and generate an 8-digit binary number that "0" means the center is greater than the neighbors' value and "1" otherwise. Then compute the frequency of different combination for each cell. Then normalized histograms of all cells. 
+ Color (RGB+HSV): 
 + RGB: The color for each cell is defined by three chromaticities combination of Red, Green and Blue. Produce the matrix representing the possible value of color. 
 + HSV: is an alternative representation of RGB features. The color of each hue is central axis of natural color ranging from black to white. The value of dimensions represents the various shades of brightly and a mixture of paints with varying amount of black or white.
We choose fix models:
+ GBM:
+ Random Forest:
+ Neural Network:
+ Adaboost:
+ XGBoost:
+ SVM:

### Outcomes
The following table shows the accuracy and training time corresponding to different models and features.

### Findings


### Contribution
Find:
Cat is hard to be predicted, 50% of cats are missclassified. 



