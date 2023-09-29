################################################################################
library(terra)
library(mapview)
library(sf)
library(tmap)
library(classInt)
setwd("")

################################################################################
# einladen der verschiedenen Vorhersagen
pred1 <- rast("figures/prediction.tif")
pred2 <- rast("figures/prediction_current.tif")
pred2_future <- rast("figures/prediction_ssp2245.tif")

pred_agg <- rast("figures/pred_agg_current.tif")
pred_agg_future <- rast("figures/pred_agg_ssp2245.tif")

# -> aggregierte durch 100 Teilen, damit sie vergleichbar werden
# -> Feuerfrequenz aus Daten zwischen 2010 und 2022 berechnet, 
#    also Häufigkeit innerhalb von 12 Jahren
# -> Alle Layer durch 12 teilen -> Waldbrandhäufigkeit pro Jahr

################################################################################
# einladen der verwendeten Modelle
mod <- readRDS("data/models/model.RDS")
mod_f <- readRDS("data/models/model_future.RDS")
mod_agg <- readRDS("data/models/model_future_agg.RDS")

mod
mod_f
mod_agg

# -> Vergleich von bestem mtry, r2 und so weiter

################################################################################
# umrechnen auf Waldbrandhäufigkeit pro Jahr

pred1 <- pred1 /12
pred2 <- pred2 /12
pred2_future <- pred2_future /12

pred_agg <- pred_agg /100 
pred_agg <- pred_agg /12

pred_agg_future <- pred_agg_future /100
pred_agg_future <- pred_agg_future /12

################################################################################
### auf festland Europa + GB zuschneiden
pred1 <- crop(pred1,c(2500000, 7500000, 1400000, 5500000))
pred2 <- crop(pred2,c(2500000, 7500000, 1400000, 5500000))
pred2_future <- crop(pred2_future,c(2500000, 7500000, 1400000, 5500000))

pred_agg <- crop(pred_agg,c(2500000, 7500000, 1400000, 5500000))
pred_agg_future <- crop(pred_agg_future,c(2500000, 7500000, 1400000, 5500000))

# einfaches plotten
plot(pred1)
plot(pred2)
plot(pred2_future)

plot(pred_agg)
plot(pred_agg_future)


################################################################################
### Europa Karte hinzufügen
#devtools::install_github("rte-antares-rpackage/spMaps", ref = "master")
library(spMaps)
eu <- getEuropeCountries(mergeCountry = FALSE)
#plot(eu)
eu <- st_as_sf(eu)

################################################################################
####################

#Karten:
#1. 1x1 km alle Prädiktoren
#2. 1x1 km 40 Prädiktoren
#3. 10x10 km heute mit sp und ger
#4. 10x10 km Zukunft mit sp und ger

#Tabelle:
#  Modellgüte mit mtry, rmse und r2

### mit tmap plotten
################################################################################
#1. 1x1 km alle Prädiktoren
map1 <- tm_shape(pred1)+
  tm_raster(col = "lyr1",
            style = "fixed",
            palette = c("#fed976","#feb24c","#fd8d3c","#fc4e2a","#e31a1c","#b10026"),
            breaks = c(0,0.02,0.04,0.08,0.1,0.2,0.4),
            title = "wildfire probability"
  )+
  tm_legend(
    legend.position = c("right","top"),
    legend.frame = TRUE,
    title.snap.to.legend = TRUE)+
  tm_shape(eu$geometry)+
  tm_polygons(alpha = 0)
map1

################################################################################
#2. 1x1 km 40 Prädiktoren
map2 <- tm_shape(pred2)+
  tm_raster(col = "lyr1",
            style = "fixed",
            palette = c("#fed976","#feb24c","#fd8d3c","#fc4e2a","#e31a1c","#b10026"),
            breaks = c(0,0.02,0.04,0.08,0.1,0.2,0.4),
            title = "wildfire probability"
  )+
  tm_legend(
    legend.position = c("right","top"),
    legend.frame = TRUE,
    title.snap.to.legend = TRUE)+
  tm_shape(eu$geometry)+
  tm_polygons(alpha = 0)
