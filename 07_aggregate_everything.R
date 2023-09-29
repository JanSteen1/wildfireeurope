################################################################################
library(terra)
library(mapview)
library(sf)
library(caret)
library(dplyr)
setwd("")


################################################################################
# kombination von predictor Layern und Polygonen
#sample <- read.csv2("data/sample.csv", sep=";", header=T)
predictors <- rast("data/predictors_ssp245.tif")
fire <- rast("data/fire/fire_crop.tif")
predictors_curr <- rast("data/predictors.tif")

### umbenennen des Prädiktorstacks
names(predictors) 
names(predictors[[1:42]])

# Modell ohne Koordinaten rechnen
predictors <- c(predictors[[1:42]])

################################################################################

# umbenennen der heutigen Prädiktoren
names(predictors_curr)
names(predictors_curr[[4:87]]) <- substr(names(predictors_curr[[4:87]]),
                                         nchar(names(predictors_curr[[4:87]]))-6, # von der 6-letzten Stelle...
                                         nchar(names(predictors_curr[[4:87]]))-0) #bis zur letzten
names(predictors_curr[[1:3]]) <- c("landcover", "foresttype", "leaftype")
names(predictors_curr[[88]]) <- c("elevation")
names(predictors_curr)

# zuschneiden auf relevante Prädiktoren

predictors_curr <- c(predictors_curr[[c(1:27,52:63,88:90)]])
names(predictors_curr)
names(predictors)


################################################################################
# Feuer als Summe aggregieren, Anzahl Feuerereignisse auf 25 x 25 km zwischen 01.2010 und 12.2022
# 25 km -> fact = 27
# 10 km -> fact = 11

fire
fire <- aggregate(fire, fact = 11, fun = "sum")
plot(fire)


# Prädiktoren auch auf 25 x 25 aggregieren
# landcover -> modal
# wetter -> mean

predictors
predictors_lc <- aggregate(predictors[[1:3]], fact = 11, fun = "modal")
predictors_we <- aggregate(predictors[[4:42]], fact = 11, fun = "mean")
pred <- c(predictors_lc, predictors_we)

# 

predictors_curr_lc <- aggregate(predictors_curr[[1:3]], fact = 11, fun = "modal")
predictors_curr_we <- aggregate(predictors_curr[[4:42]], fact = 11, fun = "mean")
pred_curr <- c(predictors_curr_lc, predictors_curr_we)

################################################################################
# alles auschreiben, um es zu sichern


writeRaster(fire,
            "data/aggregated/fire_agg.tif",
            overwrite = TRUE)

writeRaster(pred,
             "data/aggregated/pred_f_agg.tif",
            overwrite = TRUE)

writeRaster(pred_curr,
            "data/aggregated/pred_c_agg.tif",
            overwrite = TRUE)













