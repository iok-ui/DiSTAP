
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
    filename1 <- "(Tr) Diff Spectrum (Control-HT2d-HT4d-HT6d) with AB2 and leaf.mat"
    group_id <- 'AB2'
  }
  
  if (i==2) {
    filename1 <- "(Tr) Diff Spectrum (Control-HT2d-HT4d-HT6d) with CS and leaf.mat"
    group_id <- 'CS'
  }
  
  if (i==3) {
    filename1 <- "(Tr) Diff Spectrum (Control-HT2d-HT4d-HT6d) with KL and leaf.mat"
    group_id <- 'KL'
  }

  
  
    # PLOT0D for stress states
  
  wd_path <- getwd()
  read_filepath <- paste(wd_path,'/', sep = "")
  read_file2 <- paste(read_filepath, filename1, sep = "")
  
  data <- readMat(read_file2)
  
  z1 <- data$data[1]
  z2 <- data$data[2]
  z3 <- data$data[3]
  z4 <- data$data[4]
  x <- data$x
  
  z1_df <- as.data.frame(z1)
  z2_df <- as.data.frame(z2)
  z3_df <- as.data.frame(z3)
  z4_df <- as.data.frame(z4)
  x <- as.data.frame(x)
  
  z1_df <- round(z1_df,2)
  z2_df <- round(z2_df,2)
  z3_df <- round(z3_df,2)
  z4_df <- round(z4_df,2)
  
  colnames(z1_df) <- c('Control')
  colnames(z2_df) <- c('HT2d')
  colnames(z3_df) <- c('HT4d')
  colnames(z4_df) <- c('HT6d')
  colnames(x) <- c('xValue')
  
  x_z_df = cbind(x, z1_df, z2_df, z3_df, z4_df)
  
  plot1d <- ggplot(x_z_df, aes(x=xValue)) + 
    geom_line(aes(y = Control), colour = "#7E6148FF", linewidth = 1) +
    geom_line(aes(y = HT2d), colour = "#4DBBD5FF", linewidth = 1) +
    geom_line(aes(y = HT4d), colour = "#3C5488FF", linewidth = 1) +
    geom_line(aes(y = HT6d), colour = "#E64B35FF", linewidth = 1) +
    scale_color_identity(name = '', 
                         breaks = c("#7E6148FF", "#4DBBD5FF", "#3C5488FF", "#E64B35FF"),
                         labels = c("Control", "HT2d", "HT4d", "HT6d"),
                         guide = 'legend') +
    # ggtitle("DS") + 
    theme_bw() +
    theme(plot.title = element_text(size = 12),
          panel.border       = element_blank(),
          panel.grid.major   = element_blank(), #element_line(linewidth = 0.25),
          panel.grid.minor   = element_blank(), #element_line(linewidth = 0.25),
          axis.line.x        = element_line(),
          axis.line.y        = element_line(), #element_line()
          axis.ticks.x       = element_line(),
          axis.ticks.y       = element_line(),
          axis.text.x        = element_text(size = 12),
          axis.text.y        = element_text(size = 12),
          plot.margin = margin(0.5, 0.5, 0, 0.5, "cm")) +
    scale_x_continuous(limits = c(600, 1750), breaks = seq(600, 1750, by = 100)) + 
    scale_alpha_identity() + 
    labs(x = expression(tilde(v)~"(cm"^{-1}*")"), y = "Raman Intensity, (a.u.)")  # Added label for x-axis
  
  

  # Extract/Save the fig group
  
  w = 8
  h = 5
  
  if (i == 1) {
    ggsave("AB2_leaf_0d.jpeg", units="in", width = w, height = h, device='tiff', dpi=600)
  }
  
  if (i == 2) {
    ggsave("CS_leaf_0d.jpeg", units="in", width = w, height = h, device='tiff', dpi=600)
  }
  
  if (i == 3) {
    ggsave("KL_leaf_0d.jpeg", units="in", width = w, height = h, device='tiff', dpi=600)
  }
}