map2
################################################################################
#3. 10x10 km heute mit sp und ger
map21 <- tm_shape(pred_agg)+
  tm_raster(col = "lyr1",
            style = "fixed",
            palette = c("#fed976","#feb24c","#fd8d3c","#fc4e2a","#e31a1c","#b10026"),
            breaks = c(0,0.02,0.04,0.06,0.08,0.1,0.2),
            title = "wildfire probability"
  )+
  tm_legend(
    legend.position = c("right","top"),
    legend.frame = TRUE,
    title.snap.to.legend = TRUE)+
  tm_shape(eu$geometry)+
  tm_polygons(alpha = 0)
map21

### Ausschnitt Spanien
pred_agg_spain <- crop(pred_agg, c(2500000, 3800000, 1500000, 2600000))

map22 <- tm_shape(pred_agg_spain)+
  tm_raster(col = "lyr1",
            style = "fixed",
            palette = c("#fed976","#feb24c","#fd8d3c","#fc4e2a","#e31a1c","#b10026"),
            breaks = c(0,0.02,0.04,0.06,0.08,0.1,0.2),
            title = "wildfire probability",
            legend.show = FALSE
  )+
  tm_shape(eu$geometry)+
  tm_polygons(alpha = 0)
map22

### Ausschnitt Deutschland
pred_agg_ger <- crop(pred_agg, c(4000000, 4700000, 2700000, 3600000))

map23 <- tm_shape(pred_agg_ger)+
  tm_raster(col = "lyr1",
            style = "fixed",
            palette = c("#fed976","#feb24c","#fd8d3c","#fc4e2a","#e31a1c","#b10026"),
            breaks = c(0,0.02,0.04,0.06,0.08,0.1,0.2),
            title = "wildfire probability",
            legend.show = FALSE
  )+
  tm_shape(eu$geometry)+
  tm_polygons(alpha = 0)
map23


################################################################################
#4. 10x10 km Zukunft mit sp und gert
map31 <- tm_shape(pred_agg_future)+
  tm_raster(col = "lyr1",
            style = "fixed",
            palette = c("#fed976","#feb24c","#fd8d3c","#fc4e2a","#e31a1c","#b10026"),
            breaks = c(0,0.02,0.04,0.06,0.08,0.1,0.2),
            title = "wildfire probability"
                       )+
   tm_legend(
             legend.position = c("right","top"),
             legend.frame = TRUE,
             title.snap.to.legend = TRUE)+
  tm_shape(eu$geometry)+
  tm_polygons(alpha = 0)
map31

### Ausschnitt Spanien
pred_agg_f_spain <- crop(pred_agg_future, c(2500000, 3800000, 1500000, 2600000))

map32 <- tm_shape(pred_agg_f_spain)+
  tm_raster(col = "lyr1",
            style = "fixed",
            palette = c("#fed976","#feb24c","#fd8d3c","#fc4e2a","#e31a1c","#b10026"),
            breaks = c(0,0.02,0.04,0.06,0.08,0.1,0.2),
            title = "wildfire probability (ssp2245)",
            legend.show = FALSE
  )+
  tm_shape(eu$geometry)+
  tm_polygons(alpha = 0)
map32

### Ausschnitt Deutschland
pred_agg_f_ger <- crop(pred_agg_future, c(4000000, 4700000, 2700000, 3600000))

map33 <- tm_shape(pred_agg_f_ger)+
  tm_raster(col = "lyr1",
            style = "fixed",
            palette = c("#fed976","#feb24c","#fd8d3c","#fc4e2a","#e31a1c","#b10026"),
            breaks = c(0,0.02,0.04,0.06,0.08,0.1,0.2),
            title = "wildfire probability (ssp2245)",
            legend.show = FALSE
  )+
  tm_shape(eu$geometry)+
  tm_polygons(alpha = 0)
map33

#ffeda0
#fed976
#feb24c
#fd8d3c
#fc4e2a
#e31a1c
#b10026
################################################################################

#Karten:
#1. 1x1 km alle Prädiktoren
map1

#2. 1x1 km 40 Prädiktoren
map2

#3. 10x10 km heute mit sp und ger
map21
map22
map23

#4. 10x10 km Zukunft mit sp und gert
map31
map32
map33

#Tabelle:
#  Modellgüte mit mtry, rmse und r2











