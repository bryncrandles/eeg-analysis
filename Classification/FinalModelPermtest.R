#Permutation test for confirming final model

cat("\f")
rm(list = ls())
library(MASS)

setwd('~/R/LDA/Data/')
data <- cbind(read.table('CC_Beta.txt'),
              read.table('CC_Delta.txt'),
              read.table('CC_High_Alpha.txt'),
              read.table('CC_Low_Alpha.txt'),
              read.table('CC_Theta.txt'))

pca <- prcomp(data,scale=T)
eigenvectors <- pca$rotation[,1:5]
group <- c(rep("Control",60),rep("Patient",35))

accobs <- 0.7723 #CC


#permutation test
n <- 100000
acc <- vector(mode="double",length = n)

for (i in 1:n){
  #Shuffle data and apply dimension reduction
  datashuffle <- as.matrix(data[sample(1:115,115,replace=F),])
  datatransform <- datashuffle%*%eigenvectors
  
  #Traindata consists of 60 controls followed by 35 patients
  traindata <- datatransform[c(1:60,74:108),]
  #Testdata consists of 13 controls followed by 7 patients
  testdata <- datatransform[c(61:73,109:115),]
  
  #LDA
  lda.obs <- lda(traindata, grouping = group)
  #Predict and measure accuracy
  pred <- predict(lda.obs,testdata)$class
  acc[i] <- (sum(pred[1:13] == "Control") + sum(pred[14:20] == "Patient"))/20
}

#Plot permutation test
hist(acc,main = "CC total accuracy permutation test")
abline(v=accobs,col="red")
#Retrieve p value
pval <- length(acc[acc > accobs])/n
pval
