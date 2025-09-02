#!/bin/bash

#todo use config file for env, container name, image to use, Paths 
if [ $# == 0 ] || [ $# -gt 1 ]
then
  echo "Usage: "
  echo "  dockerScript -start|-s   : Starts Docker engine."
  echo "  dockerScript -stop|-st   : Stops Docker engine."
  echo "  dockerScript -build|-b   : Builds Docker image."
  echo "  dockerScript -destroy|-d : Destroys Docker container."
  echo "  dockerScript -clean|-c   : Clean destroys container and image."
  echo "  dockerScript -run|-r     : Runs Docker container."
  echo "  dockerScript -log|-l     : Dumps logfile from container."
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
    cd ../docker/0-primer/
    docker buildx build --build-arg BUILD_TIME=$(date +'%Y-%m-%d--%H-%M-%S') -t 0-primer .
    cd ../../scripts/
    echo "build complete."
  else
    echo "Docker needs to be running use first: "
    echo "     dockerScript -start|-s   : Starts Docker engine."
  fi
elif [ $1 == "-destroy" ] || [ $1 == "-d" ]
then
  echo "Dumping log file."
  docker cp 0-primer:/agent-dir/logs/. ../docker/logs/.
  echo "Destroying docker container."
  docker rm 0-primer
  echo "Container destroyed."
elif [ $1 == "-clean" ] || [ $1 == "-c" ]
then
  echo "Dumping log file."
  docker cp 0-primer:/agent-dir/logs/. ../docker/logs/.
  echo "Destroying docker container."
  docker rm 0-primer
  echo "Destroying docker image."
  docker rmi 0-primer:latest
  echo "Container and image destroyed."
elif [ $1 == "-run" ] || [ $1 == "-r" ]
then
  echo "Run docker container."
  docker run --security-opt apparmor=docker-default --name 0-primer 0-primer &
  echo "Container is running in the background."
elif [ $1 == "-log" ] || [ $1 == "-l" ]
then
  echo "Copying logfile from container."
  docker cp 0-primer:/agent-dir/logs/. ..docker/logs.
  echo "Logfile stored."
fi
