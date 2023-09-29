library(terra)

setwd("")

################################################################################
################# Einladen der Daten ###########################################

#### Feuer Daten
# Load all MODIS data:
dat <- list.files("data/fire_europe", pattern = ".FireMask", full.names = TRUE)
dat <- rast(c(dat))
#plot(dat)
dat
################################################################################
### Pixel Klassen (https://lpdaac.usgs.gov/products/mod14a2v061/)
# 0 -> not processed
# 1 -> not processed
# 2 -> not processed
# 3 -> Non-fire water pixel
# 4 -> Cloud
# 5 -> Non-fire land pixel
# 6 -> Unknown
# 7 -> Fire low confidence
# 8 -> Fire nominal confidence
# 9 -> Fire high confidence

# Zusammenfassen zu kein Feuer (0 bis 6) und Feuer (7 bis 9)
freq(dat[[1]]) # 7,8,9 -> 110 Pixel

m <- c(0, 6.1, 0,
       6.9, 9.1, 1)
rclmat <- matrix(m, ncol=3, byrow=TRUE)
fire <- classify(dat,rclmat, 
                 right=TRUE,include.lowest=TRUE)
freq(fire[[1]]) # 1 sollte 110 sein
# -> kein Feuer = 0; Feuer = 1

################################################################################
# Feuerereignisse aufsummieren

fire_freq <- sum(fire, na.rm=TRUE)
plot(fire_freq)

writeRaster(fire_freq,"data/fire/fire_freq.tif", overwrite=TRUE)

################################################################################
################################################################################
fire
landcover <- rast("data/copernicus/Corine_land_cover_eu_100m_2018.tif")
landcover

# fire umprojizieren in EPSG:3035
#fire_proj <- project(fire, "EPSG:3035", method = "near", res = c(926.6254, 926.6254))
# oder direkt einladen
fire_proj <- rast("data/fire/fire_projected.tif")
plot(fire_proj)

#writeRaster(fire_proj,
#            "data/fire/fire_projected.tif",
#            overwrite = TRUE)

# Raster ist sehr groß und wird deswegen auf relevante Koordinaten gekürzt

plot(fire_proj)

fire_crop <- crop(fire_proj, landcover, inverse = FALSE)
#fire_crop <- rast("data/fire/fire_crop.tif")
plot(fire_crop)

#writeRaster(fire_crop,
#            "data/fire/fire_crop.tif",
#            overwrite = TRUE)

################################################################################
