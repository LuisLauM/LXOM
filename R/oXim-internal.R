#' @return \code{NULL}
#'
#' @rdname echogramPlot
#' @export
echogramPlot.default <- function(echogramOutput, colEchogram = "colPalette", ...){
  colEchogram <- get(colEchogram)
  .echogramPlot(echogramOutput, colEchogram = colEchogram, ...)

  return(invisible())
}
