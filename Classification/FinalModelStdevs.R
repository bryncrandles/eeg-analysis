#Best model found using node st devs
#All analyses and graphs done after the final best model was selected can be found here

cat("\f")
rm(list = ls())

#Retrieve Data and cross-validation Function
setwd('~/R/Data/')
data <- cbind(read.table('stdevCCbeta.txt'),
              read.table('stdevCCdelta.txt'),
              read.table('stdevCChighalpha.txt'),
              read.table('stdevCClowalpha.txt'),
              read.table('stdevCCtheta.txt'))


pca <- prcomp(data,scale=T)
#Add group factor
group <- c(rep("Control",73),rep("Schiz",42))
data.df <- cbind(group,data)
data.df$group <- factor(data.df$group)

#####View the first 6 pcs
eigenvectors <- pca$rotation[,1:4]
rownames(eigenvectors) <- c("BetaResting","BetaMusic","BetaFaces",
                            "DeltaResting","DeltaMusic","DeltaFaces",
                            "HighAlphaResting","HighAlphaMusic","HighAlphaFaces",
                            "LowAlphaResting","LowAlphaMusic","LowAlphaFaces",
                            "ThetaResting","ThetaMusic","ThetaFaces")
eigenvectors


#####Plots of first six pcs against eachother
library(factoextra)
for (i in 1:3){
  for (j in (i+1):4){
    plot(fviz_pca_ind(pca, geom.ind = "point", pointshape=21,
                      axes = c(i,j), #Specifies which two pcs to plot
                      pointsize=2,
                      fill.ind  = data.df$group,
                      palette = "simpsons",
                      addEllipses = T,
                      legend.title = "Group")+
           ggtitle(paste("PC",i," vs. PC",j)))
  }
}

#####Histograms
library(sm)
for (i in 1:4){
  datatransform <- as.matrix(data)%*%eigenvectors[,i]
  sm.density.compare(as.vector(datatransform),as.factor(group),col=c("blue","red"),
                     xlab = paste("PC",i))
  title(main = paste("CC - PC",i," Group Comparison"))
  legend(locator(1),legend = c("Control","Patient"),fill = c("blue","red"))
}



#####Permutation Test
library(MASS)
accobs <- 0.7514 #CC
#permutation test
n <- 100000
acc <- vector(mode="double",length = n)
group <- c(rep("Control",60),rep("Patient",35))

for (i in 1:n){
  #Shuffle data and apply dimension reduction
  datashuffle <- as.matrix(data[sample(1:115,115,replace=F),])
  datatransform <- datashuffle%*%eigenvectors
  
  #Traindata consists of 60 controls followed by 35 patients
  traindata <- datatransform[c(1:60,74:108),]
  #Testdata consists of 13 controls followed by 7 patients
  testdata <- datatransform[c(61:73,109:115),]
  
  #LDA
  qda.obs <- qda(traindata, grouping = group)
  #Predict and measure accuracy
  pred <- predict(qda.obs,testdata)$class
  acc[i] <- (sum(pred[1:13] == "Control") + sum(pred[14:20] == "Patient"))/20
}
#Retrieve p value
pval <- length(acc[acc > accobs])/n
#Plot permutation test
hist(acc,main = paste("CC total accuracy perm test. p = ",pval,"\nn =",format(n,scientific = F)))
abline(v=accobs,col="red")




#####Individual PC Accuracies and Accuracies when removing PCS one at a time
group <- c(rep("Control",73),rep("Schiz",42))
for (i in 1:4){
  datatransform <- as.matrix(data)%*%eigenvectors[,i]
  #LDA
  qda.obs <- qda(datatransform, grouping = group)
  #Predict and measure accuracy
  pred <- predict(qda.obs,datatransform)$class
  acc <- (sum(pred[1:73] == "Control") + sum(pred[74:115] == "Patient"))/115
  print(paste("PC",i,"=",round(acc,4)))
}
for (i in 1:4){  #removing pcs
  datatransform <- as.matrix(data)%*%eigenvectors[,-i]
  #LDA
  qda.obs <- qda(datatransform, grouping = group)
  #Predict and measure accuracy
  pred <- predict(qda.obs,datatransform)$class
  acc <- (sum(pred[1:73] == "Control") + sum(pred[74:115] == "Patient"))/115
  print(paste("-PC",i,"=",round(acc,4),". Dif = ",0.7514 - round(acc,4)))
}
