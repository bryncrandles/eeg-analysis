###QDA with 10-fold cross reference for EEG analysis

#Data files had 3 columns for the 3 conditions, then the first 73 rows were the data for the control 
#group and the last 42 rows are the data for the schiz group

#Compute's accuracy of QDA for this data.  Factors can be manually changed by commenting out 
#different read.table lines

cat("\f")
rm(list = ls())
#Retrieve package containing qda()
library(MASS)

#Retrieve data
setwd('~/R/LDA/')
data <- cbind(read.table('SWP_Tables_Beta.txt'),
              read.table('SWP_Tables_Delta.txt'),
              read.table('SWP_Tables_HighAlpha.txt'),
              read.table('SWP_Tables_LowAlpha.txt'),
              read.table('SWP_Tables_Theta.txt'),
              read.table('CC_Beta.txt'),
              read.table('CC_Delta.txt'),
              read.table('CC_High_Alpha.txt'),
              read.table('CC_Low_Alpha.txt'),
              read.table('CC_Theta.txt'),
              read.table('PL_Beta.txt'),
              read.table('PL_Delta.txt'),
              read.table('PL_High_Alpha.txt'),
              read.table('PL_Low_Alpha.txt'),
              read.table('PL_Theta.txt'))

#randomly remove 3 controls and 2 patients to have even # in each group
#(70 controls and 40 patients)
data <- data[-c(sample(1:73,3),sample(74:115,2)),]

#Cross-validation K=10-fold
#*****In order to change to k=5-fold many numbers must be manually changed inside the loop
K <- 10
#vector containing accuracy for each K
accuracy <- matrix(0,nrow = K, ncol = 3)
colnames(accuracy) <- c("Overall Acc","Schiz Acc","Control Acc")


for (k in 1:K){
  #Separate testing and training data
  testindexes <- c((7*(k-1)+1):(7*k) , ((4*(k-1)+1)+70):(4*k+70))
  train <- data[-testindexes,]
  test <- data[testindexes,]
  #Training data now consists of 63 control data points followed by 36 schiz data points
  #Testing data consists of 7 control data points followed by 4 schiz data points
  
  #Label data points by their class
  cl <- factor(c(rep("c",63),rep("s",36)))
  #compute QDA
  q <- qda(train,cl)
  #Use testing data to predict class
  pred <- predict(q,test)$class
  
  #Compute accuracies
  accuracy[k,1] <- (sum(pred[1:7] == "c") + sum(pred[8:11] == "s"))/11
  accuracy[k,2] <- sum(pred[8:11] == "s")/4
  accuracy[k,3] <- sum(pred[1:7] == "c")/7
}

#Average accuracy for all k
CVacc <- colMeans(accuracy)
print(CVacc)
