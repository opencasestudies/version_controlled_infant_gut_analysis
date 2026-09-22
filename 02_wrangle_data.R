library(dplyr) # for data manipulation
library(stringr) # for working with strings

# load data that we saved in data_import
load("processed_data/sample_metadata.rda")

# clean data
clean_metadata <- sample_metadata %>%
  # remove all rows in data that are missing sample ID
  filter(!is.na(SampleID)) %>% 
  # clean study name to only include last name of first author
  mutate(Study = 
           # remove _year from study name
           str_remove(Study, "\\_.*") %>% 
           # remove first name initial from study name
           str_remove_all("(?<=.)[A-Z]")) %>% 
  # remove spaces from names of variables 
  rename(sampling_paper = `Sampling from papers`, 
         sampling_day = `Sampling, day`) %>%
  # make sampling_day a numeric variable
  mutate(sampling_day = as.numeric(sampling_day)) 

# in Yassour study, sample IDs are not unique to samples 
# first inspect this to confirm
clean_metadata %>%
  filter(Study == "Yassour") %>%
  select(Study, Category, SampleID, sampling_day) %>%
  head()

# create new unique sample IDs for Yassour study
clean_metadata <- clean_metadata %>%
  # check if study is Yassour
  mutate(SampleID = ifelse(Study == "Yassour", 
                           # if so, combine sample ID and sampling day
                           paste0(SampleID, sampling_day),
                           # if not, leave sample ID as is 
                           SampleID)) 

# confirm that we've fixed this problem
clean_metadata %>%
  filter(Study == "Yassour") %>%
  select(Study, Category, SampleID, sampling_day) %>%
  head()

# two studies (Parnanen and Yassour) took samples 
# from mothers during pregnancy
# for these samples, `sampling_day` represents sampling day 
# since start of pregnancy, unlike all other samples for which 
# `sampling_day` represents sampling day since birth
ids_before_birth <- clean_metadata %>%
  # identify these specific samples
  filter(Category == "mother",
         Study == "Parnanen" & sampling_paper == "32WK" |
           Study == "Yassour" & sampling_paper == "Gest") %>%
  # get sample ids for these samples
  pull(SampleID) 
clean_metadata <- clean_metadata %>%
  # add `sampling_before_birth` variable, and set to TRUE
  # for these specific samples we identified 
  mutate(sampling_before_birth = ifelse(SampleID %in% ids_before_birth,
                                        TRUE, FALSE))

# save cleaned data
save(clean_metadata, file = "processed_data/clean_sample_metadata.rda")
