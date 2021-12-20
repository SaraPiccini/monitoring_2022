# ice melt in green land - how to compare images at different time with regression
# proxy temperature - LST: land surface temperature (at land level, not earth)
library(raster)
library(patchwork) 
library(RStoolbox)
library(ggplot2)
library(viridis)
setwd("/Users/sarapiccini/Desktop/lab/greenland/")
# list and apply lapply function:
# list f files:
rlist <-  list.files(pattern="lst")
rlist
#import 4 layers separately
import <- lapply(rlist, raster) 
import
#stack of the files to take all data together - 4 layers together
tgr <- stack(import)
tgr
#plot stack
cl <- colorRampPalette(c("blue", "light blue", "pink", "yellow"))(100)
plot(tgr, col = cl)
#ggplot of first and final images 2000 vs. 2015
ggplot() + geom_raster(tgr$lst_2000, mapping = aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma") + ggtitle("LST in 2000")
ggplot() + geom_raster(tgr$lst_2015, mapping = aes(x=x, y=y, fill=lst_2015)) + scale_fill_viridis(option="magma") + ggtitle("LST in 2015")
# plot them together one beside the other
#before assigne them name 
p1 <- ggplot() + geom_raster(tgr$lst_2000, mapping = aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma") + ggtitle("LST in 2000")
p2 <- ggplot() + geom_raster(tgr$lst_2015, mapping = aes(x=x, y=y, fill=lst_2015)) + scale_fill_viridis(option="magma") + ggtitle("LST in 2015")
p1 + p2
#hist function to create an histogram
#plotting frequency distribution of data, (x=relative amount of values) 
par(mfrow=c(2,2))
hist(tgr$lst_2000)
hist(tgr$lst_2005)
hist(tgr$lst_2010) #the division between the two is higher
hist(tgr$lst_2015) #in 2015 there are two piks
#plot one variable on top of the other
#plot variable 2010 and 2015
plot(tgr$lst_2010, tgr$lst_2015)
abline(0,1,col="red")
#the function abline: choose intersect (a=0) and slope(b=1) of the line y = bx + a
#it is the line in which a and b have same values <- similar in all the distribution
#to make the line starting from zero:
plot(tgr$lst_2010, tgr$lst_2015, xlim=c(12500,15000), ylim=c(12500,15000))
abline(0,1,col="red")
# make plot with all the histograms and all the regression for all the variables
par(mfrow=c(4,4))
hist(tgr$lst_2000)
hist(tgr$lst_2005)
hist(tgr$lst_2010) 
hist(tgr$lst_2015)
plot(tgr$lst_2010, tgr$lst_2015, xlim=c(12500,15000), ylim=c(12500,15000))
plot(tgr$lst_2005, tgr$lst_2010, xlim=c(12500,15000), ylim=c(12500,15000))
plot(tgr$lst_2000, tgr$lst_2005, xlim=c(12500,15000), ylim=c(12500,15000))
plot(tgr$lst_2000, tgr$lst_2015, xlim=c(12500,15000), ylim=c(12500,15000))
plot(tgr$lst_2000, tgr$lst_2010, xlim=c(12500,15000), ylim=c(12500,15000))
plot(tgr$lst_2005, tgr$lst_2015, xlim=c(12500,15000), ylim=c(12500,15000))

#another solution: use the stack and pairs () function that creats scatterplot matrices. 
pairs(tgr)
#temperatures in 2015 with respect to T in 2000: rise especially in the lowest temperature (those guarantee ice)
#in the scatterplot we compare the temperatures of 2 different years with respect to one another and we use the abline (that represents the same T in the 2 different yeasr) to facilitate the visualization of the differences of temperature

