library(terra)
library(geodata)
library(dplyr)
library(sf)
library(mapview)
setwd("")


################################################################################
#### projizierte, aber nicht weiter verarbeitete Daten einladen

fire <- rast("data/fire/fire_crop.tif")

landcover <- rast("data/copernicus/Corine_land_cover_eu_100m_2018.tif")
foresttype <- rast("data/copernicus/dominant_forest_type_eu_2018_10m.tif")
leaftype   <- rast("data/copernicus/dominant_leaf_type_eu_2018_10m.tif")

tmin       <- rast("data/tmin/tmin_projected.tif")
tmax       <- rast("data/tmax/tmax_projected.tif")
tavg       <- rast("data/tavg/tavg_projected.tif")
prec       <- rast("data/prec/prec_projected.tif")
srad       <- rast("data/srad/srad_projected.tif")
wind       <- rast("data/wind/wind_projected.tif")
vapr       <- rast("data/vapr/vapr_projected.tif")

elevation  <- rast("data/elevation/elevation_projected.tif")
slope      <- rast("data/elevation/slope_projected.tif")
aspect     <- rast("data/elevation/aspect_projected.tif")

#############################################################################
#######################
#IDEE:
#######################
#Klimadaten etc zusammenfassen nach Jahreszeiten

#tmax_spring<-mean(tmax[[3]], tmax[[4]],tmax[[5]], na.rm=T)
#tmax_summer<-mean(tmax[[6]], tmax[[7]],tmax[[8]], na.rm=T)
#tmax_autumn<-mean(tmax[[9]], tmax[[10]],tmax[[11]], na.rm=T)
#tmax_winter<-mean(tmax[[12]], tmax[[1]],tmax[[2]], na.rm=T)

#plot(tmax_spring)


################################################################################
#Namen vereinfachen
################################################################################

names(landcover)<-"landcover"
names(leaftype)<-"leaftype"
names(foresttype)<-"foresttype"

names(tmax) <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
names(tmin) <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
names(tavg) <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
names(prec) <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
names(vapr) <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
names(srad) <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
names(wind) <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

names(elevation) <- c("elevation")


################################################################################
#Koordinaten ziehen und rausschreiben
################################################################################

# Maske mit nur Landmasse erstellen, um passende Punkte zu ziehen
europe_crop <- subst(landcover, from = 128, to = NA)
europe_crop <- subst(europe_crop, from = 44, to = NA)
plot(europe_crop)

#Koordinaten ziehen
coords<- spatSample(europe_crop, 20000, method="random", replace=F, na.rm=T, as.df=T, values=F, xy=T)
sample<-as.data.frame(coords)

#test <- st_as_sf(sample, coords = c("x", "y"), crs = 3035)
#mapview(test)

#ggflls ausschreiben/einlesen

write.table(coords, file="data/coords.csv", sep=";", col.names = T, row.names = T)
coords<-read.csv2("data/coords.csv", sep=";", header=T)



#ausprobieren
#test <- st_as_sf(sample, coords = c("x", "y"), crs = 3035)
#mapview(test)



################################################################################
#Einfügen der einzelnen Prädiktorenausprägungen in Tabelle
################################################################################

firetest <- extract(fire$sum, coords, method="simple")
sample$fire <- firetest$sum

firetest$landcover <- extract(landcover, coords, method="simple")
sample$landcover <-firetest$landcover$landcover

firetest$leaftype <- extract(leaftype, coords, method="simple")
sample$leaftype <-firetest$leaftype$leaftype

firetest$foresttype <- extract(foresttype, coords, method="simple")
sample$foresttype <-firetest$foresttype$foresttype

################################################################################
#tmax
################################################################################

firetest$tmax1 <- extract(tmax[[1]], coords, method="simple")
sample$tmax_01 <-firetest$tmax1$Jan

firetest$tmax2 <- extract(tmax[[2]], coords, method="simple")
sample$tmax_02 <-firetest$tmax2$Feb

