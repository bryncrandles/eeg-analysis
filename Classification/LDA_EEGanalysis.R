###LDA for SWP,CC,PL
#LDA using 10-fold cross validation for our EEG analysis
#Data files had 3 columns for the 3 conditions, then the first 73 rows were the data for the control 
#group and the last 42 rows are the data for the schiz group

#Compute's the accuracy of LDA including dimension reduction by PCA.  Factors can be manually changed
#by commenting out different read.table lines

cat("\f")
rm(list = ls())

#Retrieve Data
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


##If you want to see the scree plot for PCA
pca <- prcomp(data,scale=T)
#plot(pca$x[,1],pca$x[,2])
pca.var <- pca$sdev^2
pca.var.per <- round(pca.var/sum(pca.var)*100,1)
barplot(pca.var.per,main="Scree Plot",xlab="Principle Component",ylab="Percent Variation")
sum(pca.var.per[1:4]) #Check total variation for first few pc's



##Start of LDA

#randomly remove 3 controls and 2 patients to have even # in each group
#(70 controls and 40 patients)
data <- data[-c(sample(1:73,3),sample(74:115,2)),]

#Combine all frequencies into one matrix then separate control and schiz
controldata <- data[1:70,]
schizdata <- data[71:110,]


#Cross-validation K=10-fold
#*****In order to change to k=5-fold some numbers inside the loop must be manually changed
K <- 10
#vector containing accuracy for each K
accuracy <- matrix(0,nrow = K, ncol = 3)
colnames(accuracy) <- c("Overall Acc","Schiz Acc","Control Acc")
#Number of principle components to use
pc <- 4

for (k in 1:K){
  #Separate training and testing data
  #Picks out first tenth of each dataset and then then next tenth for K=2, etc
  test.sdata <- schizdata[c((4*(k-1)+1):(4*k)),]
  test.cdata <- controldata[c((7*(k-1)+1):(7*k)),]
  train.sdata <- schizdata[-c((4*(k-1)+1):(4*k)),]
  train.cdata <- controldata[-c((7*(k-1)+1):(7*k)),]
  
  #Combine training datasets for PCA
  traindata <- rbind(train.cdata,train.sdata)
  
  #Run PCA
  pca <- prcomp(traindata,scale = T)
  #Select first 4 principal components
  pcadata <- pca$x[,1:pc]
  
  #Mu vectors
  #Let group 1 be schizophrenics (rows 64-99) and group 2 be controls (rows 1-63)
  mu1 <- colMeans(pcadata[64:99,])
  mu2 <- colMeans(pcadata[1:63,])
  
  #Calc Spooled and compute inverse ahead of time
  n1 <- nrow(pcadata[64:99,])
  n2 <- nrow(pcadata[1:63,])
  s1 <- cov(pcadata[64:99,])
  s2 <- cov(pcadata[1:63,])
  spool <- ((n1 - 1)*s1 + (n2 - 1)*s2)/(n1 + n2 - 2)
  spoolinv <- solve(spool)
  
  #critical value for LDA
  critval <- 0.5*t(mu1 + mu2)%*%spoolinv%*%(mu1 - mu2) - log(n1/n2,base=exp(1))
  
  #Create indicator vectors for the testing data
  n1test <- nrow(test.sdata)
  n2test <- nrow(test.cdata)
  Indic1 <- matrix(0,nrow = n1test)
  Indic2 <- matrix(0,nrow = n2test)
  
  #Here a 1 in the indicator vector means that the prediction was correct
  for (i in 1:n1test){
    #Applies transformation from PCA to each obs and selects correct no. of PC's 
    #(y is a dummy variable)
    y <- (test.sdata[i,] - pca$center)/pca$scale
    y <- as.matrix(y)%*%pca$rotation
    #x is the observed value for classification
    x <- y[,1:pc]%*%spoolinv%*%(mu1 - mu2)
    if (x > critval){
      Indic1[i] <- 1
    }
  }
  for (i in 1:n2test){
    y <- (test.cdata[i,] - pca$center)/pca$scale
    y <- as.matrix(y)%*%pca$rotation
    x <- y[,1:pc]%*%spoolinv%*%(mu1 - mu2)
    if (x <= critval){
      Indic2[i] <- 1
    }
  }
  #Compute accuracy
  accuracy[k,1] <- (sum(Indic1) + sum(Indic2))/(n1test + n2test)
  accuracy[k,2] <- sum(Indic1)/n1test
  accuracy[k,3] <- sum(Indic2)/n2test
}

#Average accuracy for all k
CVacc <- colMeans(accuracy)
print(CVacc)
