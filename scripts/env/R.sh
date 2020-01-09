#!/usr/bin/env bash

cp /settings/Rprofile.site /usr/local/lib/R/etc/
Rscript /scripts/R/install_r.R
sed -i "awww-port=7000" /etc/rstudio/rserver.conf
sed -i "asession-timeout-minutes=0" /etc/rstudio/rsession.conf