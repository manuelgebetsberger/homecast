rm(list=ls())

#- create directory for precessed data
outpath  <- "data_processed_rda"
dirpath  <- "data"
plotpath <- "timeseries_plots/"

#- create directories
dir.create(outpath, showWarnings=F)
dir.create(plotpath,showWarnings=F)

#- find available files
avail    <- list.files("data")

#- defines stations to process into timeseries rda
load(sprintf("%s/%s",dirpath,avail[1]))
stations <- data$name
stations <- stations[-21]

# merging and plotting currently only for St.Oswald
stations <- "St.Oswald"


#- loop over stations
for (stat in stations){
	z <- zoo(data.frame("T"=NA,"N"=NA),as.POSIXct("2018-02-07 00:00:00"))
	
	#- loop over files extracted by the crontab
	for (file in avail){
		print(file)
		
		#- loading file
		f <- sprintf("%s/%s",dirpath,file)
		load(f)
		
		#- subsetting station
		#- check for extraction error (if data is.null)
		if (!is.null(data)){
			val <- data[data$name == stat,]
			s   <- zoo(subset(val,select=c(T,N)),val$time)
			
			#- merge if timeindex of the new file is more accurate
			if (index(s) > range(index(z))[2]){
				z <- rbind(z,s)
			}
		}
		
	}
	#- save file
	save(z,file=sprintf("%s/%s.rda",outpath,stat))
}


