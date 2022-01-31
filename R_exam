library(ncdf4) # import the copernicus file (in nc)
library(raster) # work with raster file (single layer data)
library(viridis) # plot the color palette
library(RStoolbox) # useful for remote sensing image processing (make classification)
library(ggplot2) # create graphics - ggplot function
library(gridExtra) # for multiframe ggplot
library(patchwork) # multiframe graphics
library(rgdal) # to open shape file
library(greenbrown) # to use brown green colors function that provides a color scale from brown to green and can be used to plot NDVI trend maps.
#Positive trends in Normalized Difference Vegetation Index are called 'greening' whereas negative trends are called 'browning
#How to install it: install.packages("greenbrown2.tar", repos = NULL, type="source")
#NOT ABLE TO INSTALL IT

#set the working directory
setwd("/Users/sarapiccini/Documents/datandvi")


#### NDVI #####
#import data together 
NDVI <- list.files(pattern="NDVI")
NDVI
#"c_gls_NDVI_199906110000_GLOBE_VGT_V2.2.1.nc"   
#"c_gls_NDVI_202006110000_GLOBE_PROBAV_V2.2.1.nc"

# apply raster function to all the files
NDVIr <- lapply(NDVI, raster)
NDVIr

NDVIstack <- stack(NDVIr)
plot(NDVIstack)
#cl <- brgr.colors(15)
#plot(NDVIstack, col=cl)

ext <- c(-20, 60, -80, 40)
NDVIcrop <- crop(NDVIstack, ext)
plot(NDVIcrop)
NDVIcrop

june1999 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1KM.1
june2020 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1KM.2

g1 <- ggplot() + geom_raster(data= june1999, mapping = aes(x=x, y=y, fill= Normalized.Difference.Vegetation.Index.1KM.1)) + scale_fill_viridis(option = "magma") + ggtitle("june1999")
g2 <- ggplot() + geom_raster(data= june2020, mapping = aes(x=x, y=y, fill= Normalized.Difference.Vegetation.Index.1KM.2)) + scale_fill_viridis(option = "magma") + ggtitle("june2020")

g1/g2

NDVIdif<-june2020-june1999 #PROBLEMS
plot(NDVIdif)
par(mfrow=c(2,2))
plot(june1999)
plot(june2020)
plot(NDVIdif)

cl= colorRampPalette(c("white", "brown", "blue", "light green", "dark green"))(100)
plot(NDVIdif, col =cl)

#### FCOVER #######

FCOVER <- list.files(pattern="FCOVER")
FCOVER

#"c_gls_FCOVER_199905200000_GLOBE_VGT_V2.0.2.nc"       
#"c_gls_FCOVER-RT1_202006200000_GLOBE_PROBAV_V2.0.1.nc"

FCOVERr <- lapply(FCOVER, raster)
FCOVERr

FCOVERstack <- stack(FCOVERr)
plot(FCOVERstack)

ext <- c(-20, 60, -80, 40)
FCOVERcrop <- crop(FCOVERstack, ext)
plot(FCOVERcrop)
FCOVERcrop

FCjune1999 <- FCOVERcrop$Fraction.of.green.Vegetation.Cover.1km.1
FCjune2020 <- FCOVERcrop$Fraction.of.green.Vegetation.Cover.1km.2

g1FC <- ggplot() + geom_raster(data= FCjune1999, mapping = aes(x=x, y=y, fill= Fraction.of.green.Vegetation.Cover.1km.1)) + scale_fill_viridis(option="magma") + ggtitle("FCjune1999")
g2FC <- ggplot() + geom_raster(data= FCjune2020, mapping = aes(x=x, y=y, fill= Fraction.of.green.Vegetation.Cover.1km.2)) + scale_fill_viridis(option="magma") + ggtitle("FCjune2020")

g1FC/g2FC

FCdif<-FCjune2020-FCjune1999
plot(FCdif)

par(mfrow=c(2,2))
plot(FCjune1999)
plot(FCjune2020)
plot(FCdif)

##### SWI ######
SWI <- list.files(pattern="SWI")
SWI

SWIr <- lapply(SWI, raster)
SWIr

SWIstack <- stack(SWIr)
cl<- colorRampPalette(c("black","darkblue","blue","lightblue","white"))(100)
plot(SWIstack, col=cl)