firetest$tmax3 <- extract(tmax[[3]], coords, method="simple")
sample$tmax_03 <-firetest$tmax3$Mar

firetest$tmax4 <- extract(tmax[[4]], coords, method="simple")
sample$tmax_04 <-firetest$tmax4$Apr

firetest$tmax5 <- extract(tmax[[5]], coords, method="simple")
sample$tmax_05 <-firetest$tmax5$May

firetest$tmax6 <- extract(tmax[[6]], coords, method="simple")
sample$tmax_06 <-firetest$tmax6$Jun

firetest$tmax7 <- extract(tmax[[7]], coords, method="simple")
sample$tmax_07 <-firetest$tmax7$Jul

firetest$tmax8 <- extract(tmax[[8]], coords, method="simple")
sample$tmax_08 <-firetest$tmax8$Aug

firetest$tmax9 <- extract(tmax[[9]], coords, method="simple")
sample$tmax_09 <-firetest$tmax9$Sep

firetest$tmax10 <- extract(tmax[[10]], coords, method="simple")
sample$tmax_10 <-firetest$tmax10$Oct

firetest$tmax11 <- extract(tmax[[11]], coords, method="simple")
sample$tmax_11 <-firetest$tmax11$Nov

firetest$tmax12 <- extract(tmax[[12]], coords, method="simple")
sample$tmax_12 <-firetest$tmax12$Dec


################################################################################
#tmin
################################################################################

firetest$tmin1 <- extract(tmin[[1]], coords, method="simple")
sample$tmin_01 <-firetest$tmin1$Jan

firetest$tmin2 <- extract(tmin[[2]], coords, method="simple")
sample$tmin_02 <-firetest$tmin2$Feb

firetest$tmin3 <- extract(tmin[[3]], coords, method="simple")
sample$tmin_03 <-firetest$tmin3$Mar

firetest$tmin4 <- extract(tmin[[4]], coords, method="simple")
sample$tmin_04 <-firetest$tmin4$Apr

firetest$tmin5 <- extract(tmin[[5]], coords, method="simple")
sample$tmin_05 <-firetest$tmin5$May

firetest$tmin6 <- extract(tmin[[6]], coords, method="simple")
sample$tmin_06 <-firetest$tmin6$Jun

firetest$tmin7 <- extract(tmin[[7]], coords, method="simple")
sample$tmin_07 <-firetest$tmin7$Jul

firetest$tmin8 <- extract(tmin[[8]], coords, method="simple")
sample$tmin_08 <-firetest$tmin8$Aug

firetest$tmin9 <- extract(tmin[[9]], coords, method="simple")
sample$tmin_09 <-firetest$tmin9$Sep

firetest$tmin10 <- extract(tmin[[10]], coords, method="simple")
sample$tmin_10 <-firetest$tmin10$Oct

firetest$tmin11 <- extract(tmin[[11]], coords, method="simple")
sample$tmin_11 <-firetest$tmin11$Nov

firetest$tmin12 <- extract(tmin[[12]], coords, method="simple")
sample$tmin_12 <-firetest$tmin12$Dec

################################################################################
#tavg
################################################################################

firetest$tavg1 <- extract(tavg[[1]], coords, method="simple")
sample$tavg_01 <-firetest$tavg1$Jan

firetest$tavg2 <- extract(tavg[[2]], coords, method="simple")
sample$tavg_02 <-firetest$tavg2$Feb

firetest$tavg3 <- extract(tavg[[3]], coords, method="simple")
sample$tavg_03 <-firetest$tavg3$Mar

firetest$tavg4 <- extract(tavg[[4]], coords, method="simple")
sample$tavg_04 <-firetest$tavg4$Apr

firetest$tavg5 <- extract(tavg[[5]], coords, method="simple")
sample$tavg_05 <-firetest$tavg5$May

firetest$tavg6 <- extract(tavg[[6]], coords, method="simple")
sample$tavg_06 <-firetest$tavg6$Jun

