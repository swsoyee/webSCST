# Shiny
library(shiny)
library(bs4Dash)
library(shinyWidgets)
library(reactable)
library(shinycssloaders)
library(markdown)

# Core computation
library(Seurat)
library(tidyverse)
library(Matrix)
library(data.table)
library(patchwork)
library(ggpubr)
suppressPackageStartupMessages(library(tidyHeatmap))
library(GSVA)
library(RCTD)
library(qpdf)

global_data <- reactiveValues(
  "show_upload_raw_file_input" = TRUE,
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
  "show_sc_data_file_input" = TRUE,
  "show_species_and_organ_file_input" = TRUE,
  "st_marker" = NULL,
  "position_sub_sub" = NULL,
  "stRNA" = NULL,
  "gsva_done" = FALSE,
  "normalized_done" = FALSE,
  "gsva_stRNA" = NULL,
  "database" = fread("./db/database_list.csv"),
  "sample_name_of_file" = NULL,
  "load_species_and_organ_demo" = FALSE
)

species_and_organ_table <- reactive({
  all_dataset_in_db <- grep(paste0("^[0-9]+?_.+\\.Rds"), list.files("./db"), value = TRUE)
  all_dataset_ind_db_name <- gsub(".Rds", "", all_dataset_in_db)

  split_file_name <- strsplit(all_dataset_ind_db_name, "_")

  index_table <- data.frame(
    matrix(
      unlist(split_file_name),
      nrow = length(split_file_name),
      byrow = TRUE
    )
  )

  index_table_final <- unique(
    data.frame(
      "id" = as.numeric(index_table[, 1]),
      "sample_name" = index_table[, 3:ncol(index_table)]
    )
  )

  result_table <- left_join(
    x = global_data$database,
    y = index_table_final,
    by = "id"
  )
  result_table
})

options(shiny.maxRequestSize = 4000 * 1024^2)
