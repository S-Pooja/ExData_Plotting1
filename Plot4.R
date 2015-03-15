
library(ggplot2)
library(dplyr)
library(reshape2)
library(grid)
library("gridExtra")

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

#Creating the Plot 4 and saving in current working directory  
p1 = ggplot(datafileSubsetA, aes(x=B, y=Global_active_power))+ geom_line(colour="black")+xlab("")+ylab("Voltage") +theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=9))
p2 = ggplot(datafileSubsetA, aes(x=B, y=Voltage))+ geom_line(colour="black")+xlab("")+ylab("Voltage") +theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=9))
p3 = ggplot(datafileSubsetC, aes(x=B, y=value, color=variable))+ geom_line()+xlab("")+ylab("Energy Sub Metering") + scale_colour_manual(values=c("black", "red", "blue"), name=" ") + theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=9))+theme(legend.text = element_text(colour="black", size = 6, face = "bold"))+theme(legend.position=c(.77, .87))+theme(legend.key.size = unit(.5, "cm"))
p4 = ggplot(datafileSubsetA, aes(x=B, y=Global_reactive_power))+ geom_line(colour="black")+xlab("")+ylab("Global Reactive Power (kilowatts)") +theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=9))
grid.arrange(p1, p2, p3, p4, ncol=2,nrow=2)
dev.copy(png, file="plot4.png", width=480, height=480)
dev.off()
cat("plot4.png has been saved in", getwd())  


