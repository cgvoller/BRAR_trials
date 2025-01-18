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
## Notes: Bayesian AND (response-adaptive randomisation/randomization OR 
##        response adaptive randomisation/randomization)
## Bayesian AND (adaptive randomization OR response-adaptive randomization OR adaptive allocation)
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
  gsub("\\.csv","",.) %>% 
  gsub("/", "", .) %>%
  gsub("-", "_", .)

# Read in data
df.list <-lapply(file.list,read.csv)

# Set names
names(df.list) <- file.names
# get dfs
list2env(df.list, envir = .GlobalEnv)

# Comparing previous search with updated (see notes)
BRAR_ctg_studies$NCT.Number %in% BRAR2_ctg_studies$NCT.Number

brar_ctg_studies <- BRAR2_ctg_studies
brar_ctg_studies |> dim()
# Data manipulation ------------------------------------------------------------
# Change column names
names(brar_ctg_studies) <- tolower(names(brar_ctg_studies))
names(brar_ctg_studies) <- gsub(pattern = "\\.","_",names(brar_ctg_studies))
# Select relevant columns
studies <- brar_ctg_studies %>% 
  select(acronym,study_status,start_date,completion_date,nct_number,enrollment)
# Turn blanks into NA, where there is an acronym for the trial, use that
studies %<>% 
  mutate_if(is.character, list(~na_if(.,"")))  %>% 
  mutate(nct_number = ifelse(!is.na(acronym),acronym,nct_number),
         completion_date = ifelse(is.na(completion_date),start_date,completion_date))
# Fix mixing formats of date
studies$start_date <- as.Date(parse_date_time(studies$start_date, c("Ym", "Ymd")))
studies$completion_date <-as.Date(parse_date_time(studies$completion_date, c("Ym", "Ymd")))



# Plot -------------------------------------------------------------------------
brar_plot <- studies %>%
  arrange(start_date) %>% 
  mutate(study_status = tolower(gsub("_", " ", study_status)),
         study_status=gsub("\\b([a-z])", "\\U\\1", study_status, perl=TRUE),
         nct_number=factor(nct_number,levels = unique(nct_number),ordered = T)) %>%
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
  labs(size="Enrollment", colour="Study Status")+
  #labs(color='Enrollment')+
  scale_x_date(date_breaks = "1 year") +
  xlab('Date') +
  ylab('Trial Name') +
  geom_vline(
    xintercept = Sys.Date(),
    linetype = "dotted",
    color = "red",
    size = 0.8
  ) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))+
  ggtitle("Clinical Trials using Bayesian Response-Adaptive Randomisation")

brar_plot
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
