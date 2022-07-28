#  Makefile for ROS Containers

# Command-line arguments
ROS_DISTRO ?= humble
USE_GPU ?= true        # Use GPU devices (set to true if you have an NVIDIA GPU)
USE_NET_HOST ?= true
UNIQUE_CONT ?= true
IMAGE_NAME ?= nvidia_ros
WS_SHARE ?= true

# Docker Variables
BASE_DOCKERFILE = ${PWD}/${ROS_DISTRO}/dockerfile_ros_humble_base
NAV_DOCKERFILE = ${PWD}/${ROS_DISTRO}/dockerfile_ros_humble_nav

# Set Docker volumes and environment variables
DOCKER_VOLUMES = \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw"

DOCKER_ENV_VARS = \
	--env="NVIDIA_DRIVER_CAPABILITIES=all" \
    --env NVIDIA_DISABLE_REQUIRE=1 \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1"

DOCKER_ARGS = ${DOCKER_VOLUMES} ${DOCKER_ENV_VARS} 

ifeq ("${USE_GPU}", "true")
DOCKER_ARGS += "--gpus all"
endif
ifeq ("${USE_NET_HOST}", "true")
DOCKER_ARGS += "--net=host"
endif
ifeq ("${UNIQUE_CONT}", "true")
DOCKER_ARGS += "--rm"
endif
ifeq ("${UNIQUE_CONT}", "true")
DOCKER_ARGS += "--rm"
endif
ifeq ("${WS_SHARE}", "true")
DOCKER_ARGS += --volume="${PWD}/ros2_ws":"/ros2_ws":rw
endif


## Build ##

# Build the base image
.PHONY: build-base
build-base:
	@docker build -f ${BASE_DOCKERFILE} -t ${IMAGE_NAME}_${ROS_DISTRO}_base .

# Build the base image
.PHONY: build-nav
build-nav: build-base
	@docker build -f ${NAV_DOCKERFILE} -t ${IMAGE_NAME}_${ROS_DISTRO}_nav .

## Run ##

.PHONY: run-base
run-base:
	@docker run -it ${DOCKER_ARGS} ${IMAGE_NAME}_${ROS_DISTRO}_base \
		bash

.PHONY: run-nav
run-nav:
	@docker run -it ${DOCKER_ARGS} ${IMAGE_NAME}_${ROS_DISTRO}_nav \
		bash