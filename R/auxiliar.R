.checkFilterSettings <- function(filterSettings){
  if(is.null(filterSettings)){
    message("Message: \n No filter-setting object or file detected. oXim will use default configuration.")
    output <- .filterSettings[tolower(.filterSettings$name) == "default",]
  }else if(is.vector(filterSettings) && is.character(filterSettings) && length(filterSettings) == 1){
    if(!is.element(tolower(filterSettings), tolower(unique(.filterSettings$name))))
      stop("Incorrect value for 'filterSettings'. Please define a set of filters using 'createFilterSetting' function.")

    output <- .filterSettings[tolower(.filterSettings$name) == filterSettings,]
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
