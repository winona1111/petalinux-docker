#!/bin/bash
while getopts "v:i:p:" argv
do
    case $argv in
        v) version=${OPTARG};;
        i) installer=${OPTARG};;
        p) path=${OPTARG};;
    esac
done

if [ -z $version ] || [ -z $installer ] || [ -z $path ]; then
    echo "Please give install version, installer and path! ......exiting"

else
    show="Start building petalinux:$version image......"
    echo $show
    sudo docker build --build-arg PETA_VERSION=$version \
                      --build-arg PETA_RUN_FILE=$installer \
                      -t petalinux:$version $path
    echo "Start running container......"
    sudo docker run -ti --rm -e DISPLAY=$DISPLAY --net="host" \
                    -v /tmp/.X11-unix:/tmp/.X11-unix \
                    -v $HOME/.Xauthority:/home/vivado/.Xauthority \
                    -v $HOME/Projects:/home/vivado/project \
                    -v $path:$path petalinux:$version /bin/bash
fi


