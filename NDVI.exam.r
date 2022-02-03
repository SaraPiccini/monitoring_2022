# R code for my Monitoring Ecosystem Changes and Functioning exam in 2022
# multi-temporal analysis in vegetation state in Central Africa

# Upload all the libraries needed at the beginning - for uploading and visualizing copernicus data in R
library(ncdf4) # for formatting our files - to manage spatial data, read and manipulate them (in nc)
library(raster) # work with raster file (single layer data)
library(RStoolbox) # tools for remote sensing data processing; builds on raster and make classification
library(ggplot2) # for plots - to ggplot raster layers - create graphics
library(viridis) # palette -  color scales
library(patchwork) # for comparing separate ggplots - compose multiple ggplots
library(gridExtra) #for grid.arrange plotting, creating a multiframe with ggplot

# Set the working directory
setwd("/Users/sarapiccini/Documents/datandvi")

# Importing is one by one 
NDVI1999 <- raster("c_gls_NDVI_199906010000_GLOBE_VGT_V2.2.1.nc")
NDVI1999

# we can also import multiple files at once that have the same pattern in the name (much faster when we have many files to import)
rlist <- list.files(pattern="NDVI") # listing all the files with the pattern present in the directory
rlist
list_rast <- lapply(rlist, raster) # to make the list a brick list - apply brick function to all the files (multi-layers)
list_rast
NDVIstack <- stack(list_rast) # creating a stack
NDVIstack
plot(NDVIstack)

ext <- c(-27, 47, -20, 16)
NDVIcrop <- crop(NDVIstack, ext)
plot(NDVIcrop)
NDVIcrop

# Let's assign them to an object
NDVI1999 <- list_rast[[1]]
NDVI2004 <- list_rast[[2]]
NDVI2009 <- list_rast[[3]]
NDVI2014 <- list_rast[[4]]
NDVI2019 <- list_rast[[5]]

NDVI1999 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1KM.1
NDVI2004 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1KM.2
NDVI2009 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1KM.3
NDVI2014 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1KM.4
NDVI2019 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1KM.5

NDVI1999c <- unsuperClass(NDVI1999, nClasses=5)
NDVI1999c
plot(NDVI1999c$map)





### FCOVER ###

rfcover <- list.files(pattern="FCOVER")
rfcover

rfcover_rast <- lapply(rfcover, raster) # same as doing fcover_import <- lapply(fcover_list, brick, varname="FCOVER") because the first layer is FCOVER
rfcover_rast 

# Creating a stack
FCOVERstack <- stack(rfcover_rast) 
FCOVERstack 
plot(FCOVERstack)

# Crop the image over Central Africa
FCOVERcrop <- crop(FCOVERstack, ext)
plot(FCOVERcrop)
FCOVERcrop

# Separating the files, assigning to each element of the stack a name
FCOVER1999 <- FCOVERcrop$Fraction.of.green.Vegetation.Cover.1km.1
FCOVER2004 <- FCOVERcrop$Fraction.of.green.Vegetation.Cover.1km.2
FCOVER2009 <- FCOVERcrop$Fraction.of.green.Vegetation.Cover.1km.3
FCOVER2014 <- FCOVERcrop$Fraction.of.green.Vegetation.Cover.1km.4
FCOVER2019 <- FCOVERcrop$Fraction.of.green.Vegetation.Cover.1km.5

# Create a color palette
class5_YlGn <- colorRampPalette(colors = c('#ffffcc','#c2e699','#78c679','#31a354','#006837'))(255)
plot(FCOVERcrop, col=class5_YlGn)

# Plot FCOVER of each year
par(mfrow=c(2,3))
plot(FCOVER1999, main="Forest Cover in 1999", col=class5_YlGn)
plot(FCOVER2004, main="Forest Cover in 2004", col=class5_YlGn)
plot(FCOVER2009, main="Forest Cover in 2009", col=class5_YlGn)
plot(FCOVER2014, main="Forest Cover in 2014", col=class5_YlGn)
plot(FCOVER2019, main="Forest Cover in 2019", col=class5_YlGn)

# Export file

pdf("fcover.pdf", width=30, height=10) #migliorare
par(mfrow=c(2,3))
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

# Plot frequency distribution of data
par(mfrow=c(3,2))
hist(FCOVER1999)
hist(FCOVER2004)
hist(FCOVER2009)
hist(FCOVER2014)
hist(FCOVER2019)

# Or use pairs function: density plot (histograms), scatterplot, and Pearson coefficient
pairs(FCOVERcrop)

# Plot the difference between each years - Compute the difference between the layers
dif1 <- FCOVER1999 - FCOVER2004
dif2 <- FCOVER2004 - FCOVER2009
dif3 <- FCOVER2009 - FCOVER2014
dif4 <- FCOVER2014 - FCOVER2019
dif5 <- FCOVER1999 - FCOVER2019

# Use ggplot with viridis palette to see differences between years
d1 <- ggplot() + geom_raster(data = FCOVER1999 - FCOVER2019, mapping = aes(x=x, y=y, fill= dif5)) + scale_fill_viridis() + ggtitle("Percentage of forest loss and gain between 1999 and 2019")
 




