fluidPage(
  fluidRow(
    box(
      width = 12,
      solidHeader = TRUE,
      collapsible = FALSE,
      status = "primary",
      title = tagList(
        "Welcome!"
      ),
      tagList(
        tags$img(
          src = "./home_fig.svg",
          style = "width:100%;"
        ),
        tags$br(),
        tags$br(),
        tags$h1("What is webSCST?"),
        tags$hr(),
        "webSCST is the first web tool for single-cell RNA-seq data and spatial transcriptome integration. The user-friendly interactive interface provides three main functions:",
        actionLink(
          inputId = "sc_data_uploading_and_processing",
          label = "single-cell data uploading and processing",
          icon = icon("upload")
        ),
        ",",
        actionLink(
          inputId = "spatial_transcriptome_database",
          label = "spatial transcriptome database",
          icon = icon("database")
        ),
        "and",
        actionLink(
          inputId = "go_to_integration_tab",
          label = "integration",
          icon = icon("object-group")
        ),
        ". Users could upload their raw single-cell RNA-seq data, after processing and automatically matching with the spatial transcriptome datasets we manually collected, finally got the predicted spatial information for each cell type.",
        tags$br(),
        tags$br(),
        tags$h1("How does webSCST work?"),
        tags$hr(),
        tags$li("Step 1. Users first upload their raw single-cell RNA-seq (scRNA-seq) data, webSCST could interactively process the dataset. Specially, users need to upload their single-cell gene expression matrix in mtx format, gene names and cell names in tsv format and cell type annotation in txt format. After submission, users could obtain the summary information for the submitted dataset, such as the number of genes, cells and cell types. Users could learn the details of the requirements by downloading the demo file."),
        tags$li('Step 2. In "Quality Control" page, users could interactively process their submitted dataset. Users could first filter low-quality cells by setting thresholds, such as minimum detected genes numbers in each cell, maximum detected gene numbers in each cell and percentage of mitochondria counts. In "Normalization and Scaling" step, users could select or enter desired parameters like normalize scale factor or utilized feature numbers. Subsequently, users could interactively select principal component numbers they want to use based on the clustering results in "Clustering" step. Lastly, users could download the processed clean dataset and makers genes for each cell type for further analysis.'),
        tags$li('Step 3. In "Database" section, we have manually curated 43 spatial transcriptome datasets (136 sub-datasets), which will be constantly added according to the increasing of publicly available spatial transcriptome datasets. Users can view the spatial expression of any gene of interest after specifying the species and tissue.'),
        tags$li('Step 4. In "Data Integration" page, users need to upload their processed scRNA dataset and makers downloaded from "Quality Control" step. Alternatively, users could also click "Load QC Result" button to automatically upload the dataset they just processed. Processed single-cell data could then be automatically matched with the spatial transcriptome data we curated according to the organ and species. By clicking "Match Spatial Dataset Manually" button, users may also choose any spatial transcriptome datasets manually collected in the database by ID for integration.'),
        tags$li("Step 5. Currently, four popular integration methods (AddModuleScore, MIA, ssGSEA and RCTD) have been included in webSCST. Users could interactively select any method and download the integration results they are interested in. In the future, newly developed integration tools would be added to maintain webSCST as an up-to-date resource."),
        tags$br(),
        tags$h1("Cite webSCST"),
        tags$hr(),
        "Zilong Zhang, Feifei Cui, Wei Su, Chen Cao, Quan Zou*. webSCST: an interactive web application for single-cell RNA-seq data and spatial transcriptome data integration.",
        tags$br(),
        tags$br(),
        tags$h1("Contact"),
        tags$hr(),
        "For questions and suggestions, please contact:",
        tags$br(),
        tags$b("Zilong Zhang"), "(zhangzilong@bi.a.u-tokyo.ac.jp) or ", tags$b("Quan Zou"), " (quanzou@nclab.net)",
      )
    )
  )
)
