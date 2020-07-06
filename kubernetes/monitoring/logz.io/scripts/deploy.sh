# https://app.logz.io/#/dashboard/data-sources/Kubernetes
if [ -z "$LOGZIO_TOKEN" ]; then
  echo "No token provided. Exiting..."
  exit 1
fi
echo "Found token"
# The below host and port depends on listener region
# https://docs.logz.io/shipping/log-sources/elastic-kubernetes-service.html
kubectl create secret generic logzio-logs-secret --from-literal=logzio-log-shipping-token=$LOGZIO_TOKEN --from-literal=logzio-log-listener='https://listener.logz.io:8071' -n kube-system
# RBAC
kubectl apply -f https://raw.githubusercontent.com/logzio/logzio-k8s/master/logzio-daemonset-rbac.yaml
# Non RBAC
#kubectl apply -f https://raw.githubusercontent.com/logzio/logzio-k8s/master/logzio-daemonset.yaml
