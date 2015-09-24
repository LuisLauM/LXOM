# Set directory where are outputs of Echopen
directory <- "D:/NvTomus InDemonic/IMARPE/Trabajos/DGrados/Cr 1110-12"

# Read echograms
echoData <- readEchograms(directory = directory)

# Get limits of oxycline
# Default combination
combinations <- data.frame(type = c(".noiselessFilter", ".definerFilter"),
                           radius = c(3, 3),
                           times = c(2, 1),
                           tolerance = c(0.2, NA), 
                           stringsAsFactors = FALSE)

# New combination
combinations <- data.frame(type = c(".noiselessFilter", ".definerFilter", ".noiselessFilter"),
                           radius = c(3, 3, 3),
                           times = c(2, 1, 2),
                           tolerance = c(0.2, NA, 0.1), 
                           stringsAsFactors = FALSE)

echoOutputs <- getLine98(fluidMatrix = echoData, stepBYstep = FALSE, combinations = combinations)

# Plot filtered echograms
# echogramPlot(echoOutputs$outputs$matrix_1$finalEchogram)
plot(echoOutputs)
