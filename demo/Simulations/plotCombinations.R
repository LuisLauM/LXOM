
# Definir parámetros ------------------------------------------------------
directory <- "../../Cr 1110-12/Data ecosonda/"
file <- "../Simulations/combinations.csv"


# Realizar análisis y obtener gráficos ------------------------------------
# Cargar paquete
require(LXOM)

# Leer ecogramas
echoData <- readEchograms(directory = directory)

# Leer combinaciones de filtros
combinations <- read.csv(file, stringsAsFactors = FALSE)
combinations <- split(combinations, combinations$number_comb)

# Aplicar filtros a ecoggramas leídos
for(i in seq_along(combinations)){
  # Obtener matrices de ecogramas
  echoOutputs <- getOxyrange(fluidMatrix = echoData, 
                           combinations = combinations[[i]][,-1], stepBYstep = TRUE)
  
  # Create directories for plots
  dirNames <- paste0("../Simulations/echogram_", seq_along(echoOutputs))
  sapply(dirNames, dir.create, showWarnings = FALSE)
  
  # Plotear y guardar
  for(j in seq_along(echoOutputs)){
    for(k in seq_along(echoOutputs[[j]])){
      outName <- file.path(dirNames[j], 
                           paste0("combination-", i, "_step-", k, ".png"))
      
      png(filename = outName, 
          width = ncol(echoOutputs[[j]][[k]])*2, 
          height = nrow(echoOutputs[[j]][[k]])*2, 
          res = 150)
      
      par(mar = rep(0, 4))
      echogramPlot(echoOutputs[[j]][[k]])
      
      dev.off()
    }
  }  
}