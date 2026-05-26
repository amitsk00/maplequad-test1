#!/bin/bash

set -e 

if [[  -f ./params.sh ]]; then 
    source ./params.sh

else 
    echo -e "params file missing ... exiting"
    exit 9

fi 

SERVICE_NAME="my-app1-service"
DEPLOYMENT_LABEL="my-app1"
NAMESPACE="amit"


echo -e "${BLUE}${NEW_LINE}Connecting to GKE cluster...${NC}"
gcloud container clusters get-credentials "$CLUSTER_NAME" --region "$REGION" --project "$PROJECT_ID"

echo -e "${GREEN}${NEW_LINE}${NEW_LINE}Deploying to GKE...${NC}"

kubectl apply -f gke-app/namespace.yaml
kubectl apply -f gke-app/deployment.yaml
kubectl apply -f gke-app/service.yaml


echo -e "${YELLOW}${NEW_LINE}${NEW_LINE}--------------------------------------------------${NC}"
echo -e "${BLUE}Checking the recently created objects...${NC}"
kubectl get pods -n ${NAMESPACE}
kubectl get service ${SERVICE_NAME} -n ${NAMESPACE}
echo -e "${YELLOW}--------------------------------------------------${NC}"




echo -e "${BLUE}${NEW_LINE}${NEW_LINE}Waiting for GKE to allocate an External IP...${NC}"

# Loop until the External IP is no longer empty or "pending"
EXTERNAL_IP=""
while [ -z "$EXTERNAL_IP" ] || [ "$EXTERNAL_IP" == "<pending>" ]; do
    # Fetch the IP using jsonpath formatting
    EXTERNAL_IP=$(kubectl get svc ${SERVICE_NAME} -n ${NAMESPACE} -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
    
    # If still empty, wait 5 seconds and try again
    if [ -z "$EXTERNAL_IP" ]; then
        sleep 5
    fi
done

# Create the URL variables
BASE_URL="http://$EXTERNAL_IP"
HELP_URL="http://$EXTERNAL_IP/help"

# Display the URLs clearly in the console
echo -e "${YELLOW}--------------------------------------------------${NC}"
echo -e "${GREEN}🚀 Deployment Successful!${NC}"
echo -e "${YELLOW}--------------------------------------------------${NC}"
echo -e "App URL:  ${BLUE}$BASE_URL${NC}"
echo -e "Docs URL: ${BLUE}$HELP_URL${NC}"
echo -e "${YELLOW}--------------------------------------------------${NC}"