SWIcrop <- crop(SWIstack, ext)
plot(SWIcrop, col=cl)
SWIcrop

SWIjune2007 <- SWIcrop$Soil.Water.Index.with.T.5.1
SWIjune2020 <- SWIcrop$Soil.Water.Index.with.T.5.2

g1SWI <- ggplot() + geom_raster(data= SWIjune2007, mapping = aes(x=x, y=y, fill= Soil.Water.Index.with.T.5.1)) + scale_fill_viridis() + ggtitle("SWIjune2007")
g2SWI <- ggplot() + geom_raster(data= SWIjune2020, mapping = aes(x=x, y=y, fill= Soil.Water.Index.with.T.5.2)) + scale_fill_viridis() + ggtitle("SWIjune2020")

g1SWI/g2SWI

SWIdifcl<-colorRampPalette(c("darkblue","yellow","red","black"))(100) #create the color ramp palette
SWIdif<-SWIjune2007-SWIjune2020 #make the difference
plot(SWIdif, col=SWIdifcl) #plotting the images

par(mfrow=c(1,2))
hist(SWIjune2007)
hist(SWIjune2020)



### roba bruttta  ####

LC2000 <- raster("U2018_CLC2018_V2020_20u1.tif")
points <- SpatialPoints(coords, proj4string =CRS("+proj=longlat +datum=WGS84"))
pp <- spTransform(points, "EPSG:3035")
lats <- c(U2018_CLC2018_V2020_20u1.tif$lat_0=52)
lons <- c(U2018_CLC2018_V2020_20u1.tif$lon_0=10) 

install.packages("sp")



#### LC ######

#io farei africa centrale

LC2001 <- brick("LAND2001.jpg")
plotRGB(LC2001, r=1, g=2, b=3, stretch="lin")
ggRGB(LC2001, r=1, g=2, b=3, stretch="lin")
ext <- c(380, 450, 140, 200)
LC2001crop <- crop(LC2001, ext)
ggRGB(LC2001crop, r=1, g=2, b=3, stretch="lin")

LC2011 <- brick("LAND2011.jpg")
plotRGB(LC2011, r=1, g=2, b=3, stretch="lin")
ggRGB(LC2011, r=1, g=2, b=3, stretch="lin")
LC2011crop <- crop(LC2011, ext)
ggRGB(LC2011crop, r=1, g=2, b=3, stretch="lin")

par(mfrow=c(1,2))
plotRGB(LC2001crop, r=1, g=2, b=3, stretch="lin")
plotRGB(LC2011crop, r=1, g=2, b=3, stretch="lin")

# multiframe with ggplot2 and gridExtra
p1 <- ggRGB(LC2001crop, r=1, g=2, b=3, stretch="lin")
p2 <- ggRGB(LC2001crop, r=1, g=2, b=3, stretch="lin")
grid.arrange(p1, p2, nrow=2)

# unsupervised classification
lc2001c <- unsuperClass(LC2001crop, nClasses=4)
plot(lc2001c$map)
# class 1: forest
# class 2: woody savanna
# class 3: savanna
# class 4: water

# set.seed() would allow you to attain the same results ...

lc2011c <- unsuperClass(LC2011crop, nClasses=4)
plot(lc2011c$map)

par(mfrow=c(1,2))
plot(lc2001c$map)
plot(lc2011c$map)

# frequencies
freq(lc2001c$map)
#      value count
#[1,]     1  855
#[2,]     2  1642
#[3,]     3  1035
#[4,]     4  668

s1 <- 855 + 1642 + 1035 + 668

prop2001 <- freq(lc2001c$map) / s1
prop2001
#prop forest : 20.36%
#prop woody savanna : 39.09%
#prop savanna : 24.64%
#prop sea : 15.90 %

freq(lc2011c$map)
#     value count
#[1,]     1  1122
#[2,]     2   592
#[3,]     3  1532
#[4,]     4   754
s2 <- 1122 + 592 + 1532 + 754
prop2011 <- freq(lc2011c$map) / s2
prop2011
#prop savannas : 28.05%
#prop woody forest : 38.30%
#prop forest : 18.85%
#prop sea : 14.80%


# build a dataframe
cover <- c("Savannas", "Woody Savanna", "Forest", "Water")
percent_2001 <- c(24.64, 39.09, 20.36, 15.90)
percent_2011 <- c(28.05, 38.30, 18.85, 14.80)
percent_2001
percent_2011 
percentages <- data.frame(cover, percent_2001, percent_2011)
percentages

