echo "[kubeadmin] master_ip = $1 , k8s_token=$2 ,net_iface=$3 , pod_subnet=$4 , kube_version=$5"
master_ip=$1
k8s_token=$2
net_iface=$3
pod_subnet=$4
kube_version="v$5"

echo "[kubeadmin] Pull google containers from Aliyun"
kubeadm config images pull --kubernetes-version="$kube_version" --image-repository="registry.aliyuncs.com/google_containers">/dev/null 2>&1

echo "[kubeadmin] Initialize Kubernetes Cluster"
kubeadm init --image-repository="registry.aliyuncs.com/google_containers" \
             --apiserver-advertise-address=$master_ip \
             --control-plane-endpoint=$master_ip \
             --kubernetes-version="$kube_version" \
             --token=$k8s_token \
             --pod-network-cidr=$pod_subnet

echo "[kubectl] Set kubectl config"
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config