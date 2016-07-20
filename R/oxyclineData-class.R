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



  return(invisible())
}

#' Summary method for oxyclineData
#'
#' @param object Object of class \code{oxyclineData}.
#' @param ... Extra argumemts.
#'
#' @export
#' @method summary oxyclineData
summary.oxyclineData <- function(object, ...){
  return(invisible())
}

#' Print method for summary.oxyclineData
#'
#' @param x Object of class \code{summary.oxyclineData}.
#' @param ... Extra argumemts.
#'
#' @export
#' @method print summary.oxyclineData
print.summary.oxyclineData <- function(x, ...){
  return(invisible())
}

#' Plot method for oxyclineData
#'
#' @description This method takes an \code{oxyclineData} object, make an interpolation of oxycline
#' values and show them on a map.
#'
#' @param x Object of class \code{oxyclineData}
#' @param interpParams \code{list} object including parameters passed to \code{\link{interp}} function.
#' @param coastline \code{logical}. Do you want to show the coast line over the map?
#' @param mapParams If \code{coastline=TRUE}, \code{list} object including parameters passed to \code{\link{map}}
#' function.
#' @param ... Extra arguments passed to \code{\link{image}} function.
#'
#' @export
plot.oxyclineData <- function(x, interpParams = list(duplicate = "strip"), coastline = TRUE,
                              mapParams = list(database = "world"), ...){

  # Combine all matrices in one data.frame
  allData <- NULL
  for(i in seq_along(x$oxycline_range)){
    allData <- rbind(allData, x$oxycline_range[[i]])
  }

  # Change colnames
  allData <- as.data.frame(allData, stringsAsFactors = FALSE)
  colnames(allData) <- colnames(x$oxycline_range[[1]])
  x <- allData

  # Remove rows with no-data in lat, lon or upper_limit
  index <- complete.cases(x[,c("lon", "lat", "upper_limit")])
  x <- x[index,]

  # Make interpolation using akima package
  x <- do.call(what = interp, args = c(list(x = x$lon, y = x$lat, z = x$upper_limit), interpParams))

  # Plot map
  image(x = x, ...)

  # Add map
  if(isTRUE(coastline)){
    do.call(map, list(list(add = TRUE), mapParams))
  }

  return(invisible())
}
