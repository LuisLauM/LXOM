#' readEchograms
#'
#' @title Takes outputs from Echopen and generates a matrix to calculate Oxycline.
#' @description This function search outputs of Echoopen for Fluid-like, Blue noise 
#' and Fish and use them to make a filtered matrix to calculate the Oxycline limits.
#' 
#' @param directory Directory where are outputs of Echoopen for Fluid-like, Blue noise 
#' and Fish.
#' @param ... Extra arguments.
#'   
#' @examples
#' readEchograms(directory = "C:/Echodata")

readEchograms <- function(directory, validFish38 = c(-100, -21), validBlue38 = c(-100, -56), 
                          upLimitFluid120 = -53){
  
  echoData <- .getEchoData(directory, validFish38, validBlue38, upLimitFluid120)
  
  class(echoData) <- "echoData"
  
  return(echoData)
}

#' getLine98
#'
#' @title Takes a matrix of echogram and calculate Oxycline.
#' @description This function search othe Oxycline limits using filters and the procedure 
#' especified in paper of Lau-Medrano W. and Oliveros-Ramos R..
#' 
#' @param fluidMatrix Matrix or list of matrix of echograms.
#' @param combinations List with combination of filters.
#' @param stepBYstep Returns each echogram on a list. 
#'   
#' @examples
#' getLine98(fluidMatrix)

getLine98 <- function(fluidMatrix, combinations = NULL, stepBYstep = TRUE){
  
  # Define 'fluidMatrix' using 
  fluidMatrix <- if(all.equal(class(fluidMatrix), "echoData"))
    fluidMatrix$data else
      list(fluidMatrix)
  
  oxyclineData <- list()
  for(i in seq_along(fluidMatrix)){
    oxyclineData[[i]] <- .getLine98(fluidMatrix[[i]], combinations, stepBYstep)
  }
  
  class(oxyclineData) <- "oxyclineData"
  
  return(oxyclineData)
}

#' echogramPlot
#'
#' @title Takes a list of filtered echograms plot them.
#' @description This function uses an oxyclineData-class object and plot .
#' 
#' @param echogram Object of class \code{oxyclineData} with internal echogram matrix to be plotted.
#' @param echogramNumber Select the echogram to be plotted. If zero (default) the function will plot
#' all the echograms on the list.
#' @param col Pallete of colours to plot the echograms. If \code{NULL} (default) the system
#' will use the same combination used on IMARPE.
#' @param save Do you prefer to save the output plots?
#'   
#' @examples
#' echogramPlot(fluidMatrix)

echogramPlot <- function(echogramOutputs, echogramNumber = 0, col = NULL, save = FALSE, ...){  
  
  if(echogramNumber == 0)
    echogramNumber <- seq_along(echogramOutputs) else
      echogramNumber <- unique(as.integer(echogramNumber))
  
  if(is.null(col))
    col <- colPallete
  
  cat("\nPlotting, please, wait...\n")
  for(i in echogramNumber){
    for(j in seq_along(echogramOutputs[[i]])){
      outName <- paste(i, names(echogramOutputs[[i]])[j], sep = "_")
      
      .echogramPlot(echogramOutputs[[i]][[j]], colPallete = colPallete, save = save, outName = outName, ...)
    }      
  } 
  cat("\nFinished!\n")
  
  return(invisible())
}