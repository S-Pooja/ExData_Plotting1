
library(ggplot2)
library(dplyr)
library(reshape2)

#Downloading and Reading the file
if(!file.exists("./data")){dir.create("./data")}
Url <-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(Url, destfile="./data/Dataset.zip", method="curl")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
files<-list.files("./data", recursive=TRUE)
datafile<- read.table("./data/household_power_consumption.txt", sep=";", na.strings = "?", header=TRUE)

#Converting the format of the date column, and subsetting the data file
datafile$Date<- as.Date(datafile$Date, format="%d/%m/%Y")
datafileSubset<- datafile[(datafile$Date>="2007-02-01"& datafile$Date<="2007-02-02"), ]

#Creating a new column with the complete date and time stamp 
A<-paste0(datafileSubset$Date, ",", datafileSubset$Time)
B<- as.POSIXct(A, format="%Y-%m-%d,%H:%M:%S")
datafileSubsetA<- cbind.data.frame(datafileSubset, B)

#Creating the Plot 2 and saving in current working directory  
ggplot(datafileSubsetA, aes(x=B, y=Global_active_power))+ geom_line(colour="black")+xlab("")+ylab("Global Active Power (kilowatts)") +theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=9))
dev.copy(png, file="plot2.png", width=480, height=480)
dev.off()
cat("plot2.png has been saved in", getwd())

