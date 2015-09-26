print.oxyclineData <- function(x, ...){
  return(NULL)
}

summary.oxyclineData <- function(x, ...){
  return(NULL)
}

print.summary.oxyclineData <- function(x, ...){
  return(NULL)
}

plot.oxyclineData <- function(x, what = seq_along(x$outputs), 
                              col = NULL, save = FALSE, ...){
  
  what <- suppressWarnings(as.integer(what))
  
  if(is.null(what) || is.na(what))
    stop("Invalid value for 'what' parameter.")

  for(i in what){
    
    matrix2plot <- c("original", "finalEchogram")
    names(matrix2plot) <- c("Original", "Final echogram")
    for(j in seq_along(matrix2plot)){
      echogramPlot(x$outputs[[i]][[matrix2plot[j]]], col = col, 
                   main = paste(names(matrix2plot)[j], i, sep = "_"), ...)
    }
    
#     echogramPlot(x$outputs[[i]]$original, col = col, main = paste0("Original_", i), axes = FALSE
#                  xlab = "Time", ylab = "Depth (m)", ...)
#     echogramPlot(x$outputs[[i]]$finalEchogram, col = col, main = paste0("Final echogram_", i), axes = FALSE
#                  xlab = "Time", ylab = "Depth (m)", ...)
  }
  
  return(invisible())
}