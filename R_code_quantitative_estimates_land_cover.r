R_code_quantitative_estimates_land_cover
# R_code_quantitative_estimates_land_cover
# forest: amount of cluster of trees, 3D structure forest
# package use
library(raster)
library(RStoolbox)
library(ggplot2)
setwd("/Users/sarapiccini/Desktop/lab")

#brick
# first, list the files available
rlist <- list.files(pattern="defor")
#defor as pattern for importing them directly
rlist #to see the name of the satellite images
# "defor1_.jpg" "defor2_.jpg" composed by NIR red and green, before and after the cut

#second point: lapply function:(apply a function to a list) list the files, apply functions to the list and the we made a stack of the satellite images
list_rast <- lapply(rlist, brick)
# x = name of the list we created, brick = function used to import them together
list_rast
#2 separate files (RasterBrick in the list_rast), in this conditions we do not use dollar because they are imported as separate files
#if we make a plot (use [[]] instead of $)
plot(list_rast[[1]])
# we want to treat them as separate so we do not use the stack function
#plot RGB. defor: NIR 1, red 2, green 3. everything will become red, since vegetation refects a lot in NIR
plotRGB(list_rast[[1]], r=1, g=2, b=3)
#put the NIR band on top component red of RGB
#re assign new name shorted (because the previous was a difficult name to read) to the function
l1992 <- list_rast[[1]]
plotRGB(l1992, r=1, g=2, b=3, stretch="lin")

l2006 <- list_rast[[2]]
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

#how to detect forest in the software to esitimate forest
#classify different land-use: forest and agriculture with the function
#we have an image with forest: all the pixels of the forest
#graph of reflectans with red(x) and NIR(y): pixel of forest low reflectans in red e high in nir (due to the mesofille structure)
#pixels of the forest all together in one point of the graph
#taking a pixel from agricultural area: low reflectans in NIR and high in red 
#pixels of agriculture in one area of the graph
#also water
#classification: explains to the software that pixels have names: forest and agriculture area and also water
#for classification we need RStoolbox and unsuperClass function that does unsupervised (tell software the amount of classes that we want at the end) 
#clusterin of raster data using kmeans clustering
#apply the graph 
#unsupervised classification
library(RStoolbox)
l1992c <- unsuperClass(l1992, nClasses=2)
#name of img, number of classes. in the name c as classified
l1992c
#map is linked to the object with the dollar. 
#modol: big object with several things inside 
#2 values: min 1 and max 2 = class number 1 (agricultural and water) and 2 (foster)

plot(l1992c$map)
#agricultural area + water class value 1 (white) and forest class value 2 (green)
#the continuous legend (numbers between 1 and 2) are not inside the map
#inside the map there are only two values 1 and 2
#frequencies of the pixel to know how many pixel inside the map are forest and how much agricultural areas
#freq function calculate the frequency of pixel of forest inside the map
freq(l1992c$map)
#model esimating the 2 area and the results could be different every time since it is an itertive procedure
#agricultural areas and water (class 1) = 35300
#forest (class 2) = 305992
#calculation of the proportion: 
#341292 total number of pixels
total <- 341292
#proportion of forest
propagri <- 35300 / 341292
propforest <- 305992 / total
propagri = 0.1034305 ~ 0.10
propforest = 0.8965695 ~ 0.90
#build a datafram 
cover <- c("Forest", "Agriculture")
prop1992 <- c(0.8965695, 0.1034305)
proportion1992 <- data.frame(cover, prop1992) #propootions of pixels in 1992
proportion1992
#plot them with ggplot2 library
library(ggplot2)
ggplot(proportion1992, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white") #create a new ggplot, syntax peculiar
#aesthetics: part which are coloring the graph
#create an histogram for example
#geom_bar function to make bars and so bar charts (type of the graph)

#day 2
library(raster)
> library(RStoolbox)
> library(ggplot2)
> setwd("/Users/sarapiccini/Desktop/lab")
rlist <- list.files(pattern="defor")
rlist
#[1] "defor1_.jpg" "defor2_.jpg"
#list_rast <- lapply(rlist, brick) #lapply(x, FUN)
#list_rast
l1992 <- list_rast[[1]]
l1992
l2006 <- list_rast[[2]]
l2006
plotRGB(l1992, r=1, g=2, b=3, stretch="lin")
l1992c <- unsuperClass(l1992, nClasses=2) #unsuperClass(x, nClasses) function + (argument: name of file and number of classes)
l1992c
plot(l1992c$map)
freq(l1992c$map)
#     value  count
#[1,]     1  35300
#[2,]     2 305992
> total <- 341292

propagri <- 35300 / 341292
propforest <- 305992 / total
propagri = 0.1034305 #~ 0.10
propforest = 0.8965695 #~ 0.90
#build a datafram 
cover <- c("Forest", "Agriculture")
prop1992 <- c(propforest, propagri) #istead of putting the number, we put objects
> proportion1992 <- data.frame(cover, prop1992) #propootions of pixels in 1992
> proportion1992
        cover  prop1992
1      Forest 0.8965695
2 Agriculture 0.1034305
> ggplot(proportion1992, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white")
> l2006c <- unsuperClass(l2006, nClasses=2) 
> l2006c

plot(l2006c$map)
freq(l2006c$map)
#     value  count
#[1,]     1 164230
#[2,]     2 178496
total <- 342726 
propagri <- 164230 / 342726
propforest <- 178496 / total
propagri
#[1] 0.4791875
propforest
#[1] 0.5208125
propagri = 0.4791875
propforest = 0.5208125
prop2006 <- c(propforest, propagri)
prop2006
#[1] 0.5208125 0.4791875
propagri2006 = 0.4791875
propforest2006 = 0.5208125
prop2006 <- c(propforest2006, propagri2006) #instead of putting the number, we put objects (always better to use it instead of numbers)
proportion2006 <- data.frame(cover, prop2006)
proportion2006
#        cover  prop2006
#1      Forest 0.5208125
#2 Agriculture 0.4791875
total2006 <- 342726 
# proportions:
propagri2006 <- 164230 / 342726
propforest2006 <- 178496 / total
propagri2006 = 0.4791875
propforest2006 = 0.5208125
#dataframe:
cover <- c("Forest", "Agriculture")
prop2006 <- c(propforest2006, propagri2006) #instead of putting the number, we put objects (always better to use it instead of numbers)
proportion2006 <- data.frame(cover, prop2006) #propootions of pixels in 1992
proportion2006 
        cover  prop2006
#1      Forest 0.5208125
#2 Agriculture 0.4791875
proportion <- data.frame(cover, prop1992, prop2006)
proportion
 #       cover  prop1992  prop2006
#1      Forest 0.8965695 0.5208125
#2 Agriculture 0.1034305 0.4791875


ggplot(proportion2006, aes(x=cover, y=prop2006, color=cover)) + geom_bar(stat="identity", fill="white")
ggplot(proportion, aes(x=cover, y=prop2006, color=cover)) + geom_bar(stat="identity", fill="white")

library(gridExtra)

p1 <- ggplot(proportion1992, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white")
p2 <- ggplot(proportion2006, aes(x=cover, y=prop2006, color=cover)) + geom_bar(stat="identity", fill="white")
grid.arrange(p1, p2, nrow=1)
