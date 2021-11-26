# R code for chemical cycling study
# time serie of NO2 change in EU during lockdown
# functions useful to import data: 
# possible range 
# use brick functions to take data from folders outside R, but since we have single data (single layers we use raster function)
# every single image has one layer
# use raster function: create a laster layer
# set the working directory
library(raster)
setwd("/Users/sarapiccini/Desktop/lab/EN") 

en01 <- raster("EN_0001.png")
#the range (minimum and maximum value) of the data: 0-225 8-bitfyle 8-bitimage : radiometric resolution
#8-bit (Shannon): small part of info coming 
en01
cl <- colorRampPalette(c('red', 'orange', 'yellow'))(100)
#plot the NO2 values of Jen 29020 by the cl palette
plot (en01, col=cl)
#the higher the amount of people in cities the higher the amount of NO2 spreaded
#import the ond of March NO2 and plot it
en13 <- raster("EN_0013.png")
plot (en13, col=cl)
#NO2 decreased a lot 
#plot together with a multiframe window with 2 rows and 1 column with par function
par(mfrow=c(2,1))
plot (en01, col=cl)
plot (en13, col=cl)
#plot the all set together 
#import all images one after the other: 
en01 <- raster("EN_0001.png")
en02 <- raster("EN_0002.png")
en03 <- raster("EN_0003.png")
en04 <- raster("EN_0004.png")
en05 <- raster("EN_0005.png")
en06 <- raster("EN_0006.png")
en07 <- raster("EN_0007.png")
en08 <- raster("EN_0008.png")
en09 <- raster("EN_0009.png")
en10 <- raster("EN_0010.png")
en11 <- raster("EN_0011.png")
en12 <- raster("EN_0012.png")
en13 <- raster("EN_0013.png")

#plot them together:
#par function with 4 columns and 4 rows use c since it's an arrey
par(mfrow=c(4,4))
plot(en01, col=cl)
plot(en02, col=cl)
plot(en03, col=cl)
plot(en04, col=cl)
plot(en05, col=cl)
plot(en06, col=cl)
plot(en07, col=cl)
plot(en08, col=cl)
plot(en09, col=cl)
plot(en10, col=cl)
plot(en11, col=cl)
plot(en12, col=cl)
plot(en13, col=cl)

#stack function: several layers all together a give the functiona  name
EN <- stack(en01, en02, en03, en04, en05, en06, en07, en08, en09, en10, en11, en12, en13)
#plot the stack all together
plot(EN, col=cl)

#plot only the first image from the stuck 
EN #new name of images coming out from original ones: put the stack's name 
dev.off()
plot(EN$EN_0001, col=cl)

#RGB space with images inside
#RGB space : red green blue plot of a multiframe layer
#function to plot RGB
plotRGB(EN, r=1, g=7, b=13, stretch="lin") #3 different layers in time


