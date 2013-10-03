loadMongo <- (){
options(java.parameters = "-Xmx2g")
library(rJava)
library(RMongo)
m <- mongoDbConnect('streamsaster_development')
}
#t <- head(q)
#c <- substr(t$coordinates,3,23)
#a <- strsplit(c," , ")
#coor <- as.numeric(a[[1]])

fmt <- "%a %b %d %H:%M:%S CLT %Y"
res <- dbGetQuery(m,'tweets',"",skip=0,limit=200000)
result <- transform(res, days= weekdays(as.Date(created_at,fmt)) )
result.days <- factor(result$days, levels = c('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'), ordered=TRUE)
table(result.days)

