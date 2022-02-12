# R code for my Monitoring Ecosystem Changes and Functioning exam in 2022
# Multi-temporal analysis on vegetation in Indonesia and Papua New Guinea with a focus on deforstation 
# Download data from Copernicus Global Land Service on NDVI and FCOVER 

# Upload all the libraries needed at the beginning - for uploading and visualizing copernicus data in R
library(ncdf4) # for formatting our files - to manage spatial data, read and manipulate them (in nc)
library(raster) # work with raster file (single layer data)
library(ggplot2) # for plots - to ggplot raster layers - create graphics
library(viridis) # palette - color scales
library(patchwork) # for comparing separate ggplots - compose multiple ggplots
library(gridExtra) # for grid.arrange plotting, creating a multiframe with ggplot
library(rgdal) # to open shape file (rgdal packages inside this one)


# Set the working directory
setwd("/Users/sarapiccini/Documents/datandvi")

# Importing is one by one 
FCOVER1999 <- raster("c_FCOVER_199902280000_GLOBE_VGT_V2.0.2.nc")
FCOVER1999

# we can also import multiple files at once that have the same pattern in the name (much faster when we have many files to import)
rlist <- list.files(pattern="c_FCOVER") # listing all the files with the pattern present in the directory
rlist

# to make the list a brick list - apply brick function to all the files (multi-layers)
list_rast <- lapply(rlist, raster) 
list_rast
# creating a stack
FCOVERstack <- stack(list_rast) 
FCOVERstack

# Change variables'names 
names(FCOVERstack) <- c("FCOVER.1km.1","FCOVER.1km.2","FCOVER.1km.3","FCOVER.1km.4","FCOVER.1km.5")
plot(FCOVERstack)

# Crop the image over
ext <-c(90.5, 120, -10, 10)
FCOVERcrop <- crop(FCOVERstack, ext)
plot(FCOVERcrop)
FCOVERcrop

# and then we separate the files, assigning to each element of the crop a name
FCOVER1999 <- FCOVERcrop$FCOVER.1km.1
FCOVER2004 <- FCOVERcrop$FCOVER.1km.2
FCOVER2009 <- FCOVERcrop$FCOVER.1km.3
FCOVER2014 <- FCOVERcrop$FCOVER.1km.4
FCOVER2019 <- FCOVERcrop$FCOVER.1km.5

