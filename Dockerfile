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

# hadoop
ARG HADOOP_VERSION=2.7.7
ARG HADOOP_BINARY_ARCHIVE_NAME=hadoop-${HADOOP_VERSION}
ARG HADOOP_BINARY_DOWNLOAD_URL=http://apache.claz.org/hadoop/common/hadoop-${HADOOP_VERSION}/${HADOOP_BINARY_ARCHIVE_NAME}.tar.gz
RUN curl ${HADOOP_BINARY_DOWNLOAD_URL} -o /tmp/${HADOOP_BINARY_ARCHIVE_NAME}.tar.gz
&&	tar -zxvf /tmp/${HADOOP_BINARY_ARCHIVE_NAME}.tar.gz -C /usr/local/
&& 	ln -svf /usr/local/${SPARK_BINARY_ARCHIVE_NAME} /usr/local/spark
&&	rm /tmp/${SPARK_BINARY_ARCHIVE_NAME}.tgz

export HADOOP_HOME=/home/hduser/hadoop-2.8.2
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin

export HADOOP_HOME=/home/hadoop/hadoop-2.8.5
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"

# spark
ARG SPARK_VERSION=2.4.4
ARG HADOOP_MAIN_VERSION=2.7
ARG SPARK_BINARY_ARCHIVE_NAME=spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAIN_VERSION}
ARG SPARK_BINARY_DOWNLOAD_URL=http://apache.claz.org/spark/spark-${SPARK_VERSION}/${SPARK_BINARY_ARCHIVE_NAME}.tgz
RUN curl ${SPARK_BINARY_DOWNLOAD_URL} -o /tmp/${SPARK_BINARY_ARCHIVE_NAME}.tgz
&&	tar -zxvf /tmp/${SPARK_BINARY_ARCHIVE_NAME}.tgz -C /usr/local/
&& 	ln -svf /usr/local/${SPARK_BINARY_ARCHIVE_NAME} /usr/local/spark
&&	rm /tmp/${SPARK_BINARY_ARCHIVE_NAME}.tgz
ENV SPARK_HOME /usr/local/spark
ENV PATH $SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH



ENV HADOOP_HOME /apache/hadoop
ENV HADOOP_CONF_DIR /apache/hadoop/etc/hadoop
ENV LD_LIBRARY_PATH /apache/hadoop/lib/native:/apache/hadoop/lib/native/Linux-amd64-64/lib
ENV SPARK_DIST_CLASSPATH $(hadoop --config /apache/hadoop/conf classpath):/apache/hive/conf


# python packages
RUN pip3 install --no-cache-dir \
# dev base
	mypy pylint yapf pytest ipython virtualenv flake8 \ 
# log, debug, monitor	
	loguru rainbow_logging_handler pysnooper tqdm notifiers \
# argument
	click \
# time
	pyarrow>=0.14.0 \
# science
    numpy scipy pandas dask[complete] \
    scikit-learn xgboost \
    tensorflow-gpu torch torchvision \
# db
	JPype1==0.6.3 JayDeBeApi sqlparse requests[socks] tornado \
# spark	
	py4j pyspark findspark pyspark-stubs optimuspyspark toree \
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

RUN DEBIAN_FRONTEND=noninteractive \
   apt-get install -y --no-install-recommends r-base r-base-dev r-recommended \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
   && rm -rf /var/lib/apt/lists/*
# R and packages
RUN sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" >> /etc/apt/sources.list'
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN apt-get update
RUN apt-get install cron
RUN apt-get install -y r-base-dev
RUN R -e "install.packages(c('spData','argparse', 'rjson', 'stringr', 'xgboost'), repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages(c('bit64', 'data.table', 'dplyr', 'classInt'), repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('spDataLarge', repos = 'https://nowosad.github.io/drat/', type='source')"



EXPOSE 8787

COPY settings/Rprofile.site /usr/local/lib/R/etc/
