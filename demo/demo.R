# Set directory where are outputs of Echopen
directory <- "../../Cr 1110-12/Data ecosonda/"

# Read echograms
echoData <- readEchograms(directory = directory)

# Get limits of oxycline
echoOutputs <- getLine98(fluidMatrix = echoData)

# Plot filtered echograms
echogramPlot(echoOutputs)
