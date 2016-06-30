#' Print method for oxyclineData
#' @title Print method for oxyclineData Objects.
#' @description Shows main information from oxyclineData Objects.
#'
#' @param x Object of class \code{oxyclineData}.
#' @param ... Extra argumemts.
#'
#' @export
#' @method print oxyclineData
print.oxyclineData <- function(x, ...){
  return(NULL)
}

#' Summary method for oxyclineData
#'
#' @param object Object of class \code{oxyclineData}.
#' @param ... Extra argumemts.
#'
#' @export
#' @method summary oxyclineData
summary.oxyclineData <- function(object, ...){
  return(NULL)
}

#' Print method for summary.oxyclineData
#'
#' @param x Object of class \code{summary.oxyclineData}.
#' @param ... Extra argumemts.
#'
#' @export
#' @method print summary.oxyclineData
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
