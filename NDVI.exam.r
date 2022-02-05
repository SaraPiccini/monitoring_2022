# R code for my Monitoring Ecosystem Changes and Functioning exam in 2022
# Multi-temporal analysis on vegetation in Indonesia and Papua New Guinea with a focus on deforstation 
# Download data from Copernicus Global Land Service on NDVI and FCOVER 

# Upload all the libraries needed at the beginning - for uploading and visualizing copernicus data in R
library(ncdf4) # for formatting our files - to manage spatial data, read and manipulate them (in nc)
library(raster) # work with raster file (single layer data)
#library(RStoolbox) # tools for remote sensing data processing; builds on raster and make classification
library(ggplot2) # for plots - to ggplot raster layers - create graphics
library(viridis) # palette -  color scales
library(patchwork) # for comparing separate ggplots - compose multiple ggplots
library(gridExtra) #for grid.arrange plotting, creating a multiframe with ggplot
library(rgdal)

# Set the working directory
setwd("/Users/sarapiccini/Documents/datandvi")

# Importing is one by one 
NDVI1999 <- raster("c_gls_NDVI_199906010000_GLOBE_VGT_V2.2.1.nc")
NDVI1999

# we can also import multiple files at once that have the same pattern in the name (much faster when we have many files to import)
rlist <- list.files(pattern="gls_NDVI") # listing all the files with the pattern present in the directory
rlist
list_rast <- lapply(rlist, raster) # to make the list a brick list - apply brick function to all the files (multi-layers)
list_rast
NDVIstack <- stack(list_rast) # creating a stack
NDVIstack
plot(NDVIstack)

ext <- c(94.5, 150, -11.5, 0)
NDVIcrop <- crop(NDVIstack, ext)
plot(NDVIcrop)
NDVIcrop

# Let's assign them to an object
NDVI1999 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1km.1
NDVI2004 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1km.2
NDVI2009 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1km.3
NDVI2014 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1km.4
NDVI2019 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1km.5

# Plot them with ggplot 
g1 <- ggplot() + geom_raster(data = NDVI1999, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km.1)) + scale_fill_viridis(option = "inferno") + ggtitle("NDVI in 1999") + labs(fill = "NDVI")
g2 <- ggplot() + geom_raster(data = NDVI2004, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km.2)) + scale_fill_viridis(option = "inferno") + ggtitle("NDVI in 2004") + labs(fill = "NDVI")
g3 <- ggplot() + geom_raster(data = NDVI2009, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km.3)) + scale_fill_viridis(option = "inferno") + ggtitle("NDVI in 2009") + labs(fill = "NDVI")
g4 <- ggplot() + geom_raster(data = NDVI2014, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km.4)) + scale_fill_viridis(option = "inferno") + ggtitle("NDVI in 2014") + labs(fill = "NDVI")
g5 <- ggplot() + geom_raster(data = NDVI2019, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km.5)) + scale_fill_viridis(option = "inferno") + ggtitle("NDVI in 2019") + labs(fill = "NDVI")

# I have also tried this one: scale_fill_viridis(direction = -1, option = "magma") with the order of colors reversed but 
# Plot them together (multiframe ggplot) with grid.arrange function (from gridExtra package)
grid.arrange(g1, g2, g3, g4, g5, nrow=3)
#or with patchwork package 
g2 + g1 + g3 / g4 + g5

# Export file

pdf("NDVIggplot.pdf", width=30, height=10)
grid.arrange(g1, g2, g3, g4, g5, nrow=3)
dev.off()

# I have created a color ramp palette to better differences
clNDVI <- colorRampPalette(colors = c('#6e462c', '#9c8448', 'white', '#9cab68', '#306466'))(255)

par(mfrow=c(2,3))
plot(NDVI1999, col = clNDVI)
plot(NDVI2004, col = clNDVI)
plot(NDVI2009, col = clNDVI)
plot(NDVI2014, col = clNDVI)
plot(NDVI2019, col = clNDVI)

