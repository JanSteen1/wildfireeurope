################################################################################
library(terra)
library(mapview)
library(sf)
library(caret)
library(dplyr)
library(ranger)
setwd("")


### Alles nur auf Basis der Layer, die für die Zukunft verfügbar sind. Also 
### worldclim, tmin, tmax, prec, elevation, slope, aspect

################################################################################
# kombination von predictor Layern und Polygonen
sample <- read.csv2("data/aggregated/sample.csv", sep=";", header=T)
predictors <- rast("data/aggregated/pred_f_agg.tif")

### umbenennen des Prädiktorstacks
names(predictors) 
names(predictors[[1:42]])

# Modell ohne Koordinaten rechnen
predictors <- c(predictors[[1:42]])

## define the predictor names
predictor_names <- c(names(predictors))

################################################################################
sample$ID <- c(1:20000)
### convert character to numeric
str(sample)
sample <- sample %>% mutate_if(is.character,as.numeric)

#sample$x <- as.numeric(sample$x)
#sample$y <- as.numeric(sample$y)
sample$fire <- as.numeric(sample$fire)

sample$landcover <- as.factor(sample$landcover)
sample$foresttype <- as.factor(sample$foresttype)
sample$leaftype <- as.factor(sample$leaftype)

levels(sample$landcover) <- paste0("LC_",c(1:43,48))
levels(sample$leaftype) <- paste0("LT_",c(0,1,2,255))
levels(sample$foresttype) <- paste0("FT_",c(0,1,2,255))

str(sample)

################################################################################
# kleine Stichprobe, damit es schneller rechnet
trainIDs <- createDataPartition(sample$ID,p=1,list=FALSE)
trainDat <- sample[trainIDs,]
################################################################################

# NAs entfernen:
trainDat <- trainDat[complete.cases(trainDat),]
head(trainDat)
head(trainDat[,which(names(trainDat)%in%predictor_names)])
# trainDat auf relevante Variablen kürzen
trainDat <-trainDat[,c(predictor_names,"fire")]
head(trainDat)


tg = expand.grid(mtry = c(1:10),
                 splitrule = "variance",
                 min.node.size = 5)

# Train RF model in Caret
mod <- train(fire~.,data=trainDat,
             method="ranger",
             num.trees = 250,
             tuneGrid = tg,
             importance = "impurity")

mod
plot(mod)
plot(varImp(mod)) # wichtigkeit der variablen

saveRDS(mod,file="data/models/model_future_agg.RDS") # modell speichern!

# direktes einladen des Modells
mod <- readRDS("data/models/model_future_agg.RDS")

################################################################################

predictors$landcover[!predictors$landcover%in% unique(mod$trainingData$landcover)] <-NA
predictors$leaftype[!predictors$leaftype%in% unique(mod$trainingData$leaftype)] <-NA
predictors$foresttype[!predictors$foresttype%in% unique(mod$trainingData$foresttype)] <-NA

################################################################################
### Prädiktoren zu Faktor ändern, um Vorhersagen treffen zu können

class_landcover <- data.frame(id = c(1:43,48,128), level = paste0("LC_",c(1:43,48,128)))
levels(predictors$landcover) <- class_landcover
is.factor(predictors$landcover)

class_leaftype <- data.frame(id = c(0,1,2,255), level = paste0("LT_",c(0,1,2,255)))
levels(predictors$leaftype) <- class_leaftype
is.factor(predictors$leaftype)

class_foresttype <- data.frame(id = c(0,1,2,255), level = paste0("FT_",c(0,1,2,255)))
levels(predictors$foresttype) <- class_foresttype
is.factor(predictors$foresttype)

################################################################################
### Modellvorhersage treffen

# zukünftiges Klima
prediction_ssp2245 <- terra::predict(predictors,mod,na.rm=T)

# erste Visualisierung
plot(prediction_ssp2245)

### abspeichern der prediction
writeRaster(prediction_ssp2245,
            "figures/pred_agg_ssp2245.tif",
            overwrite=T)


################################################################################
# Modell auf aktuelles Klima anwenden

# einladen der aktuellen Daten

predictors_curr <- rast("data/aggregated/pred_c_agg.tif")

# umbenennen
names(predictors_curr)

################################################################################

predictors_curr$landcover[!predictors_curr$landcover%in% unique(mod$trainingData$landcover)] <-NA
predictors_curr$leaftype[!predictors_curr$leaftype%in% unique(mod$trainingData$leaftype)] <-NA
predictors_curr$foresttype[!predictors_curr$foresttype%in% unique(mod$trainingData$foresttype)] <-NA

################################################################################
### Prädiktoren zu Faktor ändern, um Vorhersagen treffen zu können

class_landcover <- data.frame(id = c(1:43,48,128), level = paste0("LC_",c(1:43,48,128)))
levels(predictors_curr$landcover) <- class_landcover
is.factor(predictors_curr$landcover)

class_leaftype <- data.frame(id = c(0,1,2,255), level = paste0("LT_",c(0,1,2,255)))
levels(predictors_curr$leaftype) <- class_leaftype
is.factor(predictors_curr$leaftype)

class_foresttype <- data.frame(id = c(0,1,2,255), level = paste0("FT_",c(0,1,2,255)))
levels(predictors_curr$foresttype) <- class_foresttype
is.factor(predictors_curr$foresttype)

################################################################################

### Vorhersage auf aktuelles Klima treffen

prediction_current <- terra::predict(predictors_curr,mod,na.rm=T)

# erste Visualisierung
plot(prediction_current)

### abspeichern der prediction
writeRaster(prediction_current,
            "figures/pred_agg_current.tif",
            overwrite=T)

# direkt einladen

prediction_current <- rast("figures/pred_agg_current.tif")

