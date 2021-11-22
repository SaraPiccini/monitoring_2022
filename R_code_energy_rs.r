#R code for estimating energy in ecosystems
#install.packages("raster") - we will need it

library(raster)
#set the working directory:
setwd("/Users/sarapiccini/Desktop/lab") 
#importina the data and give the name to a function to use the data set

install.packages("rgdal") 
library(rgdal)
l1992 <- brick ("defor1_.jpg") #image of 1992 (satellite image)
l1992
#names: defor1_.1, defor1_.2, defor1_.3 
#make the plot
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin") #amatogrosso forest
#put the near infra-red in the red component
#defor1_.1= near infra-red (everything is becoming red because plant reflects a lor in the NIR)
#defor1_.2 = red
#defor1_.3 = green
plotRGB(l1992, r=2, g=1, b=3, stretch="Lin") #now everything will become green 
plotRGB(l1992, r=2, g=3, b=1, stretch="Lin") #now everything will become blue (everything that is vegetation)
#no bear soil (white ore yellow area), we can see the river.
#the river is not black (it should be if there were only pure water), but white like bear soil becuase of the reflection of some algaes and soil (eutrophization)

#1992-2006

l2006 <- brick("defor2_.jpg")
l2006
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")
#defor2_.1 = NIR 
#defor2_.2 = red
#defor2_.3 = green
#rio pexoto the amount of disperded soil inside the river is smaller (it is blue and not white like before) 

#par to put two images togheter (one on top of the other: 2 rows and 1 column)
#this is an arrey so we put c 
par(mfrow=c(2,1))
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")
#to recognize that the two imagines are from the same area do not look at rivers because they have pretty similar flow and energy 
#so look at patches that are the same
#the rectangular shapes (euclidean schape) are usually not natural
#fractals (coming out from different resistences during the composition): fire

#calculation of energy:
#the use of the index DVI (aborb red, reflect NIR because of the palisate tissue on the mesofille: lambda NIR-lambda R)
#if there is vegetation the index is high because the reflectans in NIR is bigger than in the R
#three layers in our image: NIR red and green: we are going to use the red and the NIR.
#a pixel of forest -> high vaure of reflectans in NIr and small in the R. layer NIR high value - layer R small value = new layer of DVI with high value
#calculate energy in 1992 (Rio de Janeiro doc)
dev.off() #function in R - close plotting device
dvi1992 <- l1992$defor1_.1 - l1992$defor1_.2
#for each pixel it mades the difference
#names of the layer: defor1_.1 contining the NIR reflectance, the second is 
#$to make the difference
cl <- colorRampPalette(c("darkblue", "yelloW", "red", "black"))(100) #specifying a color scheme
plot(dvi1992, col=cl)
#calculate energy in 2006
dvi2006 <- l2006$defor2_.1 - l2006$defor2_.2
cl <- colorRampPalette(c("darkblue", "yelloW", "red", "black"))(100)
plot(dvi2006, col=cl)
#now we have less energy - the amount of energy loss is yellow because it chatches our eyes more than the other colors 
#use yellow to emphazise things - color blind people can't see scales of colors blue-red so do not use it
#primary productivity
#monitor the situation with time dimension: differences from one time and another one
#differencing two images of energy in two different times
dvidif <- dvi1992 - dvi2006
#plot the results
cld <- colorRampPalette(c("blue", "white", "red"))(100)
plot(dvidif, col=cld)
#everything which is red passed from a high value in 1992 to a low value in 2006 - big loss of energy

#final plot: original images (1992 and 2006), dvis (1992 and 2006), final dvi difference
#3 rows and 2 columns
par(mfrow=c(3,2))
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)
plot(dvidif, col=cld)
plotRGB(l2006, r=3, g=2, b=3, stretch="Lin") #withous NIR, as human would see it
pdf("energy.pdf")
par(mfrow=c(3,2))
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)
plot(dvidif, col=cld)
dev.off()

#pdf function: save the stuffs as PDF in the lab folder (images of the forest)

pdf("dvi.pdf")
par(mfrow=c(1,3))
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)
plot(dvidif, col=cld)
dev.off()

  
  
  
  
  
  
  
  
  
  
