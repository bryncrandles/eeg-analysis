#Find misclassified subjects


cat("\f")
rm(list = ls())

setwd('~/R/LDA/')
source('LDACrossValidation.R')
setwd('~/R/LDA/Data/')
data <- cbind(read.table('SWP_Tables_Beta.txt'),
              read.table('SWP_Tables_Delta.txt'),
              read.table('SWP_Tables_HighAlpha.txt'),
              read.table('SWP_Tables_LowAlpha.txt'),
              read.table('SWP_Tables_Theta.txt'))

#Number of trials
n <- 500
TOTALacc <- 0
TOTALcontrolacc <- 0
TOTALpatientacc <- 0

misc <- matrix(0,nrow = 115, ncol = 3)
colnames(misc) <- c("# times misclassified","# times tested","Rate")
accuracies <- matrix(0,nrow = 3)

###Start trials
for (i in 1:n){
  
  #randomly remove 3 controls and 2 patients to have even # in each group
  #(70 controls and 40 patients)
  data2 <- data[-c(sample(1:73,3),sample(74:115,2)),]
  
  #Record which subjects are being tested
  for (j in 1:110){
    x <- as.integer(rownames(data2[j,]))
    misc[x,2] <- misc[x,2] + 1
  }
  
  
  
  #Randomly arranges the 70 controls and the 40 patients
  data2 <- data2[c(sample(1:70,70,replace=F),sample(71:110,40,replace=F)),]
  
  #Uses 5 pc's since it tended to have best results
  LDAoutput <- LDACrossValidation(data2,5,T)
  
  #add accuracies to the vector.  Will be averaged after the loop
  accuracies <- accuracies + LDAoutput[[1]]
  
  #Record which subjects were misclassified
  y <- as.integer(unlist(LDAoutput[[2]]))
  for (j in 1:length(y)){
    misc[y[j],1] <- misc[y[j],1] + 1
  }
}

#Average accuracies across n
accuracies <- accuracies/n

#Calculate misclassification rates
misc[,3] <- round(misc[,1] / misc[,2], digits = 4)
