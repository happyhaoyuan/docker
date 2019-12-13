FROM ubuntu:19.04

RUN apt-get update -y \
#system
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        sudo \
        software-properties-common apt-transport-https \
        zip \
        tzdata locales \
        bash-completion man-db \
        neovim git \
        rsync curl \
#python
    && apt-get install -y \
        python3 python3-pip python3-venv \
        python3-all-dev python3-setuptools build-essential python3-wheel \
#jdk
        openjdk-8-jdk maven gradle \
        cron wamerican wajig \
        proxychains wget git-lfs \
        highlight \
    && pip3 install --no-cache-dir \
    	mypy pylint yapf pytest ipython \ 
    	loguru pysnooper \
    	findspark \
		pyspark-stubs \
		plotly \
		cufflinks \
		click \
		tqdm \
		pyarrow \
		fastparquet \
		rainbow_logging_handler \
	    numpy scipy pandas pyarrow>=0.14.0 dask[complete] \
	    scikit-learn xgboost \
	    matplotlib bokeh holoviews[recommended] hvplot \
	    tabulate \
	    JPype1==0.6.3 JayDeBeApi sqlparse \
	    requests[socks] lxml notifiers \
	    py4j beakerx \
#jupyter
    	tornado jupyter nbdime \
#jupyterhub
    	jupyterhub \
#beakerx
	&& beakerx install
#nodejs
    && apt-get install -y --no-install-recommends \
        nodejs npm \
    && npm install -g n \
    && n 12.13.0 \
#jupyterlab
	&& pip3 install --no-cache-dir 
		jupyterlab jupyter-lsp python-language-server[all] \
		jupyterlab_latex qgrid \
	&& jupyter labextension install @jupyterlab/latex \
	&& jupyter labextension install @mflevine/jupyterlab_html \
	&& jupyter labextension install jupyterlab-drawio \
	&& jupyter labextension install jupyterlab_tensorboard \
	&& jupyter labextension install qgrid \
	&& jupyter labextension install @jupyterlab/github \
	&& jupyter labextension install @lckr/jupyterlab_variableinspector \
    && jupyter labextension install @jupyter-widgets/jupyterlab-manager \
    && jupyter labextension install beakerx-jupyterlab \
    && jupyter labextension install @jupyterlab/toc \
    && jupyter labextension install jupyterlab-favorites \
    && jupyter labextension install jupyterlab-recents \
    && jupyter labextension install @krassowski/jupyterlab-lsp \
    && jupyter labextension install @pyviz/jupyterlab_pyviz \
    && npm install -g configurable-http-proxy \
    && npm cache clean --force
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

EXPOSE 8888
EXPOSE 8787
EXPOSE 8000
EXPOSE 5006

COPY scripts /scripts
COPY settings /settings
COPY settings/proxychains.conf /etc/proxychains.conf
ADD settings/jupyter_notebook_config.py /etc/jupyter/
ADD settings/jupyterhub_config.py /etc/jupyterhub/
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
