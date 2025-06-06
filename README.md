# pycram-demo

PyCRAM version: [v1.0.4](https://github.com/cram2/pycram/tree/v1.0.4)

Run on Binderhub:
[![Binder](https://binder.intel4coro.de/badge_logo.svg)](https://binder.intel4coro.de/v2/gh/IntEL4CoRo/pycram-demo/ros1?urlpath=lab%2Ftree%2Fintro.ipynb)


Run on local PC
```
xhost +local:docker && \
docker build -t pycramdemo:latest . && docker run -p 8888:8888 --rm pycramdemo:latest jupyter lab --NotebookApp.token='' && \
xhost -local:docker
```