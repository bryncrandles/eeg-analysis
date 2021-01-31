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
source('QDACrossValidation.R')

#randomly remove 3 controls and 2 patients to have even # in each group
#(70 controls and 40 patients)
data <- data[-c(sample(1:73,3),sample(74:115,2)),]

#vector containing accuracy for each # of pc's used
qdaccuracy <- matrix(0,nrow = 4, ncol = ncol(data))
qdaccuracy[4,] <- 1:ncol(data)
rownames(qdaccuracy) <- c("Overall Acc","Schiz Acc","Control Acc","# PC's")

#Function does not work using just 1 principle component so it will be left out
#Computes accuracies for each number of PC's used
for (pc in 2:ncol(data)){
  qdaccuracy[1:3,pc] <- QDACrossValidation(data,pc)
} 

#Sort by overall accuracy
qdaccuracy[,order(qdaccuracy[1,],decreasing = T)]
