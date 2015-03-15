
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

#Creating the Plot 3 and saving in current working directory  
datafileSubsetC<- melt(datafileSubsetA, id.vars=c(1:6,10))
ggplot(datafileSubsetC, aes(x=B, y=value, color=variable))+ geom_line()+xlab("")+ylab("Energy Sub Metering") + scale_colour_manual(values=c("black", "red", "blue"), name=" ") +theme(legend.text = element_text(colour="black", size = 12))+theme(legend.position=c(.83, .905))+theme(legend.key.size = unit(1, "cm"))
dev.copy(png, file="plot3.png", width=480, height=480)
dev.off()
cat("plot3.png has been saved in", getwd())  

