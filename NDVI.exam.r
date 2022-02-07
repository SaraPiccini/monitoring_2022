# R code for my Monitoring Ecosystem Changes and Functioning exam in 2022
# Multi-temporal analysis on vegetation in Indonesia and Papua New Guinea with a focus on deforstation 
# Download data from Copernicus Global Land Service on NDVI and FCOVER 

# Upload all the libraries needed at the beginning - for uploading and visualizing copernicus data in R
library(ncdf4) # for formatting our files - to manage spatial data, read and manipulate them (in nc)
library(raster) # work with raster file (single layer data)
library(ggplot2) # for plots - to ggplot raster layers - create graphics
library(viridis) # palette - color scales
library(patchwork) # for comparing separate ggplots - compose multiple ggplots
library(gridExtra) #for grid.arrange plotting, creating a multiframe with ggplot


# Set the working directory
setwd("/Users/sarapiccini/Documents/datandvi")

# Importing is one by one 
FCOVER1999 <- raster("c_gls_FCOVER_199902280000_GLOBE_VGT_V2.0.2.nc")
FCOVER1999

# we can also import multiple files at once that have the same pattern in the name (much faster when we have many files to import)
rlist <- list.files(pattern="FCOVER") # listing all the files with the pattern present in the directory
rlist

# to make the list a brick list - apply brick function to all the files (multi-layers)
list_rast <- lapply(rlist, raster) 
list_rast
# creating a stack
FCOVERstack <- stack(list_rast) 
FCOVERstack

# Change variables'names 
names(FCOVERstack) <- c("FCOVER1999","FCOVER2004","FCOVER2009","FCOVER2014","FCOVER2020")
plot(FCOVERstack)

# and then we separate the files, assigning to each element of the stack a name
FCOVER1999 <- FCOVERstack$FCOVER1999
FCOVER2004 <- FCOVERstack$FCOVER2004
FCOVER2009 <- FCOVERstack$FCOVER2009
FCOVER2014 <- FCOVERstack$FCOVER2014
FCOVER2020 <- FCOVERstack$FCOVER2020
# Crop the image over Central Africa
#ext <- c(94.5, 150, -11.5, 0) indonesia
ext <- c(-10, 25, -10, 10)
FCOVERcrop <- crop(FCOVERstack, ext)
plot(FCOVERcrop)
FCOVERcrop

# Create a color palette with COLORBREWER 2.0
class5_YlGn <- colorRampPalette(colors = c('#ffffcc','#c2e699','#78c679','#31a354','#006837'))(100) #da rifare
plot(FCOVERcrop, col=class5_YlGn)

# Plot FCOVER of each year
par(mfrow=c(2,3))
plot(FCOVERcrop$FCOVER1999, main="Forest Cover in 1999", col=class5_YlGn)
plot(FCOVERcrop$FCOVER2004, main="Forest Cover in 2004", col=class5_YlGn)
plot(FCOVERcrop$FCOVER2009, main="Forest Cover in 2009", col=class5_YlGn)
plot(FCOVERcrop$FCOVER2014, main="Forest Cover in 2014", col=class5_YlGn)
plot(FCOVERcrop$FCOVER2020, main="Forest Cover in 2020", col=class5_YlGn)

# Export file
pdf("fcover.pdf", width=30, height=10) #migliorare
par(mfrow=c(2,3))
plot(FCOVERcrop$FCOVER1999, main="Forest Cover in 1999", col=class5_YlGn)
plot(FCOVERcrop$FCOVER2004, main="Forest Cover in 2004", col=class5_YlGn)
plot(FCOVERcrop$FCOVER2009, main="Forest Cover in 2009", col=class5_YlGn)
plot(FCOVERcrop$FCOVER2014, main="Forest Cover in 2014", col=class5_YlGn)
plot(FCOVERcrop$FCOVER2020, main="Forest Cover in 2020", col=class5_YlGn)
dev.off()

