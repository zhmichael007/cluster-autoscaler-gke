open cloud shell:  

git clone https://github.com/zhmichael007/cluster-autoscaler-gke.git  

cd cluster-autoscaler-gke/  

open setup.sh, modify the service account name in this file:  
```bash
SA_NAME=<Your Service Account Name>
```

bash setup.sh

the node pool design:  
<img src="https://github.com/zhmichael007/cluster-autoscaler-gke/blob/main/image/nodepooldesign.png" width="75%" height="75%">


When finished the running of setup.sh, the GKE cluster and node pool will be created, and php-apache-highcpu, php-apache-highmem has been deployed：  
<img src="https://github.com/zhmichael007/cluster-autoscaler-gke/blob/main/image/gkecluster_configmap.png" width="75%" height="75%">



change the replica of php-apache-highcpu to 30, you will find the spot t2d will be scaled out because it has the high priority.   
kubectl scale deployments/php-apache-highcpu --replicas=30  
<img src="https://github.com/zhmichael007/cluster-autoscaler-gke/blob/main/image/priorityscaleout.png" width="75%" height="75%">


