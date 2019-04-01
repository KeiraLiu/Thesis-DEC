# the data of land deals: the thing i need to remeber is that the names of 
# data.frame must be chacaters with number cannot only be number
library(readxl)
x <- seq(2000,2018,1)
x <- as.character(x)

for (i in x) {
  assign(paste("land", i,sep="") ,read_excel("~/Desktop/land_deals.xlsx", 
                      sheet = i))
}
# getting the frequency of the land deals, by country, ruling out the deals which are investor countries
a <- land2000[!land2000$target_country == land2000$investor_country, ]
h <- as.data.frame(table(land2000$investor_country))
