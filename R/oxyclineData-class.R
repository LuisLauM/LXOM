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
    echogramPlot(x$outputs[[i]]$original, col = col, main = paste0("Original_", i), ...)
    echogramPlot(x$outputs[[i]]$finalEchogram, col = col, main = paste0("Final echogram_", i), ...)
  }
  
  return(invisible())
}