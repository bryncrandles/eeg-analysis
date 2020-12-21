#Cross validation

#Currently requires that the size of schizdata is 40 and that the size of controldata is 70
#Number of factors can be anything


LDACrossValidation <- function(data,pc){
  
  #Matrix to store accuracies for each k.  Will be averaged at the end
  accuracy <- matrix(0,nrow = 10,ncol = 3)
  colnames(accuracy) <- c("Overall Acc","Control Acc","Schiz Acc")
  
  for (k in 1:10){
    #Separate testing and training data
    testindexes <- c((7*(k-1)+1):(7*k) , ((4*(k-1)+1)+70):(4*k+70))
    train <- data[-testindexes,]
    test <- data[testindexes,]
    #Training data now consists of 63 control data points followed by 36 schiz data points
    #Testing data consists of 7 control data points followed by 4 schiz data points
    
    
    #Run PCA
    pca <- prcomp(train, scale = T)
    #Select first 'pc' principal components
    pcadata <- as.matrix(pca$x[,1:pc])
    
    ##Let group 1 be controls (rows 1-63) and group 2 be schizophrenics (rows 64-99)
    #Mu vectors
    mu1 <- colMeans(pcadata[1:63,])
    mu2 <- colMeans(pcadata[64:99,])
    
    #Calculate Spooled and compute inverse ahead of time
    n1 <- 63
    n2 <- 36
    s1 <- cov(pcadata[1:63,])
    s2 <- cov(pcadata[64:99,])
    spool <- ((n1 - 1)*s1 + (n2 - 1)*s2)/(n1 + n2 - 2)
    spoolinv <- solve(spool)
    
    #critical value for LDA
    critval <- 0.5*t(mu1 + mu2)%*%spoolinv%*%(mu2 - mu1) - log(n2/n1,base=exp(1))
    
    #Create indicator vectors for the testing data
    n1test <- 7
    n2test <- 4
    Indic1 <- matrix(0,nrow = n1test)
    Indic2 <- matrix(0,nrow = n2test)
    
    #Here a 1 in the indicator vector means that the prediction was correct
    #Recall LDA rule classifies to group 2 (schiz's here) if 'x' > critval
    for (i in 1:7){
      #Applies transformation from PCA to each obs and selects correct no. of PC's 
      #(y is a dummy variable)
      y <- (test[i,] - pca$center)/pca$scale
      y <- as.matrix(y)%*%pca$rotation
      #x is the observed value for classification
      x <- y[,1:pc]%*%spoolinv%*%(mu2 - mu1)
      if (x <= critval){
        Indic1[i] <- 1
      }
    }
    for (i in 1:4){
      y <- (test[i+7,] - pca$center)/pca$scale
      y <- as.matrix(y)%*%pca$rotation
      x <- y[,1:pc]%*%spoolinv%*%(mu2 - mu1)
      if (x > critval){
        Indic2[i] <- 1
      }
    }
    
    #Compute accuracy
    accuracy[k,1] <- (sum(Indic1) + sum(Indic2))/(n1test + n2test)
    accuracy[k,2] <- sum(Indic1)/n1test
    accuracy[k,3] <- sum(Indic2)/n2test
  }
  
  #Average across all 10 folds to get total accuracy and group accuracies
  CVacc <- colMeans(accuracy)
  return(CVacc)
}