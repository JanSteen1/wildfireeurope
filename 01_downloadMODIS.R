rm(list=ls())

#remotes::install_github("fdetsch/MODIS")
library(MODIS)

EarthdataLogin() # urs.earthdata.nasa.gov download MODIS data from LP DAAC

# insert file path
lap = ""

MODISoptions(lap, outDirPath = file.path(lap, "PROCESSED")
             , MODISserverOrder = c("LPDAAC", "LAADS"), quiet = TRUE)

### download data
getHdf("MOD14A2",begin = "2022.01.01", end = "2022.12.31",
       tileH = 17:20, tileV = 1:5)

### process data (extract NDVI only)
runGdal(job="fire_europe","MOD14A2",begin = "2022.01.01", end = "2022.12.31",
        tileH = 17:20, tileV = 1:5
        , SDSstring = "10")

