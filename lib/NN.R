
# Neural Network
# Kai 
# project 2 image classification


NN_model<- function(train_data,train_label, export=T){
  
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
  
  