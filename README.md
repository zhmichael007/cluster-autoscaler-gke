open cloud shell:  

git clone https://github.com/zhmichael007/cluster-autoscaler-gke.git  

cd cluster-autoscaler-gke/  

bash setup.sh

When the cluste and node pool has been created, and php-apache-highcpu, php-apache-highmem has been deployed, change the replica of php-apache-highcpu to 10, you will find the spot t2d will be scaled out because it has the high priority. 
