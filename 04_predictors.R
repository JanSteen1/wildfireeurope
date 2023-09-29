library(terra)
library(geodata)
setwd("")

################################################################################
#### Daten einladen

fire <- rast("data/fire/fire_freq.tif")
fire_proj <- rast("data/fire/fire_projected.tif")
fire_crop <- rast("data/fire/fire_crop.tif")

# Download copernicus data here: https://land.copernicus.eu/en/products
landcover <- rast("data/copernicus/Corine_land_cover_eu_100m_2018.tif")
foresttype <- rast("data/copernicus/dominant_forest_type_eu_2018_10m.tif")
leaftype <- rast("data/copernicus/dominant_leaf_type_eu_2018_10m.tif")
################################################################################
#### 
# 1. für Projektion entscheiden -> EPSG:3035 (Corine)
# 2. alles umprojizieren
# 3. alles croppen auf Ausmaß der Feuer Pixel
# 4. alles resamplen auf Ausmaß der Feuer Pixel
# 5. Rasterstack der Prädiktoren erstellen
# 6. Ergebnisse ausschreiben

################################################################################

# Die wordclim daten werden in den Skripten 04a und 04b  aufbereitet und 
# dann hier wieder eingeladen, da die Rechenzeiten sehr lang sind

#tmin <- worldclim_global(var="tmin", res=0.5, path=("data/tmin"), version="2.1")
#tmin <- list.files("data/tmin/wc2.1_30s", full.names = TRUE, pattern = ".tif")
#tmin <- rast(c(tmin))

#tmax <- worldclim_global(var="tmax", res=0.5, path=("data/tmax"), version="2.1")
#tmax <- list.files("data/tmax/wc2.1_30s", full.names = TRUE, pattern = ".tif")
#tmax <- rast(c(tmax))

#tavg <- worldclim_global(var="tavg", res=0.5, path=("data/tavg"), version="2.1")
#tavg <- list.files("data/tavg/wc2.1_30s", full.names = TRUE, pattern = ".tif")
#tavg <- rast(c(tavg))

#prec <- worldclim_global(var="prec", res=0.5, path=("data/prec"), version="2.1")
#prec <- list.files("data/prec/wc2.1_30s", full.names = TRUE, pattern = ".tif")
#prec <- rast(c(prec))

#srad <- worldclim_global(var="srad", res=0.5, path=("data/srad"), version="2.1")
#srad <- list.files("data/srad/wc2.1_30s", full.names = TRUE, pattern = ".tif")
#srad <- rast(c(srad))

#wind <- worldclim_global(var="wind", res=0.5, path=("data/wind"), version="2.1")
#wind <- list.files("data/wind/wc2.1_30s", full.names = TRUE, pattern = ".tif")
#wind <- rast(c(wind))

#vapr <- worldclim_global(var="vapr", res=0.5, path=("data/vapr"), version="2.1")
#vapr <- list.files("data/vapr/wc2.1_30s", full.names = TRUE, pattern = ".tif")
#vapr <- rast(c(vapr))

# elevation kann nicht in R runter geladen werden, daher direkt einladen
#elevation <- rast("data/elevation/wc2.1_10m/wc2.1_10m_elev.tif")


################################################################################
# aggregieren, um das resamplen zu beschleunigen

landcover_agg <- aggregate(landcover, fact=10, fun="modal")
foresttype_agg <- aggregate(foresttype, fact=92, fun="modal")
leaftype_agg <- aggregate(leaftype, fact=92, fun="modal")

################################################################################

# resamplen der copernicus daten
landcover_res <- resample(landcover_agg, fire_crop, method = "near")
foresttype_res <- resample(foresttype_agg, fire_crop, method = "near")
leaftype_res <- resample(leaftype_agg, fire_crop, method = "near")

# kontinuierlich -> bilinear
# Klassen -> nearest neighbor

writeRaster(landcover_res, "data/copernicus/landcover_resampled.tif", overwrite = T)
writeRaster(foresttype_res, "data/copernicus/foresttype_resampled.tif", overwrite = T)
writeRaster(leaftype_res, "data/copernicus/leaftype_resampled.tif", overwrite = T)

################################################################################
# aspect und slope werden aus der elevation berechnet

# einmal bereits resamplet

slope_res <- terrain(elevation_res, v="slope", neighbors=8)
plot(slope_res)

aspect_res <- terrain(slope_res, v="aspect", unit="degrees", neighbors=8 )
plot(aspect_res)

writeRaster(slope_res, "data/elevation/slope_resampled.tif", overwrite = T)
writeRaster(aspect_res, "data/elevation/aspect_resampled.tif", overwrite = T)

# und einmal nur projeziert, um für die Trainingsdaten eine möglichst hohe
# Genauigkeit zu haben

elevation_proj <- rast("data/elevation/elevation_projected.tif")

slope_proj <- terrain(elevation_proj, v="slope", neighbors=8)
slope_proj

aspect_proj <- terrain(slope_proj, v="aspect", unit="degrees", neighbors=8 )
aspect_proj

writeRaster(slope_proj, "data/elevation/slope_projected.tif", overwrite = T)
writeRaster(aspect_proj, "data/elevation/aspect_projected.tif", overwrite = T)

################################################################################
# resampelte Daten direkt einlesen

tmin_res <- rast("data/tmin/tmin_resampled.tif") # fertig
tmax_res <- rast("data/tmax/tmax_resampled.tif") # fertig
tavg_res <- rast("data/tavg/tavg_resampled.tif") # fertig
prec_res <- rast("data/prec/prec_resampled.tif") # fertig
srad_res <- rast("data/srad/srad_resampled.tif") # fertig
wind_res <- rast("data/wind/wind_resampled.tif") # fertig
vapr_res <- rast("data/vapr/vapr_resampled.tif") # fertig 

elevation_res <- rast("data/elevation/elevation_resampled.tif") # fertig
slope_res <- rast("data/elevation/slope_resampled.tif") # fertig
aspect_res <- rast("data/elevation/aspect_resampled.tif") # fertig

landcover_res <- rast("data/copernicus/landcover_resampled.tif") # fertig
foresttype_res <- rast("data/copernicus/foresttype_resampled.tif") # fertig
leaftype_res <- rast("data/copernicus/leaftype_resampled.tif") # fertig

################################################################################
# rasterstack erstellen

predictors <- c(landcover_res, foresttype_res, leaftype_res, 
                tmax_res, tmin_res, tavg_res, wind_res, prec_res, vapr_res, srad_res,
                elevation_res, slope_res, aspect_res)

################################################################################
# Layer als tif rausschreiben

writeRaster(predictors,
            "data/predictors.tif",
            overwrite = T)

################################################################################