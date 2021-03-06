#############################################################
### Construct visual features for training/testing images ###
#############################################################

### Authors: Wanting Cheng & Jiongjiong Li
### Project 2
### ADS Spring 2018

feature <- function(img_dir, run.color = T, run.LBP = F, run.HOG = F, export=T){
  
  ### Construct process features for training/testing images
  ### Sample simple feature: Extract row average raw pixel values as features
  
  ### Input: a directory that contains images ready for processing
  ### Output: an .RData file contains processed features for the images: 
  ###         1.Color features (RGB and HSV features, 2000*2001 dataframe), 
  ###         2. Gray features (LBP feature, 2000*31 dataframe)
  
  
  ### load libraries
  library("EBImage")
  library(reticulate)
  library("wvtool")
  library("plyr")
  cv2 <- reticulate::import('cv2')
  
  if(run.color){
    color <- color_feature_extraction(img_dir, export = T)
  }
  if(run.LBP){
    LBP <- LBP_feature_extraction(img_dir, export = T)
  }
  if(run.HOG){
    HOG <- HOG_feature_extraction(img_dir, export = T)
  }
}

color_feature_extraction <- function(img_dir, export = T){
  
  ### Takes about 7min in total
  
  
    # Set the parameters for visual feature extractions
    n_resize <- 128 # the uniform size we want for all the images
    n_intervals <- 10 # How many levels we want to set for red/green/blue intensity

    
    n_files <- length(list.files(img_dir)) # number of files in the directory
    n_names <- paste0( "pet", 1:n_files, ".jpg") # the names of all the images in the directory
    intervals_RGB <- seq(0,1,length.out = n_intervals) # the limits for the levels
    intervals_value <- seq(0,0.005, length.out = n_intervals) # the limits for the levels for the V in HSV
    pb <- txtProgressBar(min = 0, max = n_files, style = 3) # Make a progress bar
    
    
    # Construct the RGB feature matrix and rename the columns and rows.
    RGB <- data.frame(matrix(NA, n_files, n_intervals^3+1))
    colnames(RGB) <- c("Image", paste("RGB_", 1:n_intervals^3, sep = ""))
    RGB$Image <- n_names
    
    # Construct the HSV feature matrix and rename the columns and rows.
    HSV <- data.frame(matrix(NA, n_files, n_intervals^3+1))
    colnames(HSV) <- c("Image", paste("HSV_", 1:n_intervals^3, sep = ""))
    HSV$Image <- n_names
    
    # Then run a loop to read all the images, resize them, and factor out their color intensity to store in the feature matrix.
    for(i in 1:n_files){
      
      img <- readImage(paste(img_dir, n_names[i], sep = ""))
      img <- resize(img, n_resize, n_resize)
      img_data <- imageData(img)
      
      # RGB
      RGB_data <- img_data
      RGB_levels <- as.data.frame(table(
        factor(findInterval(RGB_data[,,1], intervals_RGB), levels = 1:n_intervals),
        factor(findInterval(RGB_data[,,2], intervals_RGB), levels = 1:n_intervals),
        factor(findInterval(RGB_data[,,3], intervals_RGB), levels = 1:n_intervals)
      ))
      RGB[i,2:ncol(RGB)] <- RGB_levels$Freq/(n_resize^2)
      
      # HSV
      # We have to set the dimension of the img matrix to convert the rgb to hsv format.
      dim(img_data) <- c(n_resize*n_resize,3)
      HSV_data <- rgb2hsv(t(img_data))
      HSV_levels <- as.data.frame(table(
        factor(findInterval(HSV_data[1,], intervals_RGB), levels = 1:n_intervals),
        factor(findInterval(HSV_data[2,], intervals_RGB), levels = 1:n_intervals),
        factor(findInterval(HSV_data[3,], intervals_value), levels = 1:n_intervals)
      ))
      HSV[i,2:ncol(HSV)] <- HSV_levels$Freq/(n_resize^2)
      # update progress bar
      setTxtProgressBar(pb, i)
      
    }
    close(pb)
    color_features <- join(RGB, HSV)
    ### output constructed features
    if(export){
      save(color_features, file = "../output/train_feature_color.RData")
    }
    return(color_features)
    
}

