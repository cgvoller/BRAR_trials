## ─────────────────────────────────────────────────────────────────────────────
##
## Project: C:/Users/Corey/Documents/Statistics/PhD/Literature Review/Clinical Trials/Clinicaltrialsgov/BRAR_trials
##
## Purpose of script: Create summaries of BRAR Trials
##
## Author: Corey Voller
##
## Date Created: 18-01-2025
##
## QC'd by:
## QC date:
##
## ─────────────────────────────────────────────────────────────────────────────
##
## Notes:
##   
##
## ─────────────────────────────────────────────────────────────────────────────
##
## 
## Load configuations ----------------------------------------------------------

# Source configuration scripts with packages, functions and output theme options
source("config.R")
## Import data -----------------------------------------------------------------
data_path <- file.path(paste0(getwd(),"/data"))
# Get all csvs in folder
file.list = list.files(path = data_path,pattern="\\.csv$",full.names = T)
# Create names
file.names <- gsub(data_path,"",file.list) %>%
  gsub("/dbo_","",.) %>%
  gsub("\\.csv","",.)

# Read in data
df.list <-lapply(file.list,read.csv)

# Set names
names(df.list) <- file.names

# Clean names
df.list <- setNames(df.list, tolower(file.names))
tidy_names <- function(y) {
  names(y) <- names(y) %>%
    gsub("/", "", .) %>%
    gsub("-", "_", .)
  # Return
  return(y)
}
dfList <- tidy_names(df.list[1])
#dfList <- lapply(df.list,\(x) {tidy_names(x);x})
list2env(dfList, envir = .GlobalEnv)


# Data manipulation ------------------------------------------------------------
