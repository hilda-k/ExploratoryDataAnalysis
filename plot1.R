require(data.table)

### Download & unzip data
dataURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(dataURL, "./tmp.zip")
unzip("./tmp.zip")
file.remove("./tmp.zip")

### Read data
# Get headers (because skip used later)
header <- scan("./household_power_consumption.txt", what = character(), nlines = 1, quiet = TRUE)
header <- strsplit(header, ";")

# Read data with filter those w/ desired dates
data <- fread("./household_power_consumption.txt", sep=";", header=FALSE, na.strings="?", skip = 66600, nrows = 4000)
setnames(data, header[[1]])
remove(header)
data <- subset(data, Date == '1/2/2007' | Date == '2/2/2007')

# Merge date & time into single column
dateTime <- as.POSIXct(paste(data$Date, data$Time, sep = ";"), format = "%d/%m/%Y;%H:%M:%S")
data$Date <- NULL
data$Time <- NULL
data <- cbind("DateTime" = dateTime, data)
remove(dateTime)

### Plot graph
png(filename = "plot1.png", width = 480, height = 480, units = "px", bg = "transparent")
hist(data$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.off()
