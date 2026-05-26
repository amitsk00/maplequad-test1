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


echo "Connecting to GKE cluster..."
gcloud container clusters get-credentials "$CLUSTER_NAME" --region "$REGION" --project "$PROJECT_ID"

echo "Deploying to GKE..."

kubectl apply -f gke-app/namespace.yaml
kubectl apply -f gke-app/deployment.yaml
kubectl apply -f gke-app/service.yaml


echo "--------------------------------------------------"
echo -e "checking the recently created objects"
kubectl get pods -n ${NAMESPACE}
kubectl get service ${SERVICE_NAME} -n ${NAMESPACE}
echo "--------------------------------------------------"




echo -e "Waiting for GKE to allocate an External IP..."

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
echo "--------------------------------------------------"
echo "🚀 Deployment Successful!"
echo "--------------------------------------------------"
echo "App URL:  $BASE_URL"
echo "Docs URL: $HELP_URL"
echo "--------------------------------------------------"
