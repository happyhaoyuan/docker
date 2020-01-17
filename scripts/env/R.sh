#!/usr/bin/env bash

mkdir -p /usr/local/lib/R/etc/
cp /settings/Rprofile.site /usr/local/lib/R/etc/
#sed -i "1iwww-port=7000" /etc/rstudio/rserver.conf
echo "www-port=7000" > /etc/rstudio/rserver.conf
#sed -i "1isession-timeout-minutes=0" /etc/rstudio/rsession.conf
echo "session-timeout-minutes=0" > /etc/rstudio/rsession.conf