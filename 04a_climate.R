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

# tmin

#tmin <- worldclim_global(var="tmin", res=0.5, path=("data/tmin"), version="2.1")
tmin <- list.files("data/tmin/wc2.1_30s", full.names = TRUE, pattern = ".tif")
tmin <- rast(c(tmin))
################################################################################

tmin
# projezierte Auflösung ist die der Feuer Frequenz
tmin_proj <- project(tmin, "EPSG:3035", method = "bilinear")
#tmin_proj <- rast("data/tmin/tmin_projected.tif")
  
tmin_crop <- crop(tmin_proj, fire_crop, extend = TRUE)
tmin_res <- resample(tmin_crop, fire_crop, method ="bilinear")

tmin_res
plot(tmin_res)

writeRaster(tmin_proj,
            "data/tmin/tmin_projected.tif",
            overwrite = TRUE)
writeRaster(tmin_res,
            "data/tmin/tmin_resampled.tif",
            overwrite = TRUE)
################################################################################


### tmax

#tmax <- worldclim_global(var="tmax", res=0.5, path=("data/tmax"), version="2.1")
tmax <- list.files("data/tmax/wc2.1_30s", full.names = TRUE, pattern = ".tif")
tmax <- rast(c(tmax))
################################################################################

tmax
# projezierte Auflösung ist die der Feuer Frequenz
#tmax_proj <- project(tmax, "EPSG:3035", method = "bilinear", threads = TRUE)
tmax_proj <- rast("data/tmax/tmax_projected.tif")

tmax_crop <- crop(tmax_proj, fire_crop, extend = TRUE)
tmax_res <- resample(tmax_crop, fire_crop, method ="bilinear")

tmax_res
plot(tmax_res)

writeRaster(tmax_proj,
            "data/tmax/tmax_projected.tif",
            overwrite = TRUE)
writeRaster(tmax_res,
            "data/tmax/tmax_resampled.tif",
            overwrite = TRUE)
################################################################################


# tavg

#tavg <- worldclim_global(var="tavg", res=0.5, path=("data/tavg"), version="2.1")
tavg <- list.files("data/tavg/wc2.1_30s", full.names = TRUE, pattern = ".tif")
tavg <- rast(c(tavg))
################################################################################

tavg
# projezierte Auflösung ist die der Feuer Frequenz
tavg_proj <- project(tavg, "EPSG:3035", method = "bilinear", threads = TRUE)
#tavg_proj <- rast("data/tavg/tavg_projected.tif")

tavg_crop <- crop(tavg_proj, fire_crop, extend = TRUE)
tavg_res <- resample(tavg_crop, fire_crop, method ="bilinear")

tavg_res
plot(tavg_res)

writeRaster(tavg_proj,
            "data/tavg/tavg_projected.tif",
            overwrite = TRUE)
writeRaster(tavg_res,
            "data/tavg/tavg_resampled.tif",
            overwrite = TRUE)
################################################################################


# prec

#prec <- worldclim_global(var="prec", res=0.5, path=("data/prec"), version="2.1")
prec <- list.files("data/prec/wc2.1_30s", full.names = TRUE, pattern = ".tif")
prec <- rast(c(prec))
################################################################################

prec
# projezierte Auflösung ist die der Feuer Frequenz
prec_proj <- project(prec, "EPSG:3035", method = "bilinear", threads = TRUE)
#prec_proj <- rast("data/prec/prec_projected.tif")

prec_crop <- crop(prec_proj, fire_crop, extend = TRUE)
prec_res <- resample(prec_crop, fire_crop, method ="bilinear")

prec_res
plot(prec_res[[1]])

writeRaster(prec_proj,
            "data/prec/prec_projected.tif",
            overwrite = TRUE)
writeRaster(prec_res,
            "data/prec/prec_resampled.tif",
            overwrite = TRUE)
################################################################################


