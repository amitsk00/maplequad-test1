#!/bin/bash

set -e 

if [[  -f ./params.sh ]]; then 
    source ./params.sh

else 
    echo -e "params file missing ... exiting"
    exit 9

fi 

SERVICE_NAME="load-gen-service"
DEPLOYMENT_LABEL="load-gen-label"
NAMESPACE="amit"


echo -e "${BLUE}${NEW_LINE}Connecting to GKE cluster...${NC}"
gcloud container clusters get-credentials "$CLUSTER_NAME" --region "$REGION" --project "$PROJECT_ID"

echo -e "${GREEN}${NEW_LINE}${NEW_LINE}Deploying to GKE...${NC}"

# kubectl apply -f gke-app/namespace.yaml
kubectl apply -f gke-app/deployment_load.yaml
kubectl apply -f gke-app/service_load.yaml
kubectl apply -f gke-app/hpa_load.yaml


echo -e "${YELLOW}${NEW_LINE}${NEW_LINE}--------------------------------------------------${NC}"
echo -e "${BLUE}Checking the recently created objects...${NC}"
kubectl get pods -n ${NAMESPACE}
kubectl get service ${SERVICE_NAME} -n ${NAMESPACE}
echo -e "${YELLOW}--------------------------------------------------${NC}"




echo -e "${BLUE}${NEW_LINE}${NEW_LINE}Waiting for GKE to allocate an External IP...${NC}"

# Loop until the External IP is no longer empty or "pending"
LOAD_EXTERNAL_IP=""
while [ -z "$LOAD_EXTERNAL_IP" ] || [ "$LOAD_EXTERNAL_IP" == "<pending>" ]; do
    # Fetch the IP using jsonpath formatting
    LOAD_EXTERNAL_IP=$(kubectl get svc ${SERVICE_NAME} -n ${NAMESPACE} -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
    
    # If still empty, wait 5 seconds and try again
    if [ -z "$LOAD_EXTERNAL_IP" ]; then
        sleep 5
    fi
done

# Create the URL variables
LOAD_BASE_URL="http://$LOAD_EXTERNAL_IP"
LOAD_HELP_URL="http://$LOAD_EXTERNAL_IP/help"

# Display the URLs clearly in the console
echo -e "${YELLOW}--------------------------------------------------${NC}"
echo -e "${GREEN}🚀 Deployment Successful!${NC}"
echo -e "${YELLOW}--------------------------------------------------${NC}"
echo -e "App URL:  ${BLUE}$LOAD_BASE_URL${NC}"
echo -e "Docs URL: ${BLUE}$LOAD_HELP_URL${NC}"
echo -e "${YELLOW}--------------------------------------------------${NC}"



sleep 10
echo -e "will try load testing now for the app to test HPA"

LOAD_URL="http://$LOAD_EXTERNAL_IP/load/999999"

# -n = Total number of requests to perform
# -c = Number of multiple requests to make at a time (Concurrency)
# -k = Use HTTP KeepAlive (optional, but helps avoid exhausting local ports)
ab -n 500 -c 20 -k "${LOAD_URL}"

echo -e "Test completed"
