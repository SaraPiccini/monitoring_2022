# This is my first code in github 

# Here are the input data 
# Costanza data on streams
water <- c(100, 200, 300, 400, 500)
water

# Marta data on fishes genomes
fishes <- c(10, 50, 60, 100, 200)
fishes

#plot the diversity of fishes (y) versus the amount of water (x)
plot(water, fishes)

#dataframe will connect each single water values to each one of the fishes
#Every data we developped can be stored in a table, and every table is called data frame 

streams <- data.frame(water, fishes)

#view(streams): let you view the tables of data. Taking the water data and the fishes data and put them in the table
#in the first side we have water and in the left side fishes)

#from now on we are going to import or export data
#setwd("/Users/sarapiccini/Desktop/lab") always use this one for the folder
#setwd: set the working directory: the folder in which the data are foldered

setwd("/Users/sarapiccini/Desktop/lab")

# let's export our table!
# search in google: how can i write a table in r: write.table(x, file=name of the file)
# in R we have a function than the (and than the argument and the arguments are separated by commas)
# x is the object and the object name for us in "streams")
# File individualize the name of the file outside of R
# put the quads onec you exit

write.table(streams, file="my_first_table_txt" )

#now we have the output table "streams" in the folder "lab" in the desktop.  
#some collegues did send us a table - how to import it in R 
#google: "how can I import the table in R"
#from outside entering R, catch the table

read.table("my_first_table_txt")
#we can assign the table to a name to have an object- let's assign it to an object inside R
saratable <- read.table("my_first_table_txt")

#the first statistics for lazy people
#summary of the data: find it in google.
#we can see median, mean, first and third quintiles
summary(saratable)

#to find only median or mean write this:
#mean(c(data divided by commas))
#median(c(data divided by commas))

#marta does not want water data, she wants to get info only on fishes
#to have the summary only on fishes we do:
summary(saratable$fishes)

#to see the graph of the variable with each frequecy
#hist (x)
# x is an object (ex:fishes data)
#histogram
hist(saratable$fishes)

#we can do te same for water
summary(saratable$water)
hist(saratable$water)


     
