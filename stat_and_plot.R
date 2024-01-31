# Load Libraries
library(data.table)
library(ggplot2)
library(gtools)
library(dplyr)

# ----------------------------------------------------------------------------------------------------------------
# Set inputs and read in files to be used for analysis
# ----------------------------------------------------------------------------------------------------------------

# Set input params
setwd("/home/tml5905/Documents/CoralPopulationSimulation/runs/beneficial_mutation")

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
  sim_data[, starting_number_n := as.numeric(gsub(starting_number, pattern = ".*\\s(.+)", replacement = "\\1"))]
  sim_data[, initial_palmata_n := as.numeric(gsub(initial_palmata, pattern = ".*\\s(.+)", replacement = "\\1"))]
  #sim_data[, repro_rate_n := as.numeric(gsub(repro_rate, pattern = ".*\\s(.+)", replacement = "\\1"))]
  
  sim_data = sim_data %>% mutate_at(c("Year", "PopulationSize", "Total_palmata", "Total_cervicornis", "Total_prolifera", "Ratio_palmata_to_cervicornis", "cervicornis_ancestry_in_palmata", "palmata_ancestry_in_cervicornis", "palmata_ancestry_in_prolifera", "cervicornis_ancestry_in_prolifera"), as.numeric)
  
  sim_data[cervicornis_ancestry_in_palmata < 0, cervicornis_ancestry_in_palmata := 0]
  sim_data[palmata_ancestry_in_cervicornis < 0, palmata_ancestry_in_cervicornis := 0]
}

# Write to output file
fwrite(sim_data, file = "all_sim_data.csv", append = FALSE, quote = "auto", sep = ",")

# ----------------------------------------------------------------------------------------------------------------
# Plot data
# ----------------------------------------------------------------------------------------------------------------

selected_data = sim_data[Year < 201]

max_cer = max(as.integer(selected_data$Total_cervicornis))
max_pal = max(as.integer(selected_data$Total_palmata))
max_pro = max(as.integer(selected_data$Total_prolifera))
maximums = c(max_cer, max_pal, max_pro)
max_total_inds = max(maximums)

max_cer_in_pal = max((selected_data$cervicornis_ancestry_in_palmata))
max_pal_in_cer = max((selected_data$palmata_ancestry_in_cervicornis))
maximums2 = c(max_cer_in_pal, max_pal_in_cer)
max_ancestry = max(maximums2)

primary_y_lim = c(0, max_ancestry)
secondary_y_lim = c(0, max_total_inds)

b = diff(primary_y_lim)/diff(secondary_y_lim)
a = primary_y_lim[1] - b*secondary_y_lim[1]

introgressed_ancestry_twoaxis = ggplot(sim_data[Year < 150]) + 
  scale_y_continuous("Introgressed Ancestry", sec.axis = sec_axis(~ (. - a)/b, name = "Total Individuals")) +
  geom_area(aes(Year, palmata_ancestry_in_cervicornis, fill="A. palmata ancestry in A. cervicornis"), alpha = 0.4) +
  geom_area(aes(Year, cervicornis_ancestry_in_palmata, fill="A. cervicornis ancestry in A. palmata"), alpha = 0.4) + 
  scale_color_manual(values = c("#E41A1C", "#337CB7", "#A162D0")) +
  geom_line(aes(as.numeric(Year), y = a + Total_cervicornis*b, col = "A. cervicornis individuals"), linewidth = 0.75) +
  geom_line(aes(as.numeric(Year), y = a + Total_palmata*b, col = "A. palmata individuals"), linewidth = 0.75) +
  geom_line(aes(as.numeric(Year), y = a + Total_prolifera*b, col = "A. prolifera individuals"), linewidth = 0.75) +
  geom_vline(data = . %>% group_by(initial_palmata_n, starting_number_n) %>% slice_min(Total_cervicornis) %>% slice(1), aes(xintercept = Year), linetype=2, size = 1, col = "#E41A1C") +
  geom_vline(data = . %>% group_by(initial_palmata_n, starting_number_n) %>% slice_min(Total_palmata) %>% slice(1), aes(xintercept = Year), linetype=2, size = 1, col = "#337CB7") +
  geom_vline(data = . %>% group_by(initial_palmata_n, starting_number_n) %>% slice_min(Total_prolifera) %>% slice(1), aes(xintercept = Year), linetype=2, size = 1, col = "#A162D0") +
  facet_grid(initial_palmata ~ starting_number_n) +
  #geom_line(aes(as.numeric(Year), y = a + 15216*b, col = "Population_K")) + 
  theme_bw() + labs(x = "Year") + theme(legend.position="bottom", legend.box = "vertical")
ggsave("introgressed_ancestry_twoaxis.png", plot = introgressed_ancestry_twoaxis, units = "in", width = 16.38, height = 10, device="png", dpi=300)

beneficial_mutation_tracker = ggplot(sim_data[Year < 150]) + 
  scale_color_manual(values = c("#E41A1C", "#337CB7", "#A162D0")) +
  geom_line(aes(as.numeric(Year), beneficial_in_cervicornis, col = "A. cervicornis"), linewidth = 0.75) +
  geom_line(aes(as.numeric(Year), beneficial_in_palmata, col = "A. palmata"), linewidth = 0.75) +
  geom_line(aes(as.numeric(Year), beneficial_in_prolifera, col = "A. prolifera"), linewidth = 0.75) +
  facet_grid(initial_palmata ~ starting_number_n) +
  theme_bw() + labs(x = "Year") + theme(legend.position="bottom", legend.box = "vertical")
ggsave("beneficial_mutation_tracker.png", plot = beneficial_mutation_tracker, units = "in", width = 16.38, height = 10, device="png", dpi=300)

