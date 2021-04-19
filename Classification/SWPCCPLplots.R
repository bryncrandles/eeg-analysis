#Creates plots of SWP v CC, SWP v PL and CC v PL for each of the 5 frequency bands
#****This is for the coherence data
cat("\f")
rm(list = ls())

setwd('~/R/LDA/Data/')

#Retrieve data
swpdata <- cbind(read.table('SWP_Tables_Beta.txt'),
              read.table('SWP_Tables_Delta.txt'),
              read.table('SWP_Tables_HighAlpha.txt'),
              read.table('SWP_Tables_LowAlpha.txt'),
              read.table('SWP_Tables_Theta.txt'))
ccdata <- cbind(read.table('CC_Beta.txt'),
              read.table('CC_Delta.txt'),
              read.table('CC_High_Alpha.txt'),
              read.table('CC_Low_Alpha.txt'),
              read.table('CC_Theta.txt'))
pldata <- cbind(read.table('PL_Beta.txt'),
              read.table('PL_Delta.txt'),
              read.table('PL_High_Alpha.txt'),
              read.table('PL_Low_Alpha.txt'),
              read.table('PL_Theta.txt'))

group <- c(rep("Control",73),rep("Patient",42))
swpdata <- cbind(group,swpdata)
swpdata$group <- as.factor(swpdata$group)
ccdata <- cbind(group,ccdata)
ccdata$group <- as.factor(ccdata$group)
pldata <- cbind(group,pldata)
pldata$group <- as.factor(pldata$group)

#SWP vs CC plots
plot(rowMeans(swpdata[,2:4]),rowMeans(ccdata[,2:4]),main = "Beta: SWP vs CC",
     xlab = "SWP",ylab = "CC",pch = 16, col = c('red','blue'))
legend("topleft",legend = c("Controls","Patients"),fill = c('red','blue'))
plot(rowMeans(swpdata[,5:7]),rowMeans(ccdata[,5:7]),main = "Delta: SWP vs CC",
     xlab = "SWP",ylab = "CC",pch = 16, col = c('red','blue'))
legend("topleft",legend = c("Controls","Patients"),fill = c('red','blue'))
plot(rowMeans(swpdata[,8:10]),rowMeans(ccdata[,8:10]),main = "High Alpha: SWP vs CC",
     xlab = "SWP",ylab = "CC",pch = 16, col = c('red','blue'))
legend("topleft",legend = c("Controls","Patients"),fill = c('red','blue'))
plot(rowMeans(swpdata[,11:13]),rowMeans(ccdata[,11:13]),main = "Low Alpha: SWP vs CC",
     xlab = "SWP",ylab = "CC",pch = 16, col = c('red','blue'))
legend("topleft",legend = c("Controls","Patients"),fill = c('red','blue'))
plot(rowMeans(swpdata[,14:16]),rowMeans(ccdata[,14:16]),main = "Theta: SWP vs CC",
     xlab = "SWP",ylab = "CC",pch = 16, col = c('red','blue'))
legend("topleft",legend = c("Controls","Patients"),fill = c('red','blue'))

#SWP vs PL plots
plot(rowMeans(swpdata[,2:4]),rowMeans(pldata[,2:4]),main = "Beta: SWP vs PL",
     xlab = "SWP",ylab = "PL",pch = 16, col = c('darkgreen','darkorange'))
legend("bottomleft",legend = c("Controls","Patients"),fill = c('darkgreen','darkorange'))
plot(rowMeans(swpdata[,5:7]),rowMeans(pldata[,5:7]),main = "Delta: SWP vs PL",
     xlab = "SWP",ylab = "PL",pch = 16, col = c('darkgreen','darkorange'))
legend("topright",legend = c("Controls","Patients"),fill = c('darkgreen','darkorange'))
plot(rowMeans(swpdata[,8:10]),rowMeans(pldata[,8:10]),main = "High Alpha: SWP vs PL",
     xlab = "SWP",ylab = "PL",pch = 16, col = c('darkgreen','darkorange'))
legend("bottom",legend = c("Controls","Patients"),fill = c('darkgreen','darkorange'))
plot(rowMeans(swpdata[,11:13]),rowMeans(pldata[,11:13]),main = "Low Alpha: SWP vs PL",
     xlab = "SWP",ylab = "PL",pch = 16, col = c('darkgreen','darkorange'))
legend("bottom",legend = c("Controls","Patients"),fill = c('darkgreen','darkorange'))
plot(rowMeans(swpdata[,14:16]),rowMeans(pldata[,14:16]),main = "Theta: SWP vs PL",
     xlab = "SWP",ylab = "PL",pch = 16, col = c('darkgreen','darkorange'))
legend("topright",legend = c("Controls","Patients"),fill = c('darkgreen','darkorange'))

#CC vs PL plots
plot(rowMeans(ccdata[,2:4]),rowMeans(pldata[,2:4]),main = "Beta: CC vs PL",
     xlab = "CC",ylab = "PL",pch = 16, col = c('purple','turquoise'))
legend("bottomright",legend = c("Controls","Patients"),fill = c('purple','turquoise'))
plot(rowMeans(ccdata[,5:7]),rowMeans(pldata[,5:7]),main = "Delta: CC vs PL",
     xlab = "CC",ylab = "PL",pch = 16, col = c('purple','turquoise'))
legend("topleft",legend = c("Controls","Patients"),fill = c('purple','turquoise'))
plot(rowMeans(ccdata[,8:10]),rowMeans(pldata[,8:10]),main = "High Alpha: CC vs PL",
     xlab = "CC",ylab = "PL",pch = 16, col = c('purple','turquoise'))
legend("bottom",legend = c("Controls","Patients"),fill = c('purple','turquoise'))
plot(rowMeans(ccdata[,11:13]),rowMeans(pldata[,11:13]),main = "Low Alpha: CC vs PL",
     xlab = "CC",ylab = "PL",pch = 16, col = c('purple','turquoise'))
legend("bottom",legend = c("Controls","Patients"),fill = c('purple','turquoise'))
plot(rowMeans(ccdata[,14:16]),rowMeans(pldata[,14:16]),main = "Theta: CC vs PL",
     xlab = "CC",ylab = "PL",pch = 16, col = c('purple','turquoise'))
legend("topright",legend = c("Controls","Patients"),fill = c('purple','turquoise'))


