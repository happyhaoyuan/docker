FROM ubuntu:19.04

RUN apt-get update -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
# system base
    sudo bash-completion zsh man-db highlight software-properties-common apt-transport-https wajig \
    tzdata locales neovim git git-lfs zip rsync curl wget proxychains openssh-server \
# python
    python3 python3-pip python3-venv python3-all-dev python3-setuptools build-essential python3-wheel \
# R
    r-base r-base-dev r-cran-rjava r-recommended \
# develop
    openjdk-8-jdk maven gradle cron wamerican

# nodejs
RUN apt-get install -y --no-install-recommends \
    nodejs npm \
&& 	npm install -g n \
&&  n 12.13.0

# hadoop
ENV HADOOP_VERSION=2.7.7
ENV HADOOP_BINARY_ARCHIVE_NAME=hadoop-${HADOOP_VERSION}
ENV HADOOP_BINARY_DOWNLOAD_URL=http://apache.claz.org/hadoop/common/hadoop-${HADOOP_VERSION}/${HADOOP_BINARY_ARCHIVE_NAME}.tar.gz
ENV HADOOP_INSTALL_DIR=/opt
RUN curl ${HADOOP_BINARY_DOWNLOAD_URL} -o /tmp/${HADOOP_BINARY_ARCHIVE_NAME}.tar.gz
&&  tar -zxvf /tmp/${HADOOP_BINARY_ARCHIVE_NAME}.tar.gz -C ${HADOOP_INSTALL_DIR}
&&  ln -svf ${HADOOP_INSTALL_DIR}/${HADOOP_BINARY_ARCHIVE_NAME} ${HADOOP_INSTALL_DIR}/hadoop
&&  rm /tmp/${HADOOP_BINARY_ARCHIVE_NAME}.tar.gz

# spark
ENV SPARK_VERSION=2.4.4
ENV HADOOP_MAIN_VERSION=2.7
ENV SPARK_BINARY_ARCHIVE_NAME=spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAIN_VERSION}
ENV SPARK_BINARY_DOWNLOAD_URL=http://apache.claz.org/spark/spark-${SPARK_VERSION}/${SPARK_BINARY_ARCHIVE_NAME}.tgz
RUN curl ${SPARK_BINARY_DOWNLOAD_URL} -o /tmp/${SPARK_BINARY_ARCHIVE_NAME}.tgz
&&  tar -zxvf /tmp/${SPARK_BINARY_ARCHIVE_NAME}.tgz -C /opt/
&&  ln -svf /opt/${SPARK_BINARY_ARCHIVE_NAME} /opt/spark
&&  rm /tmp/${SPARK_BINARY_ARCHIVE_NAME}.tgz

# R studio
RUN rstudio_version=$(wget --no-check-certificate -qO- https://s3.amazonaws.com/rstudio-server/current.ver) \
&& rstudio_version_sub=${rstudio_version%-*} \
&& wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-${rstudio_version_sub}-amd64.deb -O /rstudio-server.deb \
&& apt-get install -y --no-install-recommends /rstudio-server.deb \
&& rm /rstudio-server.deb 

# set timezone
ARG TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
&&  echo $TZ > /etc/timezone

# set locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8  

# set environment variables
ENV M2_HOME=/usr/share/maven
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# packages and tools
RUN pip3 install --no-cache-dir \
# jupyter
    jupyter nbdime beakerx qgrid \
    jupyterhub \
    jupyterlab jupyter-lsp python-language-server[all] jupyterlab_latex 
# dev base
    mypy pylint yapf pytest ipython virtualenv flake8 lxml \ 
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

# beakerx
RUN beakerx install

# proxy
RUN npm install -g configurable-http-proxy

# jupyterlab extension
RUN jupyter labextension install @jupyterlab/latex \
&&  jupyter labextension install @mflevine/jupyterlab_html \
&&  jupyter labextension install jupyterlab-drawio \
&&  jupyter labextension install jupyterlab_tensorboard \
&&  jupyter labextension install qgrid \
&&  jupyter labextension install @jupyterlab/github \
&&  jupyter labextension install @lckr/jupyterlab_variableinspector \
&&  jupyter labextension install @jupyter-widgets/jupyterlab-manager \
&&  jupyter labextension install beakerx-jupyterlab \
&&  jupyter labextension install @jupyterlab/toc \
&&  jupyter labextension install jupyterlab-favorites \
&&  jupyter labextension install jupyterlab-recents \
&&  jupyter labextension install @krassowski/jupyterlab-lsp \
&&  jupyter labextension install @pyviz/jupyterlab_pyviz

# clean
RUN npm cache clean --force
RUN apt-get autoremove -y
RUN apt-get clean -y
# RUN rm -rf /tmp/downloaded_packages/ /tmp/*.rds /var/lib/apt/lists/*

# create directory
RUN mkdir -p /workdir /logs
&&  chmod 777 /workdir /logs

# copy files
COPY scripts /scripts
COPY settings /settings

# expose port
# jupyter service
EXPOSE 8888
# R studio
EXPOSE 7000
# jupyter hub
EXPOSE 8000
# hadoop
EXPOSE 9000
EXPOSE 9870
EXPOSE 8088
# spare
EXPOSE 5006