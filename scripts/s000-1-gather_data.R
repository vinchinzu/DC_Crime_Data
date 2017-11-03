
#Data Downloaded from 
# http://crimemap.dc.gov/CrimeMapSearch.aspx
# IN 8 CSV files according to Wards
# From 01/01/2008 to present
# 

#Other Geographic Area or Point
# Wards (in drop down)
# Ward 1
#Select Date Range (Other) -> From: #FromDate# : To: #ToDate#
#Search
#Download Crime Data
#Text (CSV)
#Check All
#Get Data 

#Add data to ../data file


setwd("scripts")
library(readxl)

file_list <- list.files("../data/")
file_list


setwd("../data")

#COMBINE FILES 
dataset <- NULL
for (file in file_list){
  # if the merged dataset doesn't exist, create it
  if (!exists("dataset")){
    dataset <- read.csv(file, header=TRUE, sep=",")
  }
  # if the merged dataset does exist, append to it
  if (exists("dataset")){
    temp_dataset <-read.csv(file, header=TRUE, sep=",")
    dataset<-rbind(dataset, temp_dataset)
    rm(temp_dataset)
  }
}