#ndvi difference between years
NDVIdif <- NDVI1999 - NDVI2019
#creation of a new color palette to emphasize differences with COLORBREWER 2.0:
col <- colorRampPalette(c('#ef3b2c','#f7f7f7','#008837'))(255)
plot(NDVIdif, col=col, main="Difference in NDVI between 1999 and 2019")


############### class
#list_rast2 <- lapply(rlist, brick) # to make the list a brick list - apply brick function to all the files (multi-layers)
#list_rast2
list_rast <- lapply(rlist, raster) # to make the list a brick list - apply brick function to all the files (multi-layers)
list_rast
NDVIstack <- stack(list_rast) # creating a stack
NDVIstack
plot(NDVIstack)
ext <- c(-5, 25, 0, 10)
NDVIcrop <- crop(NDVIstack, ext)
plot(NDVIcrop)
NDVIcrop
NDVI1999 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1KM.1
NDVI2004 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1KM.2
NDVI2009 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1KM.3
NDVI2014 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1KM.4
NDVI2019 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1KM.5
NDVI1999 <- raster("c_gls_NDVI_199906010000_GLOBE_VGT_V2.2.1.nc")
plotRGB(NDVI1999, r=1, g=2, b=3, stretch="lin")
ggRGB(NDVI1999, r=1, g=2, b=3, stretch="lin")
ext <- c(380, 450, 140, 200)
LC2001crop <- crop(LC2001, ext)
ggRGB(LC2001crop, r=1, g=2, b=3, stretch="lin")
NDVI1999c <- unsuperClass(NDVI1999, nClasses=5, clusterMap=TRUE, nStarts = 1)
NDVI1999c
plot(NDVI1999c$map)
NDVI2004c <- unsuperClass(NDVI2004, nClasses=4)
NDVI2004c
plot(NDVI2004c$map)
NDVI2009c <- unsuperClass(NDVI2009, nClasses=4)
NDVI2009c
plot(NDVI2014c$map)
NDVI2014c <- unsuperClass(NDVI2014, nClasses=4)
NDVI2014c
plot(NDVI2014c$map)
NDVI2019c <- unsuperClass(NDVI2019, nClasses=5, clusterMap=TRUE, nStarts = 1)
NDVI2019c
plot(NDVI2019c$map)
par(mfrow=c(1,2))
plot(NDVI1999c$map)
plot(NDVI2019c$map)
grid.arrange(g1, g2, g3, g4, g5, nrow=2)

### FCOVER ###
# Same passages of before
rfcover <- list.files(pattern="FCOVER")
rfcover

rfcover_rast <- lapply(rfcover, raster)
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

# Create a color palette with COLORBREWER 2.0
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

