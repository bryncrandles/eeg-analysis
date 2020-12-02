#LDA for SWP

#Retrieve Data
data <- cbind(read.table('~/R/LDA/SWP_Tables_Beta.txt'),
              read.table('~/R/LDA/SWP_Tables_Delta.txt'),
              read.table('~/R/LDA/SWP_Tables_HighAlpha.txt'),
              read.table('~/R/LDA/SWP_Tables_LowAlpha.txt'),
              read.table('~/R/LDA/SWP_Tables_Theta.txt'))

#plot(data[1:73,],data[74:115,],col=c("red","blue"))

#Combine all frequencies into one matrix then separate control and schiz
controldata <- data[1:73,]
schizdata <- data[74:115,]

#Cut off a couple data points for simplicity
schizdata <- schizdata[1:40,]
controldata <- controldata[1:70,]


#Cross-validation K=10-fold
K <- 10
#vector containing accuracy for each K
accuracy <- matrix(0,nrow = K)
#Number of principle components to use
pc <- 7

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
  accuracy[k] <- (sum(Indic1) + sum(Indic2))/(n1test + n2test)
}

#Average accuracy for all k
CVacc <- mean(accuracy)
print(CVacc)
