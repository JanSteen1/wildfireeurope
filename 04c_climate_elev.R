library(terra)
library(geodata)
setwd("")

################################################################################
#### Daten einladen

fire_crop <- rast("data/fire/fire_crop.tif")

# download full resolution wordclim data here: https://www.worldclim.org/data/worldclim21.html

################################################################################

vapr
tmin
elevation
slope
aspect

################################################################################
################################################################################
### vapr

vapr <- list.files("data/vapr/wc2.1_30s", full.names = TRUE, pattern = ".tif")
vapr <- rast(c(vapr))
################################

vapr_proj <- project(vapr, "EPSG:3035", method = "bilinear", threads = TRUE)

vapr_crop <- crop(vapr_proj, fire_crop, extend = TRUE)
vapr_res <- resample(vapr_crop, fire_crop, method ="bilinear")

vapr_res
plot(vapr_res)

writeRaster(vapr_proj,
            "data/srad/vapr_projected.tif",
            overwrite = TRUE)
writeRaster(vapr_res,
            "data/srad/vapr_resampled.tif",
            overwrite = TRUE)
################################################################################
################################################################################
### tmin

tmin <- list.files("data/tmin/wc2.1_30s", full.names = TRUE, pattern = ".tif")
tmin <- rast(c(tmin))
################################

tmin_proj <- project(tmin, "EPSG:3035", method = "bilinear", threads = TRUE)

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
################################################################################
### elevation

elevation <- rast("data/wc2.1_30s_elev.tif")
################################

elevation_proj <- project(elevation, "EPSG:3035", method = "bilinear", threads = TRUE)

elevation_crop <- crop(elevation_proj, fire_crop, extend = TRUE)
elevation_res <- resample(elevation_crop, fire_crop, method ="bilinear")

elevation_res
plot(elevation_res)

writeRaster(elevation_proj,
            "data/elevation/elevation_projected.tif",
            overwrite = TRUE)
writeRaster(elevation_res,
            "data/elevation/elevation_resampled.tif",
            overwrite = TRUE)

################################################################################
################################################################################
### aspect and slope

elevation_proj <-rast("data/elevation/elevation_projected.tif")
################################

slope_proj <- terrain(elevation_proj, v="slope", neighbors=8)
slope_proj
writeRaster(slope_proj, "data/elevation/slope_projected.tif", overwrite = T)

slope_crop <- crop(slope_proj, fire_crop, extend = TRUE)
slope_res <- resample(slope_crop, fire_crop, method ="bilinear")
plot(slope_res)

writeRaster(slope_res, "data/elevation/slope_resampled.tif", overwrite = T)
################################

aspect_proj <- terrain(slope_proj, v="aspect", unit="degrees", neighbors=8 )
aspect_proj

writeRaster(aspect_proj, "data/elevation/aspect_projected.tif", overwrite = T)

aspect_crop <- crop(aspect_proj, fire_crop, extend = TRUE)
aspecte_res <- resample(aspect_crop, fire_crop, method ="bilinear")
plot(aspect_res)

writeRaster(aspect_res, "data/elevation/aspect_resampled.tif", overwrite = T)