# Or plot them with ggplot
g1 <- ggplot() + geom_raster(FCOVERstack$FCOVER1999, mapping = aes(x=x, y=y, fill=FCOVER1999)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 1999") 
g2 <- ggplot() + geom_raster(FCOVER2004, mapping = aes(x=x, y=y, fill= Fraction.of.green.Vegetation.Cover.1km.2)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2004") + labs(fill = "FCOVER")
g3 <- ggplot() + geom_raster(FCOVER2009, mapping = aes(x=x, y=y, fill= Fraction.of.green.Vegetation.Cover.1km.3)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2009") + labs(fill = "FCOVER")
g4 <- ggplot() + geom_raster(FCOVER2014, mapping = aes(x=x, y=y, fill= Fraction.of.green.Vegetation.Cover.1km.4)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2014") + labs(fill = "FCOVER")
g5 <- ggplot() + geom_raster(FCOVER1999, mapping = aes(x=x, y=y, fill= Fraction.of.green.Vegetation.Cover.1km.5)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2019") + labs(fill = "FCOVER")

# I have also tried this one: scale_fill_viridis(direction = -1, option = "magma") with the order of colors reversed but 
# Plot them together (multiframe ggplot) with grid.arrange function (from gridExtra package)
grid.arrange(g1, g2, g3, g4, g5, nrow=3)
#or with patchwork package 
g2 + g1 + g3 / g4 + g5

# Compare fcover between each year with a linear regression model: 
par(mfrow=c(3,4))
plot(FCOVER1999, FCOVER2004, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 1999", ylab="FCOVER 2004")
abline(0,1, col="red")
plot(FCOVER1999, FCOVER2009, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 1999", ylab="FCOVER 2009")
abline(0,1, col="red")
plot(FCOVER1999, FCOVER2014, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 1999", ylab="FCOVER 2014")
abline(0,1, col="red")
plot(FCOVER1999, FCOVER2020, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 1999", ylab="FCOVER 2020")
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
plot(FCOVER1999, FCOVER2020, xlim=c(0, 1), ylim=c(0, 1), xlab="FCOVER 2014", ylab="FCOVER 2020")
abline(0,1, col="red")

# Plot frequency distribution of data: frequecies : how pixels are distributed in each different class - frequencies of each classes
par(mfrow=c(3,2))
hist(FCOVER1999)
hist(FCOVER2004)
hist(FCOVER2009)
hist(FCOVER2014)
hist(FCOVER2020)

# Or use pairs function: density plot (histograms), scatterplot, and Pearson coefficient
pairs(FCOVERcrop)

# Plot the difference between each years - Compute the difference between the layers
dif1 <- FCOVER1999 - FCOVER2004
dif2 <- FCOVER2004 - FCOVER2009
dif3 <- FCOVER2009 - FCOVER2014
dif4 <- FCOVER2014 - FCOVER2020
dif5 <- FCOVER1999 - FCOVER2020

# I have also tried this one: scale_fill_viridis(direction = -1, option = "magma") with the order of colors reversed but 
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


rLST<- list.files(pattern="LST")
rLST

rLST_rast <- lapply(rLST, raster)
rLST_rast 

# Creating a stack
LSTstack <- stack(rLST_rast) 
LSTstack 
plot(LSTstack)

# Crop the image over Central Africa
LSTcrop <- crop(LSTstack, ext)
plot(LSTcrop)
LSTcrop


LST2017 <- LSTcrop$Fraction.of.Valid.Observations.1
LST2018 <- LSTcrop$Fraction.of.Valid.Observations.2
LST2020 <- LSTcrop$Fraction.of.Valid.Observations.3
LST2021 <- LSTcrop$Fraction.of.Valid.Observations.4

dif1 <- LST2017 - LST2021

class3_RdBu <- colorRampPalette(colors = c('#ef8a62','#f7f7f7','#67a9cf'))(255)
difw <- plot(dif1, col=class3_RdBu, main = "Difference in LSR between 2017 and 2021")


##
veg2006 <- v_cropped$FCOVER2006
p_veg2006 <- ggplot() + 
                  geom_raster(veg2006, mapping = aes(x = x, y = y, fill = FCOVER2006)) +
                  scale_fill_viridis(option="plasma") + 
                  ggtitle("Fraction of green vegetation cover - January 2006")

cldif <- colorRampPalette(c('darkred','darkred', 'darkred', 'darkred', 'aliceblue', 'aliceblue', 'darkgreen', 'darkgreen', 'darkgreen', 'darkgreen'))(100)

fcdif0620 <- veg2020 - veg2006
plot(fcdif0620, col=cl, main="Difference of FCOVER", sub="Between 2006 and 2020")

# let's see the distribution of each image using the hist() function
# plotting frequency distributions of data
hist(veg2006)
hist(veg2020)


##### LAI
LAIrlist <- list.files(pattern="LAI") # listing all the files with the pattern present in the directory
LAIrlist

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







