args <- commandArgs(trailingOnly = TRUE)
if (length(args) >= 1 && nzchar(args[1])) {
  out_dir <- args[1]
} else {
  out_dir <- getwd()
}
if (!dir.exists(out_dir)) {
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
}

## Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# ---- Install required CRAN packages if missing (safe outside Docker) ----
cran_pkgs <- c(
  "ggpubr","R.matlab","hdf5r","tidyr","tidyverse","cowplot",
  "ggplot2","ggpattern","magick","here","dplyr","grid","scales",
  "rstatix","car","sf","units","s2","ragg"
)
to_install <- setdiff(cran_pkgs, rownames(installed.packages()))
if (length(to_install)) install.packages(to_install)

# ---- hrbrthemes: install from GitHub IF not already present ----
# (In Docker we preinstalled it; this does nothing there.)
if (!requireNamespace("hrbrthemes", quietly = TRUE)) {
  if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")
  remotes::install_github("hrbrmstr/hrbrthemes", upgrade = "never")
}

# ---- Load libraries (make hrbrthemes optional) ----
library(R.matlab)
library(hdf5r)
library(ggpubr)
library(tidyr)
library(cowplot)
library(ggplot2)
library(ggpattern)
library(scales)
library(here)
library(dplyr)
library(grid)

if (requireNamespace("hrbrthemes", quietly = TRUE)) {
  library(hrbrthemes)
  # Optional default theme:
  # theme_set(hrbrthemes::theme_ipsum())
} else {
  message("hrbrthemes not available; using theme_bw()")
  # theme_set(ggplot2::theme_bw())
}

# Find all relevant files 
wd_path <- getwd()
read_filepath <- paste(wd_path, '/crnr_transformed/', sep = "")
setwd(read_filepath)

files <- list.files(path = read_filepath, pattern = 'latent')
length(files)

# Initialize z1 and z2 range variables
for (i in 1:length(files)) {
  filename <- files[i]
  data <- readMat(filename)
  if (i == 1) {
    z1_range_min <- data$z1.range[1]
    z1_range_max <- data$z1.range[2]
    z2_range_min <- data$z2.range[1]
    z2_range_max <- data$z2.range[2]
  } else {
    temp_z1_range_min <- data$z1.range[1]
    if (temp_z1_range_min < z1_range_min) { z1_range_min = temp_z1_range_min }
    temp_z1_range_max <- data$z1.range[2]
    if (temp_z1_range_max > z1_range_max) { z1_range_max = temp_z1_range_max }
    temp_z2_range_min <- data$z2.range[1]
    if (temp_z2_range_min < z2_range_min) { z2_range_min = temp_z2_range_min }
    temp_z2_range_max <- data$z2.range[2]
    if (temp_z2_range_max > z2_range_max) { z2_range_max = temp_z2_range_max }
  }
}

# Round the ranges
z1_range_min <- round(z1_range_min, 2)
z1_range_max <- round(z1_range_max, 2)
z2_range_min <- round(z2_range_min, 2)
z2_range_max <- round(z2_range_max, 2)

# Step 1: Round each value in a way that increases its absolute value
z1_range_min <- ifelse(z1_range_min < 0, floor(z1_range_min), ceiling(z1_range_min))
z1_range_max <- ifelse(z1_range_max < 0, floor(z1_range_max), ceiling(z1_range_max))
z2_range_min <- ifelse(z2_range_min < 0, floor(z2_range_min), ceiling(z2_range_min))
z2_range_max <- ifelse(z2_range_max < 0, floor(z2_range_max), ceiling(z2_range_max))

# Step 2: Ensure modulus values of min and max are the same
z1_modulus <- max(abs(z1_range_min), abs(z1_range_max))
z2_modulus <- max(abs(z2_range_min), abs(z2_range_max))

# Update ranges so min and max have the same modulus
z1_range_min <- ifelse(z1_range_min < 0, -z1_modulus, z1_modulus)
z1_range_max <- ifelse(z1_range_max < 0, -z1_modulus, z1_modulus)
z2_range_min <- ifelse(z2_range_min < 0, -z2_modulus, z2_modulus)
z2_range_max <- ifelse(z2_range_max < 0, -z2_modulus, z2_modulus)