firetest$tavg7 <- extract(tavg[[7]], coords, method="simple")
sample$tavg_07 <-firetest$tavg7$Jul

firetest$tavg8 <- extract(tavg[[8]], coords, method="simple")
sample$tavg_08 <-firetest$tavg8$Aug

firetest$tavg9 <- extract(tavg[[9]], coords, method="simple")
sample$tavg_09 <-firetest$tavg9$Sep

firetest$tavg10 <- extract(tavg[[10]], coords, method="simple")
sample$tavg_10 <-firetest$tavg10$Oct

firetest$tavg11 <- extract(tavg[[11]], coords, method="simple")
sample$tavg_11 <-firetest$tavg11$Nov

firetest$tavg12 <- extract(tavg[[12]], coords, method="simple")
sample$tavg_12 <-firetest$tavg12$Dec

################################################################################
#prec
################################################################################

firetest$prec1 <- extract(prec[[1]], coords, method="simple")
sample$prec_01 <-firetest$prec1$Jan

firetest$prec2 <- extract(prec[[2]], coords, method="simple")
sample$prec_02 <-firetest$prec2$Feb

firetest$prec3 <- extract(prec[[3]], coords, method="simple")
sample$prec_03 <-firetest$prec3$Mar

firetest$prec4 <- extract(prec[[4]], coords, method="simple")
sample$prec_04 <-firetest$prec4$Apr

firetest$prec5 <- extract(prec[[5]], coords, method="simple")
sample$prec_05 <-firetest$prec5$May

firetest$prec6 <- extract(prec[[6]], coords, method="simple")
sample$prec_06 <-firetest$prec6$Jun

firetest$prec7 <- extract(prec[[7]], coords, method="simple")
sample$prec_07 <-firetest$prec7$Jul

firetest$prec8 <- extract(prec[[8]], coords, method="simple")
sample$prec_08 <-firetest$prec8$Aug

firetest$prec9 <- extract(prec[[9]], coords, method="simple")
sample$prec_09 <-firetest$prec9$Sep

firetest$prec10 <- extract(prec[[10]], coords, method="simple")
sample$prec_10 <-firetest$prec10$Oct

firetest$prec11 <- extract(prec[[11]], coords, method="simple")
sample$prec_11 <-firetest$prec11$Nov

firetest$prec12 <- extract(prec[[12]], coords, method="simple")
sample$prec_12 <-firetest$prec12$Dec


################################################################################
#vapr
################################################################################

firetest$vapr1 <- extract(vapr[[1]], coords, method="simple")
sample$vapr_01 <-firetest$vapr1$Jan

firetest$vapr2 <- extract(vapr[[2]], coords, method="simple")
sample$vapr_02 <-firetest$vapr2$Feb

firetest$vapr3 <- extract(vapr[[3]], coords, method="simple")
sample$vapr_03 <-firetest$vapr3$Mar

firetest$vapr4 <- extract(vapr[[4]], coords, method="simple")
sample$vapr_04 <-firetest$vapr4$Apr

firetest$vapr5 <- extract(vapr[[5]], coords, method="simple")
sample$vapr_05 <-firetest$vapr5$May

firetest$vapr6 <- extract(vapr[[6]], coords, method="simple")
sample$vapr_06 <-firetest$vapr6$Jun

firetest$vapr7 <- extract(vapr[[7]], coords, method="simple")
sample$vapr_07 <-firetest$vapr7$Jul

firetest$vapr8 <- extract(vapr[[8]], coords, method="simple")
sample$vapr_08 <-firetest$vapr8$Aug

firetest$vapr9 <- extract(vapr[[9]], coords, method="simple")
sample$vapr_09 <-firetest$vapr9$Sep

firetest$vapr10 <- extract(vapr[[10]], coords, method="simple")
sample$vapr_10 <-firetest$vapr10$Oct

firetest$vapr11 <- extract(vapr[[11]], coords, method="simple")
sample$vapr_11 <-firetest$vapr11$Nov

