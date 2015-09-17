# Set directory where are outputs of Echopen
directory <- "D:/NvTomus InDemonic/IMARPE/Trabajos/DGrados/Cr 1110-12"

# Read echograms
echoData <- readEchograms(directory = directory)

# Get limits of oxycline
echoOutputs <- getLine98(fluidMatrix = echoData)

# Plot filtered echograms
echogramPlot(echoOutputs$outputs)
