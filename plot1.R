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

#Convert the string representation of the date to a proper date type.
df$Date <- dmy(df$Date)

startDate <- as.Date('2007-02-01')
endDate <- as.Date('2007-02-02')

#Subset the data frame to the desired date range.
df <- subset(df, as.Date(Date) >= startDate & as.Date(Date) <= endDate)

#Initialize graphics device.
png('plot1.png')

#Plot histogram.
with(df, hist(as.numeric(Global_active_power), main='Global Active Power', col='red', xlab='Global Active Power (kilowatts)'))

#Close gramphics device.
dev.off()