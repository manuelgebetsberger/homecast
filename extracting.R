rm(list=ls())

library(XML)
library(zoo)
library(memDist)


#- Helper function to read data in meadningful formats
convertData <- function(x){
	if (length(x) == 7){
		name   <- x[[1]]$text
		height <- as.numeric(x[[2]]$text)
		time   <- as.POSIXct(x[[3]]$text,format="%d.%m.%Y %H.%M")
		N      <- as.numeric(x[[4]]$text)
		T      <- x[[5]]$text
		
		# check for missing values
		if (T == "-"){
			T <- NA
		}else{
			T <- as.numeric(paste(strsplit(T,",")[-2][[1]],collapse="."))
		}
		
		
		data <- data.frame("name"   = name,
						   "height" = height,
						   "time"   = time,
						   "N"      = N,
						   "T"      = T)
		
		
	}else{
		warning("skipping node: length != 7 -> probably just header information")
		return(NULL)
	}
}



# connecting to URL and get the raw data, convert it and return a dataframe
getData <- function(x){
	# reading page content and nodes
	page     <- readLines(url)
	raw.data <- htmlTreeParse(page, error=function(...){}, useInternalNodes = F)$children$html[["body"]]
	
	#- create list of single nodes
	datalist <- try( xmlToList( raw.data ))

	#- loop over individual stations in the table and get the wanted data
	data <- lapply(1:length(datalist),FUN=function(y) convertData(datalist[[y]]))
	data <- myRbind(data)
}



# define URL
url  <- "https://info.ktn.gv.at/asp/hydro/daten/Tabelle_Niederschlag.html"

# get data from URL and covert to readable R-formats
cat(sprintf("  getting data at %s",Sys.time()))
	
# getting data
data <- try(getData(url),silent=TRUE)
# save data
save(data,file=sprintf("data/data_%s.rda",format(Sys.time(),"%Y-%m-%d_%H%M")))

cat(sprintf(" DONE\n      ... waiting for next connection ...\n"))
print(data[data$name == "St.Oswald",])







