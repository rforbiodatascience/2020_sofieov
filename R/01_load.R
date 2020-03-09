# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Install libraries
# ------------------------------------------------------------------------------
#install.packages("tidyverse")
#install.packages("dplyr") 

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")
library("dplyr")

# Define functions
# ------------------------------------------------------------------------------
#source(file = "R/99_project_functions.R")

# Load data
# ------------------------------------------------------------------------------
my_url <- "https://www.ncbi.nlm.nih.gov/Class/FieldGuide/BLOSUM62.txt"
bl62 <- read_table(file = my_url, comment = "#") %>%
  rename(aa = X1)

# Wrangle data
# ------------------------------------------------------------------------------
bl62 <- bl62 %>%
  select(aa:V) %>%
  slice(1:20)

# Write data
# ------------------------------------------------------------------------------
write_tsv(x = bl62, 
          path = "data/_raw/01_BLOSUM62_ncbi.tsv")