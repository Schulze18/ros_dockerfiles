## Build Image
```
docker build .
```

## Start Container
Starting container sharing the folder ros_ws from the host:
```
docker run -d -t --name surf -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix/ --volume="${PWD}/ros_ws":"/ros_ws":rw IMAGE_ID
```

Attach a new bash:
```
docker exec -it surf bash
```