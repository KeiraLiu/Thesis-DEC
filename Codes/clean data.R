# sorting all the rest data
iso = NA
all <- all[,-6]
all <- cbind.data.frame(all, iso)
names <- unique(all$Country)
for (i in names){
  all[all$Country == i,]$iso <- ISO[ISO$name == i, ]$`alpha-3`
}

disasters_final <- disasters[which(disasters$iso %in% all$iso),]
institutional_quality_final <- institutional_quality[which(institutional_quality$`Country Code` %in% all$iso),]
colnames(institutional_quality_final)[10] <- "average"
Land_Governance_final <- Land_Governance[which(Land_Governance$`ISO-3 code` %in% all$iso),]
institutional_quality_final <- institutional_quality_final[institutional_quality_final$Time > 1999,]

# deal with the pfi
for (i in 1:length(pfi$Commodity)){
a <- unlist(strsplit(pfi[i,]$Commodity, "M"))
pfi[i,]$Commodity <- a[1]
}

pfi <- pfi[pfi$Commodity > 1999, ]
write.csv(pfi, "pfi")
# vix
for (i in 1:length(vix$Year)){
  a <- unlist(strsplit(vix[i,]$Year, "/"))
  vix[i,]$Year <- a[3]
}
vix <- vix[vix$Year >1999,]
k = NULL
years <- unique(vix$Year)
for (i in years){
  b <- mean(vix[vix$Year == i, ]$vix)
  k <- rbind(k,data.frame(b))
}
vix_final <- as.data.frame(k[-20,])
vix_final <- cbind(years[-20],vix_final)
colnames(vix_final) <- c("year", "vix")

DDCG <- DDCG[which(DDCG$code %in% all$iso), ]