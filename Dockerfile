FROM ubuntu:19.04

RUN apt-get update -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
# system base
    sudo \
    bash-completion zsh man-db highlight \
    software-properties-common apt-transport-https wajig \
    tzdata locales \
    neovim git git-lfs zip \
    rsync curl wget \
    proxychains \
# python
    python3 python3-pip python3-venv \
    python3-all-dev python3-setuptools build-essential python3-wheel \
# develop
    openjdk-8-jdk maven gradle \
    cron wamerican

# nodejs
RUN apt-get install -y --no-install-recommends \
    nodejs npm \
&& 	npm install -g n \
&&  n 12.13.0

# python packages
RUN pip3 install --no-cache-dir \
# dev base
	mypy pylint yapf pytest ipython virtualenv \ 
# log, debug, monitor	
	loguru rainbow_logging_handler pysnooper tqdm notifiers \
# argument
	click \
# time
	pyarrow>=0.14.0 \
# science
    numpy scipy pandas dask[complete] \
    scikit-learn xgboost \
    tensorflow-gpu \
# db
	JPype1==0.6.3 JayDeBeApi sqlparse requests[socks] tornado \
# spark	
	py4j pyspark findspark pyspark-stubs optimuspyspark\
# file
	fastparquet \
# visualization	
	matplotlib plotly cufflinks seaborn bokeh holoviews[recommended] hvplot tabulate \
#jupyter
	jupyter nbdime beakerx qgrid \
	jupyterhub \
	jupyterlab jupyter-lsp python-language-server[all] jupyterlab_latex 

# beakerx
RUN beakerx install

# proxy
RUN npm install -g configurable-http-proxy

# jupyterlab extension
RUN jupyter labextension install @jupyterlab/latex \
&& 	jupyter labextension install @mflevine/jupyterlab_html \
&& 	jupyter labextension install jupyterlab-drawio \
&& 	jupyter labextension install jupyterlab_tensorboard \
&& 	jupyter labextension install qgrid \
&& 	jupyter labextension install @jupyterlab/github \
&& 	jupyter labextension install @lckr/jupyterlab_variableinspector \
&& 	jupyter labextension install @jupyter-widgets/jupyterlab-manager \
&& 	jupyter labextension install beakerx-jupyterlab \
&& 	jupyter labextension install @jupyterlab/toc \
&& 	jupyter labextension install jupyterlab-favorites \
&& 	jupyter labextension install jupyterlab-recents \
&& 	jupyter labextension install @krassowski/jupyterlab-lsp \
&& 	jupyter labextension install @pyviz/jupyterlab_pyviz


    
RUN npm cache clean --force
RUN apt-get autoremove -y
RUN apt-get clean -y

# set timezone
ARG TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
&&  echo $TZ > /etc/timezone

# set locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8  

# create /workdir
RUN mkdir -p /workdir 
&& 	chmod 777 /workdir

EXPOSE 8888
EXPOSE 8787
EXPOSE 8000
EXPOSE 5006

# copy files
COPY scripts /scripts
COPY settings /settings
COPY settings/proxychains.conf /etc/proxychains.conf
ADD settings/jupyter_notebook_config.py /etc/jupyter/
ADD settings/jupyterhub_config.py /etc/jupyterhub/

# set environment
ENV M2_HOME=/usr/share/maven
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

#r
RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y \
        r-base-dev \
    && apt-get autoremove \
    && apt-get autoclean

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libxml2-dev \
        libcairo2-dev \
        libzmq3-dev \
        libssl-dev \
        jupyter-core \
        jupyter-client \
        libcurl4-openssl-dev \
        openjdk-8-jdk r-cran-rjava \
    && apt-get autoremove \
    && apt-get autoclean
    
RUN Rscript /scripts/install_r.r

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget \
    && rstudio_version=$(wget --no-check-certificate -qO- https://s3.amazonaws.com/rstudio-server/current.ver) \
    && rstudio_version_sub=${rstudio_version%-*} \
    && wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-${rstudio_version_sub}-amd64.deb -O /rstudio-server.deb \
    && apt-get install -y --no-install-recommends /rstudio-server.deb \
    && rm /rstudio-server.deb 

EXPOSE 8787

COPY settings/Rprofile.site /usr/local/lib/R/etc/
