FROM intel4coro/jupyter-ros2:jazzy-py3.12

USER ${NB_USER}
# Setup up a ROS workspace
ENV ROS_WS=${HOME}/workspace/ros
RUN mkdir -p ${ROS_WS}/src

# Clone pycram and its dependencies repos
WORKDIR ${ROS_WS}/src
RUN vcs import --input https://raw.githubusercontent.com/cram2/pycram/dev/rosinstall/pycram-ros2-https.rosinstall

# # init submodule repo with ssh url in .gitmodules
# RUN  cd ${ROS_WS}/src/pycram \
#   && perl -i -p -e 's|git@(.*?):|https://\1/|g' .gitmodules \
#   && git submodule sync \
#   && git submodule update --init --recursive

# # Building ROS workspace
WORKDIR ${ROS_WS}
RUN source /opt/ros/jazzy/setup.bash && \
    colcon build --symlink-install --parallel-workers 4
RUN echo "source ${ROS_WS}/install/setup.bash" >> ${HOME}/.bashrc

# # Install Python dependencies
WORKDIR ${ROS_WS}/src/pycram
RUN pip install -r requirements.txt

# Steps copy from github CI
RUN pip install jupytext treon
RUN cd ${ROS_WS}/src/pycram/examples && \
    rm -rf ../notebooks && \
    mkdir ../notebooks && \
    jupytext --to notebook *.md && \
    mv *.ipynb ../notebooks

# Extra steps for binderhub
RUN git config --global --add safe.directory ${ROS_WS}/src/pycram
WORKDIR ${ROS_WS}/src/pycram/notebooks

RUN pip uninstall -y jupyterlab_examples_cell_toolbar

COPY --chown=${NB_USER}:users utils.py ${ROS_WS}/src/pycram/notebooks
COPY --chown=${NB_USER}:users pycram.rviz ${ROS_WS}/src/pycram/notebooks
RUN ipython profile create && \
    ln -s ${ROS_WS}/src/pycram/notebooks/utils.py /home/jovyan/.ipython/profile_default/startup/00-first.py

COPY --chown=${NB_USER}:users entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
USER ${NB_USER}
