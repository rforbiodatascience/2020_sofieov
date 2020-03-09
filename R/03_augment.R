# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")

# Define functions
# ------------------------------------------------------------------------------
#source(file = "R/99_project_functions.R")

# Load data
# ------------------------------------------------------------------------------
bl62_clean <- read_tsv(file = "data/02_BLOSUM62_ncbi_clean.tsv")

# Wrangle data
# ------------------------------------------------------------------------------
# Do something smart
bl62_clean_aug <- bl62_clean

# Write data
# ------------------------------------------------------------------------------
write_tsv(x = bl62_clean_aug,
          path = "data/03_BLOSUM62_ncbi_clean_aug.tsv")
