# ros_dockerfiles
Dockerfiles to create containers with ROS. Check [this tutorial](https://roboticseabass.com/2021/04/21/docker-and-ros/) for more information.

The default images are for Ubuntu 22.04 with NVIDIA GPU drivers and ROS2 Humble.

## NVIDIA Container Toolkit
To use the NVIDIA GPUs, the containers are based on the [nvidia/cuda](https://hub.docker.com/r/nvidia/cuda) or [nvidia/cudagl](https://hub.docker.com/r/nvidia/cudagl) images. That way, it is necessary to install the [respective](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker) NVIDIA driver. 

## Building Images
GNU Make is used to simplify the commands to build and run the containers. 

To build the base image of the default ROS Distro, just type:
```
make build-base
```

To build the container for navigation (with Gazebo, ROS Control, Navigation Stack):
```
make build-nav
```

(Optional) To build any image for another ROS Distro, just select the option by:
```
make build-base ROS_DISTRO={DESIRED_ROS_DISTRO}
make build-nav ROS_DISTRO={DESIRED_ROS_DISTRO}
```

For more options, check the [Makefile](./Makefile).


## Running Containers
If you want to forwarded the DISPLAY from the container to the host (Gazebo, rqt, rviz), it is necessay to give permission to the X server host:
```
xhost +local:root
```
which is necessary only once until you reboot. 

For safety reasons, you may want to remove the permission when not using the container:
```
xhost -local:root # optional
```

To start a container using the base image:
```
make run-base
```
or the navigation:
```
make run-nav
```
which the building options (ROS_DISTRO, IMAGE_NAME) are also available. 


### Shared ROS Workspace
By default (variable WS_SHARE), the directory `ros2_ws` from the host is shared with the directory `ros2_ws` of container. Therefore, you can create/edit any code in the host, and then compile/launch the files inside the container. Changes inside the directory `ros2_ws` are persistent. 