# Plot frequency distribution of data: frequecies : how pixels are distributed in each different class - frequencies of each classes
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
d1 <- ggplot() + geom_raster(data = dif1, mapping = aes(x=x, y=y, fill= FCOVER1999 - FCOVER2004)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest loss and gain between 1999 and 2004")
d2 <- ggplot() + geom_raster(data = FCOVER2004 - FCOVER2009, mapping = aes(x=x, y=y, fill= dif2)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest loss and gain between 2004 and 2009")
d3 <- ggplot() + geom_raster(data = FCOVER2009 - FCOVER2014, mapping = aes(x=x, y=y, fill= dif3)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest loss and gain between 2009 and 2014")
d4 <- ggplot() + geom_raster(data = FCOVER2014 - FCOVER2019, mapping = aes(x=x, y=y, fill= dif4)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest loss and gain between 2014 and 2019")
d5 <- ggplot() + geom_raster(data = FCOVER1999 - FCOVER2019, mapping = aes(x=x, y=y, fill= dif5)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest loss and gain between 1999 and 2019")
# Multiframe ggplot with patchwork
d1 + d2 + d3 /  d4 + d5
# Create a color palette with COLORBREWER 2.0 
# x = 0 -> no changes: colored in white
class3_RdBu <- colorRampPalette(colors = c('#ef8a62','#f7f7f7','#67a9cf'))(255)
difw <- plot(dif5, col=class3_RdBu, main = "Difference in Forest Cover between 1999 and 2019")
# x = 0 -> no changes: colored in black
class3_RdBu2 <- colorRampPalette(colors = c('#ef8a62','#636363','#7fbf7b'))(255)
difb <- plot(dif5, col=class3_RdBu2, main = "Difference in Forest Cover between 1999 and 2019")

# Plot together
par(mfrow=c(1,2))
difw 
difb

# Export
pdf("fcoverdif.pdf", width=30, height=10) #migliorare
par(mfrow=c(2,3))
difw 
difb
dev.off()



######

install.packages("BiocManager") #to deal with HDF5 file
BiocManager::install("rhdf5")
library("rhdf5")
library("rgdal")

setwd("/Users/sarapiccini/Documents/datandvii")
rlist <- list.files(pattern="NDVI") # listing all the files with the pattern present in the directory
rlist

h5ls("g2_BIOPAR_NDVI_199812240000_AFRI_VGT_V1.3.h5") # View structure of the file
# group       name       otype  dclass          dim
#0     /        LMK H5I_DATASET INTEGER 10081 x 8961
#1     /       NDVI H5I_DATASET INTEGER 10081 x 8961
#2     / NDVI-QFLAG H5I_DATASET INTEGER 10081 x 8961
#3     /       NMOD H5I_DATASET INTEGER 10081 x 8961

# look at the attributes of the precip_data dataset:
h5readAttributes(file = "g2_BIOPAR_NDVI_199812240000_AFRI_VGT_V1.3.h5", name = "NDVI") 
#$CLASS
#[1] "DATA"
#$MISSING_VALUE
#[1] "255"
#$NB_BYTES
#[1] "Uint8"
#$OFFSET
#[1] "25"
#$ORDER_BYTES
#[1] "1"
#$PRODUCT
#[1] "NDVI"
#$SCALING_FACTOR
#[1] "250"
h5dump("g2_BIOPAR_NDVI_199812240000_AFRI_VGT_V1.3.h5")

NDVI <- brick("g2_BIOPAR_NDV_QL_201312240000_AFRI_VGT_V1.3.tiff") 
ras_brick <- brick(lapply(paste("g2_BIOPAR_NDV_QL_201312240000_AFRI_VGT_V1.3.tiff", sep=""), raster)) 
dim(ras_brick) 


############

#~~~~ ".H5" files 
#list all SMAP-L4 .H5 files
NDVI <- "g2_BIOPAR_NDVI_199812240000_AFRI_VGT_V1.3.h5"
# Open the first file as an example
nc <- nc_open(NDVI[1]) 
print(nc) # Notice the variables and the structure of the file

# Extract fields/ variables
NDVI1 <- ncvar_get(nc,"NDVI")
nc_close(nc)

print(NDVI1)

# Conver data to raster using mat2ras.R function

library(raster)
NDVI <-'g2_BIOPAR_NDV_QL_199812240000_AFRI_VGT_V1.3.tiff' 
imported_raster <- raster(NDVI)




test_file <- tempfile(fileext="g2_BIOPAR_NDVI_199812240000_AFRI_VGT_V1.3.h5")
file.h5 <- H5File$new(test_file, mode="w")

NDVI <- "g2_BIOPAR_NDVI_199812240000_AFRI_VGT_V1.3.h5"$NDVI


gdalinfo 
list_rast <- lapply(rlist, raster) # to make the list a brick list - apply brick function to all the files (multi-layers)
list_rast
NDVIstack <- stack(list_rast) # creating a stack
NDVIstack
plot(NDVIstack)

ext <- c(94.5, 150, -11.5, 0)
NDVIcrop <- crop(NDVIstack, ext)
plot(NDVIcrop)
NDVIcrop

NDVI1999 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1km.1
NDVI2004 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1km.2
NDVI2009 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1km.3
NDVI2014 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1km.4
NDVI2019 <- NDVIcrop$Normalized.Difference.Vegetation.Index.1km.5

# Plot them with ggplot 
g1 <- ggplot() + geom_raster(data = NDVI1999, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km.1)) + scale_fill_viridis(option = "inferno") + ggtitle("NDVI in 1999") + labs(fill = "NDVI")
g2 <- ggplot() + geom_raster(data = NDVI2004, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km.2)) + scale_fill_viridis(option = "inferno") + ggtitle("NDVI in 2004") + labs(fill = "NDVI")
g3 <- ggplot() + geom_raster(data = NDVI2009, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km.3)) + scale_fill_viridis(option = "inferno") + ggtitle("NDVI in 2009") + labs(fill = "NDVI")
g4 <- ggplot() + geom_raster(data = NDVI2014, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km.4)) + scale_fill_viridis(option = "inferno") + ggtitle("NDVI in 2014") + labs(fill = "NDVI")
g5 <- ggplot() + geom_raster(data = NDVI2019, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km.5)) + scale_fill_viridis(option = "inferno") + ggtitle("NDVI in 2019") + labs(fill = "NDVI")

