FROM pycram/pycram:dev

USER root
ENV SHELL=/bin/bash
# Create non-root user jovyan
ENV NB_USER=jovyan
ENV USER=${NB_USER}
RUN adduser --disabled-password \
    --gecos "Default user" \
    ${NB_USER}

# Steps copy from github CI
WORKDIR /opt/ros/overlay_ws/src/pycram
RUN pip3 install -r requirements.txt && \
    apt-get update && \
    apt-get install -y libpq-dev && \
    pip3 install -r requirements-resolver.txt && \
    pip3 install jupytext treon

RUN cd /opt/ros/overlay_ws/src/pycram/examples && \
    rm -rf tmp && \
    mkdir tmp && \
    jupytext --to notebook *.md && \
    mv *.ipynb tmp

RUN chown -R ${NB_USER}:${NB_USER} /opt/ros/overlay_ws/src/pycram
RUN git config --global --add safe.directory /opt/ros/overlay_ws/src/pycram
WORKDIR /opt/ros/overlay_ws/src/pycram/examples/tmp
EXPOSE 8888

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
USER ${NB_USER}
