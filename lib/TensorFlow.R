
# Tensorflow
# Kai 
# project 2 image classification


Tenosorflow<- function(train_data,train_label, export=T){
  
  library(reticulate)
  library(EBImage)
  library(tensorflow)
  library(keras)
  
  
  trainy <- list()
  for (i in 1:nrow(train_label)) {
    if (train_label$label[i]=="dog"){
      trainy[i] <-1
    }
    else{
      trainy[i] <-0
    }
  }
 
#  train_total <- merge(train_color,train_HOG,by=c("Image"))
#  train_total <- merge(train_total,train_LBP,by=c("Image"))
  
  trainx <- train_data[1:nrow(train_data),2:ncol(train_data)]
# remove the first column which is the image name indicator
  trainx <- data.matrix(trainx, rownames.force = NA)
  trainx <- unname(trainx, force = FALSE)

  trainlabels <- to_categorical(trainy)
  n <- ncol(trainx)
  
  #Create the model (where to recreate the model)
  # the simplest type of model is the sequential model, a linear stack of layers. 
  # Imput_shape is the first layer specifies the shapre of the input data. 28*28*3=2352
  
  model <- keras_model_sequential()
  model %>%
    layer_dense(units= 256, activation = "relu", input_shape = c(n)) %>%
    layer_dropout(rate = 0.4) %>%
    layer_dense(units= 256, activation = "relu") %>%
    layer_dense(units= 128, activation = "relu") %>%
    #  layer_dropout(rate = 0.3) %>%
    layer_dense(units= 2, activation = "sigmoid")
  
  # The final layer outputs is binary by using softmax activation function.
  # can chang ethe activation fucntion such as sigmoid
  
  summary(model)
  
  # Compile 
  # The model with approriate loss function, optimizer and metrics
  model %>%
    compile(loss ='binary_crossentropy',
            optimizer = "sgd",
            metrics = c("accuracy"))
  
  #optimizer_rmsprop(),
  #SGD()
  #          metrics = metric_binary_accuracy)
  # This one used to binary classfication usually
  
  
  # model %>%
  #  compile(loss ='mse',
  #          optimizer = 'optimizer_rmsprop(lr = 0.002)',
  #          metrics = c("accuracy"))
  # This one like a mean squared error regression
  
  
  # Fit Model
  # Train the model for 30 epochs -- one forward poass and one backward pass of all the training examples
  # Batch size -- the nuber of training examples in one forward/backward pass. the higher batch size, the more memory space required.
  
  history <- model %>%
    fit(trainx, 
        trainlabels,
        epochs = 30, 
        batch_size = 32,
        validation_split = 0.2) #20% data used for training
  
  
  # Training visualization
  plot(history)
  # as.data.frame(history)
  
  
  #model evalutaion
  
  model %>% evaluate(trainx,trainlabels)
  pred <- model %>% predict_classes(trainx)
  #table(Predict = pred, Actual = trainy1)
  prob <-  model %>% predict_proba(trainx)
  cbind(prob, Predict=pred, Actual=trainy)
}
  
  