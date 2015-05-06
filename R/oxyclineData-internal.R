.ordfilt2 <- function(data, x, weightedMatrix){
  newData <- data
  
  # Corner UpLeft
  i <- 1
  j <- 1
  miniData <- data[(i):(i + 2), (j):(j + 2)] * weightedMatrix
  newData[i, j] <- miniData[order(miniData)[x]]
  
  # Corner DownLeft
  i <- nrow(data)
  j <- 1
  miniData <- data[(i):(i - 2), (j):(j + 2)] * weightedMatrix
  newData[i, j] <- miniData[order(miniData)[x]]
  
  # Corner UpRight
  i <- 1
  j <- ncol(data)
  miniData <- data[(i):(i + 2), (j):(j - 2)] * weightedMatrix
  newData[i, j] <- miniData[order(miniData)[x]]
  
  # Corner DownRight
  i <- nrow(data)
  j <- ncol(data)
  miniData <- data[(i):(i - 2), (j):(j - 2)] * weightedMatrix
  newData[i, j] <- miniData[order(miniData)[x]]
  
  
  # Downside
  i <- nrow(data):(nrow(data) - 2)
  for(j in seq(from = 2, to = ncol(data) - 1)){
    miniData <- data[i, (j - 1):(j + 1)] * weightedMatrix
    newData[i, (j - 1):(j + 1)] <- miniData[order(miniData)[x]]
  }  
  
  # Leftside
  j <- 1:3
  for(i in seq(from = 2, to = nrow(data) - 1)){
    miniData <- data[(i - 1):(i + 1), j] * weightedMatrix
    newData[(i - 1):(i + 1), j] <- miniData[order(miniData)[x]]
  }
  
  # Upside
  i <- 1:3
  for(j in seq(from = 2, to = ncol(data) - 1)){
    miniData <- data[i, (j - 1):(j + 1)] * weightedMatrix
    newData[i, (j - 1):(j + 1)] <- miniData[order(miniData)[x]]
  }  
  
  # Rightside
  j <- ncol(data):(ncol(data) - 2)
  for(i in seq(from = 2, to = nrow(data) - 1)){
    miniData <- data[(i - 1):(i + 1), j] * weightedMatrix
    newData[(i - 1):(i + 1), j] <- miniData[order(miniData)[x]]
  }  
  
  # No borders
  for(j in seq(from = 2, to = ncol(data) - 1)){
    for(i in seq(from = 2, to = nrow(data) - 1)){
      miniData <- data[(i - 1):(i + 1), (j - 1):(j + 1)] 
      
      if(sum(!is.na(miniData), na.rm = TRUE) == 0)
        next
      
      newData[i, j] <- miniData[order(miniData * weightedMatrix)[x]]
    }
  }
  
  return(newData)
}

.ordfilt2_C <- function(data, x, weightedMatrix){
  
  # Warning messages
  if(mode(data) != "numeric" | mode(weightedMatrix) != "numeric")
    stop("Incorrect mode of data or weightedMatrix (both must be 'numeric').")
  
  # Convert NAs in 999
  data[is.na(data)] <- 999
  # weightedMatrix[weightedMatrix == 0] <- 999
  # lolo
  # Execute function
  output <- ordfilt2_C_internal(data = data, x = as.integer(x), 
                                weightedMatrix = as.numeric(weightedMatrix))
  
  # Convert 999 in NAs
  output[output > 500 | output < -500] <- NA
  
  return(output)
}

# Filter that removes (converts to NaN) isolated pixels
.noiselessFilter <- function(data, radius, times, tolerance){
  minValue <- min(data, na.rm = TRUE)
  
  data[is.na(data)] <- -999
  weightedMatrix <- diag(radius) + diag(radius)[,radius:1]
  constant1 <- ceiling(radius/2)
  weightedMatrix[constant1,] <- 1
  
  constant2 <- ceiling(sum(weightedMatrix)*tolerance)

  finalData <- data
  for(i in 1:times)
    finalData <- .ordfilt2_C(data = finalData, 
                             x = constant2, 
                             weightedMatrix = weightedMatrix)
  
  finalData[finalData < minValue | finalData == 0] <- NA
  
  return(finalData)
}

# Filter that takes isolated pixels and reforce its closest environment
.definerFilter <- function(data, radius, times){
  maxValue <- max(data, na.rm = TRUE)
  
  data[is.na(data)] <- 999
  weightedMatrix <- diag(radius) + diag(radius)[,radius:1]
  constant1 <- ceiling(radius/2)
  weightedMatrix[constant1,] <- 1
  
  constant2 <- 1
  
  finalData <- data
  for(i in 1:times)
    finalData <- .ordfilt2_C(data = finalData, 
                             x = constant2, 
                             weightedMatrix = weightedMatrix)
  
  finalData[finalData > maxValue] <- NA
  
  return(finalData)
}

