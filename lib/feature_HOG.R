#############################################################
### Construct HOG visual features for training/testing images ###
#############################################################

### Authors: Jiongjiong Li
### Project 3

feature <- function(img_dir, export=T){
  
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
  
  ### calculate HOG values and store them
  dat <- matrix(NA, n_files, ncol=1764) 
  for(i in 1:n_files){
    img <- cv2$imread(paste0(img_dir, "pet", i, ".jpg"))/255 # read in the images
    img_resized <- cv2$resize(img, dsize=tuple(64L, 64L)) # resize the graph
    hog_values <- hog$compute(np_array(img_resized * 255, dtype='uint8')) # compute the HOG calues
    dat[i,] <- hog_values
  }
  
  ### output constructed features
  if(export){
    save(dat, file = paste0("../output/feature_HOG", ".RData"))
  }
  return(dat)
}


