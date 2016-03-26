plot1 <- function(finalDf){
	hist(finalDf$Global_active_power, col="red", xlab="Global Active Power (kilowatts)")
	dev.copy(png, file="plot1.png", width=480, height=480)
	dev.off()
}