#!/bin/bash

set -e 

if [[  -f ./params.sh ]]; then 
    source ./params.sh

else 
    echo -e "params file missing ... exiting"
    exit 9

fi 


kubectl scale deployment apps/load-gen-depl --replicas=0 -n amit
kubectl scale deployment load-gen-depl --replicas=0 -n amit
kubectl scale deployment my-app1-depl --replicas=0 -n amit

kubectl delete hpa load-gen-hpa -n amit

gcloud container node-pools update ${POOL_NAME} \
    --cluster=${CLUSTER_NAME} \
    --region=${REGION} \
    --prooject=${PROJECT_ID} \
    --enable-autoscaling \
    --min-nodes=0 \
    --max-nodes=0

