#k = 10-fold Cross validation

###Inputs
#Data: Should be a matrix with units as the rows, columns are for factors.  Should be 70 rows of
#control data points followed by 40 rows of patient data points
#-Number of factors can be anything (not too big though)

#pc: Number of principle components to use in the dimension reduction

#usepca: An indication of whether to actually use pca or not.  If False is specified then it does
#not matter what number is inputted for 'pc'

###Output:
#returnvals: List containing two outputs
#[[1]] = A 3-long vector containing Total Accuracy, Control Accuracy and Patient Accuracy
#[[2]] = A list object containing the numbers of the units who were misclassified


LDACrossValidation <- function(data,pc,usepca){
  pcsused <- 1:pc
  
  #Matrix to store accuracies for each k.  Will be averaged at the end
  accuracy <- matrix(0,nrow = 10,ncol = 3)
  colnames(accuracy) <- c("Overall Acc","Control Acc","Schiz Acc")
  
  #List for keeping track of misclassified units
  misclassified <- list()
  
  for (k in 1:10){
    #Separate testing and training data
    testindexes <- c((7*(k-1)+1):(7*k) , ((4*(k-1)+1)+70):(4*k+70))
    train <- data[-testindexes,]
    test <- data[testindexes,]
    #Training data now consists of 63 control data points followed by 36 patient data points
    #Testing data consists of 7 control data points followed by 4 patient data points
    
####When running PCA:
    if (usepca == T){
      #Run PCA
      pca <- prcomp(train, scale = T)
      #Select first 'pc' principal components
      pcadata <- as.matrix(pca$x[,pcsused])
      
      ##Let group 1 be controls (rows 1-63) and group 2 be patients (rows 64-99)
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
      #Recall LDA rule classifies to group 2 (patients here) if 'x' > critval
      for (i in 1:7){
        #Applies transformation from PCA to each obs and selects correct no. of PC's 
        #(y is a dummy variable)
        y <- (test[i,] - pca$center)/pca$scale
        y <- as.matrix(y)%*%pca$rotation
        #y <- y%*%pca$rotation
        #x is the observed value for classification
        x <- y[,pcsused]%*%spoolinv%*%(mu2 - mu1)
        if (x <= critval){
          Indic1[i] <- 1
        }else{
          #y still carries the id number of the person so extract number from there
          #If misclassified, add that id number to the list
          misclassified <- c(misclassified,rownames(y))
        }
      }
      for (i in 1:4){
        y <- (test[i+7,] - pca$center)/pca$scale
        y <- as.matrix(y)%*%pca$rotation
        #y <- y%*%pca$rotation
        x <- y[,pcsused]%*%spoolinv%*%(mu2 - mu1)
        if (x > critval){
          Indic2[i] <- 1
        }else{
          misclassified <- c(misclassified,rownames(y))
        }
      }
#### For not running PCA
    } else if (usepca == F){
      ##Let group 1 be controls (rows 1-63) and group 2 be schizophrenics (rows 64-99)
      #Mu vectors
      mu1 <- colMeans(train[1:63,])
      mu2 <- colMeans(train[64:99,])
      
      #Calculate Spooled and compute inverse ahead of time
      n1 <- 63
      n2 <- 36
      s1 <- cov(train[1:63,])
      s2 <- cov(train[64:99,])
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
        #x is the observed value for classification
        x <- as.matrix(test[i,])%*%spoolinv%*%(mu2 - mu1)
        if (x <= critval){
          Indic1[i] <- 1
        }else{
          #y still carries the id number of the person so extract number from there
          #If misclassified, add that id number to the list
          #misclassified <- c(misclassified,rownames(y))
        }
      }
      for (i in 1:4){
        x <- as.matrix(test[i+7,])%*%spoolinv%*%(mu2 - mu1)
        if (x > critval){
          Indic2[i] <- 1
        }else{
          #misclassified <- c(misclassified,rownames(y))
        }
      }
    }  
    
    
    #Compute accuracy
    accuracy[k,1] <- (sum(Indic1) + sum(Indic2))/(n1test + n2test)
    accuracy[k,2] <- sum(Indic1)/n1test
    accuracy[k,3] <- sum(Indic2)/n2test
  }
  
  #Average across all 10 folds to get total accuracy and group accuracies
  CVacc <- colMeans(accuracy)
  
  returnvals <- list(CVacc,misclassified)
  return(returnvals)
}