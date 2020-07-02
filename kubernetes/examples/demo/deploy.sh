kubectl --namespace $KUBE_NAMESPACE apply -f ./namespace
kubectl --namespace $KUBE_NAMESPACE apply -f ./deployment
kubectl --namespace $KUBE_NAMESPACE get services
