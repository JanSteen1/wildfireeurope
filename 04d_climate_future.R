library(terra)
library(geodata)
setwd("")

# download full resolution wordclim data here: https://www.worldclim.org/data/cmip6/cmip6climate.html


################################################################################
#EC-Earth3-Veg/ssp245
#tn - monthly average minimum temperature (°C)
#tx - monthly average maximum temperature (°C)
#pr - monthly total precipitation (mm)


################################################################################
#### Daten einladen

fire_crop <- rast("data/fire/fire_crop.tif")

tn_ssp245 <- rast("data/ssp245/tn/wc2.1_30s_tmin_EC-Earth3-Veg_ssp245_2041-2060.tif")
tx_ssp245 <- rast("data/ssp245/tx/wc2.1_30s_tmax_EC-Earth3-Veg_ssp245_2041-2060.tif")
pr_ssp245 <- rast("data/ssp245/pr/wc2.1_30s_prec_EC-Earth3-Veg_ssp245_2041-2060.tif")


################################################################################
################################################################################
### tn
tn_ssp245

tn_ssp245_proj <- project(tn_ssp245, "EPSG:3035", method = "bilinear", threads = TRUE)
tn_ssp245_crop <- crop(tn_ssp245_proj, fire_crop, extend = TRUE)
tn_ssp245_res <- resample(tn_ssp245_crop, fire_crop, method ="bilinear")

tn_ssp245_res
plot(tn_ssp245_res)

writeRaster(tn_ssp245_proj,
            "data/ssp245/tn/tn_ssp245_proj.tif",
            overwrite = TRUE)
writeRaster(tn_ssp245_res,
            "data/ssp245/tn/tn_ssp245_res.tif",
            overwrite = TRUE)
################################################################################
################################################################################
### tx

tx_ssp245_proj <- project(tx_ssp245, "EPSG:3035", method = "bilinear", threads = TRUE)
tx_ssp245_crop <- crop(tx_ssp245_proj, fire_crop, extend = TRUE)
tx_ssp245_res <- resample(tx_ssp245_crop, fire_crop, method ="bilinear")

tx_ssp245_res
plot(tx_ssp245_res)

writeRaster(tx_ssp245_proj,
            "data/ssp245/tx/tx_ssp245_proj.tif",
            overwrite = TRUE)
writeRaster(tx_ssp245_res,
            "data/ssp245/tx/tx_ssp245_res.tif",
            overwrite = TRUE)

################################################################################
################################################################################
### pr

pr_ssp245_proj <- project(pr_ssp245, "EPSG:3035", method = "bilinear", threads = TRUE)
pr_ssp245_crop <- crop(pr_ssp245_proj, fire_crop, extend = TRUE)
pr_ssp245_res <- resample(pr_ssp245_crop, fire_crop, method ="bilinear")

pr_ssp245_res
plot(pr_ssp245_res)

writeRaster(pr_ssp245_proj,
            "data/ssp245/pr/pr_ssp245_proj.tif",
            overwrite = TRUE)
writeRaster(pr_ssp245_res,
            "data/ssp245/pr/pr_ssp245_res.tif",
            overwrite = TRUE)

################################################################################
################################################################################
### Predictor Stack Future

tn_ssp245_res <- rast("data/ssp245/tn/tn_ssp245_res.tif")
tx_ssp245_res <- rast("data/ssp245/tx/tx_ssp245_res.tif")
pr_ssp245_res <- rast("data/ssp245/pr/pr_ssp245_res.tif")

elevation_res <- rast("data/elevation/elevation_resampled.tif")
slope_res <- rast("data/elevation/slope_resampled.tif")
aspect_res <- rast("data/elevation/aspect_resampled.tif")
coords <- rast("data/coords/coordinates.tif")


landcover_res <- rast("data/copernicus/landcover_resampled.tif")
foresttype_res <- rast("data/copernicus/foresttype_resampled.tif")
leaftype_res <- rast("data/copernicus/leaftype_resampled.tif")

##Stack erstellen
predictors_ssp245 <- c(landcover_res, foresttype_res, leaftype_res, 
                       pr_ssp245_res, tx_ssp245_res, tn_ssp245_res,
                       elevation_res, slope_res, aspect_res, coords)

## Passende Namen wie beim Trainingsdatensatz/Modell
predictors <-rast("data/predictors_with_coordinates.tif")

names(predictors)


names(predictors_ssp245) 
names(predictors_ssp245[[4:39]]) <- substr(names(predictors_ssp245[[4:39]]),
                                    nchar(names(predictors_ssp245[[4:39]]))-6, # von der 6-letzten Stelle...
                                    nchar(names(predictors_ssp245[[4:39]]))-0) #bis zur letzten
names(predictors_ssp245[[1:3]]) <- c("landcover", "foresttype", "leaftype")
names(predictors_ssp245[[40]]) <- c("elevation")
names(predictors_ssp245)

#writeRaster(predictors_ssp245, "data/predictors_ssp245.tif")
