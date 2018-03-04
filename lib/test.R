######################################################
### Fit the classification model with testing data ###
######################################################

### Author: Wanting Cheng
### Project 2
### ADS Spring 2018

test <- function(model_spec, test_data, test.GBM = F, 
                 test.RF = F, test.TF = F, test.Ada = F, test.XGB = F){
  
  ### Fit the classfication model with testing data
  
  ### Input: 
  ###  - the fitted classification model using training data
  ###  -  processed features from testing images 
  ### Output: prediction
  
  ### load libraries
  
  if(test.GBM){
    library("gbm")
    
    pred <- predict(model_spec$model, test_data, n.trees = model_spec$best.iter2)
    pred <- ifelse((pred > 0.5),1,0)
    return(pred)
  }
  
  if(test.RF){
    pred <- predict(model_spec, test_data)
    return(pred)
  }
  
  if(test.TF){
    
  }
  
  if(test.Ada){
    pred <- predict(model_spec$model, test_data, n.trees = model_spec$best.iter2)
    pred <- ifelse((pred > 0),1,0)
    return(pred)
  }
  if(test.XGB){
    pred <- predict(model_spec, data.matrix(test_data))
    pred <- ifelse((pred > 0.5),1,0)
    return(pred)
  }
  
}

