# with estimates: dynamic linear estimate 
# list squares dummy avriable model 
all / DDCG / disasters_final/ iqf / lg / 
  pfi / vix_final/ pg / 
nd <-   disasters_final 
pg <- Population_grwoth_of_China
lg <- Land_Governance_final
iqf <- institutional_quality_final

fixed.dum <- lm(all$Size ~ pfi[1:17,]$index + pg$GR + vix_final$vix + nd$occurrence + 
                   iqf$average + lg$LG + factor(all$Country))
write.csv()
# how to conduct the whole panel data

Cprice = NA
all <- cbind(all, Cprice)
countries <- unique(all$iso)
years <- unique(all$Year)
for (i in years) {
  all[all$Year == i,]$Cprice <- pfi[pfi$Year == i ,]$index
}

PGR = NA
all <- cbind(all,PGR)
for (i in years) {
  all[all$Year == i,]$PGR <- pg[pg$Year == i ,]$GR
}

vix_index = NA
all <- cbind(all, vix_index)
for (i in years) {
  all[all$Year == i,]$vix_index <- vix_final[vix_final$year == i ,]$vix
}

ndc = NA
all <- cbind(all,ndc)
countries <- unique(all$iso)
for (i in countries) {
  for(j in unique(all[all$iso == i,]$Year)){
    if (all[all$iso== i,]$Year==j & j==nd[nd$iso == i,]$iso) {
  all$ndc <- nd$occurrence
    } else
    {
      all$ndc <- NA 
    }
  }
}


for(j in unique(all[all$Country == i,]$Year)){
  all[all$Year == j & all$iso == i,]$ndc <- nd[nd$year == j & nd$iso == i, ]$occurrence
}

