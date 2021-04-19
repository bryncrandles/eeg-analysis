###estimates LDA accuracy for SWP,CC,PL and node CC,PL values
#LDA using 10-fold cross validation for our EEG analysis
#Data files had 3 columns for the 3 conditions and 115 data points -- the first 73 rows were the data 
#for the control group and the last 42 rows are the data for the schiz group

#Compute's the accuracy of LDA including dimension reduction by PCA.  Factors can be manually changed
#by commenting out different read.table lines

#https://towardsdatascience.com/principal-component-analysis-pca-101-using-r-361f4c53a9ff
#Website describing how to use package for plotting principle components

cat("\f")
rm(list = ls())

#Retrieve Data and cross-validation Function
setwd('~/R/LDA/Data/')
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
#Datafiles for node CC and PL values
#data <- cbind(#read.table('nodeCCbeta.txt'),
              # read.table('nodeCCdelta.txt'),
              # read.table('nodeCChighalpha.txt'),
              # read.table('nodeCClowalpha.txt'),
              # read.table('nodeCCtheta.txt'),
              # read.table('nodePLbeta.txt'),
              # read.table('nodePLdelta.txt'),
              # read.table('nodePLhighalpha.txt'),
              # read.table('nodePLlowalpha.txt'),
              # read.table('nodePLtheta.txt'))
setwd('~/R/LDA/')
source('LDACrossValidation.R')
pcause <- T



####If you want to see the scree plot and first two PC's for PCA
# pca <- prcomp(data,scale=T)
# #Add group factor
# group <- c(rep("Control",73),rep("Schiz",42))
# data.df <- cbind(group,data)
# data.df$group <- factor(data.df$group)
# #Plot first two PC's with different colours for the two groups
# library(factoextra)
# fviz_pca_ind(pca, geom.ind = "point", pointshape=21,
#              pointsize=2,
#              fill.ind  = data.df$group,
#              palette = "simpsons",  #Use Simpson's colour palette for fun :)
#              addEllipses = T,
#              legend.title = "Group")+
#   ggtitle("PC1 vs. PC2 - Node PL") 
# #Scree Plot
# pca.var <- pca$sdev^2
# pca.var.per <- round(pca.var/sum(pca.var)*100,1)
# barplot(pca.var.per,main="Scree Plot",xlab="Principle Component",ylab="Percent Variation")




####Start of LDA

#randomly remove 3 controls and 2 patients to have even # in each group for CV
#(70 controls and 40 patients)
data <- data[-c(sample(1:73,3),sample(74:115,2)),]

#Create table for accuracies for all numbers of pcs used
maxpcs <- min(ncol(data),30)
pcaccuracy <- matrix(0,nrow = 3,ncol = maxpcs)
rownames(pcaccuracy) <- c("Total Acc","Control Acc","Schiz Acc")

#Function does not work using just 1 principle component so it will be left out
#Computes accuracies for each number of PC's used
if (pcause == T){
  for (pc in 2:maxpcs){
    LDAoutput <- LDACrossValidation(data,pc,T)
    ldaccuracy[,pc] <- LDAoutput[[1]]
  }
}else if (pcause == F){
  LDAoutput <- LDACrossValidation(data,1,F)
  ldaccuracy[,1] <- LDAoutput[[1]]
}

#Add row to show number of pc's used, then order from highest to lowest
pcaccuracy <- rbind(pcaccuracy,1:maxpcs)
pcaccuracy[,order(pcaccuracy[1,],decreasing = T)]