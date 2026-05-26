#!/bin/bash


if [[  -f ./params.sh ]]; then 
    source ./params.sh

else 
    echo -e "params file missing ... exiting"
    exit 9

fi 

# CONTAINER_NAME="my1-app1"
# IMAGE_NAME="my1-app"
# LOCAL_PORT="8000"
# CONTAINER_PORT="8000"

echo "Stopping and removing existing container..."
docker rm -f $CONTAINER_NAME 2>/dev/null || true

echo "Pruning dangling Docker images to keep things clean..."
docker image prune -f

echo "Building the Docker image..."
docker build -t $IMAGE_NAME .


echo -e "waiting for 10 seconds"
sleep 10

echo "Running the Docker container..."
docker run -d --name $CONTAINER_NAME -p $LOCAL_PORT:$CONTAINER_PORT $IMAGE_NAME


sleep 10



# REGION="europe-west1"
# AR_REGISTRY="${REGION}-docker.pkg.dev"
# PROJECT_ID="fraud-maplequad"
# REPO_NAME="test1"
# AR_NAME="${AR_REGISTRY}/${PROJECT_ID}/${REPO_NAME}"

gcloud auth configure-docker $REGION-docker.pkg.dev

# Tag the image for GAR
docker tag "${IMAGE_NAME}:latest"  "${AR_NAME}/${IMAGE_NAME}:latest"

# Push it to the cloud
docker push    "${AR_NAME}/${IMAGE_NAME}:latest"

if [[ $? -eq "0" ]]; then 
    echo -e "pushed to GAR"

fi 

