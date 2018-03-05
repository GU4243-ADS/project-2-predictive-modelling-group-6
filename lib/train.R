#########################################################
### Train a classification model with training images ###
#########################################################

### Author: Wanting Cheng
### Project 2
### ADS Spring 2018


train <- function(train_data, train_label, run.RF = F,run.NN = F,
                  run.Ada = F, run.GBM = F, run.XGB = F, run.SVM = F, export = T){
  
  ### Input: 
  ###  -  processed features from images
  ###  -  labels
  
  ### Output: training model specification
  
  ### load libraries
  library("gbm")

  RF <- function(train_data, train_label){
  
    require(randomForest, quietly = TRUE)
    
    seed = 1
    set.seed(seed)
    
    
    rf_model <- tuneRF(train_data, train_label, ntreeTry = 500, doBest = TRUE)
    if(export){
      save(rf_model, file = "../output/rf_model.Rdata")
    }
    return(rf_model)
    
    }

  NN <- function(train_data, train_label){
    
    #Library Loading
    library(reticulate)
    library(EBImage)
    library(tensorflow)
    library(keras)
    library(caret)
    
    
    # Remove the first column which is the image name indicator
    # Transform dataset into a large matrix
    trainx <- data.matrix(train_data, rownames.force = NA)
    trainx <- unname(trainx, force = FALSE)
    
    trainy <- to_categorical(train_label)
    n <- ncol(trainx)
    
    #Create the model (where to recreate the model)
    # the simplest type of model is the sequential model, a linear stack of layers. 
    # Imput_shape is the first layer specifies the shapre of the input data.
    model <- keras_model_sequential()
    model %>%
      layer_dense(units= 256, activation = "relu", input_shape = c(n)) %>%
      layer_dropout(rate = 0.4) %>%
      layer_dense(units= 256, activation = "relu") %>%
      layer_dropout(rate = 0.3) %>%
      layer_dense(units= 128, activation = "relu") %>%
      layer_dropout(rate = 0.3) %>%
      layer_dense(units= 2, activation = "softmax")
    # The final layer outputs is binary by using softmax activation function.
    
    # Compile 
    # The model with approriate loss function, optimizer and metrics
    model %>%
      compile(loss ='binary_crossentropy',
              optimizer = optimizer_rmsprop(),
              metrics = c("accuracy"))
    
    # This one used to binary classfication usually
    # Or use 'categorical_crossentropy' for general classification
    
    
    # Fit Model
    # Train the model for 50 epochs -- one forward poass and one backward pass of all the training examples
    # Batch size -- the nuber of training examples in one forward/backward pass. the higher batch size, the more memory space required.
    history <- model %>%
      fit(trainx, 
          trainy,
          epochs = 50, 
          batch_size = 48)
    
    #model evalutaion and save the model
    model %>% evaluate(trainx,trainy)
    
    saveRDS(model, "../output/NN_model.Rdata")
    return(model)
  }
  
  SVM <- function(train_data, train_label){
    
    library("e1071")
    train_label <- as.factor(train_label)
    svm_model <- svm(train_label ~ ., data = train_data, type = "C-classification")
    return(svm_model)
  }
  
  Ada <- function(train_data, train_label){
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
                   bag.fraction = 0.5,
                   cv.folds = 5
                   
    )
    
    # Using cross validation to find the best iteration number
    best.iter2<-gbm.perf(adaboost1,method = "cv")
    
    result <- list(model = adaboost1, params = best.iter2)

    return(result)
  }
  
  Xgb <- function(train_data, train_label){
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

    return(result)
  }
  
  GBM <- function(train_data, train_label){
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
              bag.fraction = 0.5,
              cv.folds = 5
    )
    best.iter2<-gbm.perf(gbm1,method = "cv")
    
    result <- list(model = gbm1, params = best.iter2)

    return(result)
  }

  ### Train with selected model
  if(run.RF){
    RF_model <- RF(train_data, train_label)
    return(RF_model)
  }
  if(run.NN){
    NN_model <- NN(train_data, train_label)
    return(NN_model)
  }
  if(run.Ada){
    Ada_model <- Ada(train_data, train_label)
    return(Ada_model)
  }
  if(run.GBM){
    GBM_model <- GBM(train_data, train_label)
    return(GBM_model)
  }
  if(run.XGB){
    XGB_model <- Xgb(train_data, train_label)
    return(XGB_model)
  }
  if(run.SVM){
    SVM_model <- SVM(train_data, train_label)
    return(SVM_model)
  }

}


