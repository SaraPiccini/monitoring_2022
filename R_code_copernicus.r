# R code for uploading and visualizing Copernicus data in R
install.packages("ncdf4")
library(ncdf4) #we need this package since data from copernicus are nc
library(raster)
install.packages("viridis")  
library(viridis) 
library(RStoolbox)
library(ggpolt2)
setwd("/Users/sarapiccini/Desktop/lab/copernicus/")
#upload data: single layers data: raster function

DryMatterProd2020 <- raster("c_gls_DMP-RT0_202006300000_GLOBE_PROBAV_V2.0.1.nc")
DryMatterProd2020

plot(DryMatterProd2020)

#use to change colors:
cl <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(DryMatterProd2020, col=cl)
#this is bad since blind people can not see differences 
cl <- colorRampPalette(c("green", "blue", "red"))(100)
plot(DryMatterProd2020, col=cl)
#ggplot function
ggplot() + geom_raster(DryMatterProd2020, mapping = aes(x=x, y=y, fill=Dry.matter.productivity.1KM))  
#geom:geometry we want to use: ex: geom_bar makes histograms, geom_raster for raster images
#fill= layer we are using (names row inside the object:DryMatterProd2020)
#scale_fill_viridis: function to prepare the colors for ggplot2
#use brick function to see how many layers are inside Copernicus data
#ggplot function with viridis
ggplot() + geom_raster(DryMatterProd2020, mapping = aes(x=x, y=y, fill=Dry.matter.productivity.1KM)) + scale_fill_viridis()
#now any blind people can see: yellow is put in the maximum 
#now we can change from viridis to other legend: magma, plasma, inferno cividis..
#let's use cividis
ggplot() + geom_raster(DryMatterProd2020, mapping = aes(x=x, y=y, fill=Dry.matter.productivity.1KM)) + scale_fill_viridis(option="cividis") + ggtitle("cividis palette")
#the default one is sividis and we do not put anything inside the () sinche it is the defaul, we put option "" to choose any different color palette

#download other data from the same folder but different time


