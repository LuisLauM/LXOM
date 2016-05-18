#' readEchograms
#'
#' @title Takes outputs from Echopen and generates a matrix to calculate Oxycline.
#' @description This function search outputs of Echoopen for Fluid-like, Blue noise
#' and Fish and use them to make a filtered matrix to calculate the Oxycline limits.
#'
#' @param directory Directory where are outputs of Echoopen for Fluid-like, Blue noise
#' and Fish.
#' @param validFish38 Range of valid values for Fish-38kHz
#' @param validBlue38 Range of valid values for Blue-38kHz
#' @param upLimitFluid120 Upper limit for Fluidlike-120kHz
#' @param pinInterval Time threshold (in secs) to consider separate two matrices (echograms).
#' @param date.format A character string. The default method is \code{\%Y-\%m-\%d \%H:\%M:\%S}.
#'
#' @examples
#' readEchograms(directory = "C:/Echodata")

# readEchograms <- function(fish38_File, blue38_File, fluidlike38_File,
#                           fish38_File = NULL, blue38_File = NULL, fluidlike38_File = NULL,
#                           validFish38 = c(-100, -21), validBlue38 = c(-100, -56),
#                           upLimitFluid120 = -53, pinInterval = 50, date.format = "%d-%m-%Y %H:%M:%S")
readEchograms <- function(directory,
                          validFish38 = c(-100, -21), validBlue38 = c(-100, -56),
                          upLimitFluid120 = -53, pinInterval = 50, date.format = "%d-%m-%Y %H:%M:%S"){

  echoData <- .getEchoData(directory, validFish38, validBlue38, upLimitFluid120, pinInterval,
                           date.format)

  class(echoData) <- "echoData"

  return(echoData)
}

#' getOxyrange
#'
#' @title Takes a matrix of echogram and calculate Oxycline.
#' @description This function search othe Oxycline limits using filters and the procedure
#' especified in paper of Lau-Medrano W. and Oliveros-Ramos R..
#'
#' @param fluidMatrix Matrix or list of matrix of echograms.
#' @param filterSettings List with combination of filters.
#' @param stepBYstep Returns each echogram on a list.
#'
#' @details If \code{filterSettings} parameter is \code{NULL}, oXim will use as default
#' \code{data.frame(type = c(".noiselessFilter", ".definerFilter"), radius = c(3, 3), times = c(2, 1), tolerance = c(0.2, NA),  stringsAsFactors = FALSE)}
#'
#' @examples
#' getOxyrange(fluidMatrix)

getOxyrange <- function(fluidMatrix, filterSettings = NULL, stepBYstep = FALSE){

  nEchograms <- fluidMatrix$info$n_echograms

  # Define 'fluidMatrix' using
  fluidMatrix <- if(all.equal(class(fluidMatrix), "echoData"))
    fluidMatrix$data else
      list(data = fluidMatrix)

  # Get filtered echograms using filterSettings
  filterSettings <- .checkFilterSettings(filterSettings)

  # Get dimensions (lon, lat, time) of outputs' matrix
  oxyDims <- .getOxyDims(fluidMatrix)

  oxyclineData <- list()
  for(i in seq_along(fluidMatrix)){
    oxyclineData[[i]] <- .getFilteredEchogram(fluidMatrix[[i]], filterSettings, stepBYstep)
  }
  names(oxyclineData) <- paste0("matrix_", seq_along(fluidMatrix))

  # Get ranges of depth of oxycline using the last matrix of each echogram
  oxyRange <- .getOxyrange(oxyclineData, oxyDims)

  # Compile outputs on a list
  oxyclineData <- list(info = list(number_echograms = nEchograms,
                                   date_range = lapply(fluidMatrix, function(x) range(x$dimnames$time)),
                                   depth_range = lapply(fluidMatrix, function(x) range(x$dimnames$depth))),
                       dims = oxyDims,
                       outputs = oxyclineData,
                       oxycline_range = oxyRange)

  # Set class
  class(oxyclineData) <- "oxyclineData"

  return(oxyclineData)
}

