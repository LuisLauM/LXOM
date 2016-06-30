
# oXim package: Oxycline Index from Matrix Echograms ---------------
#' @import R.matlab
#' @import lubridate
#' @useDynLib oXim
#'
#' @title Oxycline Index from Matrix Echograms
#'
#' @author Wencheng Lau-Medrano, \email{llau@@imarpe.gob.pe}
#' @name oXim-package
#' @description Pack oriented to extract oxycline depth from echogram matrix using Sobel-based algorithms.
#' @aliases oXim-package oXim
#' @docType package
#' @references oXim: Oxycline Index from Matrix Echograms (RJournal)
#' @keywords echograms, oxycline, depth, image-filtering
NULL

#' @export readEchograms
#' @exportClass echoData
#'
#' @title Takes outputs from Echopen and generates a matrix to calculate Oxycline.
#' @description This function search outputs of Echoopen for Fluid-like, Blue noise
#' and Fish and use them to make a filtered matrix to calculate the Oxycline limits.
#'
#' @param fileMode List with needed variables to read single Matlab files. See details below.
#' @param directoryMode List with needed variables to read Matlab files from directory. See details below.
#' @param validFish38 Range of valid values for Fish-38kHz
#' @param validBlue38 Range of valid values for Blue-38kHz
#' @param upLimitFluid120 Upper limit for Fluidlike-120kHz
#' @param pinInterval Time threshold (in secs) to consider separate two matrices (echograms).
#' @param date.format A character string. The default method is \code{\%Y-\%m-\%d \%H:\%M:\%S}.
#'
#' @details \code{fileMode} must be a list contains filenames for Fish38, Fluid120 and Bluelike38.
#' For \code{directoryMode}, it must be a list with a directory with Fish38, Fluid120 and Bluelike38
#' files in order to group and build final echograms.
#'
#' @examples
#' fileMode <- list(fish38_file   = system.file("extdata", "fish38.mat", package = "oXim"),
#'                  fluid120_file = system.file("extdata", "fluid120.mat", package = "oXim"),
#'                  blue38_file   = system.file("extdata", "blue38.mat", package = "oXim"))
#' echoData <- readEchograms(fileMode = fileMode)
#' print(echoData)
readEchograms <- function(fileMode = NULL, directoryMode = NULL,
                          validFish38 = c(-100, -21), validBlue38 = c(-100, -56),
                          upLimitFluid120 = -53, pinInterval = 50, date.format = "%d-%m-%Y %H:%M:%S"){

  echoData <- .getEchoData(fileMode = fileMode, directoryMode = directoryMode,
                           validFish38 = validFish38, validBlue38 = validBlue38, upLimitFluid120 = upLimitFluid120,
                           pinInterval = pinInterval, date.format = date.format)

  class(echoData) <- "echoData"

  return(echoData)
}

#' @export getOxyrange
#' @exportClass oxyclineData
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
#' \code{data.frame(type = c(".noiselessFilter", ".definerFilter"), radius = c(3, 3), times = c(2, 1), tolerance = c(0.2, NA), stringsAsFactors = FALSE)}
#'
#' @examples
#' fileMode <- list(fish38_file   = system.file("extdata", "fish38.mat", package = "oXim"),
#'                  fluid120_file = system.file("extdata", "fluid120.mat", package = "oXim"),
#'                  blue38_file   = system.file("extdata", "blue38.mat", package = "oXim"))
#' echoData <- readEchograms(fileMode = fileMode)
#' oxyclineRange <- getOxyrange(echoData)

getOxyrange <- function(fluidMatrix, filterSettings = NULL, stepBYstep = FALSE){

  nEchograms <- fluidMatrix$info$n_echograms

  # Define 'fluidMatrix' using
  fluidMatrix <- if(all.equal(class(fluidMatrix), "echoData")){
    fluidMatrix$data
  }else{
    list(data = fluidMatrix)
  }

  # Get filtered echograms using filterSettings
  filterSettings <- .checkFilterSettings(filterSettings)

  # Get dimensions (lon, lat, time) of outputs' matrix
  oxyDims <- .getOxyDims(oxyclineData = fluidMatrix)

  oxyclineData <- list()
  for(i in seq_along(fluidMatrix)){
    oxyclineData[[i]] <- .getFilteredEchogram(fluidMatrix[[i]], filterSettings, stepBYstep)
  }
  names(oxyclineData) <- paste0("matrix_", seq_along(fluidMatrix))

  # Get ranges of depth of oxycline using the last matrix of each echogram
  oxyRange <- .getOxyrange(oxyclineData = oxyclineData, oxyDims = oxyDims)

  # Compile outputs on a list
  oxyclineData <- list(info = list(number_echograms = nEchograms,
                                   date_range = lapply(fluidMatrix, function(x) range(x$dimnames$time)),
                                   depth_range = lapply(fluidMatrix, function(x) range(x$dimnames$depth)),
                                   filter_settings = filterSettings),
                       dims = oxyDims,
                       outputs = oxyclineData,
                       oxycline_range = oxyRange)

  # Set class
  class(oxyclineData) <- "oxyclineData"

  return(oxyclineData)
}

#' @export createFilterSetting
#'
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
createFilterSetting <- function(name = "default", type = NULL, radius = NULL, times = NULL, tolerance = NULL){

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
    defaultFilterSettings <- get("defaultFilterSettings")
    output <- subset(defaultFilterSettings, defaultFilterSettings$name == name)
  }

  return(output)
}


#' @export echogramPlot
#'
#' @title Plot a matrix of a filtered echogram.
#' @description This function uses an oxyclineData-class object and plot .
#'
#' @param echogramOutput Object of class \code{oxyclineData} with internal echogram matrix to be plotted.
#' @param colEchogram Pallete of colours to plot the echograms. If \code{NULL} (default) the system
#' will use the same combination used on object \code{colPallete}.
#' @param ... Graphical parameters for \code{\link{image}} may also passed as arguments to this function.
#'
#' @examples
#' fileMode <- list(fish38_file   = system.file("extdata", "fish38.mat", package = "oXim"),
#'                  fluid120_file = system.file("extdata", "fluid120.mat", package = "oXim"),
#'                  blue38_file   = system.file("extdata", "blue38.mat", package = "oXim"))
#' echoData <- readEchograms(fileMode = fileMode)
#' echogramPlot(echoData$data$matrix_1$echogram)
echogramPlot <- function(echogramOutput, colEchogram = "colPalette", ...){

  colEchogram <- get(colEchogram)
  .echogramPlot(echogramOutput, colEchogram = colEchogram, ...)

  return(invisible())
}

#' @title Default color palette most using on acostic echograms.
#' @name colPalette
#' @description Vector with 256 colors commonly used on echograms plots.
#' @aliases colPalette
#' @docType data
#' @usage colPalette
#' @format A vector of 256 colors in RBG format.
#' @references Boletines del Instituto del Mar del Peru.
NULL

#' @title Default set of filter parameters.
#' @name defaultFilterSettings
#' @description \code{data.frame} object containig a settings used by \code{getOxyrange}
#' function to apply echograms' matrix. It can be usefull as example of filter settings.
#' @aliases defaultFilterSettings
#' @docType data
#' @usage defaultFilterSettings
#' @format A \code{data.frame} with columns name, type, radius, times and tolerance.
#' @references Lau-Medrano, Luis & Oliveros-Ramos, Ricardo paper.
NULL
