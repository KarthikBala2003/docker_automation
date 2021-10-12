#!/bin/bash

echo "Enter custom container name "  
read CONTAINER_NAME

docker stop $CONTAINER_NAME
CONTAINER_ID=$(docker ps -a | grep $CONTAINER_NAME | tr -s ' ' | cut -d ' ' -f1)

docker rm $CONTAINER_ID

echo "Enter image name"
read IMAGE_NAME
IMAGE_ID=$(docker images | grep $IMAGE_NAME | tr -s [[:space:]] | cut -d ' ' -f3)

docker rmi $IMAGE_ID
