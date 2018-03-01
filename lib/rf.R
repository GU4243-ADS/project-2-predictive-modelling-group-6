# input: train feature with labels
# output: model spec

RF <- function(train_data){
  
  require(randomForest, quietly = TRUE)
  
  seed = 1
  set.seed(seed)
  
  response <- train_data$label
  predictors <- train_data[3:length(train_data)]
  
  rf_model <- tuneRF(predictors, response, ntreeTry = 500, doBest = TRUE)
  
  return(rf_alternate)
  
}