#' @title Create filter-settings Object.
#' @description This function allows to create correctly a filter-settings object in order to insert as input on
#' \code{getOxyrange} function.
#'
#' @param name Parameter to indicate prefixed profile of settings. This parameter has priority over the others.
#' @param type Indicates type of filter to use. See details below.
#' @param radius Indicates the size (on pixels) of sides of square used to apply the filters.
#' @param times Indicates number of times to apply the filters.
#' @param tolerance For \code{.noiselessFilter}, this parameter indicates proportion of pixels to consider from
#' filter matrix (radius x radius).
#'
#' @examples
#' # Use default profile
#' createFilterSetting(name = "default")
#'
#' # Generate a personalized profile
#' createFilterSetting(type = ".definerFilter", radius = c(3, 5, 5))
createFilterSetting <- function(name = NULL, type = NULL, radius = NULL, times = NULL, tolerance = NULL){
  if(is.null(name) || !is.vector(name) || length(name) > 1){
    # Check variables of fileter settings object
    # Chaeck name
    if(!is.element(sort(unique(type)), c(".definerFilter", ".noiselessFilter")))
      stop("Problem with 'filterSettings'. There is, at least, one wrong value on 'type' column.")

    # Check radius
    if(any(abs(as.integer(radius) - radius) > 1e-8) | any(.isOdd(radius)) | any(radius < 3))
      stop("Problem with 'filterSettings'. There is, at least, one wrong value on 'radius' column.")

    # Check times
    if(any(abs(as.integer(times) - times) > 1e-8) | any(times < 1))
      stop("Problem with 'filterSettings'. There is, at least, one wrong value on 'times' column.")

    # Check tolerance
    if(!is.numeric(tolerance) | any(tolerance <= 0 | tolerance >= 1))
      stop("Problem with 'filterSettings'. There is, at least, one wrong value on 'times' column.")

    # Get maximum length
    allLength <- max(unlist(lapply(list(type, radius, times, tolerance), length)))

    # Build filter-settings Object
    output <- data.frame(type = rep(type, length.out = allLength),
                         radius = rep(radius, length.out = allLength),
                         times = rep(times, length.out = allLength),
                         tolerance = rep(tolerance, length.out = allLength),
                         stringsAsFactors = FALSE)
  }else{
    output <- .filterSettings[.filterSettings$name == name,]
  }

  return(output)
}

#' @title Plot a matrix of a filtered echogram.
#' @description This function uses an oxyclineData-class object and plot .
#'
#' @param echogramOutput Object of class \code{oxyclineData} with internal echogram matrix to be plotted.
#' @param colEchogram Pallete of colours to plot the echograms. If \code{NULL} (default) the system
#' will use the same combination used on object \code{colPallete}.
#'
#' @examples
#' echogramPlot(fluidMatrix)

echogramPlot <- function(echogramOutput, colEchogram = NULL, ...){
  if(is.null(colEchogram))
    colEchogram <- colPallete

  .echogramPlot(echogramOutput, colEchogram = colEchogram, ...)

  return(invisible())
}

#' @title Wrap of \code{echogramPlot}.
#' @description Plot all echograms on an oxyclineData-class object.
#'
#' @param echogramOutput Object of class \code{oxyclineData} with internal echogram matrix to be plotted.
#' @param colEchogram Pallete of colours to plot the echograms. If \code{NULL} (default) the system
#' @param ... Arguments passed to internal \code{image} function.
#' will use the same combination used on object \code{colPallete}.
#'
#' @examples
#' echogramPlot.all(fluidMatrix)
#'
echogramPlot.all <- function(echogramOutputs, col = NULL, ...){

  if(is.null(col))
    col <- colPallete

  for(i in seq_along(x$outputs)){
    matrix2plot <- c("original", "finalEchogram")
    names(matrix2plot) <- c("Original", "Final echogram")
    for(j in seq_along(matrix2plot)){
      echogramPlot(x$outputs[[i]][[matrix2plot[j]]], colPallete = col,
                   main = paste(names(matrix2plot)[j], i, sep = "_"), ...)
    }
  }

  return(invisible())
}
