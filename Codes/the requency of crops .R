# how to read the data from different sheet 
library(readx1)
x <- seq(2000, 2018,1)
x <- as.character(x)
for (i in x){
  assign(paste("all", i, sep = ""),read_excel("~/Desktop/Thesis/data of dec/land deals /all.xlsx", 
                                                   sheet = i))

}
# getting the frequency of the crops each year: split and count 
y <- list(all2000, all2001, all2002, all2003, all2004, all2005, all2006, all2007,
          all2008, all2009, all2010, all2011,  all2012, all2013, all2014,
          all2015, all2016, all2017, all2018)
for (i in 1:length(y) ) {
k <- as.data.frame(y[i])
a <- unlist(strsplit(k$crop, ","))
assign(paste("crop", 1999+i, sep = ""), data.frame(table(a)) )
}
# pay attention here, each time for splitting the data, need to observe carefully 
# what is the split mark there, and write it correctly in the functioin
all_freq <- as.data.frame(table(unlist(strsplit(all$crop, ", "))))
all_freq <- all_freq[with(all_freq, order(-Freq)), ] 
# how to fix the order using with function



# how to write the data into csv and xlsx 
write.csv(all_freq, "all_freq_crops")
library(openxlsx)
write.xlsx(read.csv("all_freq_crops"), "all_freq_crops.xlsx" ) 
# remember here, i must need to add xlsx
