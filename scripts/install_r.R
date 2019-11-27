install.packages(c('repr', 'IRdisplay', 'IRkernel'), type = 'source')
IRkernel::installspec(user = FALSE)

pkgs = '
    devtools roxygen2
    Rcpp
    rmarkdown DT caTools bitops
    RJDBC jsonlite
    data.table
    mailR httr urltools openssl
    ggplot2
    lubridate
'
pkgs = strsplit(pkgs, '\\s')[[1]]
pkgs = pkgs[pkgs != '']
install.packages(pkgs, repos = 'https://cran.rstudio.org')
