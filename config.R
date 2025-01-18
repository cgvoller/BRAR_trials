## ─────────────────────────────────────────────────────────────────────────────
##
## Project: PHOSPHATE
##
## Purpose of script: Configure packages, functions, options & themes
##
## Author: Corey Voller
##
## Date Created: 21/08/2023 
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
## Options ---------------------------------------------------------------------
# Set options
# Set verbose = T for information about the flow of information between the 
# client and server
options(verbose = TRUE, stringsAsFactors = FALSE)

## Load packages ---------------------------------------------------------------
message("Load packages")

# List of packages to be used
packages <-
  c(
    "magrittr",
    "dplyr",
    "tidyr",
    "ggplot2",
    "lubridate",
    "stringr",
    "grid",
    "gridExtra"
  )

# if (length(packages[!(packages %in% installed.packages()[, "Package"])]))
#   install.packages(packages[!(packages %in% installed.packages()[, "Package"])])
# Load packages
lapply(packages, library, character.only = TRUE)

# source functions from sub folder functions
file.sources = list.files(
  c("progs/functions"),
  pattern = "\\.R$",
  full.names = TRUE,
  ignore.case = T
)

sapply(file.sources,source)
