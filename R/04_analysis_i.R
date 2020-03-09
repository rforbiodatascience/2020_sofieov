# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")
library("ggrepel")

# Define functions
# ------------------------------------------------------------------------------
#source(file = "R/99_project_functions.R")

# Load data
# ------------------------------------------------------------------------------
bl62 <-  read_tsv(file = "data/_raw/01_BLOSUM62_ncbi.tsv") 
bl62_clean_aug <- read_tsv(file = "data/03_BLOSUM62_ncbi_clean_aug.tsv")

# Wrangle data
# ------------------------------------------------------------------------------
bl62_pca <- bl62_clean_aug  %>% 
  prcomp(center = TRUE, scale = TRUE)

# Model data - Creating the scree plot
# ------------------------------------------------------------------------------
bl62_pca %>%
  tidy("pcs") %>% 
  ggplot(aes(x = PC, y = percent)) +
  geom_col() +
  theme_bw()

# Augment - see his slides
# ------------------------------------------------------------------------------
bl62_pca_aug <- bl62_pca %>%
  augment(bl62)


# Add chemical classes
# ------------------------------------------------------------------------------
get_chem_class <- function(x){
  chem_cols <- c("A" = "Hydrophobic", "R" = "Basic", "N" = "Neutral", "D" = "Acidic",
                 "C" = "sulphur", "Q" = "Neutral", "E" = "Acidic", "G" = "Polar",
                 "H" = "Basic", "I" = "Hydrophobic", "L" = "Hydrophobic", "K" = "Basic",
                 "M" = "sulphur", "F" = "Hydrophobic", "P" = "Hydrophobic", "S" = "Polar",
                 "T" = "Polar", "W" = "Hydrophobic", "Y" = "Polar", "V" = "Hydrophobic")
  return(factor(chem_cols[x]))
}

bl62_pca_aug <- bl62_pca_aug %>% 
  mutate(chem_class = get_chem_class(aa))

bl62_pca_aug %>% select(aa, chem_class)


# Visualise data
# ------------------------------------------------------------------------------
pca_plot_1 <- bl62_pca_aug %>% 
  ggplot(aes(x = .fittedPC1, y = .fittedPC2, label = aa, colour = chem_class)) +
  geom_text() +
  theme(legend.position = "bottom")

# Prep for another plot, which is more elaborated
bl62_pca_aug %>% 
  pull(chem_class) %>% 
  levels

x <- bl62_pca %>% 
  tidy("pcs") %>% 
  filter(PC==1) %>% 
  pull(percent)
x <- str_c("PC1 (", round(x*100, 2), "%)")

y <- bl62_pca %>% 
  tidy("pcs") %>% filter(PC==2) %>% 
  pull(percent)
y <- str_c("PC2 (", round(y*100, 2), "%)")

pca_plot_2 <- bl62_pca_aug %>% 
  ggplot(aes(x = .fittedPC1, y = .fittedPC2,
             label = aa, colour = chem_class)) +
  geom_label_repel() + # library("ggrepel") trick here
  theme(legend.position = "bottom") +
  scale_colour_manual(values = c("red", "blue", "black",
                                 "purple", "green", "yellow")) +
  labs(x = x, y = y)


# K-means plot
kmeans_plot_3 <- bl62 %>%
  select(-aa) %>%
  kmeans(centers = 6, iter.max = 1000, nstart = 10) %>%
  augment(bl62_pca_aug) %>% 
  head

kmeans_plot_3

# Write data
# ------------------------------------------------------------------------------
#write_tsv(...)
ggsave(filename = "/cloud/project/w6_git_project/Project/results/plot_1.png",
       plot = pca_plot_1,
       width = 10,
       height = 6)

ggsave(filename = "/cloud/project/w6_git_project/Project/results/plot_2.png",
       plot = pca_plot_2,
       width = 10,
       height = 6)

ggsave(filename = "/cloud/project/w6_git_project/Project/results/plot_3.png",
       plot = kmeans_plot_3,
       width = 10,
       height = 6)