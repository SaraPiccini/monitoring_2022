# install and import all the library 
# install.packages("ncdf4")
# install.packages("raster")
# install.packages("viridis")
# install.packages("RStoolbox")
# install.packages("ggplot2")
# install.packages("patchwork")
# install.packages("rgdal")
# library("gridExtra")
library(ncdf4) # import the copernicus file (in nc)
library(raster) # work with raster file (single layer data)
library(viridis) # plot the color palette
library(RStoolbox) # useful for remote sensing image processing (make classification)
library(ggplot2) # create graphics - ggplot function
library(gridExtra) # for multiframe ggplot
library(patchwork) # multiframe graphics
library(rgdal) # to open shape file

#set the working directory
setwd("/Users/sarapiccini/Documents/datasnow")


#### SCE COPERNICUS ####

#import data together 
SCE <- list.files(pattern="SCE")
SCE
# apply raster function to all the files
snowraster <- lapply(SCE, raster)

#snow18 <- plot(snowraster[[1]])
#snow19 <- plot(snowraster[[2]])
#snow20 <- plot(snowraster[[3]])
#snow21 <- plot(snowraster[[4]])

snowstack <- stack(snowraster)
plot(snowstack)
cl <- colorRampPalette(c("blue","light blue","pink","red"))(100)
plot(snowstack, col=cl)

ext <- c(50, 150, 50, 80)
SNOWc <- crop(snowstack, ext1)
plot(SNOWc, col=cl)
SNOWc

jan2018 <- SNOWc$Snow.Cover.Extent.1
jan2019 <- SNOWc$Snow.Cover.Extent.2
jan2020 <- SNOWc$Snow.Cover.Extent.3
jan2021 <- SNOWc$Snow.Cover.Extent.4

g1 <- ggplot() + geom_raster( data= jan2018, mapping = aes(x=x, y=y, fill= Snow.Cover.Extent.1)) + scale_fill_viridis(option = "mako") + ggtitle("2018")
g2 <- ggplot() + geom_raster( data= jan2019, mapping = aes(x=x, y=y, fill= Snow.Cover.Extent.2)) + scale_fill_viridis(option = "mako") + ggtitle("2019")
g3 <- ggplot() + geom_raster( data= jan2020, mapping = aes(x=x, y=y, fill= Snow.Cover.Extent.3)) + scale_fill_viridis(option = "mako") + ggtitle("2020")
g4 <- ggplot() + geom_raster( data= jan2021, mapping = aes(x=x, y=y, fill= Snow.Cover.Extent.4)) + scale_fill_viridis(option = "mako") + ggtitle("2021")

g1 + g2 + g3 + g4

#### LST ####

LST <- list.files(pattern="LST")
LST

Traster <- lapply(LST, raster)

temp <- stack(Traster)
plot(temp)

ext1 <- c(5, 17, 42, 48)
tempc <- crop(temp, ext1)
plot(tempc)

clt <- colorRampPalette(c("yellow","pink","red","dark red"))(100)
plot(tempc, col=clt)

temp <- stack(Traster)
plot(temp)

#### SC MODIS #####

#snow cover using modis data
SNOW <- list.files(pattern="Render")
SNOWC <- lapply(SNOW, brick)

names(SNOWC) <- c("summer2001","summer2021","winter2001","winter2021")
SNOWC
#layers = 3

summer2001 <- ggRGB(SNOWC$summer2001, r=1, g=2, b=3, stretch="lin")
winter2001 <- ggRGB(SNOWC$winter2001, r=1, g=2, b=3, stretch="lin")
summer2021 <- ggRGB(SNOWC$summer2021, r=1, g=2, b=3, stretch="lin")
winter2021 <- ggRGB(SNOWC$winter2021, r=1, g=2, b=3, stretch="lin")

grid.arrange(winter2001, summer2001, winter2021, summer2021, nrow=2)

SNOWCc2001s <- unsuperClass(SNOWC$summer2001, nClasses=2)
plot(SNOWCc2001s$map)
#class1: no snow
#class2: snow
# set.seed() would allow you to attain the same results 

SNOWCc2001w <- unsuperClass(SNOWC$winter2001, nClasses=2)
plot(SNOWCc2001w$map)

SNOWCc2021s <- unsuperClass(SNOWC$summer2021, nClasses=2)
plot(SNOWCc2021s$map)

SNOWCc2021w <- unsuperClass(SNOWC$winter2021, nClasses=2)
plot(SNOWCc2021w$map)

freq(SNOWCc2001s$map)
#     value  count
#[1,]     1 229427
#[2,]     2  29773
s1 <- 229427 + 29773
props2001 <- freq(SNOWCc2001s$map) / s1
props2001
#            value    count
#[1,] 3.858025e-06 0.885135
#[2,] 7.716049e-06 0.114865

freq(SNOWCc2001w$map)
#[1,]     1  53138
#[2,]     2  206062
s2 <- 53138 + 206062
propw2001 <- freq(SNOWCc2001w$map) / s2
propw2001
# value     count
#[1,] 3.858025e-06 0.7949923
#[2,] 7.716049e-06 0.2050077

freq(SNOWCc2021s$map)
#value  count
#[1,]     1 229007
#[2,]     2  30193
s3 <- 229007 + 30193
props2021 <- freq(SNOWCc2021s$map) / s3
props2021
#    value     count
#[1,] 3.858025e-06 0.1164853
#[2,] 7.716049e-06 0.8835147

freq(SNOWCc2021w$map)
# value  count
#[1,]     1 206800
#[2,]     2  52400
s4 <- 206800 + 52400
propw2021 <- freq(SNOWCc2021w$map) / s4
propw2021
#  value     count
#[1,] 3.858025e-06 0.7978395
#[2,] 7.716049e-06 0.2021605

#build a dataframe
cover <- c("no snow", "snow")
props2001 <- c(8851, 1148)
propw2001 <- c(7949, 2050)
props2021 <- c(8835, 1164) 
propw2021 <- c(7978, 2021)
percentages <- data.frame(cover, props2001, propw2001, props2021, propw2021)
percentages

ggplot(percentages, aes(x=cover, y=props2001, color=cover)) + geom_bar(stat="identity", fill="white")
ggplot(percentages, aes(x=cover, y=propw2001, color=cover)) + geom_bar(stat="identity", fill="white")
ggplot(percentages, aes(x=cover, y=props2021, color=cover)) + geom_bar(stat="identity", fill="white")
ggplot(percentages, aes(x=cover, y=propw2021, color=cover)) + geom_bar(stat="identity", fill="white")

p1 <- ggplot(percentages, aes(x=cover, y=props2001, color=cover)) + geom_bar(stat="identity", fill="white")
p2 <- ggplot(percentages, aes(x=cover, y=propw2001, color=cover)) + geom_bar(stat="identity", fill="white")
p3 <- ggplot(percentages, aes(x=cover, y=props2021, color=cover)) + geom_bar(stat="identity", fill="white")
p4 <- ggplot(percentages, aes(x=cover, y=propw2021, color=cover)) + geom_bar(stat="identity", fill="white")

grid.arrange(p1, p2, p3, p4, nrow=2)




