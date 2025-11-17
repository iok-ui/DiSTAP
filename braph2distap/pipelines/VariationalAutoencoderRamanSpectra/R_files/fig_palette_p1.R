
# ---------- libs (no runtime install) ----------
options(repos = c(CRAN = "https://cloud.r-project.org"))

# CRAN packages you use in this script
cran_pkgs <- c(
  "ggpubr","R.matlab","hdf5r","tidyr","tidyverse","cowplot",
  "ggplot2","ggpattern","magick","ggrepel","scales","viridis","ggsci"
)

# Do NOT install at runtime; the Docker image provides these.
# (Leave these lines commented to enforce reproducibility.)
# missing <- setdiff(cran_pkgs, rownames(installed.packages()))
# if (length(missing)) install.packages(missing)

# hrbrthemes is preinstalled from GitHub in the image; make it optional here
if (requireNamespace("hrbrthemes", quietly = TRUE)) {
  library(hrbrthemes)
} else {
  message("hrbrthemes not available; using theme_bw()")
}

# Load packages
library(R.matlab)
library(hdf5r)
library(ggpubr)
library(tidyr)
library(cowplot)
library(ggplot2)
library(ggpattern)
library(scales)
library(tidyverse)
library(viridis)
library(ggsci)
library(ggrepel)
# -----------------------------------------------

