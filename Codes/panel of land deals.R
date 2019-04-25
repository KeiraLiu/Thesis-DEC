# getting all the data
x <- seq(2000,2018,1)
x <- as.character(x)
for (i in x) {
  assign(paste("land", i,sep="") ,read_excel("//wurnet.nl/Homes/liu213/AppData/FolderRedirection/Desktop/final data/land deals.xlsx", 
                                             sheet = i))
}
# clean the data with none
y <- list(land2000, land2001, land2002, land2003, land2004, land2005, land2006,
          land2007, land2008, land2009, land2010, land2011, land2012, land2013, land2014, land2015, land2016, land2017, land2018)
all <- lapply(list(land2000, land2001, land2002, land2003, land2004, land2005, land2006,
                   land2007, land2008, land2009, land2010, land2011, land2012, land2013, land2014, land2015, land2016, land2017, land2018), 
              function(k) { k <-  k[-which(k$contract_size %in% "None"), ] })
k =NULL
for (i in 1:length(all)) {
  assign(paste("land", 1999+i,sep=""), as.data.frame(all[i]))

}


#land_deals[which(land_deals$contract_size %in% "None"), ]$contract_size <- NA
#land_deals <- land_deals[complete.cases(land_deals$contract_size),]
y <- list(land2000, land2001, land2002, land2003, land2004, land2005, land2006,
          land2007, land2008, land2009, land2010, land2011, land2012, land2013, land2014, land2015, land2016, land2017, land2018)
for (i in 1:length(y)){
k <- as.data.frame(y[i])
deals <- as.data.frame(table(k$target_country))
name <- deals$Var1
d = NULL
for (j in name){
  b <- sum(as.numeric(k[k$target_country == j,]$contract_size))
  d <- rbind(d,data.frame(b))
}
assign(paste("landc", 1999+i,sep=""), cbind(as.data.frame(table(k$target_country)), d))
}
# creating years 
y  <- seq(2000,2018,1)
y <- list(landc2000, landc2001, landc2002, landc2003, landc2004, landc2005, landc2006,
  landc2007, landc2008, landc2009, landc2010, landc2011, landc2012, landc2013, landc2014, landc2015, landc2016, landc2017, landc2018)
for (i in 1:length(y)){
  k <- as.data.frame(y[i])
year <- rep(1999+i, length(k$b))
k <- cbind(k,year)
assign(paste("landc", 1999+i,sep=""),k)
}

all <- rbind(landc2000, landc2001, landc2002, landc2003, landc2004, landc2005, landc2006,
             landc2007, landc2008, landc2009, landc2010, landc2011, landc2012, landc2013, landc2014, landc2015, landc2016, landc2017, landc2018)
all <- all[order(all$Var1),]
colnames(all) <- c("Country", "Deals", "Size","Year")
# store the data
write.csv(all,"all")

k = NULL
>  for( i in countries) {
+      b <- land_all[land_all$Area == i,]
+      k <- rbind(k,data.frame(b))
+  }
