# R code for chemical cycling study
# time serie of NO2 change in EU during lockdown
# functions useful to import data: 
# possible range 
# use brick functions to take data from folders outside R, but since we have single data (single layers we use raster function)
# every single image has one layer
# use raster function: create a raster layer
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

# day 2

#EN folder: import data all together 
#direct import
#use laplly function: apply a function over a list of vector (arrey of images: need the list to which apply another function
#make the list with function: list.files in the directory
#path: where the files are located
#pattern: common pattern of the images (ex: common name of the images: not the extenction)
#setting the working directory we can remove path from the function: we need only the common part of the name of the files 

library(raster)
#set the working directory to work with EN folder since the images are there
setwd("/Users/sarapiccini/Desktop/lab/EN") 
#the first part of the name "EN" is the same: we will use it for pattern. Use quads since we are exiting R
rlist <- list.files(pattern="EN")
#stor the list in an object with a name using arrow to assign the name to the list.files function
rlist
#apply the function "lapply" to the list with the "raster" function as the function to the list
list_rast <- lapply(rlist, raster)
list_rast
#now we have the files one after the others (1-13) imported
#use stack function to stack all the files together 
#we are stuck images using the list we made (all files imported) stck all together 

EN_stack <- stack(list_rast) 
EN_stack
cl <- colorRampPalette(c('red','orange','yellow'))(100) 
plot(EN_stack, col=cl)
#plot only the first image of the stuck:
plot(EN_stack$EN_0001, col=cl)
#difference between first and 13th image:
ENdif <- EN_stack$EN_0001 - EN_stack$EN_0013
cldif <- colorRampPalette(c('blue','white','red'))(100) 
plot(ENdif, col=cldif)

# automated processing Source function: read R code from a file, a connection or expression
# cose in internet or in computer link with R and run the code directly 
# construct the script in Word (with comments to understand what to do with the functions)  to run it directly on R

source("R_code_automatic_script.txt")
#remember to put always "setwd" as a comment in txt to make R able to read the txt 
