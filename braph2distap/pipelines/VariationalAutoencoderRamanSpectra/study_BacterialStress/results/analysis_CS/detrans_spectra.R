
list.of.packages <- c("ggpubr", "R.matlab", "hdf5r", "ggpubr", "tidyr", "tidyverse", "cowplot", "hrbrthemes", "ggplot2", "ggpattern", "magick", "ggrepel")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(R.matlab)
library(hdf5r)
library(ggpubr)
library(tidyr)
library(cowplot)
library(ggplot2)
library(ggpattern)
library(hrbrthemes)
library(scales)
library(tidyverse)
library(viridis)
library(ggsci)
library(ggrepel)

for (i in 1:3){

  if (i==1) {
    filename1 <- "(Tr) Diff Spectrum (buf-inf) with CS24hr and loc.mat"
    group_id <- '24hr'
  }
  
  if (i==2) {
    filename1 <- "(Tr) Diff Spectrum (buf-inf) with CS48hr and loc.mat"
    group_id <- '48hr'
  }


  
  
    # PLOT0D for stress states
  
  wd_path <- getwd()
  read_filepath <- paste(wd_path,'/', sep = "")
  read_file <- paste(read_filepath, filename1, sep = "")
  
  data <- readMat(read_file)
  
  z1 <- data$data[1]
  z2 <- data$data[2]
  #z3 <- data$data3
  x <- data$x
  
  z1_df <- as.data.frame(z1)
  z2_df <- as.data.frame(z2)
  #z3_df <- as.data.frame(z3)
  x <- as.data.frame(x)
  
  z1_df <- round(z1_df,2)
  z2_df <- round(z2_df,2)
  #z3_df <- round(z3_df,2)

  colnames(z1_df) <- c('pathogen')
  colnames(z2_df) <- c('buffer')
  #colnames(z3_df) <- c('WL')
  colnames(x) <- c('xValue')
  
  x_z_df = cbind(x, z1_df, z2_df)
  
  
  plot0d <- ggplot(x_z_df, aes(x=xValue)) + 
    geom_line(aes(y = pathogen), colour = "#E64B35FF", linewidth = 1) +
    geom_line(aes(y = buffer), colour = "#4DBBD5FF", linewidth = 1) +
    #geom_line(aes(y = WL), colour = "#7E6148FF", linewidth = 1) +
    scale_color_identity(name = '', 
                         breaks = c("#E64B35FF", "#4DBBD5FF"),
                         labels = c("pathogen", "buffer"),
                         guide = 'legend') +
    theme_bw() +
    theme(plot.title = element_text(size = 12),
          panel.border       = element_blank(),
          panel.grid.major   = element_blank(),
          panel.grid.minor   = element_blank(),
          axis.line.x        = element_line(),     # This draws the x-axis line
          axis.line.y        = element_line(),
          axis.ticks.x       = element_line(),     # This draws the x-axis ticks
          axis.ticks.y       = element_line(),
          axis.text.x        = element_text(size = 10, angle = 0, vjust = 0.5),  # Show x labels, optional angle
          axis.text.y        = element_text(size = 12),
          plot.margin = margin(0.5, 0.5, 0, 0.5, "cm")) +
    scale_x_continuous(limits = c(600, 1750), breaks = seq(600, 1750, by = 100)) + 
    scale_y_continuous(breaks = seq(0, 20000, by = 5000)) +
    scale_alpha_identity() + 
    labs(x = expression(tilde(v)~"(cm"^{-1}*")"), y = "Raman Intensity, (a.u.)")  # Added label for x-axis
  
  

  # Extract/Save the fig group
  
  w = 8
  h = 5
  
  if (i == 1) {
    ggsave("24hr_leaf_0d.jpeg", units="in", width = w, height = h, device='tiff', dpi=600)
  }
  
  if (i == 2) {
    ggsave("48hr_leaf_0d.jpeg", units="in", width = w, height = h, device='tiff', dpi=600)
  }

}
