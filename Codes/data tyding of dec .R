# find the different regions 
unique(CA$region)
unique(CA$sub.region)
# sorting data of ISO3 depend on the region 
ca_aisa <- CA[which(CA$region %in% "Asia"),]
ca_Europe <- CA[which(CA$region %in% "Europe"),]
ca_Oceania <- CA[which(CA$region %in% "Oceania"),]
ca_Americas <- CA[which(CA$region %in% "Americas"),]
ca_Africa <- CA[which(CA$region %in% "Africa"),]
# sorting data depend on the region
LG_aisa <- LG_finaldata[which(LG_finaldata$`ISO-3 code` %in% ca_aisa$alpha.3),]
LG_Europe <- LG_finaldata[which(LG_finaldata$`ISO-3 code` %in% ca_Europe$alpha.3),]
LG_Oceania <- LG_finaldata[which(LG_finaldata$`ISO-3 code` %in% ca_Oceania$alpha.3),]
LG_Americas <- LG_finaldata[which(LG_finaldata$`ISO-3 code` %in% ca_Americas$alpha.3),]
LG_Africa <- LG_finaldata[which(LG_finaldata$`ISO-3 code` %in% ca_Africa$alpha.3),]
# standard deviation/ mean 
LG_aisa_sd <- sd(LG_aisa$LG)
LG_aisa_mean <- mean(LG_aisa$LG)
LG_Europe_sd <- sd(LG_Europe$LG)
LG_Europe_mean <- mean(LG_Europe$LG)
LG_Oceania_sd <- sd(LG_Oceania$LG)
LG_Oceania_mean <- mean(LG_Oceania$LG)
LG_Americas_sd <- sd(LG_Americas$LG)
LG_Americas_mean <- mean(LG_Americas$LG)
LG_Africa_sd <- sd(LG_Africa$LG)
LG_Africa_mean <- mean(LG_Africa$LG)
LG_sd <- sd(LG_finaldata$LG)
LG_mean <- mean(LG_finaldata$LG)
# next step is to conduct on all quality of institutions
# what should I do with land deals? i want to work on the effects across investment factors: bifofuel and food crops  
# different targeted regions: 
                        
