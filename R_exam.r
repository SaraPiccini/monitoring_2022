# R code for my Monitoring Ecosystem Changes and Functioning exam 
# Multi-temporal analysis on vegetation in a parto of Indonesia and Borneo lowland rain forests, Malaysia, with a focus on Oil Palm plantations and Protected Areas in Sarawak (Malaysia)

# Install all the packages needed  
#install.packages("ncdf4")
#install.packages("raster")
#install.packages("ggplot2")
#install.packages("viridis")
#install.packages("patchwork")
#install.packages("gridExtra")
#install.packages("rgdal")

# Upload all the libraries needed at the beginning 
library(ncdf4) # for formatting our files - to manage spatial data, read and manipulate them (in nc)
library(raster) # work with raster file (single layer data)
library(ggplot2) # for plots - to ggplot raster layers - create graphics
library(viridis) # palette - color scales
library(patchwork) # for comparing separate ggplots, building a multiframe 
library(gridExtra) # for grid.arrange plotting, creating a multiframe  
library(rgdal) # to open shape file 

# Set the working directory
setwd("/Users/sarapiccini/Documents/dataexam/")

# Download data from Copernicus Global Land Service on Fraction of green vegetation Cover (1km V2) - spatial extent of vegetation, independent from illumination direction

# Importing one by one or
FCOVER1999 <- raster("c_FCOVER-RT6_201907200000_GLOBE_PROBAV_V2.0.1.nc")
FCOVER1999

# Import multiple files at once that have the same pattern in the name (much faster when we have many files to import)
rlist <- list.files(pattern="c_FCOVER") # listing all the files with the pattern present in the directory
rlist

# Make the list a raster list - apply raster function to all the files to create raster layer objects
list_rast <- lapply(rlist, raster) 
list_rast

# Create a stack
FCOVERstack <- stack(list_rast) 
FCOVERstack

# Change variables'names 
names(FCOVERstack) <- c("FCOVER.1km.1","FCOVER.1km.2","FCOVER.1km.3","FCOVER.1km.4","FCOVER.1km.5")
plot(FCOVERstack)

# Crop over Indonesia
ext <-c(90.5, 120, -10, 10)
ext <-c(90.5, 130, -10, 1)
FCOVERcrop <- crop(FCOVERstack, ext)
plot(FCOVERcrop) # To see if I have cropped the images well
FCOVERcrop

# Separate files, assigning to each element of the crop a name
FCOVER1999 <- FCOVERcrop$FCOVER.1km.1
FCOVER2004 <- FCOVERcrop$FCOVER.1km.2
FCOVER2009 <- FCOVERcrop$FCOVER.1km.3
FCOVER2014 <- FCOVERcrop$FCOVER.1km.4
FCOVER2019 <- FCOVERcrop$FCOVER.1km.5

# Convert raster into data frames to ggplot them - coercing them
FCOVER1999_df <- as.data.frame(FCOVER1999, xy=TRUE) 
FCOVER2004_df <- as.data.frame(FCOVER2004, xy=TRUE) 
FCOVER2009_df <- as.data.frame(FCOVER2009, xy=TRUE) 
FCOVER2014_df <- as.data.frame(FCOVER2014, xy=TRUE) 
FCOVER2019_df <- as.data.frame(FCOVER2019, xy=TRUE) 

