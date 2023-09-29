rm(list=ls())
library(raster)
library(viridis)

# Path to the Processed MODIS data:
setwd("")

# Load all MODIS data:
dat <- stack(list.files())

# crop to area of interest:
dat <- crop(dat,c(506632.5, 541380.9, 
                  5797432, 5827779))
mapview(dat[[1]])
#save cropped data so that there is no need anymore to handle the full dataset

writeRaster(dat,"Modis_crop.grd")

# Visualize a single MODIS scene (note: unit is NDVI*0.0001):
spplot(dat[[1]]* 0.0001,col.regions=viridis(100))
spplot(dat[[1:10]])
