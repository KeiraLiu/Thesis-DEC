# how to get the repitated data 
unique() # this could get the data of the repited one: the specific name of the element 
table() # this could get the name of the data, then i could use the data of those two to find out the number of names 


# inserting data
all <- read_excel("Desktop/all.xlsx", sheet = "2000")
all2000 <- all 
# investor country
unique(all2000$investor_country)
table(all2000$investor_country)
# the data of intention 
y
unique(all2000$intention)
table(all2000$intention)
# using loop to deal with the multiple data 

# the total acreage of deals withint each targeted country from 2000 to 2018
all <- read.csv("~/Desktop/data of dec/data/all.csv", sep=";") # this is the total data 
# get data of each conutryand and calculate the sum of them 
for (i in seq_along(unique(all$target_country))) {
b <- all[which(all$target_country %in% i), ]
print(sum(as.numeric(b$intended_size)))
}
# how to create am empty dataframe 
x <- c("country", "intended_size")
colnames(d) <- x
# loop for target 
for (i in unique(all$target_country) ) {
  b <- all[which(all$target_country %in% i), ]
  c <- sum(as.numeric(b$intended_size))
  d = rbind(d, data.frame(i, c))
}
print(d)
# loop for investor 
d = NULL
for (i in unique(all$investor_country ) ) {
  b <- all[which(all$investor_country %in% i), ]
  c <- sum(as.numeric(b$intended_size))
  d = rbind(d, data.frame(i, c))
}
# how to remove the rows in r "-" 
c <- d[-which(d$country %in% d_iso$country), ]
# adding iso-3 to the data.frame
d_iso <- cbind(d_iso,iso)
colnames(c)[colnames(c)=="M"] <- "iso" # rename the col 
d_iso <- rbind(d_iso, c) # this is the final data of land governance with column name 
# derive the mean the deriations across regions 
# https://swcarpentry.github.io/r-novice-inflammation/15-supp-loops-in-depth/ how to write a function and apply it in the loop 
x <- list(ca_Africa, ca_aisa, ca_Americas, ca_Europe, ca_Oceania )
for (i in x) {
  k <- d_iso[which(d_iso$iso %in% i$alpha.3), ]
  m <- mean(k$intended_size)
  s <- sd(k$intended_size)
r =  rbind (r, data.frame(i,m,s))
}
Region <- c("africa", "aisa", "americas","europe","ocreania")
r <- r[,-1] # how to remove specific row of data,directly add "-" 
r <- cbind(Region,r)
colnames(r)[colnames(r)=="m"] <- "Mean"
colnames(r)[colnames(r)=="s"] <- "SD"
p <-  data.frame("Total", mean(d_iso$intended_size), sd(d_iso$intended_size))
colnames(p) <- c("Region","Mean", "SD")
r <- rbind(r, p) # adding the "total"
# the loop for LG
x <- list(ca_Africa, ca_aisa, ca_Americas, ca_Europe, ca_Oceania )
LG = NULL
for (i in x) {
  v <- LG_finaldata[ which(LG_finaldata$`ISO-3 code` %in% i$alpha.3), ]
  Mean <- mean(v$LG)
  SD <- sd(v$LG)
LG = rbind(LG, data.frame(Mean, SD))
}
LG <- cbind(Region, LG)
v <- data.frame("Total", mean(LG_finaldata$LG), sd(LG_finaldata$LG))
colnames(v) <- c("Region","Mean", "SD")
LG <- rbind(LG,v)
# reolace the "none" with NA for the production size 
all2000$production_size[which(all2000$production_size %in% "None")] <- NA # pay attention here, only NA is empty value
all2000$contract_size[which(all2000$contract_size %in% "None")] <- NA
all2000_complete <- all2000[complete.cases(all2000$production_size,all2000$contract_size),] # complete.cases: include all the stuff 
difference_land <- all2000_complete$contract_size - all2000_complete$production_size
all2000_complete <- cbind(all2000_complete, difference_land)
mean(all2000_complete$difference_land)
sd(all2000_complete$difference_land)

as.data.frame(table(all$intention))

# how to write csv to xlsx https://stackoverflow.com/questions/29186040/convert-a-csv-to-excel-without-using-xlsx-package?rq=1
library(openxlsx)
write.xlsx(read.csv("d.csv"), "d.xlsx")