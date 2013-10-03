library(rmongodb)
library(ggplot2)

loadMongo <- (){
db <- "streamsaster_development"
ns <- "tweets"
dbns <- "streamsaster_development.tweets"
mo <- mongo.create()
}