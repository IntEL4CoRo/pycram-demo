# pycram-demo


Run on Binderhub:
[![Binder](https://binder.intel4coro.de/badge_logo.svg)](https://binder.intel4coro.de/v2/gh/IntEL4CoRo/pycram-demo/main?labpath=orm_example.ipynb)


Run on local PC
```
xhost +local:docker && \
docker build -t pycramdemo:latest . && docker run -p 8888:8888 --rm pycramdemo:latest jupyter lab --NotebookApp.token='' && \
xhost -local:docker
```