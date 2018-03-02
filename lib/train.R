#########################################################
### Train a classification model with training images ###
#########################################################

### Author: Wanting Cheng
### Project 2
### ADS Spring 2018


train <- function(train_data, run.RF = F,run.TF = F,run.GBM = F, export = T){
  

  ### Input: 
  ###  -  processed features from images with labels
  ### Output: training model specification
  
  ### load libraries
  library("gbm")
  
  ### Train with gradient boosting model
  if(run.RF){
    RF_model <- RF(train_data)
    return(RF_model)
  }
  if(run.tf){
    TF_model <- TF(train_data)
    return(TF_model)
  }
  if(run.GBM){
    GBM_model <- GBM(train_data)
    return(GBM_model)
  }

  RF <- function(train_data){
  
    require(randomForest, quietly = TRUE)
    
    seed = 1
    set.seed(seed)
    
    response <- train_data$label
    predictors <- train_data[3:length(train_data)]
    
    rf_model <- tuneRF(predictors, response, ntreeTry = 500, doBest = TRUE)
    save(rf_model, file = "../output/rf_model.Rdata")
    return(rf_model)
    
    }

  TF <- function(train_data){
    
    save(tf_model, file = "../output/tf_model.Rdata")
    return(TF_model)
  }
  
  GBM <- function(train_data){
    
    save(gbm_model, file = "../output/gbm_model.Rdata")
    return(GBM_model)
  }

}

getwd()
load("../data/split_data/train/train_data.Rdata")
RF_model <- train(train_data, run.RF = T)


