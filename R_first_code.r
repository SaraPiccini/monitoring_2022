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

#view(streams): let you view the graph of data