# Results
z1_range_min
z1_range_max
z2_range_min
z2_range_max

# Generate x and y ticks based on quartiles of the range limits
NUM_OF_TICKS <-25  # Set this for quartiles

# Quartiles based on range for x and y axes
# Generate normalized quantile values and scale to the range of z1
grid_x <- qnorm(seq(0.001, 0.999, length.out = NUM_OF_TICKS))
x_ticks <- round(scales::rescale(grid_x, to = c(z1_range_min, z1_range_max)), 2)

# Generate normalized quantile values and scale to the range of z2
grid_y <- qnorm(seq(0.001, 0.999, length.out = NUM_OF_TICKS))
y_ticks <- round(scales::rescale(grid_y, to = c(z2_range_min, z2_range_max)), 2)

# Print the ticks to verify
print("X-axis quartile ticks:")
print(x_ticks)

print("Y-axis quartile ticks:")
print(y_ticks)


# Determine the minimum and maximum integer values within x_ticks and y_ticks range
x_min <- floor(min(x_ticks))
x_max <- ceiling(max(x_ticks))
y_min <- floor(min(y_ticks))
y_max <- ceiling(max(y_ticks))

# Generate integer ticks for x and y within these ranges
new_x_ticks <- seq(x_min, x_max, by = 1)
new_y_ticks <- seq(y_min, y_max, by = 1)

# Store the count of integer ticks as NUM_OF_NEW_X_TICKS and NUM_OF_NEW_Y_TICKS
NUM_OF_NEW_X_TICKS <- length(new_x_ticks)
NUM_OF_NEW_Y_TICKS <- length(new_y_ticks)

# Print results to verify
print("Generated X-axis integer ticks:")
print(new_x_ticks)
print(paste("Number of integer X ticks:", NUM_OF_NEW_X_TICKS))

print("Generated Y-axis integer ticks:")
print(new_y_ticks)
print(paste("Number of integer Y ticks:", NUM_OF_NEW_Y_TICKS))




#Sys.sleep()

