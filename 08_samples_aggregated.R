################################################################################
library(terra)
library(mapview)
library(sf)
library(caret)
library(dplyr)
setwd("")

################################################################################

fire <- rast("data/aggregated/fire_agg.tif")
#pred_f <- rast("data/aggregated/pred_f_agg.tif")
pred_c <- rast("data/aggregated/pred_c_agg.tif")

names(pred_c)
#names(pred_f)

################################################################################
#Koordinaten ziehen und rausschreiben
################################################################################

# Maske mit nur Landmasse erstellen, um passende Punkte zu ziehen
europe_crop <- subst(pred_c$landcover, from = 128, to = NA)
europe_crop <- subst(europe_crop, from = 44, to = NA)
plot(europe_crop)

#Koordinaten ziehen
coords<- spatSample(europe_crop, 20000, method="random", replace=F, na.rm=T, as.df=T, values=F, xy=T)
sample<-as.data.frame(coords)

#test <- st_as_sf(sample, coords = c("x", "y"), crs = 3035)
#mapview(test)

#ggflls ausschreiben/einlesen

write.table(coords, file="data/aggregated/coords.csv", sep=";", col.names = T, row.names = T)
coords<-read.csv2("data/aggregated/coords.csv", sep=";", header=T)



################################################################################
#Einfügen der einzelnen Prädiktorenausprägungen in Tabelle
################################################################################

firetest <- extract(fire$sum, coords, method="simple")
sample$fire <- firetest$sum

firetest$landcover <- extract(pred_c$landcover, coords, method="simple")
sample$landcover <-firetest$landcover$landcover

firetest$leaftype <- extract(pred_c$leaftype, coords, method="simple")
sample$leaftype <-firetest$leaftype$leaftype

firetest$foresttype <- extract(pred_c$foresttype, coords, method="simple")
sample$foresttype <-firetest$foresttype$foresttype

################################################################################
### tmax
################################################################################

firetest$tmax_01 <- extract(pred_c$tmax_01, coords, method="simple")
sample$tmax_01 <-firetest$tmax_01$tmax_01

firetest$tmax_02 <- extract(pred_c$tmax_02, coords, method="simple")
sample$tmax_02 <-firetest$tmax_02$tmax_02

firetest$tmax_03 <- extract(pred_c$tmax_03, coords, method="simple")
sample$tmax_03 <-firetest$tmax_03$tmax_03

firetest$tmax_04 <- extract(pred_c$tmax_04, coords, method="simple")
sample$tmax_04 <-firetest$tmax_04$tmax_04

firetest$tmax_05 <- extract(pred_c$tmax_05, coords, method="simple")
sample$tmax_05 <-firetest$tmax_05$tmax_05

firetest$tmax_06 <- extract(pred_c$tmax_06, coords, method="simple")
sample$tmax_06 <-firetest$tmax_06$tmax_06

firetest$tmax_07 <- extract(pred_c$tmax_07, coords, method="simple")
sample$tmax_07 <-firetest$tmax_07$tmax_07

firetest$tmax_08 <- extract(pred_c$tmax_08, coords, method="simple")
sample$tmax_08 <-firetest$tmax_08$tmax_08

firetest$tmax_09 <- extract(pred_c$tmax_09, coords, method="simple")
sample$tmax_09 <-firetest$tmax_09$tmax_09

firetest$tmax_10 <- extract(pred_c$tmax_10, coords, method="simple")
sample$tmax_10 <-firetest$tmax_10$tmax_10

firetest$tmax_11 <- extract(pred_c$tmax_11, coords, method="simple")
sample$tmax_11 <-firetest$tmax_11$tmax_11

firetest$tmax_12 <- extract(pred_c$tmax_12, coords, method="simple")
sample$tmax_12 <-firetest$tmax_12$tmax_12

################################################################################
### tmin
################################################################################

firetest$tmin_01 <- extract(pred_c$tmin_01, coords, method="simple")
sample$tmin_01 <-firetest$tmin_01$tmin_01

firetest$tmin_02 <- extract(pred_c$tmin_02, coords, method="simple")
sample$tmin_02 <-firetest$tmin_02$tmin_02

