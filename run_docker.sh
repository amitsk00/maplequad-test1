#!/bin/bash

CONTAINER_NAME="my1-app1"
IMAGE_NAME="my1-app"
LOCAL_PORT="8000"
CONTAINER_PORT="8000"

echo "Stopping and removing existing container..."
docker rm -f $CONTAINER_NAME 2>/dev/null || true

echo "Pruning dangling Docker images to keep things clean..."
docker image prune -f

echo "Building the Docker image..."
docker build -t $IMAGE_NAME .

echo "Running the Docker container..."
docker run -d --name $CONTAINER_NAME -p $LOCAL_PORT:$CONTAINER_PORT $IMAGE_NAME



AR_NAME="europe-west1-docker.pkg.dev/fraud-maplequad/test1"
