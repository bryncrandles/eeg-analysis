#Creates bar charts with error bars of the two groups next to each other and with
#all three conditions in one graph
#Code can be slightly modified for different time delays.  Here I was doing time delay 4 (16ms)
rm(list=ls())

datas <- read.table('R/SWP Values/SWP300vals4.txt')
datac <- read.table('R/SWP Values/SWP400Vals4.txt')
colnames(datac) <- c("Resting","Music","Faces")
colnames(datas) <- c("Resting","Music","Faces")

#Compute means and standard deviations for both groups for all tasks
avgs <- colMeans(datas)
avgc <- colMeans(datac)
avg <- cbind(avgs,avgc)
sds <- apply(datas,2,sd)
sdc <- apply(datac,2,sd)
sdsd <- cbind(sds,sdc)
colnames(avg) <- c("Schiz","Control")
colnames(sdsd) <- c("Schiz","Control")

#Divide standard deviation by n to get standard error
sdsd[,1] <- sdsd[,1]/sqrt(42)
sdsd[,2] <- sdsd[,2]/sqrt(72)

#Create plot
foo <- barplot(t(avg),beside=T,ylim=c(0,1),main="Time Delay 16ms",ylab="SWP",col=c("turquoise","orange"))
arrows(x0=foo,y0=t(avg)+t(sdsd),y1=t(avg)-t(sdsd),angle=90,code=3,length=0.1)
legend("topright",legend = c("Schiz","Control"),fill=c("turquoise","orange"))

#Displays averages and standard deviations if desired
# t(avg)
# t(sdsd)
