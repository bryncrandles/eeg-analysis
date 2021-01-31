#Further testing of different combinations of factors put into model
#Does LDA n times to find an estimate of the true total accuracy

#Clear
cat("\f")
rm(list = ls())
#Get function and data
setwd('~/R/LDA/')
source('LDACrossValidation.R')
setwd('~/R/LDA/Data/')
data <- cbind(read.table('SWP_Tables_Beta.txt'),
              read.table('SWP_Tables_Delta.txt'),
              read.table('SWP_Tables_HighAlpha.txt'),
              read.table('SWP_Tables_LowAlpha.txt'),
              read.table('SWP_Tables_Theta.txt'))
              # read.table('CC_Beta.txt'),
              # read.table('CC_Delta.txt'),
              # read.table('CC_High_Alpha.txt'),
              # read.table('CC_Low_Alpha.txt'),
              # read.table('CC_Theta.txt'),
              # read.table('PL_Beta.txt'),
              # read.table('PL_Delta.txt'),
              # read.table('PL_High_Alpha.txt'),
              # read.table('PL_Low_Alpha.txt'),
              # read.table('PL_Theta.txt'))

#Number of trials
n <- 250
#Accuracy-counting variables
TOTALacc <- 0
TOTALcontrolacc <- 0
TOTALpatientacc <- 0
#Vector to track which # of pc's is being used the most
TimesPCused <- matrix(0,nrow = ncol(data))

###Start trials
for (i in 1:n){
  #randomly remove 3 controls and 2 patients to have even # in each group
  #(70 controls and 40 patients)
  data2 <- data[-c(sample(1:73,3),sample(74:115,2)),]
  
  #Randomly arranges the 70 controls and the 40 patients
  data2 <- data2[c(sample(1:70,70,replace=F),sample(71:110,40,replace=F)),]
  
  #Matrix to keep track of accuracies for all numbers of principle components
  ldaccuracy <- matrix(0,nrow = 3,ncol = ncol(data2))
  
  #Computes accuracy for each # of pc's
  for (pc in 2:ncol(data2)){
    LDAoutput <- LDACrossValidation(data2,pc,T)
    ldaccuracy[,pc] <- LDAoutput[[1]]
  }
  
  #Identify highest overall accuracy and retrieve 3 accuracies from that column
  TOTALacc <- TOTALacc + max(ldaccuracy[1,])
  TOTALcontrolacc <- TOTALcontrolacc + ldaccuracy[2,which.max(ldaccuracy[1,])]
  TOTALpatientacc <- TOTALpatientacc + ldaccuracy[3,which.max(ldaccuracy[1,])]
  TimesPCused[which.max(ldaccuracy[1,])] <- TimesPCused[which.max(ldaccuracy[1,])] + 1
}

#Take average
TOTALacc <- TOTALacc/n
TOTALcontrolacc <- TOTALcontrolacc/n
TOTALpatientacc <- TOTALpatientacc/n
#*The control and patient accuracies were the values corresponding to the highest overall accuracy,
#not necesarily the highest control/patient accuracy