# Plot them with ggplot
g1 <- ggplot() + geom_raster(FCOVER1999, mapping = aes(x=x, y=y, fill=FCOVER.1km.1)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 1999") + labs(fill = "FCOVER")
g2 <- ggplot() + geom_raster(FCOVER2004, mapping = aes(x=x, y=y, fill=FCOVER.1km.2)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2004") + labs(fill = "FCOVER")
g3 <- ggplot() + geom_raster(FCOVER2009, mapping = aes(x=x, y=y, fill=FCOVER.1km.3)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2009") + labs(fill = "FCOVER")
g4 <- ggplot() + geom_raster(FCOVER2014, mapping = aes(x=x, y=y, fill=FCOVER.1km.4)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2014") + labs(fill = "FCOVER")
g5 <- ggplot() + geom_raster(FCOVER2019, mapping = aes(x=x, y=y, fill=FCOVER.1km.5)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2019") + labs(fill = "FCOVER")

# I have also tried this one: scale_fill_viridis(direction = -1, option = "magma") with the order of colors reversed but it does not work well
# Plot them together (multiframe ggplot) with grid.arrange function (from gridExtra package)
grid.arrange(g1, g2, g3, g4, g5, nrow=3)
#or with patchwork package 
g2 + g1 + g3 / g4 + g5

# Export file
pdf("fcover_ggplot.pdf", width=30, height=20) #migliorare
par(mfrow=c(2,3))
grid.arrange(g1, g2, g3, g4, g5, nrow=3)
dev.off()

# Create a color palette with COLORBREWER 2.0 to plot FCover
class5_YlGn <- colorRampPalette(colors = c('#ffffcc','#c2e699','#78c679','#31a354','#006837'))(100) #da rifare
plot(FCOVERcrop, col=class5_YlGn)

# Plot FCOVER of each year
par(mfrow=c(2,3))
plot(FCOVER1999, main="Forest Cover in 1999", col=class5_YlGn)
plot(FCOVER2004, main="Forest Cover in 2004", col=class5_YlGn)
plot(FCOVER2009, main="Forest Cover in 2009", col=class5_YlGn)
plot(FCOVER2014, main="Forest Cover in 2014", col=class5_YlGn)
plot(FCOVER2019, main="Forest Cover in 2019", col=class5_YlGn)

# Export file
pdf("fcover.pdf", width=40, height=20) 
par(mfrow=c(3,2))
plot(FCOVER1999, main="Forest Cover in 1999", col=class5_YlGn)
plot(FCOVER2004, main="Forest Cover in 2004", col=class5_YlGn)
plot(FCOVER2009, main="Forest Cover in 2009", col=class5_YlGn)
plot(FCOVER2014, main="Forest Cover in 2014", col=class5_YlGn)
plot(FCOVER2019, main="Forest Cover in 2019", col=class5_YlGn)
dev.off()

# Compare fcover between each year with a linear regression model: 
par(mfrow=c(3,4))
plot(FCOVER1999, FCOVER2004, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 1999", ylab="FCOVER 2004")
abline(0,1, col="red")
plot(FCOVER1999, FCOVER2009, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 1999", ylab="FCOVER 2009")
abline(0,1, col="red")
plot(FCOVER1999, FCOVER2014, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 1999", ylab="FCOVER 2014")
abline(0,1, col="red")
plot(FCOVER1999, FCOVER2019, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 1999", ylab="FCOVER 2020")
abline(0,1, col="red")
plot(FCOVER2004, FCOVER2009, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 2004", ylab="FCOVER 2009")
abline(0,1, col="red")
plot(FCOVER2004, FCOVER2014, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 2004", ylab="FCOVER 2014")
abline(0,1, col="red")
plot(FCOVER2004, FCOVER2019, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 2004", ylab="FCOVER 2019")
abline(0,1, col="red")
plot(FCOVER2009, FCOVER2014, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 2009", ylab="FCOVER 2014")
abline(0,1, col="red")
plot(FCOVER2009, FCOVER2019, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 2009", ylab="FCOVER 2019")
abline(0,1, col="red")
plot(FCOVER2014, FCOVER2019, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 2014", ylab="FCOVER 2019")
abline(0,1, col="red")
plot(FCOVER1999, FCOVER2019, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 2014", ylab="FCOVER 2020")
abline(0,1, col="red")

#Export them
pdf("ablineFCOVER.pdf", width=40, height=20) 
par(mfrow=c(3,4))
plot(FCOVER1999, FCOVER2004, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 1999", ylab="FCOVER 2004")
abline(0,1, col="red")
plot(FCOVER1999, FCOVER2009, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 1999", ylab="FCOVER 2009")
abline(0,1, col="red")
plot(FCOVER1999, FCOVER2014, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 1999", ylab="FCOVER 2014")
abline(0,1, col="red")
plot(FCOVER1999, FCOVER2020, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 1999", ylab="FCOVER 2019")
abline(0,1, col="red")
plot(FCOVER2004, FCOVER2009, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 2004", ylab="FCOVER 2009")
abline(0,1, col="red")
plot(FCOVER2004, FCOVER2014, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 2004", ylab="FCOVER 2014")
abline(0,1, col="red")
plot(FCOVER2004, FCOVER2019, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 2004", ylab="FCOVER 2019")
abline(0,1, col="red")
plot(FCOVER2009, FCOVER2014, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 2009", ylab="FCOVER 2014")
abline(0,1, col="red")
plot(FCOVER2009, FCOVER2019, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 2009", ylab="FCOVER 2019")
abline(0,1, col="red")
plot(FCOVER2014, FCOVER2019, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 2014", ylab="FCOVER 2019")
abline(0,1, col="red")
plot(FCOVER1999, FCOVER2019, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 2014", ylab="FCOVER 2019")
abline(0,1, col="red")
dev.off()

# Plot frequency distribution of data: frequecies : how pixels are distributed in each different class - frequencies of each classes
par(mfrow=c(3,2))
hist(FCOVER1999)
hist(FCOVER2004)
hist(FCOVER2009)
hist(FCOVER2014)
hist(FCOVER2019)

#Export them
pdf("histFCOVER.pdf", width=40, height=20) 
par(mfrow=c(3,2))
hist(FCOVER1999)
hist(FCOVER2004)
hist(FCOVER2009)
hist(FCOVER2014)
hist(FCOVER2019)
dev.off()

# Or use pairs function: density plot (histograms), scatterplot, and Pearson coefficient
pairs(FCOVERcrop)

# Plot the difference between 1999 and 2019 - Compute the difference between the layers
dif5 <- FCOVER1999 - FCOVER2019

# I have also tried this one: scale_fill_viridis(direction = -1, option = "magma") with the order of colors reversed but 
# Create a color palette with COLORBREWER 2.0 
# x = 0 -> no changes: colored in white
class3_RdBu <- colorRampPalette(colors = c('#ef8a62','#f7f7f7','#67a9cf'))(100)
plot(dif5, col=class3_RdBu, main = "Difference in Forest Cover between 1999 and 2019")
# x = 0 -> no changes: colored in black
class3_RdBu2 <- colorRampPalette(colors = c('#ef8a62','#636363','#7fbf7b'))(100)
plot(dif5, col=class3_RdBu2, main = "Difference in Forest Cover between 1999 and 2019")

# Plot together
par(mfrow=c(1,2))
plot(dif5, col=class3_RdBu, main = "Difference in Forest Cover between 1999 and 2019")
plot(dif5, col=class3_RdBu2, main = "Difference in Forest Cover between 1999 and 2019")

# Export
pdf("fcoverdif.pdf", width=15, height=10) 
par(mfrow=c(2,3))
plot(dif5, col=class3_RdBu, main = "Difference in Forest Cover between 1999 and 2019")
plot(dif5, col=class3_RdBu2, main = "Difference in Forest Cover between 1999 and 2019")
dev.off()

##### LAI
LAIrlist <- list.files(pattern="LAI") # listing all the files with the pattern present in the directory
LAIrlist
LAI2020 <- brick("c_gls_LAI-RT0_202006300000_GLOBE_PROBAV_V2.0.1.nc")
LAI1999 <- raster("c_gls_LAI_200907310000_GLOBE_VGT_V2.0.1.nc")
LAI1999 <- raster("c_gls_LAI_199908200000_GLOBE_VGT_V2.0.2.nc")

# to make the list a brick list - apply brick function to all the files (multi-layers)
LAIlist_rast <- lapply(LAIrlist, raster) 
LAIlist_rast
# creating a stack
LAIstack <- stack(LAIlist_rast) 
LAIstack
plot(LAIstack)

LAIcrop <- crop(LAIstack, ext)
plot(LAIcrop)
LAIcrop

ggplot() plasma
hist
abline
pairs(LAIcrop)

##### tiff

palmoil <- brick("Palm_oil_plantations.tiff")
palmoil
plotRGB(palmoil, r=1, g=2, b=3, stretch = "lin")

hist(palmoil)

# FCOVER April 2019 in Sarawak - Malaysia

malaysia2019 <- raster("c_gls_FCOVER300_201910100000_GLOBE_PROBAV_V1.0.1.nc")
ext2 <- c(108, 120, -5, 7)
malaysia2019c <- crop(malaysia2019, ext2)
g6 <- ggplot() + geom_raster(malaysia2019c, mapping = aes(x=x, y=y, fill=Fraction.of.green.Vegetation.Cover.333m)) 
+ scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in Malaysia in 2019") + labs(fill = "FCOVER")



##### shp from global forest watch
# https://data.globalforestwatch.org/datasets/gfw::sarawak-oil-palm-concessions/about - April 2019
oilpalm <- readOGR("/Users/sarapiccini/Documents/datandvi/Sarawak_oil_palm_concessions/Sarawak_oil_palm_concessions.shp")
oilpalm
plot(oilpalm)
class()
summary()
foilpalm <- fortify(oilpalm)

gfoilpalm <-ggplot() + geom_polygon(data = foilpalm , aes(x = long, y = lat, group = group), fill="#69b3a2", color="white") + theme_void()

ggoilpalm <- ggplot() + geom_raster(FCOVER2019, mapping = aes(x = x, y = y, fill = FCOVER.1km.5)) + scale_fill_viridis(option="magma") + labs(fill = "FCOVER") +
geom_polygon(data=foilpalm,aes(x=long, y=lat, group=group), fill="#69b3a2",color="white", lwd=0.1) + theme_void() +
ggtitle("Oil Palm Concessions")

# https://data.globalforestwatch.org/datasets/gfw::sarawak-protected-areas/about - April 2019
protectedareas <- readOGR("/Users/sarapiccini/Documents/datandvi/Sarawak_protected_areas/Sarawak_protected_areas.shp")
protectedareas
plot(protectedareas)
class(protectedareas) #SpatialPolygonsDataFrame
summary(protectedareas)
fprotectedareas <- fortify(protectedareas)

gfprotectedareas <- ggplot() + geom_polygon(data = fprotectedareas, aes(x = long, y = lat, group = group), fill="#69b3a2", color="white") + theme_void()

ggprotectedareas <- ggplot() + geom_raster(FCOVER2019, mapping = aes(x = x, y = y, fill = FCOVER.1km.5)) + scale_fill_viridis(option="magma") + labs(fill = "FCOVER") +
geom_polygon(data=fprotectedareas,aes(x=long, y=lat, group=group), fill="#69b3a2",color="white",lwd=0.1) + theme_void() +
ggtitle("Protected Areas")

# Plot together
ggoilpalm + ggprotectedareas

# Export
pdf("OilPalmCrops_ProtectedAreas.pdf", width=20, height=10) 
ggoilpalm + ggprotectedareas
dev.off()

