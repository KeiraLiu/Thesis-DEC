# get the frequency of intention for each year 
y <- list(all2000, all2001, all2002, all2003, all2004, all2005, all2006, all2007, all2008,all2009, all2010,all2011,all2012,
          all2013, all2014, all2015,all2016,all2017,all2018)
w <- c("all2000", "all2001", "all2002", "all2003", "all2004", "all2005_in", "all2006_in", "all2007_in", "all2008_in",
               "all2009_in", "all2010_in","all2011_in","all2012_in",
               "all2013_in", "all2014_in", "all2015_in","all2016_in","all2017_in","all2018_in") 
for (i in y) {
  j <- as.data.frame(table(i$intention))
  print(j)
}
# how to give the name of each new data.frame
for (i in y) {
   for (j in w){
       assign(j,as.data.frame(table(i$intention)))
       write.csv(j,"j")
     } 
}
# get the difference of contract size and the production size across different years 
h = NULL # always forgot the genereate this first 
for (i in y) {
i$production_size[which(i$production_size %in% "None")] <- NA # pay attention here, only NA is empty value
i$contract_size[which(i$contract_size %in% "None")] <- NA
k <- i[complete.cases(i$production_size,i$contract_size),] # complete.cases: include all the stuff 
k$contract_size <- as.numeric(k$contract_size)
k$production_size <- as.numeric(k$production_size)
difference_land <- k$contract_size - k$production_size
k <- cbind(k, difference_land)
h <- rbind(h, data.frame(mean(k$difference_land), sd(k$difference_land)))
}
colnames(h) <- c("Mean", "SD")
Year <- seq(2000, 2018, by = 1)
h <- cbind(Year, h)
write.csv(h,"Difference_size_year")
plot(h$Year, h$Mean,type = "l")
# the difference of contract size and the production size across different countries  
all$production_size[which(all$production_size %in% "None")] <- NA # pay attention here, only NA is empty value
all$contract_size[which(all$contract_size %in% "None")] <- NA
all_complete<- all[complete.cases(all$production_size,all$contract_size),]
v <- unique(all_complete$target_country)
diff = NULL
for(i in v){
 k <- all_complete[which(all_complete$target_country %in% i),] 
 k$contract_size <- as.numeric(k$contract_size)
 k$production_size <- as.numeric(k$production_size)
 difference_land <- mean(k$contract_size) - mean(k$production_size)
 diff <- rbind(diff, data.frame(i,difference_land))
}
write.csv(diff,"Difference_size_conutry")
# the difference of contract size and the production size across different regions
diff_iso <- diff[which(diff$i %in% country.name$name ),] # the sequence of vaiables matters the results
iso_diff <- iso_diff$alpha.3
iso_diff <- country.name[which(diff$i %in% country.name$name),]
iso_diff <- iso_diff$alpha.3
x <- list(ca_Africa, ca_aisa, ca_Americas, ca_Europe, ca_Oceania)
diff_region = NULL
for (i in x) {
  v <- diff[which(diff$iso_diff %in% i$alpha.3), ]
  Mean <- mean(v$difference_land)
  SD <- sd(v$difference_land)
  diff_region = rbind(diff_region, data.frame(Mean, SD))
}
diff_region <- cbind(Region, diff_region)
total <-  data.frame("Total", mean(diff$difference_land), sd(diff$difference_land))
colnames(total) <- c("Region","Mean", "SD")
diff_region <- rbind(diff_region, total)
write.csv(diff_region, "diff_region_size")

