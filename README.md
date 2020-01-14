# docker

docker run -d \
--restart="always" \
--name zac \
--hostname zac-hub \
--memory=$(($(head -n 1 /proc/meminfo | awk '{print $2}') * 4 / 5))k \
--cpus=$(($(nproc) - 2)) \
--log-opt max-size=50m \
-p 5006:5006 \
-p 7000:7000 \
-p 8000:8000 \
-p 8088:8088 \
-p 9000:9000 \
-p 9870:9870 \
-e DOCKER_USER=`id -un` \
-e DOCKER_USER_ID=`id -u` \
-e DOCKER_PASSWORD=`id -un` \
-e DOCKER_GROUP_ID=`id -g` \
-e DOCKER_ADMIN_USER=`id -un` \
-v $(pwd):/workdir \
-v $(dirname $HOME):/home_host \
9434/zac:latest /scripts/sys/init.sh

[nbdime](https://github.com/jupyter/nbdime): Jupyter diff and merge

[qgrid](https://github.com/quantopian/qgrid): Dataframe explorer

[beakerx](https://github.com/twosigma/beakerx): Collection of JVM kernels and interactive widgets for plotting, tables, autotranslation, and other extensions

[jupyterlab-latex](https://github.com/jupyterlab/jupyterlab-latex): Latex live-editor

[jupyterlab_html](https://github.com/mflevine/jupyterlab_html): HTML viewer

[jupyterlab-drawio](https://github.com/QuantStack/jupyterlab-drawio): Drawio

[jupyterlab_tensorboard](jupyterlab_tensorboard): TensorBoard

[jupyterlab-github](https://github.com/jupyterlab/jupyterlab-github): Github

[jupyterlab-variableInspector](https://github.com/lckr/jupyterlab-variableInspector): Variable Inspector

[jupyter-widgets](https://github.com/jupyter-widgets/ipywidgets/blob/master/docs/source/user_install.md): [Interactive Widgets](https://github.com/jupyter-widgets/ipywidgets/blob/master/docs/source/examples/Index.ipynb)

[jupyterlab-toc](https://github.com/jupyterlab/jupyterlab-toc): Table of contents

[jupyterlab-favorites](https://github.com/tslaton/jupyterlab-favorites): Favorite folders for quicker browsing

[jupyterlab-recents](https://github.com/tslaton/jupyterlab-recents): Track recent files and folders

[jupyterlab-lsp](https://github.com/krassowski/jupyterlab-lsp): Language server protocol

[jupyterlab_pyviz](https://github.com/holoviz/pyviz_comms)