firetest$vapr12 <- extract(vapr[[12]], coords, method="simple")
sample$vapr_12 <-firetest$vapr12$Dec

################################################################################
#srad
################################################################################

firetest$srad1 <- extract(srad[[1]], coords, method="simple")
sample$srad_01 <-firetest$srad1$Jan

firetest$srad2 <- extract(srad[[2]], coords, method="simple")
sample$srad_02 <-firetest$srad2$Feb

firetest$srad3 <- extract(srad[[3]], coords, method="simple")
sample$srad_03 <-firetest$srad3$Mar

firetest$srad4 <- extract(srad[[4]], coords, method="simple")
sample$srad_04 <-firetest$srad4$Apr

firetest$srad5 <- extract(srad[[5]], coords, method="simple")
sample$srad_05 <-firetest$srad5$May

firetest$srad6 <- extract(srad[[6]], coords, method="simple")
sample$srad_06 <-firetest$srad6$Jun

firetest$srad7 <- extract(srad[[7]], coords, method="simple")
sample$srad_07 <-firetest$srad7$Jul

firetest$srad8 <- extract(srad[[8]], coords, method="simple")
sample$srad_08 <-firetest$srad8$Aug

firetest$srad9 <- extract(srad[[9]], coords, method="simple")
sample$srad_09 <-firetest$srad9$Sep

firetest$srad10 <- extract(srad[[10]], coords, method="simple")
sample$srad_10 <-firetest$srad10$Oct

firetest$srad11 <- extract(srad[[11]], coords, method="simple")
sample$srad_11 <-firetest$srad11$Nov

firetest$srad12 <- extract(srad[[12]], coords, method="simple")
sample$srad_12 <-firetest$srad12$Dec

################################################################################
#wind
################################################################################

firetest$wind1 <- extract(wind[[1]], coords, method="simple")
sample$wind_01 <-firetest$wind1$Jan

firetest$wind2 <- extract(wind[[2]], coords, method="simple")
sample$wind_02 <-firetest$wind2$Feb

firetest$wind3 <- extract(wind[[3]], coords, method="simple")
sample$wind_03 <-firetest$wind3$Mar

firetest$wind4 <- extract(wind[[4]], coords, method="simple")
sample$wind_04 <-firetest$wind4$Apr

firetest$wind5 <- extract(wind[[5]], coords, method="simple")
sample$wind_05 <-firetest$wind5$May

firetest$wind6 <- extract(wind[[6]], coords, method="simple")
sample$wind_06 <-firetest$wind6$Jun

firetest$wind7 <- extract(wind[[7]], coords, method="simple")
sample$wind_07 <-firetest$wind7$Jul

firetest$wind8 <- extract(wind[[8]], coords, method="simple")
sample$wind_08 <-firetest$wind8$Aug

firetest$wind9 <- extract(wind[[9]], coords, method="simple")
sample$wind_09 <-firetest$wind9$Sep

firetest$wind10 <- extract(wind[[10]], coords, method="simple")
sample$wind_10 <-firetest$wind10$Oct

firetest$wind11 <- extract(wind[[11]], coords, method="simple")
sample$wind_11 <-firetest$wind11$Nov

firetest$wind12 <- extract(wind[[12]], coords, method="simple")
sample$wind_12 <-firetest$wind12$Dec

################################################################################
#elevation, slope, aspect
################################################################################

firetest$elevation <- extract(elevation, coords, method="simple")
sample$elevation <-firetest$elevation$elevation

firetest$slope <- extract(slope, coords, method="simple")
sample$slope <-firetest$slope$slope

firetest$aspect <- extract(aspect, coords, method="simple")
sample$aspect <-firetest$aspect$aspect




####
#Ausschreiben
write.table(sample, file="data/sample.csv", sep=";", col.names = T, row.names = T)


#Kontrolleinlesen
sample1 <- read.csv2("data/sample.csv", sep=";", header=T)




