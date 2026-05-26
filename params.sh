#!/bin/bash

# ANSI Color Codes for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color (resets the output)
NEW_LINE="\n\n"



REGION="europe-west1"
AR_REGISTRY="${REGION}-docker.pkg.dev"
PROJECT_ID="fraud-maplequad"
REPO_NAME="test1"
AR_NAME="${AR_REGISTRY}/${PROJECT_ID}/${REPO_NAME}"



CONTAINER_NAME1="my1-app1"
IMAGE_NAME1="my1-app"
LOCAL_PORT1="8000"
CONTAINER_PORT1="8000"



CONTAINER_NAME2="load-gen"
IMAGE_NAME2="load-gen-img"
LOCAL_PORT2="8002"
CONTAINER_PORT2="8002"


CONTAINER_NAME3="my-app3"
IMAGE_NAME3="my-app3"
LOCAL_PORT3="8003"
CONTAINER_PORT3="8003"




CLUSTER_NAME="draud-detect" 
POOL_NAME="pool1"