# let's plot them!
ggplot(percentages, aes(x=cover, y=percent_2001, color=cover)) + geom_bar(stat="identity", fill="white")
ggplot(percentages, aes(x=cover, y=percent_2011, color=cover)) + geom_bar(stat="identity", fill="white")

p1 <- ggplot(percentages, aes(x=cover, y=percent_2001, color=cover)) + geom_bar(stat="identity", fill="white")
p2 <- ggplot(percentages, aes(x=cover, y=percent_2011, color=cover)) + geom_bar(stat="identity", fill="white")

grid.arrange(p1, p2, nrow=1)


#### brazil 
# class 1: savannas
# class 2: forest
# class 3: grasslands
# class 4: sea

# value count
#[1,]     1  1339
#[2,]     2  2336
#[3,]     3   878
#[4,]     4  3847
s1 <- 1339 + 2336 + 878 + 3847

#prop savannas : 15.94%
#prop forest : 27.80%
#prop grasslands : 10.54%
#prop sea : 45.79 %

# value count
#[1,]     1   785
#[2,]     2  2636
#[3,]     3   435
#[4,]     4  2144


s2 <- 785 + 2636 + 435 + 2144

#prop savannas : 13.08%
#prop forest :  35.73%
#prop grasslands : 7.25%
#prop sea : 43.93 %

cover <- c("Savannas", "Forest", "Grasslands", "Sea")
percent_2001 <- c(15.94, 27.80, 10.54, 45.79)
percent_2011 <- c(13.08, 35.73, 7.25, 43.93)
percent_2001
percent_2011 
percentages <- data.frame(cover, percent_2001, percent_2011)
percentages



#### NDVI ####

NDVI2007 <- brick("NDVJune2007.jpeg")
plotRGB(LC2001, r=1, g=2, b=3, stretch="lin")
ggRGB(LC2001, r=1, g=2, b=3, stretch="lin")
ext <- c(380, 450, 140, 200)
NDVI2007crop <- crop(NDVI2007, ext)
ggRGB(NDVI2007crop, r=1, g=2, b=3, stretch="lin")

NDVI2020 <- brick("NDVjun2020.jpeg")
plotRGB(NDVI2020, r=1, g=2, b=3, stretch="lin")
ggRGB(NDVI2020, r=1, g=2, b=3, stretch="lin")
NDVI2020crop <- crop(NDVI2020, ext)
ggRGB(NDVI2020crop, r=1, g=2, b=3, stretch="lin")

par(mfrow=c(1,2))
plotRGB(NDVI2007crop, r=1, g=2, b=3, stretch="lin")
plotRGB(NDVI2020crop, r=1, g=2, b=3, stretch="lin")

# multiframe with ggplot2 and gridExtra
p1 <- ggRGB(NDVI2007crop, r=1, g=2, b=3, stretch="lin")
p2 <- ggRGB(NDVI2020crop, r=1, g=2, b=3, stretch="lin")
grid.arrange(p1, p2, nrow=2)

# unsupervised classification
NDVI2007c <- unsuperClass(NDVI2007crop, nClasses=4)
plot(NDVI2007c$map)
# class 1: forest
# class 2: woody savanna
# class 3: savanna
# class 4: water

# set.seed() would allow you to attain the same results ...

NDVI2020c <- unsuperClass(NDVI2020crop, nClasses=4)
plot(NDVI2020c$map)

par(mfrow=c(1,2))
plot(NDVI2007c$map)
plot(NDVI2020c$map)

# frequencies
freq(lc2001c$map)
#      value count
#[1,]     1  855
#[2,]     2  1642
#[3,]     3  1035
#[4,]     4  668

s1 <- 855 + 1642 + 1035 + 668

prop2001 <- freq(lc2001c$map) / s1
prop2001
#prop forest : 20.36%
#prop woody savanna : 39.09%
#prop savanna : 24.64%
#prop sea : 15.90 %

freq(lc2011c$map)
#     value count
#[1,]     1  1122
#[2,]     2   592
#[3,]     3  1532
#[4,]     4   754
s2 <- 1122 + 592 + 1532 + 754
prop2011 <- freq(lc2011c$map) / s2
prop2011
#prop savannas : 28.05%
#prop woody forest : 38.30%
#prop forest : 18.85%
#prop sea : 14.80%


