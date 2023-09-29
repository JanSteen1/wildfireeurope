library(terra)
library(geodata)
setwd("")

################################################################################
#### Daten einladen

fire <- rast("data/fire/fire_freq.tif")
fire_proj <- rast("data/fire/fire_projected.tif")
fire_crop <- rast("data/fire/fire_crop.tif")

# download full resolution wordclim data here: https://www.worldclim.org/data/worldclim21.html

#### 
# 1. für Projektion entscheiden -> EPSG:3035 (Corine)
# 2. alles umprojizieren
# 3. alles croppen auf Ausmaß der Feuer Pixel
# 4. alles resamplen auf Ausmaß der Feuer Pixel
# 5. Rasterstack der Prädiktoren erstellen
# 6. Ergebnisse ausschreiben
################################################################################


# srad

#srad <- worldclim_global(var="srad", res=0.5, path=("data/srad"), version="2.1")
srad <- list.files("data/srad/wc2.1_30s", full.names = TRUE, pattern = ".tif")
srad <- rast(c(srad))
################################################################################

srad
# projezierte Auflösung ist die der Feuer Frequenz
#srad_proj <- project(srad, "EPSG:3035", method = "bilinear")
srad_proj <- rast("data/srad/srad_projected.tif")

srad_crop <- crop(srad_proj, fire_crop, extend = TRUE)
srad_res <- resample(srad_crop, fire_crop, method ="bilinear")

srad_res
plot(srad_res)

writeRaster(srad_proj,
            "data/srad/srad_projected.tif",
            overwrite = TRUE)
writeRaster(srad_res,
            "data/srad/srad_resampled.tif",
            overwrite = TRUE)
################################################################################


### wind

wind <- worldclim_global(var="wind", res=0.5, path=("data/wind"), version="2.1")
wind <- list.files("data/wind/wc2.1_30s", full.names = TRUE, pattern = ".tif")
wind <- rast(c(wind))
################################################################################

wind
# projezierte Auflösung ist die der Feuer Frequenz
wind_proj <- project(wind, "EPSG:3035", method = "bilinear", threads = TRUE)
#wind_proj <- rast("data/wind/wind_projected.tif")

wind_crop <- crop(wind_proj, fire_crop, extend = TRUE)
wind_res <- resample(wind_crop, fire_crop, method ="bilinear")

wind_res
plot(wind_res[[8]])

writeRaster(wind_proj,
            "data/wind/wind_projected.tif",
            overwrite = TRUE)
writeRaster(wind_res,
            "data/wind/wind_resampled.tif",
            overwrite = TRUE)
################################################################################
