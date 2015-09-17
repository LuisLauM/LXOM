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
#' @param intoOriginal Make the indexation on the original matrix?
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
  
  names(oxyclineData) <- paste0("matrix_", seq_along(fluidMatrix))
  
  oxyclineData <- list(info = list(),
                       outputs = oxyclineData)
  
  class(oxyclineData) <- "oxyclineData"
  
  return(oxyclineData)
}

#' @title Takes a list of filtered echograms plot them.
#' @description This function uses an oxyclineData-class object and plot .
#' 
#' @param echogramOutput Object of class \code{oxyclineData} with internal echogram matrix to be plotted.

#' @param col Pallete of colours to plot the echograms. If \code{NULL} (default) the system
#' will use the same combination used on IMARPE.
#'   
#' @examples
#' echogramPlot(fluidMatrix)

echogramPlot <- function(echogramOutput, col = NULL, ...){
  if(is.null(col))
    col <- colPallete
  
  .echogramPlot(echogramOutput, colPallete = col, ...)

  return(invisible())
}

echogramPlot.all <- function(echogramOutputs, col = NULL, ...){  
    
  if(is.null(col))
    col <- colPallete
  
  cat("\nPlotting, please, wait...\n")  
  
  for(i in seq_along(echogramOutputs)){
    for(j in seq_along(echogramOutputs[[i]])){
      .echogramPlot(echogramOutputs[[i]][[j]], colPallete = col, ...)
    }      
  } 
  cat("\nFinished!\n")
  
  return(invisible())
}