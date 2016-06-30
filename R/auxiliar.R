.checkFilterSettings <- function(filterSettings){
  defaultFilterSettings <- get("defaultFilterSettings")

  if(is.null(filterSettings)){
    message("Message: \nNo filter-setting object or file detected. OXim will use default filter configuration.")
    output <- defaultFilterSettings[tolower(defaultFilterSettings$name) == "default",]
  }else if(is.vector(filterSettings) && is.character(filterSettings) && length(filterSettings) == 1){
    if(!is.element(tolower(filterSettings), tolower(unique(defaultFilterSettings$name)))){
      stop("Incorrect value for 'filterSettings'. Please define a set of filters using 'createFilterSetting' function.")
    }

    output <- defaultFilterSettings[tolower(defaultFilterSettings$name) == filterSettings,]
  }else if(is.data.frame(filterSettings) &&
           all(is.element(c("type", "radius", "times", "tolerance"), tolower(colnames(filterSettings))))){
    output <- filterSettings
  }

  # Check variables of fileter settings object
  # Chaeck name
  if(!all(is.element(sort(unique(output$type)), c(".definerFilter", ".noiselessFilter"))))
    stop("Problem with 'filterSettings'. There is, at least, one wrong value on 'type' column.")

  # Check radius
  if(any(abs(as.integer(output$radius) - output$radius) > 1e-8) | any(.isOdd(output$radius)) | any(output$radius < 3))
    stop("Problem with 'filterSettings'. There is, at least, one wrong value on 'radius' column.")

  # Check times
  if(any(abs(as.integer(output$times) - output$times) > 1e-8) | any(.isOdd(output$times)) | any(output$times < 1))
    stop("Problem with 'filterSettings'. There is, at least, one wrong value on 'times' column.")

  # Check tolerance
  if(!is.numeric(output$tolerance) | any(output$tolerance <= 0 | output$tolerance >= 1, na.rm = TRUE))
    stop("Problem with 'filterSettings'. There is, at least, one wrong value on 'times' column.")

  return(output)
}

.isOdd <- function(x){
  return(ifelse(x %% 2 != 0, FALSE, TRUE))
}

.getCoordsAxes <- function(coord, what){

  if(tolower(what) == "lon"){
    if(coord < 0){
      sufix <- "\u00b0 W"
    }else if(coord > 0){
      sufix <- "\u00b0 E"
    }else{
      sufix <- "\u00b0"
    }
  }else if(tolower(what) == "lat"){
    if(coord < 0){
      sufix <- "\u00b0 S"
    }else if(coord > 0){
      sufix <- "\u00b0 N"
    }else{
      sufix <- "\u00b0"
    }
  }else{
    stop("Incorrect value for 'what' parameter.")
  }

  output <- paste0(round(abs(coord), 3), sufix)

  return(output)
}

.ac <- as.character
.an <- as.numeric
.anc <- function(...) as.numeric(as.character(...))
