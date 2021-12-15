# R code for uploading and visualizing Copernicus data in R
install.packages("ncdf4)
library(ncdf4)
library(raster)
setwd("/Users/sarapiccini/Desktop/lab/copernicus/")
#upload data: single layers data: raster function

DryMatterProd2020 <- raster("c_gls_DMP-RT0_202006300000_GLOBE_PROBAV_V2.0.1.nc")
DryMatterProd2020

plot(DryMatterProd2020)
