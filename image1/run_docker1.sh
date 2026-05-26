#!/bin/bash


if [[  -f ./params.sh ]]; then 
    source ./params.sh

else 
    echo -e "${RED}params file missing ... exiting$ {NC}"
    exit 9

fi 

# CONTAINER_NAME1="my1-app1"
# IMAGE_NAME1="my1-app"
# LOCAL_PORT1="8000"
# CONTAINER_PORT1="8000"

echo -e "${BLUE}Stopping and removing existing container...${NC}"
docker rm -f $CONTAINER_NAME1 2>/dev/null || true

echo -e "${BLUE}Pruning dangling Docker images to keep things clean...${NC}"
docker image prune -f

echo -e "${GREEN}Building the Docker image...${NC}"
docker build -t $IMAGE_NAME1 ..


echo -e "${YELLOW}waiting for 10 seconds...${NC}"
sleep 10

echo -e "${GREEN}${NEW_LINE}Running the Docker container...${NC}"
docker run -d --name $CONTAINER_NAME1 -p $LOCAL_PORT1:$CONTAINER_PORT1 $IMAGE_NAME1


sleep 10



# REGION="europe-west1"
# AR_REGISTRY="${REGION}-docker.pkg.dev"
# PROJECT_ID="fraud-maplequad"
# REPO_NAME="test1"
# AR_NAME="${AR_REGISTRY}/${PROJECT_ID}/${REPO_NAME}"

echo -e "${BLUE}${NEW_LINE}Auth for GKE cluster ${NC}"
gcloud auth configure-docker $REGION-docker.pkg.dev

# Tag the image for GAR
docker tag "${IMAGE_NAME1}:latest"  "${AR_NAME}/${IMAGE_NAME1}:latest"

# Push it to the cloud
docker push    "${AR_NAME}/${IMAGE_NAME1}:latest"

if [[ $? -eq "0" ]]; then 
    echo -e "${GREEN}Successfully pushed to GAR!${NC}"
else
    echo -e "${RED}>>> issue pushing image to GAR ${NC}"
fi 
