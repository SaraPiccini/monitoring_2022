# install and import all the library 
library(ncdf4) # import the copernicus file (in nc)
library(raster) # work with raster file (single layer data)
library(viridis) # plot the color palette
library(RStoolbox) # useful for remote sensing image processing (make classification - unsuperclass)
library(ggplot2) # create graphics - ggplot function
library(gridExtra) # for multiframe ggplot
library(patchwork) # multiframe graphics
library(rgdal) # to open shape file

setwd("/Users/sarapiccini/Documents/datalst")


### LST ####

LST <- list.files(pattern="DC")
LST

LSTraster <- lapply(LST, raster)
LSTraster


LSTstack <- stack(LSTraster)
LSTstack
plot(LSTstack)

ext <- c(-10, 30, 35, 50)
LSTcrop <- crop(LSTstack, ext)
plot(LSTcrop)
LSTcrop
cl <- colorRampPalette(c("blue", "light blue", "pink", "yellow"))(100)
plot(LSTcrop, col = cl)

LSTFEB2018 <- LSTcrop$Fraction.of.Valid.Observations.1
LSTJUNE2018 <- LSTcrop$Fraction.of.Valid.Observations.2
LSTJULY2018 <- LSTcrop$Fraction.of.Valid.Observations.3
LSTAUG2018 <- LSTcrop$Fraction.of.Valid.Observations.4
LSTOCT2018 <- LSTcrop$Fraction.of.Valid.Observations.5
LSTF2020 <- LSTcrop$Fraction.of.Valid.Observations.6
LSTJUNE2020 <- LSTcrop$Fraction.of.Valid.Observations.7
LSTJULY2020 <- LSTcrop$Fraction.of.Valid.Observations.8
LSTAUG2020 <- LSTcrop$Fraction.of.Valid.Observations.9
LSTOCT2020 <- LSTcrop$Fraction.of.Valid.Observations.10


### TCI ####

TCI <- list.files(pattern="TCI")
TCI

TCIraster <- lapply(TCI, raster)
TCIraster
TCIstack <- stack(TCIraster)
TCIstack
plot(LSTstack)

TCIcrop <- crop(TCIstack, ext)
plot(TCIcrop)
TCIcrop
plot(TCIcrop, col = cl)

TCIFEB2018 <- TCIcrop$Fraction.of.Valid.Observations.1
TCIJUNE2018 <- TCIcrop$Fraction.of.Valid.Observations.2
TCIJULY2018 <- TCIcrop$Fraction.of.Valid.Observations.3
TCIAUG2018 <- TCIcrop$Fraction.of.Valid.Observations.4
TCIOCT2018 <- TCIcrop$Fraction.of.Valid.Observations.5
TCIFEB2020 <- TCIcrop$Fraction.of.Valid.Observations.6
TCIJUNE2020 <- TCIcrop$Fraction.of.Valid.Observations.7
TCIJULY2020 <- TCIcrop$Fraction.of.Valid.Observations.8
TCIAUG2020 <- TCIcrop$Fraction.of.Valid.Observations.9
TCIOCT2020 <- TCIcrop$Fraction.of.Valid.Observations.10

p1 <- ggplot() + geom_raster(TCIcrop$Fraction.of.Valid.Observations.1, mapping = aes(x=x, y=y, fill=Fraction.of.Valid.Observations.1)) + scale_fill_viridis(option="magma") + ggtitle("TCI in FEBRUARY 2018")
p2 <- ggplot() + geom_raster(LSTcrop$Fraction.of.Valid.Observations.1, mapping = aes(x=x, y=y, fill=Fraction.of.Valid.Observations.1)) + scale_fill_viridis(option="magma") + ggtitle("LST in FEBRUARY 2018")
p1 + p2



#### SSM ####

SSM <- list.files(pattern="SSM")
SSM

SSMraster <- lapply(SSM, raster)
SSMraster
SSMstack <- stack(SSMraster)
SSMstack
plot(SSMstack)

SSMcrop <- crop(SSMstack, ext)
plot(SSMcrop)
SSMcrop

ext <- c(-10, 0, 35, 40)

### BA ####
BA <- list.files(pattern="BA")
BA

BAraster <- lapply(BA, raster)
BAraster
BAstack <- stack(BAraster)
BAstack
plot(BAstack)

BAcrop <- crop(BAstack, ext)
plot(BAcrop)
BAcrop

ext <- c(-10, 0, 35, 40)

