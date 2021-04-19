#Final selected model from classification testing
#Plots principle components of final model and retrieves the eigenvector

#LDA classification method, 5 principle components, factors used: CC
cat("\f")
rm(list=ls())

setwd('~/R/LDA/Data/')
data <- cbind(read.table('CC_Beta.txt'),
              read.table('CC_Delta.txt'),
              read.table('CC_High_Alpha.txt'),
              read.table('CC_Low_Alpha.txt'),
              read.table('CC_Theta.txt'))
colnames(data) <- c("BetaResting","BetaMusic","BetaFaces",
                    "DeltaResting","DeltaMusic","DeltaFaces",
                    "HAlphaResting", "HAlphaMusic","HAlphaFaces",
                    "LAlphaResting","LAlphaMusic","LAlphaFaces",
                    "ThetaResting","ThetaMusic","ThetaFaces")
#Run PCA
pca <- prcomp(data, scale = T)

group <- c(rep("Control",73),rep("Patient",42))
data.df <- cbind(group,data)
data.df$group <- as.factor(data.df$group)

#Plots principle components against each other with ellipses
#Change the "axes" and "ggtitle" lines to switch to different pairs of PC's
library(factoextra)
fviz_pca_ind(pca, geom.ind = "point", pointshape=21,
             axes = c(4,5), #Specifies which two pcs to plot
             pointsize=2,
             fill.ind  = data.df$group,
             palette = "simpsons",
             addEllipses = T,
             legend.title = "Group")+
  ggtitle("PC4 vs. PC5")

#Retrieve eigenvectors
eigenvectors <- as.data.frame(pca$rotation[,1:5])
eigenvectors <- round(eigenvectors,4)
