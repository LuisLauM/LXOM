## ---- echo = FALSE, message = FALSE--------------------------------------
library(oXim)

## ---- eval=FALSE---------------------------------------------------------
#  install.packages("oXim")

## ------------------------------------------------------------------------
# Print method
print(echoData)

## ------------------------------------------------------------------------
# Print method
summary(echoData)

## ---- fig.height=5, fig.width=7------------------------------------------
# Plot method
plot(echoData)

## ---- cache=TRUE---------------------------------------------------------

# Calculate oxycline limits (oxyclineData object)
oxyLimits <- getOxyrange(fluidMatrix = echoData)


## ------------------------------------------------------------------------
print(oxyLimits)

## ------------------------------------------------------------------------
summary(oxyLimits)

## ---- fig.height=5, fig.width=7------------------------------------------
plot(oxyLimits)

