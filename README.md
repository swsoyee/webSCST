# webSCST

  a web tool for single-cell RNA-seq data and spatial transcriptome data integration 


  webSCST implemented in shiny with all major browsers supported is available at http://www.webscst.com. If you have large-scale single-cell datasets that could not be handled online, webSCST is also freely available as an R package. 
	 
  After your successful installation of R package webSCST, you need also download the database file at ftp://119.3.126.206/db.rar. Then you need to unzip db.zip file and replace the db folder at webSCST-main/inst/app/db with it.  


## Installation

The development version from [GitHub](https://github.com/) with:

```r
# install.packages("devtools")
devtools::install_github("swsoyee/webSCST")
```

## Launch Application

```r
webSCST::run()
```
