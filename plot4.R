plot4 <- function(finalDf){
	par(mfrow=c(2,2))
	par(mar=c(1,1,1,1))

	#R1C1
	with(finalDf,plot(date_ts,Global_active_power, type="l", xlab="", ylab="Global Active Power"))
	#R1C2
	with(finalDf,plot(date_ts,Voltage, type="l", ylab="Voltage"))
	#R2C1
	with(finalDf,plot(date_ts,Sub_metering_1, type="l", xlab="", ylab="Energy sub metering"))
	lines(finalDf$date_ts,finalDf$Sub_metering_2,col="red")
	lines(finalDf$date_ts,finalDf$Sub_metering_3,col="blue")

	#bty removes the box, cex shrinks the text, spacing added after labels so it renders correctly
	legend("topright", col=c("black","red","blue"), c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "),lty=c(1,1), bty="n", cex=.5) 

	#R2C2
	with(finalDf,plot(date_ts,Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power"))

	dev.copy(png, file="plot4.png", width=480, height=480)
	dev.off()
}