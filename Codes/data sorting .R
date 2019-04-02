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
y <- list(land2000, land2001, land2002, land2003, land2004, land2005, land2006,
land2007, land2008, land2009, land2010, land2011, land2012, land2013, land2014, land2015, land2016, land2017, land2018)

for (i in 1:length(y)) {
  k <- as.data.frame(y[i])
  assign(paste("fland",i+1999,sep="") , k[!k$target_country == k$investor_country, ])
}
for (i in 1:length(y)) {
  y[i] <- as.data.frame(y[i])[, -5]
}
# 
k <- rbind(as.data.frame(table(fland2000$target_country)), as.data.frame(table(fland2000$investor_country)))
# get the data of non-country 426
c <- all[-which(all$investor_country %in% fall$investor_country), ]
c$investor_country <- as.factor(c$investor_country)
k = NULL
for (i in 1:length(c$deal_id)){
  a <- unlist(strsplit(c[i,]$investor_country, ", "))
  e <- is.element(c[i,]$target_country, a)
  k <- rbind(k,data.frame(c[i,]$deal_id, c[i,]$target_country, e))
}
colnames(k) <- c("ID","Country","co-investment")
write.csv("k","country_coinvesttment")
all[which(all$contract_size %in% "None"), ]$contract_size <- NA
all <- all[complete.cases(all$contract_size),]
all_co_investment <- all[all$deal_id %in% k[k$`co-investment` %in% "TRUE",]$ID, ]
# sum of the land deals for co-investment with local company 
9234107/71605729
#the deals invoving local company 
236/2378

# subsetting data 
annual <- NULL
z <- list(fland2000, fland2001, fland2002, fland2003, fland2004, fland2005, fland2006,
          fland2007, fland2008, fland2009, fland2010, fland2011, fland2012, fland2013, fland2014, fland2015, fland2016, fland2017, fland2018)
for (i in 1:length(z)) {
 a <-  as.data.frame(z[i])
 g <- length(a$deal_id)
 annual <- rbind(annual, data.frame(g))
}
year <- seq(2000,2018,1)
year <- as.character(year)
annual_deal <- cbind(year, annual)
colnames(annual_deal)[2] <- "Deals"
write.csv("annual_deal", "annual_deal")
library(openxlsx)
write.xlsx(read.csv("annual_deal"), "annual_deal.xlsx")
# plot 
n <- ggplot(data=annual_deal, aes(x=year, y=Deals, group=1)) +
  +     geom_line()

n + theme(axis.text.x = element_text(
                                     size=10, angle=45))


