open cloud shell:  

git clone https://github.com/zhmichael007/cluster-autoscaler-gke.git  

cd cluster-autoscaler-gke/  

bash setup.sh

the node pool design:  
<img src="https://github.com/zhmichael007/cluster-autoscaler-gke/blob/main/image/nodepooldesign.png" width="50%" height="50%">


When the cluste and node pool has been created, and php-apache-highcpu, php-apache-highmem has been deployed：  
![image](https://github.com/zhmichael007/cluster-autoscaler-gke/blob/main/image/gkecluster_configmap.png)


change the replica of php-apache-highcpu to 30, you will find the spot t2d will be scaled out because it has the high priority.   
kubectl scale deployments/php-apache-highcpu --replicas=30  
![image](https://github.com/zhmichael007/cluster-autoscaler-gke/blob/main/image/priorityscaleout.png)


