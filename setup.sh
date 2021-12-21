#!/bin/bash

CLUSTER_NAME=cluster-autoscaler
HIGH_MEM_SPOT=("e2-custom-4-32768" "n2-custom-4-32768" "n2d-custom-4-32768")
HIGH_CPU_SPOT=("e2-custom-4-8192" "n2-custom-4-8192" "t2d-standard-4" "n2d-custom-4-8192" "c2-standard-4")
SA_NAME="project-admin@zhmichael1.iam.gserviceaccount.com"

echo "start GKE node pool provisioning, cluster name: "$CLUSTER_NAME

#default node pool
gcloud beta container clusters create $CLUSTER_NAME \
--region us-central1 \
--node-locations us-central1-a \
--machine-type=e2-standard-4 \
--service-account=$SA_NAME \
--num-nodes 1

gcloud container clusters get-credentials $CLUSTER_NAME --region us-central1


echo "start high mem on-demand provisioning"
gcloud beta container node-pools create on-demand-highmem-e2 \
--cluster=$CLUSTER_NAME \
--region us-central1 \
--machine-type=e2-standard-4 \
--num-nodes 0 \
--service-account=$SA_NAME \
--node-labels=ondemand-spot=ondemand,machine-type=highmem

#high mem spot
echo "start high mem spot provisioning"
for instancetype in ${HIGH_MEM_SPOT[@]}; do
	gcloud beta container node-pools create "spot-highmem-"${instancetype%%-*} \
	--cluster=$CLUSTER_NAME \
	--region us-central1 \
	--machine-type=$instancetype \
	--num-nodes 1 \
	--service-account=$SA_NAME \
	--node-labels=ondemand-spot=spot,machine-type=highmem \
	--spot
done

echo "start high cpu on-demand provisioning"
gcloud beta container node-pools create on-demand-highcpu-e2 \
--cluster=$CLUSTER_NAME \
--region us-central1 \
--machine-type=e2-standard-4 \
--num-nodes 0 \
--service-account=$SA_NAME \
--node-labels=ondemand-spot=ondemand,machine-type=highcpu

#high CPU spot 
echo "start high cpu spot provisioning"
for instancetype in ${HIGH_CPU_SPOT[@]}; do
	gcloud beta container node-pools create "spot-highcpu-"${instancetype%%-*} \
	--cluster=$CLUSTER_NAME \
	--region us-central1 \
	--machine-type=$instancetype \
	--num-nodes 1 \
	--service-account=$SA_NAME \
	--node-labels=ondemand-spot=spot,machine-type=highcpu \
	--spot
done

kubectl apply -f priority-expander-configmap-gke.yaml
kubectl apply -f cluster-autoscaler-autodiscover-gke.yaml
kubectl create clusterrolebinding root-cluster-admin-binding --clusterrole=cluster-admin --serviceaccount=kube-system:cluster-autoscaler
