# R code for species distribution modelling mainly distribution on individuals of a population in space
install.packages("sdm") #species distribution models 
library(sdm)
# we going to use this for populations' studies: check for single species: individuals from same species
# we use data inside tha package, we do not need to set the working directory since data are already in
library(raster) #predictors
library(rgdal) #geospatial data abstraction library - species

#use of "system.file" function that shows all the files in a certain package called sdm
file <- system.file("external/species.shp", package="sdm")
#shp extention: shape file-point related to the species(presence-absence)
#explain the name of the file we are taking the files
#path in which we have the data:"/Library/Frameworks/R.framework/Versions/4.1/Resources/library/sdm/external/species.shp"
#if we take this path and we put it in our file systems we will find our species data

#recreating a ship file inside r with the shapefile function, we are importing this data
species <- shapefile(file) #exactly as the raster function for raster files. These are points(vector of coordinates)
plot(species, pch=19, col="red") #points scattered in space 


