source('~/Documentos/R/func.R')
library(ggplot2)
library(maps)
library(ggmap)
library(plyr)


data <- get_geotweets()

#Southamerica
southamerica_map(data)

#map from Chile
base_url <- get_map(location=c(lon=-70.137234,lat=-20.232241), zoom=13, maptype="roadmap")
base_ggmap <- ggmap(base_url)
plot_ggmap(base_ggmap, data)

#filter data from Chile y=-17.5 -56 x=-76 -68
#chile_data <- data[data$latitude < -17.5 & data$latitude > -56 & data$longitude < -68 & data$longitude > -76,]

#Términos
simulacro_data <- data[grepl("simulacro", data$text),]

#Prueba
#count(simulacro_data, "readable_date")
#test <- transform(simulacro_data, day= format(readable_date, "%Y/%m/%d - %H"))
test <- transform(simulacro_data, day= format(readable_date, "%H"))
test
counts <- ddply(test, .(day), nrow)
counts


p <- ggplot(counts, aes(x=day, y=V1))
z <- p + geom_histogram()
z
