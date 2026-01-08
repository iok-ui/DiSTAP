
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

# Define all timepoints and locations
timepoints <- c("24h", "48h", "72h")
locations <- paste0("loc", 1:6)

# Loop through each timepoint and location
for (tp in timepoints) {
  for (loc in locations) {
    
  # Construct filenames dynamically
  filename1 <- sprintf("(Tr) Diff Spectrum (mock-pseudo) for %s and %s.mat", tp, loc)
  group_id <- tp
  
  # Print summary (optional)
  cat("\n====================\n")
  cat("Timepoint:", tp, " | Location:", loc, "\n")
  cat("filename1:", filename1, "\n")
  
  
  
  # (Optional) print summary
  cat(sprintf("\n▶ Processing: %s | %s\n", tp, loc))

  
  
  # PLOT0D for stress states
  
  wd_path <- getwd()
  read_filepath <- paste(wd_path,'/crnr_detransformed/', sep = "")
  read_file <- paste(read_filepath, filename1, sep = "")
  
  data <- readMat(read_file)
  
  z1 <- data$data1
  z2 <- data$data2
  x <- data$x
  
  z1_df <- as.data.frame(z1)
  z2_df <- as.data.frame(z2)
  x <- as.data.frame(x)
  
  z1_df <- round(z1_df,2)
  z2_df <- round(z2_df,2)

  colnames(z1_df) <- c('mock')
  colnames(z2_df) <- c('pseudo')
  colnames(x) <- c('xValue')
  
  x_z_df = cbind(x, z1_df, z2_df)
  
  
  plot0d <- ggplot(x_z_df, aes(x=xValue)) + 
    geom_line(aes(y = pseudo), colour = "#E64B35FF", linewidth = 1) +
    geom_line(aes(y = mock), colour = "#4DBBD5FF", linewidth = 1) +
    scale_color_identity(name = '', 
                         breaks = c("#E64B35FF", "#4DBBD5FF"),
                         labels = c("pseudo", "mock"),
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
    scale_alpha_identity() + 
    labs(x = expression(tilde(v)~"(cm"^{-1}*")"), y = "Raman Intensity, (a.u.)")  # Added label for x-axis
  
  

  # Extract/Save the fig group
  
  w = 8
  h = 5
  
  # Define output filename
  save_name <- sprintf("%s_mock-pseudo_0d_%s.jpeg", tp, loc)
  
  # Save the figure
  ggsave(
    filename = save_name,
    units = "in",
    width = w, height = h,
    device = "tiff",
    dpi = 600
  )
  
  # Print confirmation
  cat(sprintf("✅ Saved: %s\n", save_name))
 }
}
