## Integration Methods Used in webSCST

**AddModuleScore**: AddModuleScore is a function in R package `{Seurat}`, which is a scoring-based method. Since AddModuleScore function aims to find average expression levels of each cluster, it has been widely used for finding similar gene expression patterns between single-cell clusters and spatial transcriptome clusters.

> **Citation**: Stuart T, Butler A, Hoffman P, Hafemeister C, Papalexi E, Mauck WM, 3rd, Hao Y, Stoeckius M, Smibert P, Satija R: Comprehensive Integration of Single-Cell Data. Cell 2019, 177(7):1888-1902.e1821.

**MIA**: MIA is a mapping integration method which is short for “Multimodal Intersection Analysis”. MIA first identifies cell type-specific genes in single-cell data and region-specific genes in spatial data, and then performs the integration by hypergeometric distribution of these two types of genes.

> **Citation**: Moncada R, Barkley D, Wagner F, Chiodin M, Devlin JC, Baron M, Hajdu CH, Simeone DM, Yanai I: Integrating microarray-based spatial transcriptomics and single-cell RNA-seq reveals tissue architecture in pancreatic ductal adenocarcinomas. Nature biotechnology 2020, 38(3):333-342.

**ssGSEA**: ssGSEA is a function in R package `{GSVA}`, which is an extension of GSEA (Gene Set Enrichment Analysis). Utilizing the maker genes for each cell types (obtained from single-cell data), ssGSEA could score the spatial location with spatial gene expression patterns.

> **Citation**: Hänzelmann S, Castelo R, Guinney J: GSVA: gene set variation analysis for microarray and RNA-seq data. BMC bioinformatics 2013, 14:7.

**RCTD**: RCTD is a deconvolution integration method by statistical models. Utilizing a Possion distribution to model the genes for each pixel, RCTD try to obtain average expression for each gene per cell-type. A random platform parameter is also included makes RCTD more robust for cross-platform spatial data decomposition.

> **Citation**: Cable DM, Murray E, Zou LS, Goeva A, Macosko EZ, Chen F, Irizarry RA: Robust
decomposition of cell type mixtures in spatial transcriptomics. Nature biotechnology 2021.

## Addresses

1.Institute of Fundamental and Frontier Sciences, University of Electronic Science and
Technology of China. No.4, Section2, North Jianshe Road, Chengdu, China.  
2.Yangtze Delta Region Institute (Quzhou), University of Electronic Science and Technology of China. Building 1, Qu Shidai Innovation Building, No. 288, Qinjiang East Road, Kecheng District, Quzhou, China.  
3.Yahoo Japan Corporation, Kioi Tower, 1-3 Kioicho, Chiyoda-ku, Tokyo, 102-8282, Japan.  
