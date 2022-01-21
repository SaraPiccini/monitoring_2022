# R code for species distribution modelling mainly distribution on individuals of a population in space
install.packages("sdm") #species distribution modelling package
library(sdm) #spatial package
# we going to use this for populations' studies: check for single species: individuals from same species
# we use data inside tha package, we do not need to set the working directory since data are already in
library(raster) #predictors: environmental variable - help in predicting species distributions
library(rgdal) #geospatial data abstraction library - species - coordinate data with value (vector data: array of coordinates)

#use of "system.file" function that shows all the files in a certain package called sdm
file <- system.file("external/species.shp", package="sdm") #species data (path, package used and name it) 
#shp extention: shape file-point related to the species(presence-absence)
#prj = info about coordinate system of out data UTM-zones
#shx = links every data to a line
#explain the name of the file we are taking the files
#path in which we have the data:"/Library/Frameworks/R.framework/Versions/4.1/Resources/library/sdm/external/species.shp"
#if we take this path and we put it in our file systems we will find our species data
file #we can see the path -> inside the external folder there are the data
#recreating a shape file inside r with the shapefile function, we are importing this data
species <- shapefile(file) #exactly as the raster function for raster files (correspondence function of raster). These are points(vector of coordinates)
species #datarame, each row of the table are point: spatial point dataframe 
#200 points inside , 1 variable (called occurence: 0 r 1 if you find or not the species)
species$Occurrence #200 occurences with 1 or 0 to each species
#language used for subsetting data
#how many occurrences are there? use [] to make a subset - if you want to subset the occurerences == 1 or 0 (for negative query(!=)
species[species$Occurrence == 1,] #control symbol: used to explain that the query has finished : the comma (,)
#94 are the occurrences = 1
species[species$Occurrence == 0,] #200-94=106
#we can built a new dataframe with only presences assigning it to a new object: -  manner to subset DataFrame
presences <- species[species$Occurrence == 1,]
absences <- species[species$Occurrence == 0,]
#plot
plot(species, pch=19) #points scattered in space - distribution of species in an area
#plotting only presences of the species
plot(presences, pch=19, col="blue") #lower amount of points since we only have presences
#add to the presences plot also the absences: add additional points to the previous plot - plot together presences and absences
points(absences, pch=19, col="red") #plot in-situ data
#presences in blue and absences in red
#Probability to find species or not - species distribution model based on raster dataset (T+elevation+water availability) - use of predictors
#look at the predictors
#raster data: path in which they are located: only external not specifying single files because we want all
path <- system.file("external", package="sdm")
path #folder in which rasterdata - all predictors have same extention (ASC): ASCII useful extention (sort of txt) - code for info interchange
#predictors are contained inside same folderrs of species but with extention asc  
#list files function: list files inside a certain folder (path in our case-external folder) - common pattern for files: asc
lst <- list.files(path, pattern="asc", full.names=TRUE) #list of the files -> vegetation T elevation precipitation
#you can use ethe lapply function with the raster function but in this case it is not needed since data are inside the package and they have an asc extention
#stack of the list 
preds <- stack(lst)
preds
#plot predictors: change colorRampPalette - to high light max values put  YELLOW color
cl <- colorRampPalette(c('blue','orange','red','yellow')) (100)
plot(preds, col=cl) 

plot(preds$elevation, col=cl)
points(presences, pch=19) #most of the points are in the low elevation parts and not in the peaks

plot(preds$temperature, col=cl)
points(presences, pch=19) #it will be found at higher T - not at very low T

plot(preds$vegetation, col=cl)
points(presences, pch=19) #where there is vegetation cover and the species avoid parts where there is no vegetation

plot(preds$precipitation, col=cl)
points(presences, pch=19) #distribution of the species: medium intermediate precipitation level

# day 2
#importing the source script
#set working directory to upload the entire script
setwd("/Users/sarapiccini/Desktop/lab/")

source("R_code_source_sdm.r")
#source function: read R code from a file - quads for outside-R file
#in the theoretical slide of SDMs we schould use individuals of a species and predictors
preds #predicotrs imported: elevation, precipitation, temperature, vegetation

#to do the model we explain to the software the data we are going to use
#training data (species data) we tell the model where the species are 
#sdmData create sdm Data object
#let's explain to the model what are the training and predictors data
datasdm <- sdmData(train=species, predictors=preds)
#train=species: data we have imported with presences and absences 
#explanatory variables:another word used for predictors (explain a variable-direct correlation)
datasdm
#class=description of a certain object(ex:class of table:dataframe)
#features:predictors
#sdm function: fit and evaluate species distribution model
#linear model:lm 
m1 <- sdm(Occurrence~temperature+elevation+precipitation+vegetation, data=datasdm, methods = "glm")
#variable use ad y:occurrence, ~:math equal, variable use as xs:T, elevation, precipitation, vegetation
#the model will calculate slope(b) and intecept(a) of the straight line: y=bx+a, y2=b2x2+a, y3=b3x3+a..
#data we use:datasdm and finally we need the method to use to build the model (linear model)
#generalized linear model when dealing with more variables all normally distributed (assumption) as in this case
#GAM:generalize additive model (non parametric models): for non-normally distributed variables
m1
#array/vector of methods to usemore methods at once
#the model produced slope and intercept, now we use this model and make prediction: for each pixel what is the probability of presence based on the line(method, prediction)
#corresponding each slope to each predictors -> final prediction of presence of species in space

#predict the speed of spreading of a species in a certain area
#applay the formula y=bx+a starting from the parameters, to the 4 predictors to have the final prediction
#if you make a model than you can make a prediction with this function:
p1 <- predict(m1, newdata=preds) #map probability (prediction)
p1
#explain model we are using. Applay the parameters of the model to predictors
#it is a raster layer. plot the prediction:
plot(p1, col=cl) #preiction of the probability of the presence of species
#goodness of feed: plot the presencies and we can expect that some part of the model will be more or less good.
points(presences, pch=19)
#plot preferences together with p1 with this function to add points into the picture
#we have the prediction of the presence of the species: located in the part of high probability to find it so the model is good
#on the west the model is not in line with original data, we can see some indidivuals: there could be additional predictors important 
#for the species and we are not considering them
#probability of occurrence in the map

#final stack with everything all together
s1 <- stack(preds, p1)
s1
plot(s1, col=cl)
#you can find species in the yellow probability (yellow color for the higher value of what you want to see)
#change the name of s1 - reassign the name to the new array:
names(s1) <- c('Elevation', 'Precipitation', 'Temperature', 'Vegetation', 'Model')
plot(s1, col=cl) 
#now the picture is called model
names(s1) <- c('Elevation', 'Precipitation', 'Temperature', 'Vegetation', 'Probability')
plot(s1, col=cl)
#we can put any names and make any change we wont to rename the pictures
#this type of model can be applied to any variables

