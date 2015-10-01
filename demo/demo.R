# Set directory where are outputs of Echopen
directory <- "D:/NvTomus InDemonic/Tesis Pregrado/Datos_9"

# Read echograms
echoData <- readEchograms(directory = directory, date.format = "%m-%d-%Y %H:%M:%S")

# Get limits of oxycline
# Default combination
combinations <- data.frame(type = c(".noiselessFilter", ".noiselessFilter", ".noiselessFilter", ".definerFilter"),
                           radius = c(7, 5, 3, 3),
                           times = c(3, 1, 1, 3),
                           tolerance = c(0.3, 0.2, 0.2, NA), 
                           stringsAsFactors = FALSE)

# New combination
combinations <- data.frame(type = c(".noiselessFilter", ".definerFilter"),
                           radius = c(3, 3),
                           times = c(2, 1),
                           tolerance = c(0.2, NA), 
                           stringsAsFactors = FALSE)


echoOutputs <- getOxyrange(fluidMatrix = echoData, stepBYstep = FALSE, combinations = combinations)

# Remove active (previous) plots
activePlots <- dev.list()
while(!is.null(activePlots))
{
  dev.off()
  activePlots <- dev.list()
}

# Plot filtered echograms
# png(filename = file.path(directory, "ecograma0.png"), width = 4500, height = 1500, res = 120)
plot(echoOutputs, plot.oxyrange = FALSE)
# dev.off()