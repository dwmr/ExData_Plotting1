#declare function that checks if a package is installed - 
#used to ensure needed packages are available
is.installed <- function(mypkg) is.element(mypkg, installed.packages()[,1])

localFile <- 'UCIrvineData.zip'
fileURL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'

if (!file.exists(localFile)) download.file(fileURL,destfile=localFile, mode='wb')

localFile <- 'household_power_consumption.txt'

if (!file.exists(localFile)) unzip(localFile, overwrite=TRUE)

if (!is.installed('lubridate')) install.package('lubridate')
library('lubridate')

df <- read.csv(localFile, sep=";", stringsAsFactors=FALSE)

df$Date <- dmy(df$Date)

startDate <- as.Date('2007-02-01')
endDate <- as.Date('2007-02-02')

df <- subset(df, as.Date(Date) >= startDate & as.Date(Date) <= endDate)

png('plot1.png')

hist(as.numeric(df$Global_active_power), main='Global Active Power', col='red', xlab='Global Active Power (kilowatts)')

dev.off()