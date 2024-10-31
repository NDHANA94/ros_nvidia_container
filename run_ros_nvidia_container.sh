#!/bin/sh

XAUTH=$HOME/.Xauthority
WORKDIR=$(pwd)/volume


# Check if the XAUTH file does not exist
if [ ! -f $XAUTH ]; then
    # Retrieve X11 authorization entries for display :0 and modify them
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')

    # Check if there are existing X11 authorization entries
    if [ ! -z "$xauth_list" ]; then
        # Merge the retrieved X11 authorization entries into the specified file ($XAUTH)
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        # Create an empty file for X11 authentication if no entries exist
        touch $XAUTH
    fi

    # Change the permissions of the XAUTH file to allow read access for all users
    chmod a+r $XAUTH
fi


# run docker container
docker run -it --gpus all \
    --env DISPLAY=$DISPLAY \
    --env QT_X11_NO_MITSHM=1 \
    --volume /tmp/.X11-unix:/tmp/.X11-unix:rw \
    --volume $XAUTH:/root/.Xauthority \
    --device /dev/dri:/dev/dri \
    --volume $WORKDIR:/ros_ws \
    --env NVIDIA_DRIVER_CAPABILITIES=all \
    --network host \
    --privileged \
    noetic_dev_ws:nvidia # Change this image name if your image has a different name. 

