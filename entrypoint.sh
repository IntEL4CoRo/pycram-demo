#!/bin/bash

source ${ROS_PATH}/setup.bash
source ${ROS_WS}/devel/setup.bash

roscore &

exec "$@"