rm(list=ls())
library(zoo)

#- Helper function to create continuous timeseries filled with NA
timeseries <- function(x,days=5){
	
	#- subsetting the last days
	latest <- range(index(x))[2]
	begin  <- latest - 3600*24*days
	sub    <- subset(x,index(x) >= begin)
	
	#- making continous timeseries every 15 minutes
	start <- range(index(sub))[1]
	end   <- range(index(sub))[2]
	ind   <- seq(start,end,by=60*15)
	na.ind <- zoo(NA,ind)
	
	#- return continuous timeseries
	ts <- merge(na.ind,sub)[,-1]
}



#- Helper function to deaccumulate measured precipitation
deaccumulate <- function(x){
	
	#- take precipitation measurements
	acc  <- x$N
	#- make the difference to the timestep before
	dacc <- diff(acc)
	#- find indices with negative difference (when accumulation is typically set to 0 at the beginning of a new month
	id <- dacc < 0
	#- replace difference by correct values
	dacc[id] <- unlist(lapply(as.numeric(acc[id]),FUN=function(y) ifelse(y== 0,0,y)))
	
	#- append to data
	x <- merge(x,dacc)
}






#- define data directory,time window to plot (in days, and station
outpath    <- "data_processed_rda"
timewindow <- 5
station    <- "St.Oswald"

#- loading file
load(file=sprintf("%s/%s.rda",outpath,station))

#- subsetting timeseries
sub <- timeseries(z)

#- deaccumulation
sub <- deaccumulate(sub)

#- do quick plot of available timeseries
pdf(file=sprintf("timeseries_plots/%s.pdf",station),width=8,height=4)
for (i in "T"){
	plot(sub[,i],col=1,type="l",lwd=2,pch=16,xlab="",ylab=i,main=station)
	abline(0,0)
}
dev.off()




