library(ggplot2)
library(maps)
library(ggmap)

debug=TRUE
if(debug==FALSE){
source('~/Documentos/R/clean.R')
}

get_geotweets <- function(geo=TRUE){
  if(geo==TRUE){
    result <- df[df$latitude!=0.0,]
    return(result)
  }
  else{
    result <- df[df$latitude==0.0,]
    return(result)
  }
}

southamerica_map <- function(data){
  #Get world map info
  world_map <- map_data("world", c("Chile","Argentina", "Peru","Bolivia", "Uruguay", "Ecuador", "Colombia", "Brazil", "Paraguay", "Venezuela"))
  plot_map(world_map, data)
}

chile_map <- function(data){
  chile_map <- map_data("world", c("Chile"), xlim=c(-76.0,-68.0), ylim=c(-56.0, -17.5))
  plot_map(chile_map, data)
}

chile_ggmap <- (){
  
}

plot_map <- function(base_map, data){
  #Create a base plot
  p <- ggplot() + coord_map()
  
  #Add map to base plot
  world_map <- p + geom_polygon(data=base_map,aes(x=long,y=lat,group=group,alpha=0.9),colour="black",fill="#7109AA")
  map <- world_map + geom_jitter(data=data, aes(x=longitude, y=latitude),colour="#FFFF00")
  map
}

plot_ggmap <- function(base_map, data){
  map <- base_map + geom_jitter(data=data, aes(x=longitude, y=latitude),colour="#FF0000", size=1.5)
  map
}