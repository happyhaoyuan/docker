FROM ubuntu:19.04

ENV TERM xterm
RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] Start to build docker"

RUN apt-get update -y

# base
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    sudo bash-completion zsh man-db highlight zip rsync tzdata locales software-properties-common
RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] Base finished!"

# utils
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    neovim git git-lfs wajig curl wget proxychains openssh-server apt-transport-https
RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] Utils finished!"

#zsh
RUN chsh -s /bin/zsh root

# nodejs
RUN apt-get install -y --no-install-recommends \
    nodejs npm \
&&  npm install -g n
RUN n latest
RUN npm install -g configurable-http-proxy
RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] Nodejs finished!"

# python
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3 python3-pip python3-venv python3-all-dev python3-setuptools build-essential python3-wheel
RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] Py finished!"

# R
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    r-base r-base-dev r-cran-rjava r-recommended
RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] R finished!"

# develop
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openjdk-8-jdk maven gradle cron wamerican
RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] Dev finished!"

RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] System base finished"

# hadoop
ENV HADOOP_VERSION=2.7.7
ENV HADOOP_BINARY_ARCHIVE_NAME=hadoop-${HADOOP_VERSION}
ENV HADOOP_BINARY_DOWNLOAD_URL=http://apache.claz.org/hadoop/common/hadoop-${HADOOP_VERSION}/${HADOOP_BINARY_ARCHIVE_NAME}.tar.gz
ENV HADOOP_INSTALL_DIR=/opt
RUN curl ${HADOOP_BINARY_DOWNLOAD_URL} -o /tmp/${HADOOP_BINARY_ARCHIVE_NAME}.tar.gz \
&&  tar -zxvf /tmp/${HADOOP_BINARY_ARCHIVE_NAME}.tar.gz -C ${HADOOP_INSTALL_DIR} \
&&  ln -svf ${HADOOP_INSTALL_DIR}/${HADOOP_BINARY_ARCHIVE_NAME} ${HADOOP_INSTALL_DIR}/hadoop \
&&  rm /tmp/${HADOOP_BINARY_ARCHIVE_NAME}.tar.gz
RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] Hadoop finished"

# spark
ENV SPARK_VERSION=2.4.4
ENV HADOOP_MAIN_VERSION=2.7
ENV SPARK_BINARY_ARCHIVE_NAME=spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAIN_VERSION}
ENV SPARK_BINARY_DOWNLOAD_URL=http://apache.claz.org/spark/spark-${SPARK_VERSION}/${SPARK_BINARY_ARCHIVE_NAME}.tgz
RUN curl ${SPARK_BINARY_DOWNLOAD_URL} -o /tmp/${SPARK_BINARY_ARCHIVE_NAME}.tgz \
&&  tar -zxvf /tmp/${SPARK_BINARY_ARCHIVE_NAME}.tgz -C /opt/ \
&&  ln -svf /opt/${SPARK_BINARY_ARCHIVE_NAME} /opt/spark \
&&  rm /tmp/${SPARK_BINARY_ARCHIVE_NAME}.tgz
RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] Spark finished"

# R studio
RUN rstudio_version=$(wget --no-check-certificate -qO- https://s3.amazonaws.com/rstudio-server/current.ver) \
&& rstudio_version_sub=${rstudio_version%-*} \
&& wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-${rstudio_version_sub}-amd64.deb -O /rstudio-server.deb \
&& apt-get install -y --no-install-recommends /rstudio-server.deb \
&& rm /rstudio-server.deb 
RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] R studio finished"

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
RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] Setting finished"

# packages and tools
# jupyter
RUN pip3 install --no-cache-dir \
jupyter nbdime beakerx qgrid jupyterhub jupyterlab jupyter-lsp python-language-server[all] jupyterlab_latex ipykernel
# dev base
RUN pip3 install mypy pylint yapf pytest ipython virtualenv flake8 lxml
# log, debug, monitor   
RUN pip3 install loguru rainbow_logging_handler pysnooper tqdm notifiers
# argument
RUN pip3 install click pyyaml
# time
RUN pip3 install pyarrow>=0.14.0 pytz
# science
RUN pip3 install numpy scipy pandas dask[complete] scikit-learn xgboost
RUN pip3 install tensorflow
#RUN pip3 install tensorflow-gpu
#RUN pip3 install torch torchvision
# db
RUN pip3 install JPype1==0.6.3 JayDeBeApi sqlparse requests[socks] tornado influxdb
# spark 
RUN pip3 install pyspark py4j findspark pyspark-stubs optimuspyspark toree
# file
RUN pip3 install fastparquet
# visualization 
RUN pip3 install matplotlib plotly cufflinks seaborn bokeh holoviews[recommended] hvplot tabulate colorlover
RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] Pip finished"

# beakerx
RUN beakerx install

# jupyterlab extension
RUN jupyter labextension install @jupyterlab/latex
RUN jupyter labextension install @mflevine/jupyterlab_html
RUN jupyter labextension install jupyterlab-drawio
RUN jupyter labextension install jupyterlab_tensorboard
RUN jupyter labextension install @jupyterlab/github
RUN jupyter labextension install @lckr/jupyterlab_variableinspector
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension install @jupyterlab/toc
RUN jupyter labextension install jupyterlab-favorites
RUN jupyter labextension install jupyterlab-recents
RUN jupyter labextension install @krassowski/jupyterlab-lsp
#RUN jupyter labextension install qgrid
#RUN jupyter labextension install beakerx-jupyterlab
#RUN jupyter labextension install @pyviz/jupyterlab_pyviz
RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] Jupyter finished"

# install R related packages
COPY scripts/R/install_r.R /tmp
RUN Rscript /tmp/install_r.R
RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] R packages installed"

# create directory
RUN mkdir -p /workdir /logs
RUN chmod -R 777 /workdir /logs

# brew
RUN git clone https://github.com/Homebrew/brew /workdir/.linuxbrew/Homebrew 
RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] brew cloned"

# powerline
RUN wget https://raw.githubusercontent.com/powerline/powerline/develop/font/10-powerline-symbols.conf -O /workdir/10-powerline-symbols.conf
RUN wget https://raw.githubusercontent.com/powerline/powerline/develop/font/PowerlineSymbols.otf -O /workdir/PowerlineSymbols.otf
# RUN DEBIAN_FRONTEND=noninteractive apt-get install -y powerline fonts-powerline
RUN mkdir -p /usr/share/fonts/OTF
RUN cp /workdir/10-powerline-symbols.conf /usr/share/fonts/OTF/
RUN mv /workdir/10-powerline-symbols.conf /etc/fonts/conf.d/
RUN mv /workdir/PowerlineSymbols.otf /usr/share/fonts/OTF/
RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] powerline installed"

# clean
RUN npm cache clean --force
RUN apt-get autoremove -y
RUN apt-get clean -y
RUN rm -rf /tmp/downloaded_packages/ /tmp/*.rds 
#/var/lib/apt/lists/*

RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] Cleaning finished"

# expose port
# jupyter service
# EXPOSE 8888
# R studio
EXPOSE 7000
# jupyter hub
EXPOSE 8000
# hadoop
EXPOSE 8088
EXPOSE 9000
EXPOSE 9870
# spare
EXPOSE 5006

# copy files
COPY scripts /scripts
COPY settings /settings

RUN echo "[$(tput setaf 6)INFO$(tput sgr0)] All finished"