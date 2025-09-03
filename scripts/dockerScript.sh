#!/bin/bash

#config file
source conf/dockerConfig.conf

#todo use config file for env, container name, image to use, Paths 
if [ $# == 0 ] || [ $1 == "-help" ] || [ $1 == "-h" ]
then
  echo "Usage: "
  echo "  dockerScript -start|-s   : Starts Docker engine."
  echo "  dockerScript -stop|-st   : Stops Docker engine."
  echo "  dockerScript -build|-b   : Builds Docker image."
  echo "  dockerScript -destroy|-d : Destroys Docker container."
  echo "  dockerScript -clean|-c   : Clean destroys container and image."
  echo "  dockerScript -run|-r     : Runs Docker container."
  echo "  dockerScript -log|-l     : Dumps logfile from container."
elif [ $1 == "-test" ] || [ $1 == "-t" ]
then
  echo "TEST"
  if [ $# == 2 ]
  then
    CONF=$2
    if [ -f $CONF ]
    then
      source $2
      echo "$CHECKVAR"
      echo "$(<"$2")"
    else
      echo "File $CONF does not exist."
    fi
  fi
elif [ $1 == "-start" ] || [ $1 == "-s" ]
then
  echo "Starting Docker engine."
  sudo service docker start
  echo "Docker engine started."
elif [ $1 == "-stop" ] || [ $1 == "-st" ]
then
  echo "Stopping Docker engine."
  sudo service docker stop &>/dev/null
  sudo systemctl stop docker.socket &>/dev/null
  echo "Docker engine stopped."
elif [ $1 == "-build" ] || [ $1 == "-b" ]
then
  if docker info > /dev/null 2>&1;
  then
    echo "building docker image"
    cd ../$DOCKER_PATH/$DOCKER_IMAGE_NAME/
    docker buildx build --build-arg BUILD_TIME=$(date +'%Y-%m-%d--%H-%M-%S') -t $DOCKER_IMAGE_NAME .
    cd ../../$SCRIPT_PATH/
    echo "build complete."
  else
    echo "Docker needs to be running use first: "
    echo "     dockerScript -start|-s   : Starts Docker engine."
  fi
elif [ $1 == "-destroy" ] || [ $1 == "-d" ]
then
  echo "Dumping log file."
  docker cp $DOCKER_CONTAINER_NAME:/agent-dir/logs/. ../$DOCKER_PATH/logs/.
  echo "Destroying docker container."
  docker rm $DOCKER_CONTAINER_NAME
  echo "Container destroyed."
elif [ $1 == "-clean" ] || [ $1 == "-c" ]
then
  echo "Dumping log file."
  docker cp $DOCKER_CONTAINER_NAME:/agent-dir/logs/. ../$DOCKER_PATH/logs/.
  echo "Destroying docker container."
  docker rm $DOCKER_CONTAINER_NAME
  echo "Destroying docker image."
  docker rmi $DOCKER_IMAGE_NAME:latest
  echo "Container and image destroyed."
elif [ $1 == "-run" ] || [ $1 == "-r" ]
then
  echo "Run docker container."
  docker run --security-opt apparmor=docker-default --name $DOCKER_CONTAINER_NAME $DOCKER_IMAGE_NAME &
  echo "Container is running in the background."
elif [ $1 == "-log" ] || [ $1 == "-l" ]
then
  echo "Copying logfile from container."
  docker cp $DOCKER_CONTAINER_NAME:/agent-dir/logs/. ../$DOCKER_PATH/logs
  echo "Logfile stored."
fi
