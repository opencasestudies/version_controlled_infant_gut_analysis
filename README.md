# version_controlled_infant_gut_analysis

## Introduction

This repository is the companion repository to the Bio-OCS Version Control case study. This is meant to serve an educational purpose, while mimicking a repository for a scientific analysis. These are real data, introduced by Wang et al. 

Data citation: Wang, S., Zeng, S., Egan, M., Cherry, P., Strain, C., Morais, E., Boyaval, P., Ryan, C. A., Dempsey, E., Ross, R. P., & Stanton, C. (2021). Metagenomic analysis of mother‑infant gut microbiome reveals global distinct and shared microbial signatures. Gut Microbes, 13(1). https://doi.org/10.1080/19490976.2021.1911571 

## Organization

This repo is organized as follows:

- raw data: 
  - meta_analysis_metadata.xlsx: Sample metadata, available as file "Table S1.xlsx" in the [Supplementary Information](https://www.tandfonline.com/action/downloadSupplement?doi=10.1080%2F19490976.2021.1911571&file=kgmi_a_1911571_sm8722.zip&__cf_chl_tk=DEof_mHrRsIvA3N7tqoxMQaEPKs1rFG8PWbjQqhDJcY-1771529206-1.0.1.1-r9ilfrtjQlW1cGewP6YMASIyLseZ0a51kWPS09ggMbg) of the Wang et al. paper 
- processed_data: 
  - sample_metadata.csv: A clean version of "meta_analysis_metadata.xlsx", saved as a single data frame 
  - sequencing_metadata.csv: Sequencing metadata, pulled from the ENA Portal [API](https://www.ebi.ac.uk/ena/portal/api/search) in script "01-pull-sequencing-data.R"