#Declare function that checks if a package is installed - 
#used to ensure needed packages are available
is.installed <- function(mypkg) is.element(mypkg, installed.packages()[,1])

localFile <- 'UCIrvineData.zip'
fileURL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'

#Check if the archive is downloaded.  If not - download it.
if (!file.exists(localFile)) download.file(fileURL,destfile=localFile, mode='wb')

localFile <- 'household_power_consumption.txt'

#Check if the zip is extraxted.  If not - extract it.
if (!file.exists(localFile)) unzip(localFile, overwrite=TRUE)

#Check if date processing package is installed.  If not - install it.  Then load it.
if (!is.installed('lubridate')) install.package('lubridate')
library('lubridate')

#Load data frame.
df <- read.csv(localFile, sep=";", stringsAsFactors=FALSE)

#Create new DateTime variable in dataset by concatenating Date and Time variables.
df$DateTime <- paste(df$Date, df$Time, sep=' ')

#Convert string representation of DateTime to proper date type.
df$DateTime <- dmy_hms(df$DateTime)

startDate <- as.Date('2007-02-01')
endDate <- as.Date('2007-02-02')

#Subset the data frame to the desired date range.
df <- subset(df, as.Date(DateTime) >= startDate & as.Date(DateTime) <= endDate)

#Initialize graphics device.
png('plot2.png')

#Plot line graph.
with(df, plot(Global_active_power~DateTime, type='l', ylab='Global Active Power (kilowatts)', xlab=''))

#Close graphics device.
dev.off()
