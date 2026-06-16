library(readxl) # for reading data from supplementary table
library(dplyr) # for combining data across studies 

# read tabs for each study from Table S1 from Wang et al. supplementary information, saved as "meta_analysis_metadata.xlsx"
study_data <- lapply(3:10, function(i) {
  read_xlsx("raw_data/Table S1.xlsx", sheet = i)
}) 

# set all variables to be characters in order to combine data across studies
# original data had encoded same variable in different formats across studies
study_data_clean <- lapply(study_data, function(df) {
  df %>% mutate(across(everything(), as.character))
})

# combine lists for each study into a single data frame
sample_metadata <- bind_rows(study_data_clean)

# save data frame as a .rda file
save(sample_metadata, file = "processed_data/sample_metadata.rda")