for (i in 1:3){

  if (i==1) {
    filename1 <- "(Tr)_latent_space_WL_and_HL_and_LL_and_SH_at_AB_and_loc1.mat"
    filename2 <- "(Tr) Diff Spectrum (WL-HL-LL-SH) with AB and loc1.mat"
    filename3a <- "ranked_sig_pks_WL AB.mat"
    filename3b <- "ranked_sig_pks_HL AB.mat"
    filename3c <- "ranked_sig_pks_LL AB.mat"
    filename3d <- "ranked_sig_pks_SH AB.mat"
    group_id <- 'AB'
  }
  
  if (i==2) {
    filename1 <- "(Tr)_latent_space_WL_and_HL_and_LL_and_SH_at_CS_and_loc1.mat"
    filename2 <- "(Tr) Diff Spectrum (WL-HL-LL-SH) with CS and loc1.mat"
    filename3a <- "ranked_sig_pks_WL CS.mat"
    filename3b <- "ranked_sig_pks_HL CS.mat"
    filename3c <- "ranked_sig_pks_LL CS.mat"
    filename3d <- "ranked_sig_pks_SH CS.mat"
    group_id <- 'CS'
  }
  
  if (i==3) {
    filename1 <- "(Tr)_latent_space_WL_and_HL_and_LL_and_SH_at_KL_and_loc1.mat"
    filename2 <- "(Tr) Diff Spectrum (WL-HL-LL-SH) with KL and loc1.mat"
    filename3a <- "ranked_sig_pks_WL KL.mat"
    filename3b <- "ranked_sig_pks_HL KL.mat"
    filename3c <- "ranked_sig_pks_LL KL.mat"
    filename3d <- "ranked_sig_pks_SH KL.mat"
    group_id <- 'KL'
  }










  # LATENT SPACE PLOT
  
  # wd_path <- getwd()
  # read_filepath <- paste(wd_path,'/crnr_transformed/', sep = "")
  # read_file1 <- paste(read_filepath, filename1, sep = "")
  
  # data <- readMat(read_file1)
  # 
  # z1 <- data$z1
  # z1 <- lapply(z1, unlist, use.names=FALSE)
  # z1_df_1 <- as.data.frame(z1[[1]])
  # z1_df_2 <- as.data.frame(z1[[2]])
  # z1_df_3 <- as.data.frame(z1[[3]])
  # z1_df_4 <- as.data.frame(z1[[4]])
  # 
  # z1_df_1 <- round(z1_df_1,2)
  # z1_df_2 <- round(z1_df_2,2)
  # z1_df_3 <- round(z1_df_3,2)
  # z1_df_4 <- round(z1_df_4,2)
  # 
  # colnames(z1_df_1) <- c('z1')
  # colnames(z1_df_2) <- c('z1')
  # colnames(z1_df_3) <- c('z1')
  # colnames(z1_df_4) <- c('z1')
  # 
  # z1_df_1$shade <- 'WL'
  # z1_df_2$shade <- 'HL'
  # z1_df_3$shade <- 'LL'
  # z1_df_4$shade <- 'SH'
  # 
  # z1_df <- rbind(z1_df_1, z1_df_2, z1_df_3, z1_df_4)
  # 
  # z2 <- data$z2
  # z2 <- lapply(z2, unlist, use.names=FALSE)
  # z2_df_1 <- as.data.frame(z2[[1]])
  # z2_df_2 <- as.data.frame(z2[[2]])
  # z2_df_3 <- as.data.frame(z2[[3]])
  # z2_df_4 <- as.data.frame(z2[[4]])
  # 
  # z2_df_1 <- round(z2_df_1,2)
  # z2_df_2 <- round(z2_df_2,2)
  # z2_df_3 <- round(z2_df_3,2)
  # z2_df_4 <- round(z2_df_4,2)
  # 
  # colnames(z2_df_1) <- c('z2')
  # colnames(z2_df_2) <- c('z2')
  # colnames(z2_df_3) <- c('z2')
  # colnames(z2_df_4) <- c('z2')
  # 
  # z2_df_1$shade <- 'WL'
  # z2_df_2$shade <- 'HL'
  # z2_df_3$shade <- 'LL'
  # z2_df_4$shade <- 'SH'
  # 
  # z2_df <- rbind(z2_df_1, z2_df_2, z2_df_3, z2_df_4)
  # 
  # df <- cbind(z1_df$z1, z2_df$z2, z1_df$shade)
  # df <- as.data.frame(df)
  # colnames(df) <- c('z1', 'z2', 'shade')
  # df$z1 <- as.double(df$z1)
  # df$z2 <- as.double(df$z2)
  # 
  # # Add group mean points and stars
  # ls <- ggscatter(df, x = "z1", y = "z2",
  #           color = "shade", palette = c("#DC0000FF", "#4DBBD5FF", "#3C5488FF", "#7E6148FF"),
  #           shape = "shade",
  #           ellipse = FALSE, 
  #           mean.point = TRUE,
  #           star.plot = FALSE, 
  #           ggtheme = theme_bw()
  #           )+ 
  #   theme(aspect.ratio=1, 
  #         legend.position = "top", 
  #         panel.grid.major = element_blank(), 
  #         panel.grid.minor = element_blank(), 
  #         panel.border = element_rect(linewidth = 1))
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  # PLOT1D for stress states
  
  wd_path <- getwd()
  read_filepath <- paste(wd_path,'/crnr_transformed/', sep = "")
  read_file2 <- paste(read_filepath, filename2, sep = "")
  
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
  
  colnames(z1_df) <- c('WL')
  colnames(z2_df) <- c('HL')
  colnames(z3_df) <- c('LL')
  colnames(z4_df) <- c('SH')
  colnames(x) <- c('xValue')
  
  x_z_df = cbind(x, z1_df, z2_df, z3_df, z4_df)
  
  
  plot1d <- ggplot(x_z_df, aes(x=xValue)) + 
  # geom_area(colour='#DC0000FF', fill='#DC000099') +
  # geom_area_pattern(data = plot_id,
  #                   pattern = "gradient",
  #                   fill = "#00000000",
  #                   pattern_fill  = "#00000000",
  #                   pattern_fill2 = "#DC000099") +
    geom_line(aes(y = HL), colour = "#E64B35FF", linewidth = 1) +
    geom_line(aes(y = WL), colour = "#7E6148FF", linewidth = 1) +
    geom_line(aes(y = LL), colour = "#4DBBD5FF", linewidth = 1) +
    geom_line(aes(y = SH), colour = "#3C5488FF", linewidth = 1) +
    scale_color_identity(name = '', 
                        breaks = c("#E64B35FF", "#7E6148FF", "#4DBBD5FF", "#3C5488FF"),
                        labels = c("HL", "WL", "LL", "SH"),
                        guide = 'legend') +
    # ggtitle("DS") + 
    theme_bw() +
    theme(plot.title = element_text(size = 12),
          panel.border       = element_blank(),
          panel.grid.major   = element_blank(), #element_line(linewidth = 0.25),
          panel.grid.minor   = element_blank(), #element_line(linewidth = 0.25),
          axis.line.x        = element_blank(),
          axis.line.y        = element_line(), #element_line()
          axis.ticks.x       = element_blank(),
          axis.ticks.y       = element_line(),
          axis.text.x        = element_blank(),
          axis.text.y        = element_text(size = 12),
          plot.margin = margin(0.5, 0.5, 0, 0.5, "cm")) +
          # legend.key = element_rect(fill = "white", colour = "white"),
          # legend.text = element_text(size = 8, colour = "black")) +
          # margin = margin(0,15,0,0, unit = "pt")
    scale_alpha_identity() + labs(x="",y="")
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  # lollipop plot
  
  # read in states data (leaf)
  
  wd_path <- getwd()
  read_filepath <- paste(wd_path,'/', sep = "")
  read_file3a <- paste(read_filepath, filename3a, sep = "")
  read_file3b <- paste(read_filepath, filename3b, sep = "")
  read_file3c <- paste(read_filepath, filename3c, sep = "")
  read_file3d <- paste(read_filepath, filename3d, sep = "")
  
  data1 <- readMat(read_file3a)
  data2 <- readMat(read_file3b)
  data3 <- readMat(read_file3c)
  data4 <- readMat(read_file3d)
  
  z1 <- data1$ranked.sig.pks.WL
  z2 <- data2$ranked.sig.pks.HL
  z3 <- data3$ranked.sig.pks.LL
  z4 <- data4$ranked.sig.pks.SH
  
  z1_df <- as.data.frame(z1)
  z2_df <- as.data.frame(z2)
  z3_df <- as.data.frame(z3)
  z4_df <- as.data.frame(z4)
  
  z1_df <- round(z1_df,2)
  z2_df <- round(z2_df,2)
  z3_df <- round(z3_df,2)
  z4_df <- round(z4_df,2)
  
  colnames(z1_df)[colnames(z1_df) == "V1"] ="wavenum_original"
  colnames(z1_df)[colnames(z1_df) == "V2"] ="wavenum"
  colnames(z1_df)[colnames(z1_df) == "V3"] ="value"
  colnames(z2_df)[colnames(z2_df) == "V1"] ="wavenum_original"
  colnames(z2_df)[colnames(z2_df) == "V2"] ="wavenum"
  colnames(z2_df)[colnames(z2_df) == "V3"] ="value"
  colnames(z3_df)[colnames(z3_df) == "V1"] ="wavenum_original"
  colnames(z3_df)[colnames(z3_df) == "V2"] ="wavenum"
  colnames(z3_df)[colnames(z3_df) == "V3"] ="value"
  colnames(z4_df)[colnames(z4_df) == "V1"] ="wavenum_original"
  colnames(z4_df)[colnames(z4_df) == "V2"] ="wavenum"
  colnames(z4_df)[colnames(z4_df) == "V3"] ="value"
  
  # N - number of significant peaks
  N <- 5
  z1_df <- head(z1_df, N)
  z2_df <- head(z2_df, N)
  z3_df <- head(z3_df, N)
  z4_df <- head(z4_df, N)
  
  z1_df <- z1_df[-c(1)]
  z2_df <- z2_df[-c(1)]
  z3_df <- z3_df[-c(1)]
  z4_df <- z4_df[-c(1)]
  
  z1_df$group <- group_id
  z2_df$group <- group_id
  z3_df$group <- group_id
  z4_df$group <- group_id
  
  z1_df$shade <- 'WL'
  z2_df$shade <- 'HL'
  z3_df$shade <- 'LL'
  z4_df$shade <- 'SH'
  
  z1_df <- z1_df[c("wavenum", "group", "value", "shade")]
  z2_df <- z2_df[c("wavenum", "group", "value", "shade")]
  z3_df <- z3_df[c("wavenum", "group", "value", "shade")]
  z4_df <- z4_df[c("wavenum", "group", "value", "shade")]
  
  z1_df <- z1_df[-c(4)]
  z2_df <- z2_df[-c(4)]
  z3_df <- z3_df[-c(4)]
  z4_df <- z4_df[-c(4)]
  
  data_ll <- rbind(z1_df[-c(2)], z2_df[-c(2)], z3_df[-c(2)], z4_df[-c(2)])
  
  data_ll$shade <- c(rep('WL', N), rep('HL', N), rep('LL', N), rep('SH', N))
  data_ll$shade <- factor(data_ll$shade, levels = c("HL", "WL", "LL", "SH"))
  
  ymax_value = 2750
  tick_increment = 500
  
  ll <- ggscatter(data_ll, x = "wavenum", y = "value",
              color = "shade", palette = c("#E64B35FF", "#7E6148FF", "#4DBBD5FF", "#3C5488FF"),
              shape = "shade",
              xlim = c(600, 1750),
              ylim = c(0, ymax_value),
              size = 5,
              ellipse = FALSE, 
              mean.point = FALSE,
              star.plot = FALSE) +
  expand_limits(x = c(600, 1750)) +
  scale_shape_manual(values = c(15, 16, 17, 18)) + 
  scale_x_continuous(breaks = seq(600, 1750, by = 100)) +
  scale_y_continuous(breaks = seq(0, ymax_value, by = tick_increment)) +
  theme(legend.position="none", 
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        plot.margin = margin(0, 0.5, 0, 0.5, "cm"))
  # geom_segment(data = data_ll,
  #             aes(x = wavenum, xend = wavenum,
  #                 y = 0, yend = value),
  #             color = "#B5BEC6",
  #             linewidth = 0.25,
  #             alpha = .5) +
  # geom_label_repel(aes(label = wavenum,
  #                   fill = shade), color = 'white',
  #                   size = 5)
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  ## palette
  
  temp1 <- ggarrange(plot1d, ll, 
                     #heights = c(3, 3),
                     ncol = 1, nrow = 2, 
                     align = "v")
  #ggsave(temp1, file="TEMP1.jpeg", units="in", width = 9, height = 5, device='tiff', dpi=600)
  
  # temp2 <- ggarrange(ls, temp1,
  #                    #heights = c(3, 6),
  #                    ncol = 2, nrow = 1,
  #                    align = "h", 
  #                    labels = "b"
  #                    ) 
  # ggsave(temp2, file="TEMP2.jpeg", units="in", width = 7, height = 5, device='tiff', dpi=600)
  # 
  # final <- ggarrange(ls, 
  #                    ggarrange(plot1d, ll, 
  #                              heights = c(4, 4), #widths = c(6, 6),
  #                              ncol = 1, nrow = 2, 
  #                              align = "v", 
  #                              labels = "c"),
  #                    heights = c(6, 6),
  #                    ncol = 2, nrow = 1,
  #                    align = "h", 
  #                    labels = "b"
  #                    ) 
  # ggsave("final.jpeg", device='tiff', dpi=600)
  #units="in", width = 8, height = 4,
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  # Extract/Save the fig group
  
  w = 8
  h = 5
  
  if (i == 1) {
    ggsave("AB_1d_ll.jpeg", units="in", width = w, height = h, device='tiff', dpi=600)
  }
  
  if (i == 2) {
    ggsave("CS_1d_ll.jpeg", units="in", width = w, height = h, device='tiff', dpi=600)
  }
  
  if (i == 3) {
    ggsave("KL_1d_ll.jpeg", units="in", width = w, height = h, device='tiff', dpi=600)
  }
}
