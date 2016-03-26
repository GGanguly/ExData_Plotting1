dataLoad <- function(bigDataFile){
	# Lets assume that the workstation doesn't have sufficient memory, and so the data file has to be read using small buckets 
	# instead of loading the whole file of 2+Million records

	# Bucket size: 10K
	max.rows <- 100000

	# read the first chunk outside the loop
	temp100k <- read.csv2(bigDataFile, header = TRUE, sep = ";", stringsAsFactors=F,  nrows = max.rows)

	# Grab all column names
	colNames <- names(temp100k)

	# Create an empty dataframe having the same set of column names
	final.df <- temp100k[FALSE,]
	
	# load lubridate
	require(lubridate)
	require(dplyr)
	
	# Subset ONLY those observations that belong to 1st and 2nd of Feb'2007
	temp <- temp100k[dmy(temp100k$Date)==dmy("01/02/2007") | dmy(temp100k$Date)==dmy("02/02/2007"),]

	final.df[1:nrow(temp), ] <- temp     ## add to the data
	last.row = nrow(temp)                ## keep track of row index, incl. header

	# The dataset has 2,075,259 rows and 9 columns
	# That means : 21 iterations of 100K records each
	for (i in 2:20){    ## nine chunks remaining to be read
		rm(temp100k)
		temp100k <- read.csv2(bigDataFile, skip=i*max.rows+1, sep = ";", nrow=max.rows, col.names = colNames, header=FALSE,stringsAsFactors=FALSE)
		rm(temp)
		temp <- temp100k[dmy(temp100k$Date)==dmy("01/02/2007") | dmy(temp100k$Date)==dmy("02/02/2007"),]
		if(nrow(temp) >0) {
			final.df[(last.row+1):(last.row+nrow(temp)), ] <- temp
		}
		last.row <- last.row + nrow(temp)    ## increment the current count
	}

	final.df <- final.df[1:last.row, ]   ## only keep filled rows
	## clean up the last chunk to free memory
	rm(temp)    
	rm(temp100k)

	# Convert COLUMN CLASS from 3:9 to numeric from character
	# as.character(x) is required to convert factors to character, else they can't get converted over to numeric
	final.df[,c(3:9)]= apply(final.df[,c(3:9)], 2, function(x) as.numeric(as.character(x)))

	# We add an extra column that is of date type
	final.df<- final.df %>% mutate(date_ts= parse_date_time(paste(final.df$Date, final.df$Time), c("%d/%m/%Y %H:%M:%S"), exact = TRUE))
}