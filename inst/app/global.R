# Shiny
library(shiny)
library(bs4Dash)
library(shinyWidgets)
library(reactable)
library(shinycssloaders)

# Core computation
library(Seurat)
library(tidyverse)
library(Matrix)
library(data.table)
library(patchwork)
library(ggpubr)
suppressPackageStartupMessages(library(tidyHeatmap))
library(GSVA)

global_data <- reactiveValues(
  "upload_matrix_file" = NULL,
  "upload_feature_file" = NULL,
  "upload_cell_file" = NULL,
  "upload_cell_type_file" = NULL,
  "scRNA" = NULL,
  "HBgenes" = c(
    "HBA1", "HBA2", "HBB", "HBD", "HBE1",
    "HBG1", "HBG2", "HBM", "HBQ1", "HBZ", "ABC"
  ),
  "quality_control_process_done" = FALSE,
  "scRNA_filter_1" = NULL,
  "marker" = NULL,
  "st_marker" = NULL,
  "position_sub_sub" = NULL,
  "stRNA" = NULL,
  "gsva_done" = FALSE,
  "gsva_stRNA" = NULL,
  "database" = fread("./db/database_list.csv")
)

options(shiny.maxRequestSize = 4000 * 1024^2)
