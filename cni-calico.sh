echo "[kubectl] Deploy Calico network"
curl -fsSL https://github.com/seanbao/k8s-deloyment/calico-3.24.5.yaml -o calico.yaml
# 将calico的pod网段设置为kubeadmin初始化的网段，否则网络会有问题
sed -i '/CALICO_IPV4POOL_CIDR/,+1 s/# //' calico.yaml
pod_cidr=$(echo $pod_subnet | sed 's/\//\\\//;s/\./\\\./g')
sed -i "s/192\.168\.0\.0\/16/${pod_cidr}/" calico.yaml
kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f calico.yaml >/dev/null 2>&1
# 指定calico通信使用的网卡
kubectl --kubeconfig=/etc/kubernetes/admin.conf set env daemonset/calico-node \
        -n kube-system IP_AUTODETECTION_METHOD=interface=$net_iface

echo "***** control-plane initialized complete! *****"