# build a dataframe
cover <- c("Savannas", "Woody Savanna", "Forest", "Water")
percent_2001 <- c(24.64, 39.09, 20.36, 15.90)
percent_2011 <- c(28.05, 38.30, 18.85, 14.80)
percent_2001
percent_2011 
percentages <- data.frame(cover, percent_2001, percent_2011)
percentages

# let's plot them!
ggplot(percentages, aes(x=cover, y=percent_2001, color=cover)) + geom_bar(stat="identity", fill="white")
ggplot(percentages, aes(x=cover, y=percent_2011, color=cover)) + geom_bar(stat="identity", fill="white")

p1 <- ggplot(percentages, aes(x=cover, y=percent_2001, color=cover)) + geom_bar(stat="identity", fill="white")
p2 <- ggplot(percentages, aes(x=cover, y=percent_2011, color=cover)) + geom_bar(stat="identity", fill="white")

grid.arrange(p1, p2, nrow=1)



#### lansat 4-5 hub - apps.sentinel-hub.com ####

l2010 <- brick("2010-07-31-00_00_2010-07-31-23_59_Landsat_4-5_TM_L1_False_color-2.jpg")
plotRGB(l2010, r=1, g=2, b=3, stretch="lin")
ggRGB(l2010, r=1, g=2, b=3, stretch="lin")


l1988 <- brick("1988-07-02-00_00_1988-07-02-23_59_Landsat_4-5_TM_L1_False_color-2.jpg")
plotRGB(l1988, r=1, g=2, b=3, stretch="lin")
ggRGB(l1988, r=1, g=2, b=3, stretch="lin")


par(mfrow=c(1,2))
plotRGB(l1988, r=1, g=2, b=3, stretch="lin")
plotRGB(l2010, r=1, g=2, b=3, stretch="lin")

# multiframe with ggplot2 and gridExtra
p1 <- ggRGB(l1988, r=1, g=2, b=3, stretch="lin")
p2 <- ggRGB(l2010, r=1, g=2, b=3, stretch="lin")
grid.arrange(p1, p2, nrow=2)

# unsupervised classification
l1988c <- unsuperClass(l1988, nClasses=3)
plot(l1988c$map)
# class 1: agriculture
# class 2: forest


l2010c <- unsuperClass(l2010, nClasses=3)
plot(l2010c$map)

# set.seed() would allow you to attain the same results ...

par(mfrow=c(1,2))
plot(l1988c$map)
plot(l2010c$map)

# frequencies
freq(lc2001c$map)
#      value count
#[1,]     1  855
#[2,]     2  1642
#[3,]     3  1035
#[4,]     4  668

s1 <- 855 + 1642 + 1035 + 668

prop2001 <- freq(lc2001c$map) / s1
prop2001
#prop forest : 20.36%
#prop woody savanna : 39.09%
#prop savanna : 24.64%
#prop sea : 15.90 %

freq(lc2011c$map)
#     value count
#[1,]     1  1122
#[2,]     2   592
#[3,]     3  1532
#[4,]     4   754
s2 <- 1122 + 592 + 1532 + 754
prop2011 <- freq(lc2011c$map) / s2
prop2011
#prop savannas : 28.05%
#prop woody forest : 38.30%
#prop forest : 18.85%
#prop sea : 14.80%


# build a dataframe
cover <- c("Savannas", "Woody Savanna", "Forest", "Water")
percent_2001 <- c(24.64, 39.09, 20.36, 15.90)
percent_2011 <- c(28.05, 38.30, 18.85, 14.80)
percent_2001
percent_2011 
percentages <- data.frame(cover, percent_2001, percent_2011)
percentages

# let's plot them!
ggplot(percentages, aes(x=cover, y=percent_2001, color=cover)) + geom_bar(stat="identity", fill="white")
ggplot(percentages, aes(x=cover, y=percent_2011, color=cover)) + geom_bar(stat="identity", fill="white")

p1 <- ggplot(percentages, aes(x=cover, y=percent_2001, color=cover)) + geom_bar(stat="identity", fill="white")
p2 <- ggplot(percentages, aes(x=cover, y=percent_2011, color=cover)) + geom_bar(stat="identity", fill="white")

grid.arrange(p1, p2, nrow=1)




