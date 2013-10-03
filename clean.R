source('~/Documentos/R/load.R')

#Para simulacro iquique
startDate <- ISOdate(year=2013, month=08, day=08,hour=02, min=00, sec=00, tz="UTC")
endDate <- ISOdate(year=2013, month=08, day=08, hour=22, min=05, sec=00,tz="UTC")
df <- find_by_date(mo, dbns, startDate, endDate, 100000L)

#dates
df <- transform(df, readable_date=as.POSIXlt(date,tz="UTC",origin="1970-01-01"))