
# Read settings for filters ----------------------------------------------------

.filterSettings <- read.csv(file = "auxiliar/filter_settings.csv", stringsAsFactors = FALSE)

save(.filterSettings, file = "data/filterSettings.RData")
