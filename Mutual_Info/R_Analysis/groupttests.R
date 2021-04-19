#Group t-tests of SWP (MI feature)
#Load data
datac <- read.table(file.choose())
datas <- read.table(file.choose())
colnames(datac) <- c("Resting","Music","Faces")
colnames(datas) <- c("Resting","Music","Faces")

#Compute t-tests
t.test(datac$Resting,datas$Resting,conf.level=1-0.05/3)
t.test(datac$Music,datas$Music,conf.level=1-0.05/3)
t.test(datac$Faces,datas$Faces,conf.level=1-0.05/3)

#Permutation test to check validity of t-tests
nperm <- 1000
tvals <- numeric(nperm)
data <- c(datac$Resting,datas$Resting)

for (i in 1:nperm){
  #Permute data
  perm <- sample(data,114)
  permc <- perm[1:72]
  perms <- perm[73:114]
  #Run t-test
  ttt <- t.test(permc,perms)
  tvals[i] <- ttt$statistic
}
#Compute observed t-test
ttt<-t.test(datac$Resting,datas$Resting)
tobs <- ttt$statistic

#plot results
hist(tvals,col="gray")
abline(v = tobs,col="red")
qt <- quantile(tvals,probs = c(0.05/6,1-0.05/6))
abline(v = qt,col="black")
