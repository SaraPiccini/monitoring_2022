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
#set the working directory everytime you use raster
#GRD mens greed 
# index with valus
#model to create this file
#HDR stating what is the name of the file and its info
#SDX
#we are going to import satallite data, PUTTING QUADS BECAUSE WE ARE GOING TO CATCH DATA OUTSIDE R (from the working directory) 
#and using brick function: raterbricck (multi-layer) 

l2011 <- brick("p224r63_2011.grd")

#Since we want to use this data in the future we put a name in front of the function
#Landsat is the satellite from 1972 cover the world every 14 days
#objects in R cannot be numbers

#in R objects have a class: several rasters 
#dataframe 
#dimension
#1 band with pizels , 1499 rows 2967 columns, 4447533 pixels, 7 layers (4 million time 7) 28 millions of pixels (data using)
#extent: meters
#source:
#bands: sre(sensors)
#reflectance: ratio between tha amount of the reflected energy
#the higer will be the reflectance the higher will be the amount of light catch by a sensor

plot(l2011)
#plot the data in order to see landscape (amazon forest) composed by different bands. Reflectances of bands  
#B1 is the amount of reflectance in the blue band
#B2 the amount of refelctance in the green band
#B3 is the reflectans in the red band
#B4 is the reflectans in the NIR band
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

library(raster)
#set the folder in which data are: called working directory - set the working directory:
#function for working directory:
setwd("/Users/sarapiccini/Desktop/lab")
l2011 <- brick("p224r63_2011.grd") 
#grd:greed (set of pixel) #brick function creates a raster file: RasterBrick

#B1 is the amount of reflectance in the blue band called (B1_sre)
#B2 is the amount of refelctance in the green band called (B2_sre)
#B3 is the reflectans in the red band called (B3_sre)
#B4 is the reflectans in the NIR (near infra-red) band called (B4_sre)
#each pixel has the reflectans in a certain band 
#pixel resolution is 30 m

#plot the green band(B2)
#see the name of this band in our file: B2_sre(spectral reflectance)
#object:l2011
#how to link the object and the name of the file of the green band in R: use the symbol $
plot(l2011$B2_sre) 
#plot is the function, the argument is the thing inside the parenthesis
#to change it change the skin of the colors with this function:
#the colorRampPalette function is estending the color palette to another color (we can choose the color we want)
cl <- colorRampPalette (c("black", "grey", "light grey"))(100)
#everything that absorb the green light (no reflectans=0) will become black, light grey means a lor of reflectans of the green band
#grey for medium reflectans of green light
#100 = numbers od different color we use from black to light grey
#narrow to associate the object (colorRampPalette) to a name (cl)

plot(l2011$B2_sre, col=cl)

#change the colorRampPalette from dark green to light green:
clg <- colorRampPalette (c("dark green", "green", "light green"))(100)
plot(l2011$B2_sre, col=clg)

#do the same for the blue band using dark blue , blue, and light blue
#name of the blue band (we can see this on r): B1_sre
clb <- colorRampPalette (c("dark blue", "blue", "light blue")) (100)
plot(l2011$B1_sre, col=clb)

#function "par": set or query graphical parametres: can change 
#multiframe: put first and second plot in one frame: we put one row and two colomns 
#oper a new window called multiframe and we put the green and blue plot in one row and two colomns
#plot both images in just one multiframe graph:
par(mfrow=c(1,2)) #1 row and 2 colomns (the first number is the number of rows in the multiframe 
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

par(mfrow=c(2,1)) #2 rows and 1 colomn 
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

#colors do not exist, they're just a convention, they're just in out brain

#to reverse the pattern and have the green before the blue, since it's a sequence of function:
par(mfrow=c(2,1))
plot(l2011$B2_sre, col=clg)
plot(l2011$B1_sre, col=clb)

plot(l2011$B1_sre) #image of the reflectans of the pixels of the landscape in the blue
#change colors to see better: plot the blue band using a blue colorRampPalette
clb <- colorRampPalette(c("dark blue", "blue", "light blue")) (100)
#build a multiframe: build a multi-plot: 1 row of plots and 2 colomns. Plot the blue and the green besides, with different colorRampPalette
par(mfrow=c(1,2))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

