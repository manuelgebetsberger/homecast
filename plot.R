rm(list=ls())
graphics.off()
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


#- Plotfunction
plotFun <- function(x,param=NULL,...){
	if (is.null(param)){stop("No parameter defined")}
	
	limit <- range(na.omit(x[,param]))
	plot(index(x),rep(0,length(index(x))),col="white",ylim=limit,xlab="",...)
	abline(0,0)
	
	
	# add vertical lines for specific hour of the day
	day <- index(x)[as.POSIXlt(index(x))$min == 0 & as.POSIXlt(index(x))$hour %in% 0]
	h12 <- index(x)[as.POSIXlt(index(x))$min == 0 & as.POSIXlt(index(x))$hour %in% 12]
	h3  <- index(x)[as.POSIXlt(index(x))$min == 0 & as.POSIXlt(index(x))$hour %in% c(3,6,9,15,18,21)]
	cols <- "lightgrey"
	abline(v=day,col=cols,lty=1,lwd=2)
	abline(v=h12,col=cols,lty=1,lwd=1)
	abline(v=h3, col=cols,lty=3,lwd=1)
	
	# add time to margin
	#mtext(side=3,at=day,"00:00",cex=0.5)
	mtext(side=1,at=h12,"12:00",cex=0.5)
	
	
	lines(x[,param],col=1,type="l",las=1,lwd=2)
	
	
	# add data source into the figure
	reset <- function() {
		par(mfrow=c(1, 1), oma=rep(0, 4), mar=rep(0, 4), new=TRUE)
		plot(0:1, 0:1, type="n", xlab="", ylab="", axes=FALSE)
	}
	reset()
	leg <- "Data source: https://info.ktn.gv.at/asp/hydro/daten/Niederschlag.html"
	legend("bottomright", legend=leg,bty="n",cex=0.5)

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
	plotFun(sub,param="T",ylab="Temperature [°C]",main=station)
dev.off()



