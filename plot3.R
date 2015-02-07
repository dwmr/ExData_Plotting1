#Declare function that checks if a package is installed - 
#used to ensure needed packages are available
is.installed <- function(mypkg) is.element(mypkg, installed.packages()[,1])

archiveFile <- 'UCIrvineData.zip'
fileURL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'

#Check if the archive is downloaded.  If not - download it.
if (!file.exists(archiveFile)) download.file(fileURL,destfile=archiveFile, mode='wb', method='curl')

dataFile <- 'household_power_consumption.txt'

#Check if the zip is extraxted.  If not - extract it.
if (!file.exists(dataFile)) unzip(archiveFile, overwrite=TRUE)

#Check if date processing package is installed.  If not - install it.  Then load it.
if (!is.installed('lubridate')) install.package('lubridate')
library('lubridate')

#Load data frame.
df <- read.csv(dataFile, sep=";", stringsAsFactors=FALSE)

#Create new DateTime variable in dataset by concatenating Date and Time variables.
df$datetime <- paste(df$Date, df$Time, sep=' ')

#Convert string representation of DateTime to proper date type.
df$datetime <- dmy_hms(df$datetime)

startDate <- as.Date('2007-02-01')
endDate <- as.Date('2007-02-02')

#Subset the data frame to the desired date range.
df <- subset(df, as.Date(datetime) >= startDate & as.Date(datetime) <= endDate)

#Convert string representations of numeric variables to proper numeric type.
df$Sub_metering_1 <- as.numeric(df$Sub_metering_1)
df$Sub_metering_2 <- as.numeric(df$Sub_metering_2) 
df$Sub_metering_3 <- as.numeric(df$Sub_metering_3) 

#Initialize graphics device.
png('plot3.png')

#Plot line graph - overlay subsequent plots.
with(df, plot(Sub_metering_1~datetime, type='l', ylab='Energy sub metering', xlab=''))
with(df, lines(Sub_metering_2~datetime, type='l', col='red'))
with(df, lines(Sub_metering_3~datetime, type='l', col='blue'))

#Add a legend to the plot.
legend('topright', names(df[,7:9]), lty=1, col=c('black','red','blue'))

#Close graphics device.
dev.off()