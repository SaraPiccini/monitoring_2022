# R code for uploading and visualizing Copernicus data in R
install.packages("ncdf4")
library(ncdf4) #we need this package since data from copernicus are nc
library(raster)
install.packages("viridis")  
library(viridis) 
library(RStoolbox)
library(ggplot2)
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

#importing all the data together
rlist <- list.files(pattern="gls")
rlist
list_rast <- lapply(rlist, raster)
list_rast
drymatterstack <- stack(list_rast)
drymatterstack
dmsummer2020 <- drymatterstack$Dry.matter.productivity.1KM.1
dmsummer2020
dmsummer2019 <- drymatterstack$Dry.matter.productivity.1KM.2
dmsummer2019
#ggplot with viridis package: #avoid turbo for color blind people
ggplot() + geom_raster(dmsummer2020, mapping = aes(x=x, y=y, fill=Dry.matter.productivity.1KM.1)) + scale_fill_viridis() + ggtitle("Dry matter productivity during summer 2020")
ggplot() + geom_raster(dmsummer2019, mapping = aes(x=x, y=y, fill=Dry.matter.productivity.1KM.2)) + scale_fill_viridis() + ggtitle("Dry matter productivity during summer 2019")

#let's patchwrok them together
#namethe two ggplot
library (patchwork)
p1 <- ggplot() + geom_raster(dmsummer2020, mapping = aes(x=x, y=y, fill=Dry.matter.productivity.1KM.1)) + scale_fill_viridis() + ggtitle("Dry matter productivity during summer 2020")
p2 <- ggplot() + geom_raster(dmsummer2019, mapping = aes(x=x, y=y, fill=Dry.matter.productivity.1KM.2)) + scale_fill_viridis() + ggtitle("Dry matter productivity during summer 2019")

p1 / p2 #now we have the two ggplot one on top of the other
#how to prop data in our region: use coordinates: range 
#you can crop your image on a certain area:
#in order to zoom in Italy (as in any kind of region) we must see the coordinates: 
#longitude from 0 to 20
#latitude from 30 to 50
#use Crop function:
ext <- c(0, 20, 30, 50)
dmsummer2020_cropped <- crop(dmsummer2020, ext) #name of the file and extention of file we want to crop, now extent has changed
dmsummer2019_cropped <- crop(dmsummer2019, ext)
# stack_cropped <- crop(drymatterstack, ext) this will crop the all stack and than single layers 
dmsummer2020_cropped
dmsummer2019_cropped 


p1 <- ggplot() + geom_raster(dmsummer2020_cropped, mapping = aes(x=x, y=y, fill=Dry.matter.productivity.1KM.1)) + scale_fill_viridis() + ggtitle("Dry matter productivity during summer 2020")
p2 <- ggplot() + geom_raster(dmsummer2019_cropped, mapping = aes(x=x, y=y, fill=Dry.matter.productivity.1KM.2)) + scale_fill_viridis() + ggtitle("Dry matter productivity during summer 2019")
p1 / p2

#reference system