LBP_feature_extraction <- function(img_dir, export = T){
  ### load libraries
  if(!suppressWarnings(require('wvtool')))
  {
    install.packages('wvtool')
    require('wvtool')
  }
  library("EBImage")
  library(reticulate)
  library("wvtool")
  cv2 <- reticulate::import('cv2')
  
  ### Takes about 20min in total
  
  
  # Set the parameters for visual feature extractions
  n_resize <- 128 # the uniform size we want for all the images
  n_intervals_LBP <- 30 # How many levels we want to set for LBP intensity
  n_files <- length(list.files(img_dir)) # number of files in the directory
  n_names <- paste0( "pet", 1:n_files, ".jpg") # the names of all the images in the directory
  intervals_LBP <- seq(0,255, length.out = n_intervals_LBP) # the limits for the levels for LBP features
  pb <- txtProgressBar(min = 0, max = n_files, style = 3) # Make a progress bar
  
  # Construct the LBP feature matrix and rename the columns and rows.
  LBP <- data.frame(matrix(NA, n_files, n_intervals_LBP+1))
  colnames(LBP) <- c("Image", paste("LBP_", 1:n_intervals_LBP, sep = ""))
  LBP$Image <- n_names
  
  # Then run a loop to read all the images, resize them, and factor out their color intensity to store in the feature matrix.
  for(i in 1:n_files){
    
    img <- readImage(paste(img_dir, n_names[i], sep = ""))
    img <- resize(img, n_resize, n_resize)
    img_data <- imageData(img)
    
    # LBP
    img_gray <- cv2$cvtColor(np_array(img, dtype='float32'), cv2$COLOR_BGR2GRAY)
    lbp_data <- lbp(img_gray)$lbp.ori
    lbp_levels <- as.data.frame(table(
      factor(findInterval(lbp_data, intervals_LBP), levels = 1:n_intervals_LBP)
    ))
    LBP[i, 2:ncol(LBP)] <- lbp_levels$Freq/(n_resize^2)
    # update progress bar
    setTxtProgressBar(pb, i)
  }
  close(pb)

  ### output constructed features
  if(export){
    save(LBP, file = "../output/train_feature_LBP.RData")
  }
  return(LBP)
  
}


HOG_feature_extraction<- function(img_dir, export=T){
  
  ### Construct process features for training/testing images
  ### Sample simple feature: Extract HOG values as features
  
  ### Input: a directory that contains images ready for processing
  ### Output: an .RData file contains processed features for the images
  
  ### load libraries
  
  library("reticulate")
  cv2 <- reticulate::import('cv2') # import cv2
  library("EBImage")
  
  winSize <- tuple(64L,64L) # resize the image
  blockSize <- tuple(16L,16L) #size of one block
  blockStride <- tuple(8L,8L) # length everytime block moves
  cellSize <- tuple(8L,8L) # size of one cell
  nbins = 9L # 9 orientations
  hog = cv2$HOGDescriptor(winSize,blockSize,blockStride,cellSize,nbins)
  
  n_files <- length(list.files(img_dir)) # number of total image files
  n_names <- paste0( "pet", 1:n_files, ".jpg")

  
  ### calculate HOG values and store them
  HOG <- data.frame(matrix(NA, n_files, ncol=1765))
  colnames(HOG) <- c("Image", paste("HOG_", 1:1764, sep = ""))
  HOG$Image <- n_names
  for(i in 1:n_files){
    img <- cv2$imread(paste0(img_dir, "pet", i, ".jpg"))/255  # read in the images
    img_resized <- cv2$resize(img, dsize=tuple(64L, 64L)) # resize the graph
    hog_values <- hog$compute(np_array(img_resized * 255, dtype='uint8')) # compute the HOG calues
    HOG[i,2:1765] <- hog_values

  }

  ### output constructed features
  if(export){
    save(HOG, file = paste0("../output/feature_HOG", ".RData"))
  }
  return(HOG)
  
}

