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

## Create plot1.png
png("plot1.png", width=480, heigh=480, bg="transparent")
hist( dataSample$GlobalActivePower, main="Global Active Power", xlab="Global Active Power (kilowatts)", col="red" )
dev.off()