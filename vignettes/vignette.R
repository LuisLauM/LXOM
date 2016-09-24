## ---- echo = FALSE, message = FALSE--------------------------------------
library(oXim)

## ---- eval=FALSE---------------------------------------------------------
#  install.packages("oXim")

## ---- cache=TRUE---------------------------------------------------------

# Set directories where the Echopen's outputs are located
fileMode <- list(fish38_file   = system.file("extdata", "fish38.mat", package = "oXim"),
                 fluid120_file = system.file("extdata", "fluid120.mat", package = "oXim"),
                 blue38_file   = system.file("extdata", "blue38.mat", package = "oXim"))

# Read echograms (echoData object)
echoData <- readEchograms(fileMode = fileMode)


## ------------------------------------------------------------------------
# Print method
print(echoData)

## ------------------------------------------------------------------------
# Print method
summary(echoData)

## ---- fig.height=5, fig.width=7------------------------------------------
# Plot method
plot(echoData)

## ------------------------------------------------------------------------
print(oxyLimits)

## ------------------------------------------------------------------------
summary(oxyLimits)

## ---- fig.height=5, fig.width=7------------------------------------------
plot(oxyLimits)

