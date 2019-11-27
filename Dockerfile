FROM ubuntu:19.04

RUN apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        sudo \
        software-properties-common apt-transport-https \
        zip \
        tzdata locales \
        bash-completion man-db \
        neovim git \
        rsync curl \
    && apt-get autoremove -y \
    && apt-get clean -y

# timezone
ARG TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

# locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8  

# create /workdir
RUN mkdir -p /workdir && chmod 777 /workdir

COPY scripts /scripts

#r
RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y \
        r-base-dev \
    && apt-get autoremove \
    && apt-get autoclean
    
RUN apt-get install libzmq3-dev libcurl4-openssl-dev libssl-dev jupyter-core jupyter-client r-cran-rjava

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libxml2-dev \
        libcairo2-dev \
        libssl-dev \
        libcurl4-openssl-dev \
        openjdk-8-jdk r-cran-rjava \
    && apt-get autoremove \
    && apt-get autoclean
    
RUN Rscript /scripts/install_packages.r

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget \
    && rstudio_version=$(wget --no-check-certificate -qO- https://s3.amazonaws.com/rstudio-server/current.ver) \
    && wget https://download2.rstudio.org/rstudio-server-${rstudio_version}-amd64.deb -O /rstudio-server.deb \
    && apt-get install -y --no-install-recommends /rstudio-server.deb \
    && rm /rstudio-server.deb 

COPY settings/Rprofile.site /usr/local/lib/R/etc/