# I have also tried this one: scale_fill_viridis(direction = -1, option = "magma") with the order of colors reversed but 
# Plot them together (multiframe ggplot) with grid.arrange function (from gridExtra package)
grid.arrange(g1, g2, g3, g4, g5, nrow=3)

clNDVI <- colorRampPalette(colors = c('#6e462c', '#9c8448', 'white', '#9cab68', '#306466'))(255)

par(mfrow=c(2,3))
plot(NDVI1999, col = clNDVI)
plot(NDVI2004, col = clNDVI)
plot(NDVI2009, col = clNDVI)
plot(NDVI2014, col = clNDVI)
plot(NDVI2019, col = clNDVI)

#ndvi difference between years
NDVIdif <- NDVI1999 - NDVI2019
#creation of a new color palette to emphasize differences with COLORBREWER 2.0:
col <- colorRampPalette(c('#ef3b2c','#f7f7f7','#008837'))(255)
plot(NDVIdif, col=col, main="Difference in NDVI between 1999 and 2019")

######


rfcover <- list.files(pattern="FCOVER")
rfcover

rfcover_rast <- lapply(rfcover, raster)
rfcover_rast 

# Creating a stack
FCOVERstack <- stack(rfcover_rast) 
FCOVERstack 
plot(FCOVERstack)

ext <- c(-80, -20, -60, 20)
# Crop the image over Central Africa
FCOVERcrop <- crop(FCOVERstack, ext)
plot(FCOVERcrop)
FCOVERcrop
class5_YlGn <- colorRampPalette(colors = c('#ffffcc','#c2e699','#78c679','#31a354','#006837'))(255)
plot(FCOVERcrop, col=class5_YlGn)

FCOVER1999 <- FCOVERcrop$Fraction.of.green.Vegetation.Cover.1km.1
FCOVER2019 <- FCOVERcrop$Fraction.of.green.Vegetation.Cover.1km.2

plot(FCOVER1999, FCOVER2019, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 1999", ylab="FCOVER 2019")
abline(0,1, col="red")


par(mfrow=c(1,2))
hist(FCOVER1999)
hist(FCOVER2019)


pairs

dif1 <- FCOVER1999 - FCOVER2019

class3_RdBu <- colorRampPalette(colors = c('#ef8a62','#f7f7f7','#67a9cf'))(255)
difw <- plot(dif1, col=class3_RdBu, main = "Difference in Forest Cover between 1999 and 2019")


