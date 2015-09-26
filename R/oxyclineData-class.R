print.oxyclineData <- function(x, ...){
  return(NULL)
}

summary.oxyclineData <- function(x, ...){
  return(NULL)
}

print.summary.oxyclineData <- function(x, ...){
  return(NULL)
}

plot.oxyclineData <- function(x, what = seq_along(x$outputs), plot.line98 = TRUE, 
                              col = NULL, save = FALSE, ...){
  
  what <- suppressWarnings(as.integer(what))
  
  if(is.null(what) || is.na(what))
    stop("Invalid value for 'what' parameter.")

  for(i in what){
    matrix2plot <- c("original", "finalEchogram")
    names(matrix2plot) <- c("Original", "Final echogram")
    for(j in seq_along(matrix2plot)){
      echogramPlot(x$outputs[[i]][[matrix2plot[j]]], colPallete = col, 
                   main = paste(names(matrix2plot)[j], i, sep = "_"), ...)
      
      if(isTRUE(plot.line98))
        .line98Plot(x$line98[[i]], lwd = 2)
    }
  }
  
  return(invisible())
}