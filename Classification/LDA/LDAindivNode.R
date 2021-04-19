#Classification accuracy for individual nodes

cat("\f")
rm(list = ls())
library(MASS)
library(xtable)

#Import all datasets for individual nodes
#1-73 - Controls, 74-115 patients
setwd('~/R/LDA/Data/')
betaCCdata <- read.table('nodeCCbeta.txt')
deltaCCdata <- read.table('nodeCCdelta.txt')
highalphaCCdata <- read.table('nodeCChighalpha.txt')
lowalphaCCdata <- read.table('nodeCClowalpha.txt')
thetaCCdata <- read.table('nodeCCtheta.txt')
betaPLdata <- read.table('nodePLbeta.txt')
deltaPLdata <- read.table('nodePLdelta.txt')
highalphaPLdata <- read.table('nodePLhighalpha.txt')
lowalphaPLdata <- read.table('nodePLlowalpha.txt')
thetaPLdata <- read.table('nodePLtheta.txt')

setwd('~/R/LDA/')
source('LDACrossValidation.R')


#Compute classification accuracy for each node
accuracy <- matrix(0,nrow=129,ncol=4)
colnames(accuracy) <- c("Total Acc","Control Acc","Patient Acc","# PC's")
for (i in 1:129){
  data <- cbind(betaCCdata[,i],deltaCCdata[,i],highalphaCCdata[,i],lowalphaCCdata[,i],thetaCCdata[,i])
                #betaPLdata[,i],deltaPLdata[,i],highalphaPLdata[,i],lowalphaPLdata[,i],thetaPLdata[,i])
  
  #randomly remove 3 controls and 2 patients to have even # in each group
  #(70 controls and 40 patients)
  data <- data[-c(sample(1:73,3),sample(74:115,2)),]
  
  pcaccuracy <- matrix(0,nrow = 3,ncol = ncol(data))
  rownames(pcaccuracy) <- c("Total Acc","Control Acc","Schiz Acc")
  
  for (pc in 2:ncol(data)){
    pcaccuracy[,pc] <- LDACrossValidation(data,pc,T)[[1]]
  }
  
  
  accuracy[i,1:3] <- pcaccuracy[,which.max(pcaccuracy[1,])]
  accuracy[i,4] <- which.max(pcaccuracy[1,])
}

#Write results into text file
write.table(accuracy,file = 'CCnodeacc.txt',row.names=F,col.names=F)

