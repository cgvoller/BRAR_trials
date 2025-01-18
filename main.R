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
# Change column names
names(brar_ctg_studies) <- tolower(names(brar_ctg_studies))
names(brar_ctg_studies) <- gsub(pattern = "\\.","_",names(brar_ctg_studies))
# Select relevant columns
studies <- brar_ctg_studies %>% 
  select(study_status,start_date,completion_date,nct_number,enrollment)
# Fix mixing formats of date
studies$start_date <- as.Date(parse_date_time(studies$start_date, c("Ym", "Ymd")))
studies$completion_date <-as.Date(parse_date_time(studies$completion_date, c("Ym", "Ymd")))


# Plot -------------------------------------------------------------------------
brar_plot <- studies %>%
  mutate(study_status = tolower(gsub("_", " ", study_status)),
         study_status=gsub("\\b([a-z])", "\\U\\1", study_status, perl=TRUE)) %>%
  ggplot(
    aes(
      x = start_date,
      y = nct_number,
      xend = completion_date,
      yend = nct_number,
      size = enrollment,
      col = study_status
    )
  ) +
  geom_segment(size = 0.8) +
  geom_point() +
  scale_x_date(date_breaks = "1 year") +
  xlab('Date') +
  ylab('NCT Number') +
  geom_vline(
    xintercept = Sys.Date(),
    linetype = "dotted",
    color = "red",
    size = 0.8
  ) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))+
  ggtitle("Clinical Trials using Bayesian Response-Adaptive Randomisation")

width <- 15
height <- 10
### Save plot ------------------------------------------------------------------
# tiff
# ggsave(
#   plot = brar_plot,
#   filename = "BRAR_studies",
#   path = file.path(getwd(), "output"),
#   width = width,
#   height = height,
#   device = 'tiff',
#   dpi = 700
# )

ggsave(filename = "BRAR.jpeg",
  plot = brar_plot,
  path = file.path(getwd(), "Output"),
  width = width,
  height = height,
  dpi = 700
)
