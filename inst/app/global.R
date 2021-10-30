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

global_data <- reactiveValues(
  "upload_matrix_file" = NULL,
  "matrix_preview" = paste(
    capture.output(
      str(
        readMM(
          system.file(
            "external/pores_1.mtx",
            package = "Matrix"
          )
        )
      )
    ),
    collapse = "\n"
  ),
  "upload_feature_file" = NULL
)

options(shiny.maxRequestSize = 1000 * 1024^2)
