#RDA of EEG data with k=10 fold cross validation

#Data files had 3 columns for the 3 conditions, then the first 73 rows were the data for the control 
#group and the last 42 rows are the data for the schiz group

#Compute's accuracy of RDA for this data.  Factors can be manually changed by commenting out 
#different read.table lines

cat("\f")
rm(list = ls())
#Retrieve RDA package
library(MASS)
library(klaR)

#Retrieve data
setwd('~/R/LDA/Data/')
# data <- cbind(read.table('SWP_Tables_Beta.txt'),
#               read.table('SWP_Tables_Delta.txt'),
#               read.table('SWP_Tables_HighAlpha.txt'),
#               read.table('SWP_Tables_LowAlpha.txt'),
#               read.table('SWP_Tables_Theta.txt'),
#               read.table('CC_Beta.txt'),
#               read.table('CC_Delta.txt'),
#               read.table('CC_High_Alpha.txt'),
#               read.table('CC_Low_Alpha.txt'),
#               read.table('CC_Theta.txt'),
#               read.table('PL_Beta.txt'),
#               read.table('PL_Delta.txt'),
#               read.table('PL_High_Alpha.txt'),
#               read.table('PL_Low_Alpha.txt'),
#               read.table('PL_Theta.txt'))
data <- cbind(read.table('nodeCCbeta.txt'),
              read.table('nodeCCdelta.txt'),
              read.table('nodeCChighalpha.txt'),
              read.table('nodeCClowalpha.txt'),
              read.table('nodeCCtheta.txt'),
              read.table('nodePLbeta.txt'),
              read.table('nodePLdelta.txt'),
              read.table('nodePLhighalpha.txt'),
              read.table('nodePLlowalpha.txt'),
              read.table('nodePLtheta.txt'))
setwd('~/R/LDA/')
source('RDACrossValidation.R')
usepca <- T

#randomly remove 3 controls and 2 patients to have even # in each group
#(70 controls and 40 patients)
data <- data[-c(sample(1:73,3),sample(74:115,2)),]


#vector containing accuracy for each # of pc's used
maxpcs <- 115
rdaccuracy <- matrix(0,nrow = 4, ncol = maxpcs)
rdaccuracy[4,] <- 1:maxpcs
rownames(rdaccuracy) <- c("Overall Acc","Schiz Acc","Control Acc","# PC's")


#Function does not work using just 1 principle component so it will be left out
#Computes accuracies for each number of PC's used
if (usepca == T){
  for (pc in 2:maxpcs){
    rdaccuracy[1:3,pc] <- RDACrossValidation(data,pc,usepca)
  } 
  
  #Sort by overall accuracy
  rdaccuracy[,order(rdaccuracy[1,],decreasing = T)]
}else if (usepca == F){
  rdaccuracy[1:3,1] <- RDACrossValidation(data,1,usepca)
  rdaccuracy
}



