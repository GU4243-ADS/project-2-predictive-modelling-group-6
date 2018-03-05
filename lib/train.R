#########################################################
### Train a classification model with training images ###
#########################################################

### Author: Wanting Cheng
### Project 2
### ADS Spring 2018


train <- function(train_data, train_label, params, run.RF = F,run.tf = F,
                  run.Ada = F, run.GBM = F, run.XGB = F, run.SVM = F, export = T){
  

  ### Input: 
  ###  -  processed features from images
  ###  -  labels
  
  ### Output: training model specification
  
  ### load libraries
  library("gbm")

  RF <- function(train_data, train_label, params){
  
    require(randomForest, quietly = TRUE)
    
    seed = 1
    set.seed(seed)
    
    
    rf_model <- tuneRF(train_data, train_label, ntreeTry = 500, doBest = TRUE)
    if(export){
      save(rf_model, file = "../output/rf_model.Rdata")
    }
    return(rf_model)
    
    }

  TF <- function(train_data, train_label, params){
    
    save(tf_model, file = "../output/tf_model.Rdata")
    return(TF_model)
  }
  SVM <- function(train_data, train_label, params){
    
    library("e1071")
    
    svm_model <- svm(train_label ~ ., data = train_data, type = "C-classification",
                     kernel = "radial", gamma = params)
    return(svm_model)
  }
  
  Ada <- function(train_data, train_label, params){
    if(!suppressWarnings(require('gbm')))
    {
      install.packages('gbm')
      require('gbm')
    }
    
    library(gbm)
    
    # adaboost1 denotes the adaboost model
    adaboost1<-gbm(train_label~.,
                   data = train_data,
                   distribution = "adaboost",
                   n.trees = 1000,
                   shrinkage = 0.005,
                   interaction.depth = 6,
                   n.minobsinnode = 10,
                   keep.data = TRUE,
                   verbose = TRUE,
                   train.fraction = 0.5,
                   bag.fraction = 0.5
    )
    
    # Using cross validation to find the best iteration number
    best.iter2<-gbm.perf(adaboost1,method = "OOB")
    
    result <- list(model = adaboost1, params = best.iter2)
    if(export){
      save(result, file = "../output/ada_model.Rdata")
    }
    return(result)
  }
  
  Xgb <- function(train_data, train_label, params){
    if(!suppressWarnings(require('xgboost')))
    {
      install.packages('xgboost')
      require('xgboost')
    }
    
    library(xgboost)
    
    # xgboost1 denotes the xgboost model
    xgboost1<-xgboost(data=data.matrix(train_data),
                      label=train_label,
                      max.depth = 11, 
                      eta = 0.5,
                      nround = 25, 
                      objective = "binary:logistic")
    
    result <- xgboost1
    if(export){
      save(result, file = "../output/xgb_model.Rdata")
    }
    return(result)
  }
  
  GBM <- function(train_data, train_label, params){
    if(!suppressWarnings(require('gbm')))
    {
      install.packages('gbm')
      require('gbm')
    }
    
    library(gbm)
    
    gbm1<-gbm(train_label~.,
              data = train_data,
              distribution = "bernoulli",
              n.trees = 1000,
              shrinkage = 0.005,
              interaction.depth = 6,
              n.minobsinnode = 10,
              keep.data = TRUE,
              verbose = TRUE,
              train.fraction = 0.5,
              bag.fraction = 0.5
    )
    best.iter2<-gbm.perf(gbm1,method = "OOB")
    
    result <- list(model = gbm1, params = best.iter2)
    if(export){
    save(result, file = "../output/gbm_model.Rdata")
    }
    return(result)
  }

  ### Train with selected model
  if(run.RF){
    RF_model <- RF(train_data, train_label, params)
    return(RF_model)
  }
  if(run.tf){
    TF_model <- TF(train_data, train_label, params)
    return(TF_model)
  }
  if(run.Ada){
    Ada_model <- Ada(train_data, train_label, params)
    return(Ada_model)
  }
  if(run.GBM){
    GBM_model <- GBM(train_data, train_label, params)
    return(GBM_model)
  }
  if(run.XGB){
    XGB_model <- Xgb(train_data, train_label, params)
    return(XGB_model)
  }
  if(run.SVM){
    SVM_model <- SVM(train_data, train_label, params)
    return(SVM_model)
  }

}


