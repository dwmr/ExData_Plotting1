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

df$datetime <- paste(df$Date, df$Time, sep=' ')

df$datetime <- dmy_hms(df$datetime)

startDate <- as.Date('2007-02-01')
endDate <- as.Date('2007-02-02')

df <- subset(df, as.Date(datetime) >= startDate & as.Date(datetime) <= endDate)

df$Sub_metering_1 <- as.numeric(df$Sub_metering_1)
df$Sub_metering_2 <- as.numeric(df$Sub_metering_2) 
df$Sub_metering_3 <- as.numeric(df$Sub_metering_3) 

png('plot4.png')

par(mfrow=c(2,2))

with(df,{
  plot(Global_active_power~datetime, type='l', ylab='Global Active Power', xlab='') 
  plot(Voltage~datetime, type='l')
  plot(Sub_metering_1~datetime, type='l', ylab='Energy sub metering', xlab='')
  lines(Sub_metering_2~datetime, type='l', col='red')
  lines(Sub_metering_3~datetime, type='l', col='blue')
  legend('topright', names(df[,7:9]), lty=1, col=c('black','red','blue'), bty='n')
  plot(Global_reactive_power~datetime, type='l')
}) 

dev.off()
