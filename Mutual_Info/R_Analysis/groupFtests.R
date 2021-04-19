#Permutation tests for the F-tests

#retrieve data
datac <- read.table(file.choose())
datas <- read.table(file.choose())
colnames(datac) <- c("Resting","Music","Faces")
colnames(datas) <- c("Resting","Music","Faces")

#Assumptions check
boxplot(datac)
boxplot(datas)
#appears skewed with outliers so we will do permutation test

#permutation test
nperm <- 1000
FvalsG <- numeric(nperm)
FvalsC <- numeric(nperm)
FvalsGC <- numeric(nperm)
for (i in 1:nperm){
  #Permute data conditions
  permc <- datac
  for (j in 1:72){
    permc[j,] <- sample(datac[j,],3,replace=F)
  }
  perms <- datas
  for (j in 1:42){
    perms[j,] <- sample(datas[j,],3,replace=F)
  }
  #Permute data groups
  temp <- rbind(datac,datas)
  rows <- sample(nrow(temp),replace=F)
  perm <- temp[rows,]
  colnames(perm) <- c("Resting","Music","Faces")
  
  
  #Assemble data to do ANOVA
  swvals <- c(perm$Resting,perm$Music,perm$Faces)
  cond <- c(rep("Resting",72),rep("Music",72),rep("Faces",72),rep("Resting",42),rep("Music",42),rep("Faces",42))
  subj <- c(rep(1:72,3),rep(73:114,3))
  group <- c(rep("Control",72*3),rep("Schiz",42*3))
  df <- cbind.data.frame(subj,group,cond,swvals)
  colnames(df) <- c("Subj","Group","Cond","SWP")
  df$Subj <- factor(df$Subj)
  df$Group <- factor(df$Group)
  df$Cond <- factor(df$Cond)
  
  #ANOVA for each permutation
  anova <- aov(SWP ~ Group*Cond + Error(Subj/Cond),data = df)
  FvalsG[i] <- summary(anova)[[1]][[1]][[1,"F value"]]
  FvalsC[i] <- summary(anova)[[2]][[1]][[1,"F value"]]
  FvalsGC[i] <- summary(anova)[[2]][[1]][[2,"F value"]]
}

#Calculate Observed F-Value
#Assemble data to do ANOVA
swvals <- c(datac$Resting,datac$Music,datac$Faces,datas$Resting,datas$Music,datas$Faces)
cond <- c(rep("Resting",72),rep("Music",72),rep("Faces",72),rep("Resting",42),rep("Music",42),rep("Faces",42))
subj <- c(rep(1:72,3),rep(73:114,3))
group <- c(rep("Control",72*3),rep("Schiz",42*3))
df <- cbind.data.frame(subj,group,cond,swvals)
colnames(df) <- c("Subj","Group","Cond","SWP")
df$Subj <- factor(df$Subj)
df$Group <- factor(df$Group)
df$Cond <- factor(df$Cond)
#Observed ANOVA
anova <- aov(SWP ~ Group*Cond + Error(Subj/Cond),data = df)
summary(anova)
FobsG <- summary(anova)[[1]][[1]][[1,"F value"]]
FobsC <- summary(anova)[[2]][[1]][[1,"F value"]]
FobsGC <- summary(anova)[[2]][[1]][[2,"F value"]]

#Plots
#Group
hist(FvalsG,col="grey",xlim=c(0,4),main="F Values:Group TD0",xlab="F")
abline(v=FobsG,col="red")
qt <- quantile(FvalsG,probs=c(0.5,0.9,0.95,0.99))
abline(v=qt,col="black")
qt

#Condition
hist(FvalsC,col="grey",xlim=c(0,18),main="F Values:Condition TD0",xlab="F")
abline(v=FobsC,col="red")
qt <- quantile(FvalsC,probs=c(0.5,0.9,0.95,0.99))
abline(v=qt,col="black")
qt

#Interaction
hist(FvalsGC,col="grey",xlim=c(0,12),main="F Values:Interaction TD0",xlab="F")
abline(v=FobsGC,col="red")
qt <- quantile(FvalsGC,probs=c(0.50,0.9,0.95,0.99))
abline(v=qt,col="black")
qt
