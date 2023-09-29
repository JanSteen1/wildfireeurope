################################################################################
library(terra)
library(mapview)
library(sf)
library(caret)
library(dplyr)
setwd("")

################################################################################
# kombination von predictor Layern und Polygonen
sample <- read.csv2("data/sample.csv", sep=";", header=T)
predictors <- rast("data/predictors.tif")

### umbenennen des Prädiktorstacks
names(predictors) 
names(predictors[[4:87]]) <- substr(names(predictors[[4:87]]),
                              nchar(names(predictors[[4:87]]))-6, # von der 6-letzten Stelle...
                              nchar(names(predictors[[4:87]]))-0) #bis zur letzten
names(predictors[[1:3]]) <- c("landcover", "foresttype", "leaftype")
names(predictors[[88]]) <- c("elevation")
names(predictors)

## define the predictor names
predictor_names <- c(names(predictors))

################################################################################
sample$ID <- c(1:19798)
### convert character to numeric
str(sample)
sample <- sample %>% mutate_if(is.character,as.numeric)

sample$x <- as.numeric(sample$x)
sample$y <- as.numeric(sample$y)
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

# Train Ranger model in Caret
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

saveRDS(mod,file="data/models/model.RDS") # modell speichern!

# direktes einladen des Modells
mod <- readRDS("data/models/model.RDS")

################################################################################
### zum testen auf kleinen Auschnitt zuschneiden

#predictors_c <- crop(predictors,c( 4000000, 4200000, 3000000, 3200000 ))
#writeRaster(predictors_c,
#          "data/test_predictors.tif")
#predictors_c <- rast("data/test_predictors.tif")
#predictors <- predictors_c

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

prediction <- terra::predict(predictors,mod,na.rm=T)

# erste Visualisierung
plot(prediction)

### abspeichern der prediction
writeRaster(prediction,
            "figures/prediction.tif",
            overwrite=T)

################################################################################
