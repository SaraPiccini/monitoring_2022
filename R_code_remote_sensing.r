#R code for ecocystem monitoring by remote sensing 
#First of all, we need to install additional packages: raster
#raster package to manage image data
# https://cran.r-project.org/web/packages/raster/index.html
#quad when the package is outside R (install raster), quads as a protection, no quads when it's already inside R (library)
#raster: additional package (or library) for R in which we can use additional functions

install.packages("raster")

library(raster)
#now the software is ready to use raster

#import data in R from "lab"
#the function we use is called "brick" to create the "raster brick" (composite of all of the bands)
#this function is inside the raster package (raster: matrix with different pixels)
#we are going to exit R (using the quads)

setwd("/Users/sarapiccini/Desktop/lab") 

#GRD mens greed
# index with valus
#model to create this file
#HDR stating what is the name of the file and its info
#SDX
#we are going to import satallite data, PUTTING QUADS BECAUSE WE ARE GOING TO CATCH DATA OUTSIDE R

l2011 <- brick("p224r63_2011_masked.grd")

#Since we want to use this data in the future we put a name in front of the function
#Landsat is the satellite from 1972 cover the world every 14 days
#objects in R cannot be numbers

#in R objects have a class: several rasters 
#dataframe 
#dimension
#1 band with pizels , 1499 rows 2967 columns, 4447533 pixels, 7 layers (4 million time 7) 28 millions of pixels (data using)
#extent: meters
#source:
#bands: sre(
#reflectance: ratio between tha amount of the reflected energy
#the higer will be the reflectance the higher will be the amount of light catch by a sensor

plot(l2011)
#plot the data in order to see landscape (amazon forest) composed by different bands. Reflectances of bands  
#B1 is the amount of reflectance in the blue band
#B2 the amount of refelctance in the green band
#B3 red band
#B1 B2 B3 are the reflectance is the visible bands
#color palette can change in this way: 
#change the colors that we want to use to show the differend band
#to change the color form black(lowest value oh the reflectance) to lightgrey
#arrey of colors: put c

cl <- colorRampPalette(c("black", "grey", "light grey"))(100) 
plot(l2011, col=cl)

#100: how many tons in the palette from black to light grey (100 colors from black to light grey)
#colors always with quads
#now we see the same images of before but with different colors (black grey..)
#we can plot the in order to show some 
#rgb scheme: red blue green, basic colors used in computer
#and in Lancet we have first band, second band, third band..
#under the B component we put the first band
#G second
#R third

plotRGB(l2011, r=3, g=2, b=1, stretch="Lin")
#x: name of the file
#R:band to be put in the rad channel, B:band to be put in the blue channel
#strecht: how much we want to do the stretch
#we see the part of troipcal forest we are going to analyze, we can color it in different ways
#natural color image: how human see landscape since we are using oly green blue and red bands.

#associated
