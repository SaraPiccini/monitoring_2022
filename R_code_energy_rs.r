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
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
#put the near infra-red in the red component
#defor1_.1= near infra-red (everything is becoming red because plant reflects a lor in the NIR)
#defor1_.2 = red
#defor1_.3 = green
plotRGB(l1992, r=2, g=1, b=3, stretch="Lin") #now everything will become green 
plotRGB(l1992, r=2, g=3, b=1, stretch="Lin") #now everything will become blue (everything that is vegetation)
#no bear soil (white ore yellow area), we can see the river.
#the river is not black (it should be if there were only pure water), but white like bear soil becuase of the reflection of some algaes and soil (eutrophization)