for (i in 1:length(files)){
  filename <- files[i]
  data <- readMat(filename)
  
  z1 <- data$z1
  z1 <- lapply(z1, unlist, use.names=FALSE)
  z1_df_1 <- as.data.frame(z1[[1]])
  z1_df_2 <- as.data.frame(z1[[2]])
  z1_df_3 <- as.data.frame(z1[[3]])
  z1_df_4 <- as.data.frame(z1[[4]])
  
  z1_df_1 <- round(z1_df_1,2)
  z1_df_2 <- round(z1_df_2,2)
  z1_df_3 <- round(z1_df_3,2)
  z1_df_4 <- round(z1_df_4,2)
  
  colnames(z1_df_1) <- c('z1')
  colnames(z1_df_2) <- c('z1')
  colnames(z1_df_3) <- c('z1')
  colnames(z1_df_4) <- c('z1')
  
  z1_df_1$state <- 'White light'
  z1_df_2$state <- 'High light'
  z1_df_3$state <- 'Low light'
  z1_df_4$state <- 'Shade'
  
  z1_df <- rbind(z1_df_1, z1_df_2, z1_df_3, z1_df_4)
  
  z2 <- data$z2
  z2 <- lapply(z2, unlist, use.names=FALSE)
  z2_df_1 <- as.data.frame(z2[[1]])
  z2_df_2 <- as.data.frame(z2[[2]])
  z2_df_3 <- as.data.frame(z2[[3]])
  z2_df_4 <- as.data.frame(z2[[4]])
  
  z2_df_1 <- round(z2_df_1,2)
  z2_df_2 <- round(z2_df_2,2)
  z2_df_3 <- round(z2_df_3,2)
  z2_df_4 <- round(z2_df_4,2)
  
  colnames(z2_df_1) <- c('z2')
  colnames(z2_df_2) <- c('z2')
  colnames(z2_df_3) <- c('z2')
  colnames(z2_df_4) <- c('z2')
  
  z2_df_1$state <- 'White light'
  z2_df_2$state <- 'High light'
  z2_df_3$state <- 'Low light'
  z2_df_4$state <- 'Shade'
  
  z2_df <- rbind(z2_df_1, z2_df_2, z2_df_3, z2_df_4)
  
  df <- cbind(z1_df$z1, z2_df$z2, z1_df$state)
  df <- as.data.frame(df)
  colnames(df) <- c('z1', 'z2', 'state')
  df$z1 <- as.double(df$z1)
  df$z2 <- as.double(df$z2)


  # Function to compute the error function (erf)
  erf <- function(x) {
    return(2 * pnorm(sqrt(2) * x) - 1)  # Adjusted erf function
  }

  # Define a safe inverse error function (erf^-1) with range check
  erf_inv <- function(x) {
    # Limit x to [-1, 1] to avoid NaNs in qnorm calculation
    x <- pmax(pmin(x, 1), -1)
    qnorm((x + 1) / 2) / sqrt(2)
  }
  
  # Calculate erf for the original z1 and z2 values
  df <- df %>%
    mutate(
      z1_erf = erf(z1),
      z2_erf = erf(z2)
    )

  # Define the target labels
  tick_labels <- c(-5, -1, -0.5, 0, 0.5, 1, 5)
  
  # Calculate tick positions on the erf scale that correspond to these values
  tick_positions <- sapply(tick_labels, erf)  # Map to erf scale
  
  # Calculate the median points for each group
  median_points <- df %>%
    group_by(state) %>%
    summarise(
      z1_erf_median = median(z1_erf),
      z2_erf_median = median(z2_erf)
    )
  
  # Plot using ggscatter with custom tick positions and labels
  # Define custom order for legend
  df$state <- factor(df$state, levels = c("High light", "White light", "Low light", "Shade"))
  
  ls <- ggscatter(
    df,
    x = "z1_erf",
    y = "z2_erf",
    color = "state", 
    palette = c("#E64B35FF", "#7E6148FF", "#4DBBD5FF", "#3C5488FF"), #DC0000FF
    shape = "state",
    ellipse = FALSE,
    star.plot = FALSE,
    alpha = 0.3,
    ggtheme = theme_bw()
  ) +
    scale_shape_manual(values = c(15, 16, 17, 18)) + 
    # Specify shapes explicitly
    labs(
      x = "z1",
      y = "z2"
    ) +
    expand_limits(x = c(-1, 1), y = c(-1, 1)) +  
    scale_x_continuous(
      breaks = tick_positions,
      labels = tick_labels
    ) +
    scale_y_continuous(
      breaks = tick_positions,
      labels = tick_labels
    ) +
    theme(
      aspect.ratio = 1,
      legend.position = "top",
      legend.text = element_text(size = 9), 
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_rect(linewidth = 1),
      axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, size = 9),
      axis.text.y = element_text(size = 9), 
      plot.margin = margin(0, 0, 0, -20)
    ) +
    coord_fixed(ratio = 1) +  
    geom_point(
      data = median_points,
      aes(x = z1_erf_median, y = z2_erf_median, 
          color = state, shape = state),
      size = 4
    )
  
  
    # Save plots
    w <- 2.75
    h <- 2.75
    
    if (grepl("AB", filename)) {
      ggsave(file.path(out_dir, "lsqmed_AB.jpeg"),
             units = "in", width = w, height = h,
             device = "tiff", dpi = 600)
    }
    
    if (grepl("CS", filename)) {
      ggsave(file.path(out_dir, "lsqmed_CS.jpeg"),
             units = "in", width = w, height = h,
             device = "tiff", dpi = 600)
    }
    
    if (grepl("KL", filename)) {
      ggsave(file.path(out_dir, "lsqmed_KL.jpeg"),
             units = "in", width = w, height = h,
             device = "tiff", dpi = 600)
    }
}



