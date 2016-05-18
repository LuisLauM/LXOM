# Print method for oxyclineData objects
print.oxyclineData <- function(x, ...){
  return(NULL)
}

# Summary method for oxyclineData objects
summary.oxyclineData <- function(x, ...){
  return(NULL)
}

# Print method for summary of oxyclineData objects
print.summary.oxyclineData <- function(x, ...){
  return(NULL)
}

# Plot method for oxyclineData objects
plot.oxyclineData <- function(x, what = seq_along(x$outputs), plot.oxyrange = TRUE,
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

      if(isTRUE(plot.oxyrange))
        .lineOxyrangePlot(x$oxycline_range[[i]], lwd = 2)
    }
  }

  return(invisible())
}
