#Test LDA accuracy when removing PCs

cat("\f")
rm(list = ls())
library(MASS)

#Retrieve data
setwd('~/R/LDA/Data/')
data <- cbind(read.table('CC_Beta.txt'),
  read.table('CC_Delta.txt'),
  read.table('CC_High_Alpha.txt'),
  read.table('CC_Low_Alpha.txt'),
  read.table('CC_Theta.txt'))
data <- as.matrix(data)

#Run PCA
pca <- prcomp(data,scale=T)
group <- c(rep("Control",73),rep("Patient",42))
#Take some PC's and transform data - change c() in next line to select which PC's to keep/remove
eigenvectors <- pca$rotation[,c(1,2,3,5)]
datatransform <- data%*%eigenvectors

#LDA
lda.obs <- lda(datatransform, grouping = group)
#Predict and measure accuracy
pred <- predict(lda.obs,datatransform)$class
acc <- (sum(pred[1:73] == "Control") + sum(pred[74:115] == "Patient"))/115
acc






