# install and import all the library 


library(c("ncdf4", "raster", "viridis", "RStoolbox", "ggplot2", "patchwork", "rgdal", "gridExtra"))

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





