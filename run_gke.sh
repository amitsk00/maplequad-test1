#!/bin/bash

if [[  -f ./params.sh ]]; then 
    source ./params.sh

else 
    echo -e "params file missing ... exiting"
    exit 9

fi 



echo "Connecting to GKE cluster..."
gcloud container clusters get-credentials "$CLUSTER_NAME" --region "$REGION" --project "$PROJECT_ID"

echo "Deploying to GKE..."
kubectl apply -f gke-app/deployment.yaml
kubectl apply -f gke-app/service.yaml