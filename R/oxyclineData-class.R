#' Print method for oxyclineData
#' @title Print method for oxyclineData Objects.
#' @description Shows main information from oxyclineData Objects.
#'
#' @param x Object of class \code{oxyclineData}.
#' @param ... Extra argumemts.
#'
#' @export
#' @method print oxyclineData
#'
#' @examples
#' # Set a list of directories
#' fileMode <- list(fish38_file   = system.file("extdata", "fish38.mat", package = "oXim"),
#'                  fluid120_file = system.file("extdata", "fluid120.mat", package = "oXim"),
#'                  blue38_file   = system.file("extdata", "blue38.mat", package = "oXim"))
#'
#' # Read echograms
#' echoData <- readEchograms(fileMode = fileMode)
#'
#' # Calculate oxycline range
#' echoOutputs <- getOxyrange(fluidMatrix = echoData)
#'
#' # Print oxycline range
#' print(echoOutputs)
print.oxyclineData <- function(x, ...){
  return(NULL)
}

#' Summary method for oxyclineData
#'
#' @param x Object of class \code{oxyclineData}.
#' @param ... Extra argumemts.
#'
#' @export
#' @method summary oxyclineData
#'
#' @examples
#' # Set a list of directories
#' fileMode <- list(fish38_file   = system.file("extdata", "fish38.mat", package = "oXim"),
#'                  fluid120_file = system.file("extdata", "fluid120.mat", package = "oXim"),
#'                  blue38_file   = system.file("extdata", "blue38.mat", package = "oXim"))
#'
#' # Read echograms
#' echoData <- readEchograms(fileMode = fileMode)
#'
#' # Calculate oxycline range
#' echoOutputs <- getOxyrange(fluidMatrix = echoData)
#'
#' # Get summary
#' summary(echoOutputs)
summary.oxyclineData <- function(x, ...){
  return(NULL)
}

#' Print method for summary.oxyclineData
#'
#' @param x Object of class \code{summary.oxyclineData}.
#' @param ... Extra argumemts.
#'
#' @export
#' @method print summary.oxyclineData
#'
#' @examples
#' # Set a list of directories
#' fileMode <- list(fish38_file   = system.file("extdata", "fish38.mat", package = "oXim"),
#'                  fluid120_file = system.file("extdata", "fluid120.mat", package = "oXim"),
#'                  blue38_file   = system.file("extdata", "blue38.mat", package = "oXim"))
#'
#' # Read echograms
#' echoData <- readEchograms(fileMode = fileMode)
#'
#' # Calculate oxycline range
#' echoOutputs <- getOxyrange(fluidMatrix = echoData)
#'
#' # Get and print summary
#' print(summary(echoOutputs))
print.summary.oxyclineData <- function(x, ...){
  return(NULL)
}

#' Plot method for oxyclineData
#'
#' @param x Object of class \code{oxyclineData}
#' @param what What echogram (in number) do you want to plot?
#' @param plot.oxyrange \code{logical}. If \code{TRUE} (default), show lines of oxycline range.
#' @param col Vector of color (palette) used to plot echograms.
#' @param ... Extra arguments passed to \code{echogramPlot} function.
#'
#' @export
#' @method plot oxyclineData
#'
#' @examples
#' # Set a list of directories
#' fileMode <- list(fish38_file   = system.file("extdata", "fish38.mat", package = "oXim"),
#'                  fluid120_file = system.file("extdata", "fluid120.mat", package = "oXim"),
#'                  blue38_file   = system.file("extdata", "blue38.mat", package = "oXim"))
#'
#' # Read echograms
#' echoData <- readEchograms(fileMode = fileMode)
#'
#' # Calculate oxycline range
#' echoOutputs <- getOxyrange(fluidMatrix = echoData)
#'
#' # Plot oxycline range
#' plot(echoOutputs)
plot.oxyclineData <- function(x, what = seq_along(x$outputs), plot.oxyrange = TRUE,
                              col = NULL, ...){

  what <- suppressWarnings(as.integer(what))

  if(is.null(what) || is.na(what))
    stop("Invalid value for 'what' parameter.")

  for(i in what){
    matrix2plot <- c("original", "finalEchogram")
    names(matrix2plot) <- c("Original", "Final echogram")
    for(j in seq_along(matrix2plot)){
      echogramPlot(x$outputs[[i]][[matrix2plot[j]]], colPallete = col,
                   main = paste(names(matrix2plot)[j], i, sep = "_"), ...)

      if(isTRUE(plot.oxyrange))
        .lineOxyrangePlot(x$oxycline_range[[i]], lwd = 2)
    }
  }

  return(invisible())
}
