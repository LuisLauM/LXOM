rm(list = ls())
# Set directory where are outputs of Echopen
directory <- "inst/exampleData/"

fileMode <- list(fish38_file   = system.file("extdata", "fish38.mat", package = "oXim"),
                 fluid120_file = system.file("extdata", "fluid120.mat", package = "oXim"),
                 blue38_file   = system.file("extdata", "blue38.mat", package = "oXim"))


# Read echograms
echoData <- readEchograms(fileMode = fileMode)

# Test principal methods
print(echoData)

summEchoData <- summary(echoData)
print(summEchoData)

plot(echoData)

# Get limits of oxycline
# Default combination
# combinations <- data.frame(type = c(".noiselessFilter", ".noiselessFilter", ".noiselessFilter", ".definerFilter"),
#                            radius = c(7, 5, 3, 3),
#                            times = c(3, 1, 1, 3),
#                            tolerance = c(0.3, 0.2, 0.2, NA),
#                            stringsAsFactors = FALSE)

# New combination
# combinations <- data.frame(type = c(".noiselessFilter", ".definerFilter"),
#                            radius = c(3, 3),
#                            times = c(2, 1),
#                            tolerance = c(0.2, NA),
#                            stringsAsFactors = FALSE)


echoOutputs <- getOxyrange(fluidMatrix = echoData)

# print(echoData)
# print(summary(echoData))

# Remove active (previous) plots
# activePlots <- dev.list()
# while(!is.null(activePlots))
# {
#   dev.off()
#   activePlots <- dev.list()
# }

# Plot filtered echograms
# png(filename = file.path(directory, "ecograma0.png"), width = 4500, height = 1500, res = 120)
# plot(echoOutputs, plot.oxyrange = FALSE)
# dev.off()
