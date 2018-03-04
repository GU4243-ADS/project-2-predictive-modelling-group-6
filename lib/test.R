######################################################
### Fit the classification model with testing data ###
######################################################

### Author: Wanting Cheng
### Project 2
### ADS Spring 2018

test <- function(model_spec, test_data, test.GBM = F, 
                 test.RF = F, test.TF = F, test.Ada = F){
  
  ### Fit the classfication model with testing data
  
  ### Input: 
  ###  - the fitted classification model using training data
  ###  -  processed features from testing images 
  ### Output: prediction
  
  ### load libraries
  
  if(test.GBM){
    library("gbm")
    
    pred <- predict(fit_train$fit, newdata = dat_test, 
                    n.trees = fit_train$iter, type = "response")
    
    return(as.numeric(pred > 0.5))
  }
  
  if(test.RF){
    pred <- predict(model_spec, test_data)
  }
  
  if(test.TF){
    
  }
  
  if(test.Ada){
    
  }
  
}

