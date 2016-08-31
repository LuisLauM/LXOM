#' @return \code{NULL}
#'
#' @rdname echogramPlot
#' @export
echogramPlot.default <- function(x, colEchogram = "colPalette", ...){
  colEchogram <- get(colEchogram)
  .echogramPlot(x, colEchogram = colEchogram, ...)

  return(invisible())
}
