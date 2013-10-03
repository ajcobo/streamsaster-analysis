library(rmongodb)


db <- "streamsaster_development"
ns <- "tweets"
dbns <- "streamsaster_development.tweets"
mo <- mongo.create()


find_by_date <- function(mo, dbns, startDate, endDate, chunk = 100000L){
  buf <- mongo.bson.buffer.create()
  mongo.bson.buffer.start.object(buf, "created_at")
  mongo.bson.buffer.append(buf, "$gt", startDate)
  mongo.bson.buffer.append(buf, "$lt", endDate)
  mongo.bson.buffer.finish.object(buf)
  query <- mongo.bson.from.buffer(buf)
  
  count <- mongo.count(mo, dbns, query)
  i <- 0
  while(i <= count){
    #Buscar las siguientes
    cursor <- mongo.find(mo, dbns, query,limit=chunk, skip=i)
    
    #Largo de los siguientes datos
    if(count > chunk){
      length <- chunk  
    } else{
      length <- count
    }
    
    if(i==0){
      mongo_frame = mongo_data_frame(mo, dbns, cursor, length)
    } else{
    new_frame = mongo_data_frame(mo, dbns, cursor, length)
    mongo_frame <- rbind(x=mongo_frame, y=new_frame) 
    }
    mongo.cursor.destroy(cursor)
    i <- i + length
  }
  result <- mongo_frame
  return(result)
}

#Transformar a data-frame
mongo_data_frame <- function(mo, dbns,cursor, count=0){
  i <- 1
  user <- vector("character", count)
  text <- vector("character", count)
  date <- seq(length=count)
  location <- vector("character", count) 
  friends_count <- vector("numeric", count)
  retweet_count <- vector("numeric", count)
  statuses_count <- vector("numeric", count)
  longitude <- vector("numeric", count) 
  latitude <- vector("numeric", count) 

  while (mongo.cursor.next(cursor)){
    v <- mongo.cursor.value(cursor)
    user[i] <- mongo.bson.value(v,"user")
    text[i] <- mongo.bson.value(v,"text")
    date[i] <- mongo.bson.value(v, "created_at")
    location[i] <- mongo.bson.value(v, "location") 
    friends_count[i] <- mongo.bson.value(v, "friends_count")
    retweet_count[i] <- mongo.bson.value(v, "retweet_count")
    statuses_count[i] <- mongo.bson.value(v, "statuses_count")
    if(mongo.bson.value(v, "coordinates")[1] == "NULL"){
      longitude[i] = 0.0
      latitude[i] = 0.0
    }
    else{
      longitude[i] <- mongo.bson.value(v, "coordinates")[1]
      latitude[i] <- mongo.bson.value(v, "coordinates")[2]
    }
    i <- i + 1
  }
  df <- as.data.frame(list(user=user, text=text, date=date, location=location, friends_count=friends_count, retweet_count=retweet_count, statuses_count=statuses_count, latitude=latitude, longitude=longitude),stringsAsFactors=FALSE)
  return(df)
}