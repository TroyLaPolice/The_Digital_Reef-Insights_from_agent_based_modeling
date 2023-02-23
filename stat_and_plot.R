# Load Libraries
library(data.table)
library(ggplot2)
library(gtools)

# ----------------------------------------------------------------------------------------------------------------
# Set inputs and read in files to be used for analysis
# ----------------------------------------------------------------------------------------------------------------

# Set input params
setwd("/home/tml5905/Documents/CoralPopulationSimulation/runs/pref_habitat")

# Specify and select files
file_names = list.files(".", pattern="sim_pop*", full.names = TRUE)

if (length(file_names) != 0)
{
  # Sort Files
  file_names = mixedsort(file_names)
  # Read in File
  files = lapply(file_names, read.csv)
}

# -----------------------------------------
# Read in parameter file
# -----------------------------------------

# Read in Param File
param_file_name = "param_inputs_clean.txt"
param_file = lapply(param_file_name, read.csv)

# -----------------------------------------
# Create DT from data file
# -----------------------------------------


if (length(file_names) != 0)
{
  file_data = lapply(1:length(file_names), function(x) 
  {
    params = strsplit(as.character(param_file[[1]][x,]), split = "   ")[[1]]
    params = matrix(params, nrow = 1)
    colnames(params) = gsub(sapply(strsplit(params, split = " = "), function(x) x[1]), pattern = " ", replacement = "_")
    data = files[[x]]
    
    cbind(params, data)
  }
  )
  
  # Create data table with simulation output data
  sim_data = rbindlist(file_data)
  
  # Add columns that remove extra strings in parameter set
  sim_data[, Map_Style_n := as.numeric(gsub(map_style, pattern = ".*\\s(.+)", replacement = "\\1"))]
  sim_data[, habitat_preference_n := as.numeric(gsub(habitat_preference, pattern = ".*\\s(.+)", replacement = "\\1"))]
  sim_data[, starting_number_n := as.numeric(gsub(starting_number, pattern = ".*\\s(.+)", replacement = "\\1"))]
  sim_data[, initial_palmata_n := as.numeric(gsub(initial_palmata, pattern = ".*\\s(.+)", replacement = "\\1"))]
  sim_data[cervicornis_ancestry_in_palmata < 0, cervicornis_ancestry_in_palmata := 0]
  sim_data[palmata_ancestry_in_cervicornis < 0, palmata_ancestry_in_cervicornis := 0]
}

# Write to output file
fwrite(sim_data, file = "all_sim_data.csv", append = FALSE, quote = "auto", sep = ",")

# ----------------------------------------------------------------------------------------------------------------
# Plot data
# ----------------------------------------------------------------------------------------------------------------

introgressed_ancestry_100 = ggplot(sim_data[Year < 100 & Year %% 5 == 0]) + 
  geom_point(aes(as.numeric(Year), cervicornis_ancestry_in_palmata, pch = factor(habitat_preference_n), col = "cervicornis ancestry in palmata")) + 
  theme_bw() + labs(x = "Year") + labs(y = "Introgressed Ancestry") + 
  facet_grid(initial_palmata ~ starting_number)  + 
  geom_point(aes(as.numeric(Year), palmata_ancestry_in_cervicornis, pch = factor(habitat_preference_n), col = "palmata ancestry in cervicornis")) + 
  facet_grid(initial_palmata ~ starting_number) 
ggsave("introgressed_ancestry_100.png", plot = introgressed_ancestry_100, units = "in", width = 14, height = 7, device="png", dpi=700)

introgressed_ancestry_250 = ggplot(sim_data[Year < 250 & Year %% 10 == 0]) + 
  geom_point(aes(as.numeric(Year), cervicornis_ancestry_in_palmata, pch = factor(habitat_preference_n), col = "cervicornis ancestry in palmata")) + 
  theme_bw() + labs(x = "Year") + labs(y = "Introgressed Ancestry") + 
  facet_grid(initial_palmata ~ starting_number)  + 
  geom_point(aes(as.numeric(Year), palmata_ancestry_in_cervicornis, pch = factor(habitat_preference_n), col = "palmata ancestry in cervicornis")) + 
  facet_grid(initial_palmata ~ starting_number) 
ggsave("introgressed_ancestry_250.png", plot = introgressed_ancestry_250, units = "in", width = 14, height = 7, device="png", dpi=700)

introgressed_ancestry_1000 = ggplot(sim_data[Year < 1000 & Year %% 25 == 0]) + 
  geom_point(aes(as.numeric(Year), cervicornis_ancestry_in_palmata, pch = factor(habitat_preference_n), col = "cervicornis ancestry in palmata")) + 
  theme_bw() + labs(x = "Year") + labs(y = "Introgressed Ancestry") + 
  facet_grid(initial_palmata ~ starting_number)  + 
  geom_point(aes(as.numeric(Year), palmata_ancestry_in_cervicornis, pch = factor(habitat_preference_n), col = "palmata ancestry in cervicornis")) + 
  facet_grid(initial_palmata ~ starting_number) 
ggsave("introgressed_ancestry_1000.png", plot = introgressed_ancestry_1000, units = "in", width = 14, height = 7, device="png", dpi=700)

introgressed_ancestry_5000 = ggplot(sim_data[Year < 5000 & Year %% 25 == 0]) + 
  geom_point(aes(as.numeric(Year), cervicornis_ancestry_in_palmata, pch = factor(habitat_preference_n), col = "cervicornis ancestry in palmata")) + 
  theme_bw() + labs(x = "Year") + labs(y = "Introgressed Ancestry") + 
  facet_grid(initial_palmata ~ starting_number)  + 
  geom_point(aes(as.numeric(Year), palmata_ancestry_in_cervicornis, pch = factor(habitat_preference_n), col = "palmata ancestry in cervicornis")) + 
  facet_grid(initial_palmata ~ starting_number) 
ggsave("introgressed_ancestry_5000.png", plot = introgressed_ancestry_5000, units = "in", width = 14, height = 7, device="png", dpi=700)
