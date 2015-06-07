library(sqldf)

## setwd
#wd <- "##Path to working directory"
#curwd <- getwd()
#if ( wd != curwd ) {
#    setwd(wd)
#}
#######################################

## TXT file was too big for GitHub so I only added the ZIP. This line does some
## initial setup to unzip the file and place it in the ./data directory before proceeding. 
unzip("./data/household_power_consumption.txt.zip", files="household_power_consumption.txt", exdir="./data")

## read table
cols <- c("character", "character", rep("numeric", 7))
sql <- "SELECT * FROM file WHERE Date='1/2/2007' OR Date='2/2/2007'"
householdData <- read.csv.sql("./data/household_power_consumption.txt", sql = sql, header = TRUE, sep=";", colClasses = cols)

dataSample <- householdData

dateTime <- paste( dataSample$Date, dataSample$Time, sep = " " )
dateTime <- strptime( dateTime, format = "%d/%m/%Y %H:%M:%S" )

dataSample <- cbind( dataSample, dateTime )
names(dataSample) <- colNames <- c("Date", "Time", "GlobalActivePower", "GlobalReactivePower", "Voltage", "GlobalIntensity", "SubMetering1", "SubMetering2", "SubMetering3", "DateTime")

## Create plot4.png
png("plot4.png", width=480, heigh=480, bg="transparent")

par(mfrow = c(2, 2))

## 1: same as plot2, but without " (kilowatts)" in the y label
plot(dataSample$DateTime, dataSample$GlobalActivePower, type="l", xlab="", ylab="Global Active Power")

## 2
plot(dataSample$DateTime, dataSample$Voltage, xlab="datetime", type="l", ylab="Voltage")

## 3: same as plot3, but without a border around the legend
plot(dataSample$DateTime, dataSample$SubMetering1, type="l", xlab="", ylab="Energy sub metering")
lines(dataSample$DateTime, dataSample$SubMetering2, type="l", col="red")
lines(dataSample$DateTime, dataSample$SubMetering3, type="l", col="blue")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd="1", col=c("black", "red", "blue"), bty="n")

## 4
plot(dataSample$DateTime, dataSample$GlobalReactivePower, xlab="datetime", ylab="Global_reactive_power", type="l")

dev.off()