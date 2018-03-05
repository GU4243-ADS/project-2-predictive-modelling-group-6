########################
### Cross Validation ###
########################

### Author: Wanting Cheng
### Project 2
### ADS Spring 2018


cv.function <- function(X.train, y.train, d, K, cv.svm = F) {

  n        <- length(y.train)
  n.fold   <- floor(n/K)
  s        <- sample(rep(1:K, c(rep(n.fold, K-1), n-(K-1)*n.fold)))  
  cv.error <- rep(NA, K)
  
  for (i in 1:K){
    print(i)
    train_data  <- X.train[s != i,]
    train_label <- y.train[s != i]
    test_data   <- X.train[s == i,]
    test_label  <- y.train[s == i]
    
    if( cv.svm ){
      params <- list(gamma=d)
      fit <- train(train_data, train_label, params, run.SVM = T)
      
      pred <- test(fit, test_data, test.SVM = T)
      
    }
    if( cv.gbm ){
      params <- list(shrinkage=d)
      fit <- train(train_data, train_label, params, run.gbm = TRUE)
      pred <- test(fit, test_data, test_gbm = T)
      
    }
    if( cv.ada ){
      params <- list(shrinkage=d)
      fit <- train(train_data, train_label, params, run.gbm = TRUE)
      pred <- test(fit, test_data, test_gbm = T)
      
    }
    cv.error[i] <- mean(pred != test_label)
    
  }			
  return(c(mean(cv.error), sd(cv.error)))
}

