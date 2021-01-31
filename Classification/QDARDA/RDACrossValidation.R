#10-fold Cross validation for RDA

#Currently requires that the size of schizdata is 40 and that the size of controldata is 70
#Number of factors can be anything

#Returns Overall accuracy and both group accuracies

RDACrossValidation <- function(data,pc,usepca){
  
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
    
    if (usepca == T){
      #Run PCA
      pca <- prcomp(train, scale = T)
      #Select first 'pc' principal components
      pcadata <- as.matrix(pca$x[,1:pc])
      
      #Label data points by their class
      cl <- factor(c(rep("c",63),rep("s",36)))
      #compute QDA
      rdanalysis <- rda(pcadata,cl)
      
      #Applies transformation from PCA to each obs and selects correct no. of PC's 
      #Scale testing data
      for (i in 1:11){
        test[i,] <- (test[i,] - pca$center)/pca$scale
      }
      
      #Transform testing data
      test <- as.matrix(test)%*%pca$rotation
      #Select first pc principle components
      test <- test[,1:pc]
      
    }else if (usepca == F){
      #Label data points by their class
      cl <- factor(c(rep("c",63),rep("s",36)))
      #compute QDA
      rdanalysis <- rda(train,cl)
    }
    
    #Predict class of testing data
    pred <- predict(rdanalysis,test)$class
    
    
    #Compute accuracies
    accuracy[k,1] <- (sum(pred[1:7] == "c") + sum(pred[8:11] == "s"))/11
    accuracy[k,2] <- sum(pred[8:11] == "s")/4
    accuracy[k,3] <- sum(pred[1:7] == "c")/7
  }
  
  #Average across all 10 folds to get total accuracy and group accuracies
  CVacc <- colMeans(accuracy)
  return(CVacc)
}