# Function that applies a combination of filters (with different parameters) and 
# get a better matrix to calculate limits of oxycline
.getLine98 <- function(fluidMatrix, combinations = NULL, stepBYstep = TRUE){
  
  fluidTime <- fluidMatrix$time
  fluidMatrix <- fluidMatrix$echogram
  
  # Set combination of filters that wil be applied 
  if(is.null(combinations))
    combinations <- list(list(type = ".noiselessFilter",
                              radius = 3,
                              times = 2,
                              tolerance = 0.2),
                         list(type = ".definerFilter",
                              radius = 3,
                              times = 1))
  
  # Get filtered matrix
  tempOutput <- fluidMatrix
  outputList <- list(original = fluidMatrix)
  for(i in seq_along(combinations)){
    tempFunction <- get(combinations[[i]]$type)
    
    tempOutput <- switch(combinations[[i]]$type,
                         .noiselessFilter = tempFunction(tempOutput, 
                                                         radius = combinations[[i]]$radius,
                                                         times = combinations[[i]]$times,
                                                         tolerance = combinations[[i]]$tolerance),
                         .definerFilter = tempFunction(tempOutput, 
                                                       radius = combinations[[i]]$radius,
                                                       times = combinations[[i]]$times),
                         "Incorrect type of filter.")
    
    if(stepBYstep) 
      outputList[[i + 1]] <- tempOutput else 
        if(i == length(combinations))
          outputList[[2]] <- tempOutput
  }
  
  names(outputList) <- if(length(outputList) > 2)
    c("original", paste0("echogram_", seq(length(combinations) - 1)), "finalEchogram") else
      c("original", "finalEchogram")
  
  return(outputList)
}

# Takes outputs from Echopen and generates a matrix to calculate Oxycline
.getEchoData <- function(directory, validFish38, validBlue38, upLimitFluid120, pinInterval = 5){
  
  # Define ttext pattern of databases
  pattern_Fish38  <- "_2Freq_Fish38.mat"
  # pattern_Fluid38 <- "_2Freq_Fluid38.mat"
  pattern_Blue38  <- "_2Freq_Blue38.mat"
  
  # pattern_Fish120   <- "_2Freq_Fish120.mat"
  pattern_Fluid120  <- "_2Freq_Fluid120.mat"
  # pattern_Blue120   <- "_2Freq_Blue120.mat"
  
  # Generate file list with text patterns
  listFiles_Fish <- list.files(path = directory, pattern = pattern_Fish38, 
                               full.names = TRUE, recursive = TRUE)
  listFiles_Fluid <- list.files(path = directory, pattern = pattern_Fluid120, 
                                full.names = TRUE, recursive = TRUE)
  listFiles_Blue <- list.files(path = directory, pattern = pattern_Blue38, 
                               full.names = TRUE, recursive = TRUE)
  
  # Read files and concatenate in one matrix
  allData <- allTime <- NULL
  for(i in seq_along(listFiles_Fish)){
    tempList_Fish <- readMat(listFiles_Fish[i])
    tempList_Fluid <- readMat(listFiles_Fluid[i])
    tempList_Blue <- readMat(listFiles_Blue[i])
    
    tempData_Fish <- tempList_Fish$Data.values
    tempData_Fluid <- tempList_Fluid$Data.values
    tempData_Blue <- tempList_Blue$Data.values
    
    tempTime <- paste(tempList_Fluid$Ping.date, tempList_Fluid$Ping.time)
    rm(list = c("tempList_Fish", "tempList_Fluid", "tempList_Blue")) 
    
    # Clear data using limit parameters
    tempData_Fish[tempData_Fish < -998 | tempData_Fish < validFish38[1] |
                    tempData_Fish > validFish38[2]] <- NaN
    tempData_Blue[tempData_Blue < -998 | tempData_Blue < validBlue38[1] |
                    tempData_Blue > validBlue38[2]] <- NaN  
    tempData_Fluid[tempData_Fluid < -998 | tempData_Fluid > upLimitFluid120] <- NaN
    
    # Clear main data (Fluid-like) using Fish and Blue noise data
    tempData <- tempData_Fluid*(is.na(tempData_Blue) & is.na(tempData_Fish))
    tempData[tempData == 0] <- NaN  
    
    allTime <- c(allTime, tempTime)
    allData <- cbind(allData, t(tempData))
  }
  
  # Convert time
  allTime <- strptime(allTime, format = "%d-%m-%Y %H:%M:%S")
  
  # Get points where the difference between two pin is larger than pinInterval (sec)
  breakPoints <- which(as.numeric(diff(allTime)) > pinInterval)
  breakPoints <- if(is.null(dim(breakPoints)) && length(breakPoints) > 1)
    c(1, dim(allData)[2]) else
      c(1, breakPoints + 1, dim(allData)[2])
  
  # Split big matrix by breakpoints to get matrix of echograms
  data <- list()
  for(i in seq_along(breakPoints[-1])){
    tempEchogram <- list()
    
    tempEchogram[[1]] <- allData[,seq(breakPoints[i], breakPoints[i + 1])]
    tempEchogram[[2]] <- allTime[seq(breakPoints[i], breakPoints[i + 1])]
    
    names(tempEchogram) <- c("echogram", "time")
    
    data[[i]] <- tempEchogram
  }
  
  output <- list(info = list(parameters = list(validFish38 = validFish38,
                                               validBlue38 = validBlue38,
                                               upLimitFluid120 = upLimitFluid120),
                             n_echograms = length(breakPoints[-1])), 
                 data = data)
  
  return(output)
}

.echogramPlot <- function(echogram_1, colPallete, save, outName, ...){
  
  if(save)
    png(filename = paste0(outName, ".png"), 
        width = ncol(echogram_1)*2, height = nrow(echogram_1)*2, res = 150)
  
  par(mar = c(0, 0, 0, 0))
  image(raster(x = echogram_1, xmn = 0, xmx = dim(echogram_1)[2], ymn = 0, ymx = dim(echogram_1)[1]), 
        col = colPallete, axes = FALSE, xlab = NA, ylab = NA, ...)
  axis(2, at = pretty(1:dim(echogram_1)[2]), labels = rev(pretty(dim(echogram_1)[2]:0)), las = 2)
  axis(1, at = ceiling(seq(from = 0, to = dim(echogram_1)[2], length.out = 9)))
  # grid()
  box()
  
  if(save)
    dev.off()
  
  
  
  return(invisible())
}