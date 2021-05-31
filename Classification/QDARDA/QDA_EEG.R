###QDA with 10-fold cross reference for EEG analysis

#Data files had 3 columns for the 3 conditions, then the first 73 rows were the data for the control 
#group and the last 42 rows are the data for the schiz group

#Compute's accuracy of QDA for this data.  Factors can be manually changed by commenting out 
#different read.table lines

cat("\f")
rm(list = ls())
#Retrieve package containing qda()
library(MASS)

setwd('~/R/LDA/')
source('QDACrossValidation.R')
#Retrieve data
setwd('~/R/Data/')
# data <- cbind(read.table('SWP_Beta.txt'),
#               read.table('SWP_Delta.txt'),
#               read.table('SWP_High_Alpha.txt'),
#               read.table('SWP_Low_Alpha.txt'),
#               read.table('SWP_Theta.txt'))
#               # read.table('CC_Beta.txt'),
#               # read.table('CC_Delta.txt'),
#               # read.table('CC_High_Alpha.txt'),
#               # read.table('CC_Low_Alpha.txt'),
#               # read.table('CC_Theta.txt'))
#               # read.table('PL_Beta.txt'),
#               # read.table('PL_Delta.txt'),
#               # read.table('PL_High_Alpha.txt'),
#               # read.table('PL_Low_Alpha.txt'),
#               # read.table('PL_Theta.txt'))
#Datafiles for node standard deviation measures
data <- cbind(read.table('stdevCCbeta.txt'),
              read.table('stdevCCdelta.txt'),
              read.table('stdevCChighalpha.txt'),
              read.table('stdevCClowalpha.txt'),
              read.table('stdevCCtheta.txt'),
              read.table('stdevPLbeta.txt'),
              read.table('stdevPLdelta.txt'),
              read.table('stdevPLhighalpha.txt'),
              read.table('stdevPLlowalpha.txt'),
              read.table('stdevPLtheta.txt'))
usepca <- F
N <- 100
maxpcs <- min(30,ncol(data))

#vector containing accuracy for each # of pc's used
qdaccuracy <- matrix(0,nrow = 4, ncol = maxpcs)
rownames(qdaccuracy) <- c("Overall Acc","Schiz Acc","Control Acc","# PC's")
for (i in 1:N){
  #randomly remove 3 controls and 2 patients to have even # in each group
  #(70 controls and 40 patients)
  data2 <- data[-c(sample(1:73,3),sample(74:115,2)),]
  
  #Function does not work using just 1 principle component so it will be left out
  #Computes accuracies for each number of PC's used
  if (usepca == T){
    for (pc in 2:maxpcs){
      qdaccuracy[1:3,pc] <- qdaccuracy[1:3,pc] + QDACrossValidation(data2,pc,usepca)
    }
  }else if (usepca == F){
    qdaccuracy[1:3,1] <- qdaccuracy[1:3,1] + QDACrossValidation(data2,1,usepca)
  }

}
qdaccuracy <- qdaccuracy/N
qdaccuracy[4,] <- 1:maxpcs

#Sort by overall accuracy
qdaccuracy[,order(qdaccuracy[1,],decreasing = T)]