#plot the blue and green besides, with different colorRampPalette
par(mfrow=c(2,1))
clb <- colorRampPalette(c("dark blue","blue","light blue"))(100)
plot(l2011$B1_sre, col=clb)
clg <- colorRampPalette(c("dark green","green","light green"))(100)
plot(l2011$B2_sre, col=clg)
#plot the first four bands with 2 rows and 2 columns (plot all bands)
par(mfrow=c(2,2))
clb <- colorRampPalette(c("dark blue","blue","light blue"))(100)
plot(l2011$B1_sre, col=clb)
clg <- colorRampPalette(c("dark green","green","light green"))(100)
plot(l2011$B2_sre, col=clg)
clr <- colorRampPalette(c("dark red", "red", "pink"))(100)
plot(l2011$B3_sre, col=clr)
clnir <- colorRampPalette(c("red", "orange", "yellow"))(100)
plot(l2011$B4_sre, col=clnir)

#RGB composition of colors: 3 main colors(red green blue) and then you mix them to obtain the others
#function to clean: close the plot device: dev.off
dev.off()
#plotRGB: put the satellite image and then the different layers (the red, blue and green chanel with the correspondent bands)
plotRGB(l2011, r=3, g=2, b=1, stretch="Lin") #natural colours
#stretch argument: stretching the values to let us see the colors better
#to extend our view to the infra-red: plants:huge reflectans in the near-infrared
#switch from band 1,2,3, to band 2,3,4 to use infra-red band shifting by one
plotRGB(l2011, r=4, g=3, b=2, stretch="Lin") #false colours
#vegetation is red now becase of the near-infrared band in which vegetation reflects a lot
#now we can see some part changed and the agricultural area besides the forest
#to change the chanel in which we are going to put the near infra-red:
plotRGB(l2011, r=3, g=4, b=2, stretch="Lin")
#now we see very fluo green, and now we can see better umidity, where water in passing in the forest and in violet agricultural soil
plotRGB(l2011, r=3, g=2, b=4, stretch="Lin")
#to see how much deforestation, all of the bear soil = yellow parts 

#multiframe with these immages
par(mfrow=c(2,2))
plotRGB(l2011, r=3, g=2, b=1, stretch="Lin")
plotRGB(l2011, r=4, g=3, b=2, stretch="Lin")
plotRGB(l2011, r=3, g=4, b=2, stretch="Lin")
plotRGB(l2011, r=3, g=2, b=4, stretch="Lin")
#exploratory analysis
#multi-temporal analysis: how the situation has changed from the past (1988-2021)

#final day on this tropical forest reserve
plotRGB(l2011, r=4, g=3, b=2, stretch="Lin")
#strech to visualize data
#linear stretch : from 0 to 1: to allow our eyes to better see the colours 
#plants absorb blue and red and reflect green and near-infrared

#another function 
#instead of using a line we can enhance the function
#histogram strectch is the name of the function with "S" shape curve
plotRGB(l2011, r=4, g=3, b=2, stretch="Hist")

#import data from 1988
#use the brick function
l1988 <- brick("p224r63_1988.grd")
l1988
#quads since we are exiting R
#we have the same bands and the same resolution as before
#to plot them in the same window (2 rows and 1 column) we use he multi-frame using par function
par(mfrow=c(2,1))
plotRGB(l1988, r=4, g=3, b=2, stretch="Lin")  
plotRGB(l2011, r=4, g=3, b=2, stretch="Lin")
#monitoring on how things change in time
#in 1988 the forest was there, then they started build agricultural area and in 2011 we have several parts related to agriculture.

#make use of NIR in other wavelands. If we put the NIR (near infra-red) in the blue channel which become yellow
par(mfrow=c(2,1))
plotRGB(l2011, r=2, g=3, b=4, stretch="Lin")
plotRGB(l1988, r=2, g=3, b=4, stretch="Lin")