firetest$tmin_03 <- extract(pred_c$tmin_03, coords, method="simple")
sample$tmin_03 <-firetest$tmin_03$tmin_03

firetest$tmin_04 <- extract(pred_c$tmin_04, coords, method="simple")
sample$tmin_04 <-firetest$tmin_04$tmin_04

firetest$tmin_05 <- extract(pred_c$tmin_05, coords, method="simple")
sample$tmin_05 <-firetest$tmin_05$tmin_05

firetest$tmin_06 <- extract(pred_c$tmin_06, coords, method="simple")
sample$tmin_06 <-firetest$tmin_06$tmin_06

firetest$tmin_07 <- extract(pred_c$tmin_07, coords, method="simple")
sample$tmin_07 <-firetest$tmin_07$tmin_07

firetest$tmin_08 <- extract(pred_c$tmin_08, coords, method="simple")
sample$tmin_08 <-firetest$tmin_08$tmin_08

firetest$tmin_09 <- extract(pred_c$tmin_09, coords, method="simple")
sample$tmin_09 <-firetest$tmin_09$tmin_09

firetest$tmin_10 <- extract(pred_c$tmin_10, coords, method="simple")
sample$tmin_10 <-firetest$tmin_10$tmin_10

firetest$tmin_11 <- extract(pred_c$tmin_11, coords, method="simple")
sample$tmin_11 <-firetest$tmin_11$tmin_11

firetest$tmin_12 <- extract(pred_c$tmin_12, coords, method="simple")
sample$tmin_12 <-firetest$tmin_12$tmin_12

################################################################################
# prec
################################################################################

firetest$prec_01 <- extract(pred_c$prec_01, coords, method="simple")
sample$prec_01 <-firetest$prec_01$prec_01

firetest$prec_02 <- extract(pred_c$prec_02, coords, method="simple")
sample$prec_02 <-firetest$prec_02$prec_02

firetest$prec_03 <- extract(pred_c$prec_03, coords, method="simple")
sample$prec_03 <-firetest$prec_03$prec_03

firetest$prec_04 <- extract(pred_c$prec_04, coords, method="simple")
sample$prec_04 <-firetest$prec_04$prec_04

firetest$prec_05 <- extract(pred_c$prec_05, coords, method="simple")
sample$prec_05 <-firetest$prec_05$prec_05

firetest$prec_06 <- extract(pred_c$prec_06, coords, method="simple")
sample$prec_06 <-firetest$prec_06$prec_06

firetest$prec_07 <- extract(pred_c$prec_07, coords, method="simple")
sample$prec_07 <-firetest$prec_07$prec_07

firetest$prec_08 <- extract(pred_c$prec_08, coords, method="simple")
sample$prec_08 <-firetest$prec_08$prec_08

firetest$prec_09 <- extract(pred_c$prec_09, coords, method="simple")
sample$prec_09 <-firetest$prec_09$prec_09

firetest$prec_10 <- extract(pred_c$prec_10, coords, method="simple")
sample$prec_10 <-firetest$prec_10$prec_10

firetest$prec_11 <- extract(pred_c$prec_11, coords, method="simple")
sample$prec_11 <-firetest$prec_11$prec_11

firetest$prec_12 <- extract(pred_c$prec_12, coords, method="simple")
sample$prec_12 <-firetest$prec_12$prec_12


################################################################################
#elevation, slope, aspect
################################################################################

firetest$elevation <- extract(pred_c$elevation, coords, method="simple")
sample$elevation <-firetest$elevation$elevation

firetest$slope <- extract(pred_c$slope, coords, method="simple")
sample$slope <-firetest$slope$slope

firetest$aspect <- extract(pred_c$aspect, coords, method="simple")
sample$aspect <-firetest$aspect$aspect

################################################################################


####
#Ausschreiben
write.table(sample, file="data/aggregated/sample.csv", sep=";", col.names = T, row.names = T)


#Kontrolleinlesen
sample1 <- read.csv2("data/aggregated/sample.csv", sep=";", header=T)

head(sample)
table(sample$fire)











