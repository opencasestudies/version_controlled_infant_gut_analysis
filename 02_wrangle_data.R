library(dplyr)
library(stringr)

load("processed_data/sample_metadata.rda")

# clean data
clean_metadata <- sample_metadata %>%
  filter(!is.na(SampleID)) %>% # remove all rows in data that are missing sample ID
  mutate(Study = # clean study name to only include last name of first author
           str_remove(Study, "\\_.*") %>% # remove _year from study name
           str_remove_all("(?<=.)[A-Z]")) %>% # remove first name initial from study name
  rename(sampling_paper = `Sampling from papers`, # remove spaces from names of variables 
         sampling_day = `Sampling, day`) %>%
  mutate(sampling_day = as.numeric(sampling_day)) # make sampling_day a numeric variable

# in Yassour study, sample IDs are not unique to samples
clean_metadata %>%
  filter(Study == "Yassour") %>%
  select(Study, Category, SampleID, sampling_day) %>%
  head()

# create new unique sample IDs for Yassour study
clean_metadata <- clean_metadata %>%
  mutate(SampleID = ifelse(Study == "Yassour", # check if study is Yassour
                           paste0(SampleID, sampling_day), # if so, combine sample ID and sampling day
                           SampleID)) # if not, leave sample ID as is 

# confirm that we've fixed this problem
clean_metadata %>%
  filter(Study == "Yassour") %>%
  select(Study, Category, SampleID, sampling_day) %>%
  head()

# two studies (Parnanen and Yassour) took samples from mothers during pregnancy
# for these samples, `sampling_day` represents sampling day since start of pregnancy,
# unlike all other samples for which `sampling_day` represents sampling day since birth
ids_before_birth <- clean_metadata %>%
  filter(Category == "mother",
         Study == "Parnanen" & sampling_paper == "32WK" |
           Study == "Yassour" & sampling_paper == "Gest") %>%
  pull(SampleID) # get sample ids for these samples
clean_metadata <- clean_metadata %>%
  mutate(sampling_before_birth = ifelse(SampleID %in% ids_before_birth,
                                        TRUE,
                                        FALSE))

# save cleaned data
save(clean_metadata, file = "processed_data/clean_sample_metadata.rda")
