# This RScript generates 30 SIFT features from the provided data file

required.packages <- c('class', 'text2vec', 'data.table')
absent.packages <- setdiff(required.packages,
                           intersect(installed.packages()[,1],
                                     required.packages))
# Install additional packages
if (length(absent.packages) > 0){
  install.packages(absent.packages, dependencies = TRUE)
}

# library('dplyr')
# Random seed for uniform reproduction
set.seed(2018)

# To prepare for k-means algorithm, concatenate SIFT features
# of all images into one matrix
#
# sift.dim = 128
# n.images <- 2000
# data <- matrix(ncol=sift.dim)
# next.row = 1
# for (i in 1:n.images){
#   file.name <- sprintf(file.name.template, i)
#   sift <- load(sprintf(data.path.template, file.name))
#   data <- rbind(data, features)
#   #print(sprintf(data.path.template, i))
# }
# data <- na.omit(data)

# Because we have processed the data, we 
# read in the readily available version here. 
# Here we run the k-means algorithm to determine
# the number of features we are generalizing
# the SIFT key-points into

library('class')
# load('sift_combined.RData')
k = 200
# km <- kmeans(data, k, algorithm = 'MacQueen', 
#              nstart = 5, iter.max = 20)

# Save k-means model
km.filename.template = '../output/sift_feature_kmeans_model_%d.RData'
km.filename = sprintf(km.filename.template, k)
# save(km, file=sprintf(model.name.template, k))

load(km.filename)

# For each image, classify each sift key-point and compile
# them into a list 
data.path <- 'train-features/' # Change here for image data path
image.name.template <- 'pet%i.jpg.sift.Rdata' # Change here for 
                                              # filename template
n.images <- 2000
image.names <- vector(mode='list', length=n.images)
sift.tokens <- vector(mode='list', length=n.images)
file.name.template <- paste(data.path, image.name.template, sep='')
for (i in 1:n.images){
  load(sprintf(file.name.template, i))
  cluster_labels = knn(km$centers, features, 1:k)
  image.names[[i]] = file.name
  sift.tokens[[i]] = cluster_labels
}

# Then, we take the bag-of-words approach to the SIFT 
# key points, end up producing feature vectors not 
# unlike word vectorization in NLP problems.
library('text2vec')
library('data.table')
# Reproducing word vectorization on the feature classes
iterator = itoken(sift.tokens, 
                  ids = image.names,
                  progressbar = FALSE)
vocab = create_vocabulary(iterator)
vectorizer = vocab_vectorizer(vocab)
doc.term.mat = create_dtm(iterator, vectorizer)

# Tidy up and save the outputs to file
sift.data <- as.data.frame(as.matrix(doc.term.mat))
# Due to high overload, we normalize each row vector 
# to have L2 norm 1
norm <- apply(sift.data, 1, function(x) sqrt(sum(x^2)))
sift.data <- sift.data / norm
out.data <- data.frame()
out.path.template <- 'sift_features_%d.RData'
out.filename <- sprintf(out.path.template, k)
save(sift.data, file=out.filename)
print(sprintf('SIFT features saved at %s', out.filename))
