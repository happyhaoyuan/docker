#!/usr/bin/env bash

mkdir -p /usr/local/lib/R/etc/
cp /settings/Rprofile.site /usr/local/lib/R/etc/
sed -i "awww-port=7000" /etc/rstudio/rserver.conf
sed -i "asession-timeout-minutes=0" /etc/rstudio/rsession.conf