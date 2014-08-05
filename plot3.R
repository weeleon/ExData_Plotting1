#plot3.R is a data cleaning script following the instructions
#set out for the Data Exploration Module project 1 assignment
#

#initialise paths to main data location
myDataZip <- "/Users/lenw/Documents/Coursera_Offline/Data_Science/Data_Exp_Project1/exdata-data-household_power_consumption.zip"
myDataText <- "/Users/lenw/Documents/Coursera_Offline/Data_Science/Data_Exp_Project1/household_power_consumption.txt"
myOutputPath <- "/Users/lenw/Documents/repo_DataExploration/ExData_Plotting1"

#define default working directory
setwd(myOutputPath)

#if the zipped data file has not been downloaded then download and unpack it
if (!file.exists(myDataZip)) {
      #record the date of download
      dateDownloaded <- paste(date(),"CEST")
      #download and save the required data archives
      download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",myDataZip,method="curl")
      #call system command to unpack the zipped archive
      unzip(myDataZip, exdir = "/Users/lenw/Documents/Coursera_Offline/Data_Science/Data_Exp_Project1")
      #drop the download date into a text file called "DownloadDate.txt" in the download area
      write.table(dateDownloaded,file="/Users/lenw/Documents/Coursera_Offline/Data_Science/Data_Exp_Project1/DownloadDate.txt",col.names=F,row.names=F,quote=F)
}

#confirm that the zip file has properly unpacked, if not halt execution
if (!file.exists(myDataText)) stop ("Error - unzipped data not found!")

#only read a part of the data to get the names of the columns
smalltest <- read.table(myDataText,sep=";",header=T,na.strings="?",colClasses="character",nrows=5)
mynames <- names(smalltest)

#read in only the part of the file that corresponds to the dates of interest
mydata <- read.table(myDataText,sep=";",header=F,na.strings="?",colClasses="character",skip=66637,nrows=2880)
names(mydata) <- mynames

#coerce the dates and times into POSIX format as R-style
temp <- sapply(1:2880,function(x) paste(mydata$Date[x],mydata$Time[x]))
RDate <- strptime(as.character(temp),"%d/%m/%Y %H:%M:%S")

#---------------------------------------------------------
#extract only the three Sub_metering values to be plotted
sm1 <- as.numeric(mydata$Sub_metering_1)
sm2 <- as.numeric(mydata$Sub_metering_2)
sm3 <- as.numeric(mydata$Sub_metering_3)

#generate a line-type plot to the screen device first
par(ps = 16)
plot(RDate,sm1, main="",type="l",xlab="",ylab="Energy sub metering",lwd=1)
lines(RDate,sm2,col="red")
lines(RDate,sm3,col="blue")
legend("topright",lty=1,cex=0.8,legend=c("Sub_metering_1    ","Sub_metering_2    ","Sub_metering_3    "),col=c("black","red","blue"))

#copy the plot from the screen device to the PNG file device at 480x480 pixel size
#save as plot3.png
dev.copy(png,"plot3.png",height=480,width=480,units="px"); dev.off();




