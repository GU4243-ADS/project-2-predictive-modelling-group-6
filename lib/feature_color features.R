#############################################################
### Construct visual features for training/testing images ###
#############################################################

### Authors: Wanting Cheng
### Project 2
### ADS Spring 2018

feature <- function(img_dir){
  
  ### Construct process features for training/testing images
  ### Sample simple feature: Extract row average raw pixel values as features
  
  ### Input: a directory that contains images ready for processing
  ### Output: an .RData file contains processed features for the images
  
  ### load libraries
  library("EBImage")
  library(reticulate)
  cv2 <- reticulate::import('cv2')

  # Set the parameters for visual feature extractions
  n_resize <- 128 # the uniform size we want for all the images
  n_intervals <- 10 # How many levels we want to set for red/green/blue intensity
  n_files <- length(list.files(img_dir)) # number of files in the directory
  n_names <- list.files(img_dir) # the names of all the images in the directory
  intervals_RGB <- seq(0,1,length.out = n_intervals) # the limits for the levels
  intervals_value <- seq(0,0.005, length.out = n_intervals) # the limits for the levels for the V in HSV
  
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
  }
  
  color_features <- merge(RGB, HSV, by.x = "Image")
  return(color_features)
  
}