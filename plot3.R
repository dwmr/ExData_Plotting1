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

df$DateTime <- paste(df$Date, df$Time, sep=' ')

df$DateTime <- dmy_hms(df$DateTime)

startDate <- as.Date('2007-02-01')
endDate <- as.Date('2007-02-02')

df <- subset(df, as.Date(DateTime) >= startDate & as.Date(DateTime) <= endDate)

df$Sub_metering_1 <- as.numeric(df$Sub_metering_1)
df$Sub_metering_2 <- as.numeric(df$Sub_metering_2) 
df$Sub_metering_3 <- as.numeric(df$Sub_metering_3) 

png('plot3.png')

with(df, plot(Sub_metering_1~DateTime, type='l', ylab='Energy sub metering', xlab=''))
with(df, lines(Sub_metering_2~DateTime, type='l', col='red'))
with(df, lines(Sub_metering_3~DateTime, type='l', col='blue'))

legend('topright', names(df[,7:9]), lty=1, col=c('black','red','blue'))

dev.off()