# Plot them with ggplot
g1 <- ggplot() + geom_raster(FCOVER1999_df, mapping = aes(x=x, y=y, fill=FCOVER.1km.1)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 1999") + labs(fill = "FCOVER")
g2 <- ggplot() + geom_raster(FCOVER2004_df, mapping = aes(x=x, y=y, fill=FCOVER.1km.2)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2004") + labs(fill = "FCOVER")
g3 <- ggplot() + geom_raster(FCOVER2009_df, mapping = aes(x=x, y=y, fill=FCOVER.1km.3)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2009") + labs(fill = "FCOVER")
g4 <- ggplot() + geom_raster(FCOVER2014_df, mapping = aes(x=x, y=y, fill=FCOVER.1km.4)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2014") + labs(fill = "FCOVER")
g5 <- ggplot() + geom_raster(FCOVER2019_df, mapping = aes(x=x, y=y, fill=FCOVER.1km.5)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2019") + labs(fill = "FCOVER")

# I have also tried this one: scale_fill_viridis(direction = -1, option = "magma") with the order of colors reversed but it does not work well
# Plot them together (multiframe ggplot) with grid.arrange function (from gridExtra package)
grid.arrange(g1, g2, g3, g4, g5, nrow=3)
#or through patchwork package 
g2 + g1 + g3 / g4 + g5

# Export file
png("outputs/fcover_ggplot.png", res = 300, width = 3000, heigh = 2000)
grid.arrange(g1, g2, g3, g4, g5, nrow=3)
dev.off()

# Create a color palette with COLORBREWER 2.0 to plot FCover
cl1 <- colorRampPalette(colors = c('#edf8fb','#b2e2e2','#66c2a4','#2ca25f','#006d2c'))(100) 
plot(FCOVERcrop, col=cl1)

# Plot FCOVER of each year
par(mfrow=c(2,3))
plot(FCOVER1999, main="Forest Cover in 1999", col=cl1)
plot(FCOVER2004, main="Forest Cover in 2004", col=cl1)
plot(FCOVER2009, main="Forest Cover in 2009", col=cl1)
plot(FCOVER2014, main="Forest Cover in 2014", col=cl1)
plot(FCOVER2019, main="Forest Cover in 2019", col=cl1)

# Export file
png("outputs/fcover.png", res = 300, width = 3000, heigh = 2000)
par(mfrow=c(3,2))
plot(FCOVER1999, main="Forest Cover in 1999", col=cl1)
plot(FCOVER2004, main="Forest Cover in 2004", col=cl1)
plot(FCOVER2009, main="Forest Cover in 2009", col=cl1)
plot(FCOVER2014, main="Forest Cover in 2014", col=cl1)
plot(FCOVER2019, main="Forest Cover in 2019", col=cl1)
dev.off()

# Compare fcover between each year with a linear regression model (scatterplot): 
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
png("outputs/ablineFCOVER.png", res = 300, width = 3000, heigh = 2000)
par(mfrow=c(3,4))
plot(FCOVER1999, FCOVER2004, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 1999", ylab="FCOVER 2004")
abline(0,1, col="red")
plot(FCOVER1999, FCOVER2009, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 1999", ylab="FCOVER 2009")
abline(0,1, col="red")
plot(FCOVER1999, FCOVER2014, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 1999", ylab="FCOVER 2014")
abline(0,1, col="red")
plot(FCOVER1999, FCOVER2019, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 1999", ylab="FCOVER 2019")
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

# Plot frequency distribution of data with histograms 
par(mfrow=c(3,2))
hist(FCOVER1999)
hist(FCOVER2004)
hist(FCOVER2009)
hist(FCOVER2014)
hist(FCOVER2019)

#Export them
png("outputs/histFCOVER.png", res = 300, width = 3000, heigh = 2000)
par(mfrow=c(3,2))
hist(FCOVER1999)
hist(FCOVER2004)
hist(FCOVER2009)
hist(FCOVER2014)
hist(FCOVER2019)
dev.off()

# Or use pairs function (pairs plot): matrix of scatterplots
pairs(FCOVERcrop)

# Plot the difference between 1999 and 2019 - Compute the difference between the layers
dif <- FCOVER1999 - FCOVER2019

# I have also tried this one: scale_fill_viridis(direction = -1, option = "magma") with the order of colors reversed but 

# Create two color palettes with COLORBREWER 2.0 
# x = 0 -> no changes
cl2 <- colorRampPalette(colors = c('#ca0020','#f7f7f7','#008837'))(100) 
plot(dif, col=cl2, main = "Difference in Fraction of vegetation Cover between 1999 and 2019")
# x = 0 -> no changes
cl3 <- colorRampPalette(colors = c('#ca0020','#f4a582','#636363','#a6dba0','#008837'))(100)
plot(dif, col=cl3, main = "Difference in Fraction of vegetation Cover between 1999 and 2019")

# Create another color palettes with the amount of forest loss in yellow because this color catches our eyes more than the other colors
cl5 <- colorRampPalette(colors = c('darkblue','yelloW','red','black'))(100)
plot(dif, col=cl5, main = "Difference in Fraction of vegetation Cover between 1999 and 2019")

# Plot together
par(mfrow=c(2,2))
plot(dif, col=cl2, main = "Difference in Fraction of vegetation Cover between 1999 and 2019")
plot(dif, col=cl3, main = "Difference in Fraction of vegetation Cover between 1999 and 2019")
plot(dif, col=cl5, main = "Difference in Fraction of vegetation Cover between 1999 and 2019")

# Export
png("outputs/fcoverdif.png", res = 300, width = 4000, heigh = 4000)
par(mfrow=c(2,2))
plot(dif, col=cl2, main = "Difference of the Fraction of vegetation cover between 1999 and 2019")
plot(dif, col=cl3, main = "Difference of the Fraction of vegetation cover between 1999 and 2019")
plot(dif, col=cl5, main = "Difference in Fraction of vegetation Cover between 1999 and 2019")
dev.off()


# Download data from Copernicus Global Land Service on Leaf Area Index (1km V2) that quantifies the thickness of the vegetation cover

# I repeated the same processes as before with LAI data
LAIlist <- list.files(pattern="LAI") # listing all the files with the pattern present in the directory
LAIlist
# Apply raster function to all the files
LAIlist_rast <- lapply(LAIlist, raster) 
LAIlist_rast
# Create a stack
LAIstack <- stack(LAIlist_rast) 
LAIstack
# Change variables'names 
names(LAIstack) <- c("LAI.1km.1","LAI.1km.2","LAI.1km.3")
# Crop over Indonesia
LAIcrop <- crop(LAIstack, ext)
plot(LAIcrop)
LAIcrop
# Separate files, assigning to each element of the crop a name
LAI1999 <- LAIcrop$LAI.1km.1
LAI2009 <- LAIcrop$LAI.1km.2
LAI2020 <- LAIcrop$LAI.1km.3
# Convert raster into data frames to ggplot them
LAI1999_df <- as.data.frame(LAI1999, xy=TRUE) 
LAI2009_df <- as.data.frame(LAI2009, xy=TRUE) 
LAI2020_df <- as.data.frame(LAI2020, xy=TRUE) 

# Plot them with ggplot
p1 <- ggplot() + geom_raster(LAI1999_df, mapping = aes(x=x, y=y, fill=LAI.1km.1)) + scale_fill_viridis(option = "plasma") + ggtitle("Leaf Area Index in 1999") + labs(fill = "LAI")
p2 <- ggplot() + geom_raster(LAI2009_df, mapping = aes(x=x, y=y, fill=LAI.1km.2)) + scale_fill_viridis(option = "plasma") + ggtitle("Leaf Area Index in 2009") + labs(fill = "LAI")
p3 <- ggplot() + geom_raster(LAI2020_df, mapping = aes(x=x, y=y, fill=LAI.1km.3)) + scale_fill_viridis(option = "plasma") + ggtitle("Leaf Area Index in 2020") + labs(fill = "LAI")

# Plot them together
p1 + p2 + p3
# Export file
png("outputs/lai_ggplot.png", res = 300, width = 7000, heigh = 2000)
p1 + p2 + p3
dev.off()

# Plot the difference between 1999 and 2020:
difLAI<- LAI1999 - LAI2020

# Create a color palette with COLORBREWER 2.0 
cl4 <- colorRampPalette(colors = c('#ca0020','#f4a582','#f7f7f7','#a6dba0','#008837'))(100)

# Plot the difference with 3 different color palettes
par(mfrow=c(2,1))
plot(difLAI, col=cl4, main = "Difference in LAI between 1999 and 2020")
plot(difLAI, col=cl3, main = "Difference in LAI between 1999 and 2020")
plot(difLAI, col=cl5, main = "Difference in LAI between 1999 and 2020")

# Export file
png("outputs/difLAI.png", res = 300, width = 4000, heigh = 2500)
par(mfrow=c(2,2))
plot(difLAI, col=cl4, main = "Difference in LAI between 1999 and 2020")
plot(difLAI, col=cl3, main = "Difference in LAI between 1999 and 2020")
plot(difLAI, col=cl5, main = "Difference in LAI between 1999 and 2020")
dev.off()

# Plot scatterplots, histograms and Pearson correlation coefficient of LAI 
pairs(LAIcrop)
# Export file
png("outputs/pLAI.png", res = 300, width = 4000, heigh = 2000)
pairs(LAIcrop)
dev.off()


# Download data from Copernicus Global Land Service on Fraction of green vegetation Cover (300m V1) to have a higher resolution image

# FCOVER April 2019 in Sarawak - Malaysia 
# Repeat same processes as before
# Import and use raster function
malaysia2019 <- raster("c_gls_FCOVER300_201910100000_GLOBE_PROBAV_V1.0.1.nc")
# Crop the image over Sarawak state
ext2 <- c(108, 116, 0, 8)
malaysia2019c <- crop(malaysia2019, ext2)
# Convert raster object into a dataframe to make a ggplot
malyasia2019_df <- as.data.frame(malaysia2019c, xy=TRUE) 
# ggplot
g6 <- ggplot() + geom_raster(malyasia2019_df, mapping = aes(x=x, y=y, fill=Fraction.of.green.Vegetation.Cover.333m)) + scale_fill_viridis(option = "magma") + ggtitle("Fraction of vegetation cover in Malaysia in 2019") + labs(fill = "FCOVER")
# Export it
png("outputs/malaysia.png", res= 300, width = 2000, heigh = 2000)
g6 
dev.off()


# Download shape file from Global Forest Watch on Oil Palm Concessions and Plantations in April 2019
# Import and use readOGR function: reads an OGR data source and layer into a suitable Spatial vector object
oilpalm <- readOGR("/Users/sarapiccini/Documents/dataexam/Sarawak_oil_palm_concessions/Sarawak_oil_palm_concessions.shp")
oilpalm # Check class: SpatialPolygonsDataFrame 

# Fortify it to make a ggplot
foilpalm <- fortify(oilpalm)
gfoilpalm <-ggplot() + geom_polygon(data = foilpalm , aes(x = long, y = lat, group = group), fill="#69b3a2", color="white") + theme_void()

# ggplot with FCOVER
ggoilpalm <- ggplot() + geom_raster(malyasia2019_df, mapping = aes(x = x, y = y, fill = Fraction.of.green.Vegetation.Cover.333m)) + scale_fill_viridis(option="magma") + labs(fill = "FCOVER") +
geom_polygon(data=foilpalm,aes(x=long, y=lat, group=group), fill="transparent", color="black", lwd=0.3) + theme_void() +
ggtitle("Oil Palm Concessions")

# Download shape file from Global Forest Watch on Protected Areas in April 2019
# Import and use readOGR function
protectedareas <- readOGR("/Users/sarapiccini/Documents/dataexam/Sarawak_protected_areas/Sarawak_protected_areas.shp")
protectedareas # Check class: SpatialPolygonsDataFrame

# Fortify it to make a ggplot
fprotectedareas <- fortify(protectedareas)
gfprotectedareas <- ggplot() + geom_polygon(data = fprotectedareas, aes(x = long, y = lat, group = group), fill="#69b3a2", color="white") + theme_void()

# ggplot with FCOVER
ggprotectedareas <- ggplot() + geom_raster(malyasia2019_df, mapping = aes(x = x, y = y, fill = Fraction.of.green.Vegetation.Cover.333m)) + scale_fill_viridis(option="magma") + labs(fill = "FCOVER") +
geom_polygon(data=fprotectedareas,aes(x=long, y=lat, group=group), fill="transparent",color="black",lwd=0.5) + theme_void() +
ggtitle("Protected Areas")

# Plot together (shape files ggplot)
gfoilpalm + gfprotectedareas
# Plot together (shape files and FCOVERggplot)
ggoilpalm + ggprotectedareas

# Export
png("outputs/shapefiles.png", res = 300, width = 3000, heigh = 2000)
gfoilpalm + gfprotectedareas
dev.off()
png("outputs/OilPalmCrops_ProtectedAreas.png", res = 300, width = 3000, heigh = 2000)
ggoilpalm + ggprotectedareas
dev.off()

