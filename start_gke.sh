#!/bin/bash

set -e 

if [[  -f ./params.sh ]]; then 
    source ./params.sh

else 
    echo -e "params file missing ... exiting"
    exit 9

fi 




kubectl scale deployment apps/load-gen-depl --replicas=1 -n amit
kubectl scale deployment load-gen-depl --replicas=1 -n amit
kubectl scale deployment my-app1-depl --replicas=1 -n amit

kubectl apply  gke-app/hpa_load.yaml 

