rm(list=ls())

#- create directory for precessed data
outpath  <- "data_processed_rda"
dirpath  <- "data"
dir.create(outpath,showWarnings=F)

#- find available files
avail    <- list.files("data")

#- defines stations to process into timeseries rda
load(sprintf("%s/%s",dirpath,avail[1]))
stations <- data$name
stations <- stations[-21]


#- loop over stations
for (stat in stations){
	z <- zoo(data.frame("T"=NA,"N"=NA),as.POSIXct("2018-02-07 00:00:00"))
	
	#- loop over files extracted by the crontab
	for (file in avail){
		
		#- loading file
		f <- sprintf("%s/%s",dirpath,file)
		load(f)
		
		#- subsetting station
		val <- data[data$name == stat,]
		s   <- zoo(subset(val,select=c(T,N)),val$time)
		
		#- merge if timeindex of the new file is more accurate
		if (index(s) > range(index(z))[2]){
			z <- rbind(z,s)
		}
		
	}
	
	#- do quick plot of available timeseries
	pdf(file=sprintf("timeseries_plots/%s.pdf",stat))
		plot(na.omit(z),type="b",lwd=2,pch=16,xlab="TIME",main=stat)
	dev.off()
	
	#- save file
	save(z,file=sprintf("%s/%s.rda",outpath,stat))
}


