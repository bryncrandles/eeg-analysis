#Code used for doing analysis on SWP of EEG recordings
#Repeated Measures ANOVA
#This is using Mutual Information feature still

#Retrieve data and label
data <- read.table(file.choose())
colnames(data) = c("Resting","Music","Faces")

#Boxplot of data
boxplot(data,ylab="SWP")

#Permutation Test
nperm <- 1000
Fvals <- numeric(nperm)

for (i in 1:nperm){
  #Permutate data
  perm <- data
  colnames(perm) = c("Resting","Music","Faces")
  for (j in 1:42){
    perm[j,] <- sample(data[j,],3)
  }
  
  #Assemble data for anova
  swvals <- c(perm$Resting,perm$Music,perm$Faces)
  cond <- c(rep("Resting",42),rep("Music",42),rep("Faces",42))
  subj <- rep(1:42,3)
  df <- cbind.data.frame(subj,cond,swvals)
  colnames(df) <- c("Subj","Cond","SW")
  df$Subj <- factor(df$Subj)
  df$Cond <- factor(df$Cond)
  
  #Calculate F value for each permutation
  anova <- aov(SW ~ Cond + Error(Subj),data = df)
  Fvals[i] <- summary(anova)[[2]][[1]][[1,"F value"]]
}

#Calculate observed F value
swvals <- c(data$Resting,data$Music,data$Faces)
df <- cbind.data.frame(subj,cond,swvals)
colnames(df) <- c("Subj","Cond","SW")
df$Subj <- factor(df$Subj)
df$Cond <- factor(df$Cond)

anova <- aov(SW ~ Cond + Error(Subj),data = df)
Fobs <- summary(anova)[[2]][[1]][[1,"F value"]]


#Plot histogram of all permutated F values and compare with F-obs
hist(Fvals,col="gray",las=1,xlim=c(0,12),main="F values",xlab="F")
abline(v = Fobs,col = "red")

#Calculate some quantiles and also plot those on the histogram
qt <- quantile(Fvals, probs = c(0.5,0.9,0.95,0.99))
abline(v = qt,col = "blue")
