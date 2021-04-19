#Creates density estimation of both groups for each PC
cat("\f")
rm(list = ls())
library(MASS)

#Retrieve data
setwd('~/R/LDA/Data/')
data <- cbind(read.table('CC_Beta.txt'),
              read.table('CC_Delta.txt'),
              read.table('CC_High_Alpha.txt'),
              read.table('CC_Low_Alpha.txt'),
              read.table('CC_Theta.txt'))
data <- as.matrix(data)

#Run PCA
pca <- prcomp(data,scale=T)
group <- c(rep("Control",73),rep("Patient",42))
#Take a PC and transform data - change c() in next line to select which PC to plot
eigenvectors <- pca$rotation[,c(4)]
datatransform <- data%*%eigenvectors


#Histogram of densities
library(sm)
sm.density.compare(as.vector(datatransform),as.factor(group),col=c("blue","red"),
                   xlab = "PC5")
title(main = "CC - PC4 Group Comparison")
legend(locator(1),legend = c("Control","Patient"),fill = c("blue","red"))
