#!/usr/bin/env bash
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
kubectl apply -f $SCRIPTS_DIR/../config/nginx.yaml
kubectl --namespace $KUBE_NAMESPACE apply -f $SCRIPTS_DIR/../config/namespace.yaml
kubectl --namespace $KUBE_NAMESPACE apply -f $SCRIPTS_DIR/../config/secrets.yaml
kubectl --namespace $KUBE_NAMESPACE apply -f $SCRIPTS_DIR/../config/deployment
kubectl --namespace $KUBE_NAMESPACE apply -f $SCRIPTS_DIR/../config/service
kubectl --namespace $KUBE_NAMESPACE apply -f $SCRIPTS_DIR/../config/ingress
kubectl --namespace $KUBE_NAMESPACE get services
kubectl --namespace $KUBE_NAMESPACE get deployments
kubectl --namespace $KUBE_NAMESPACE get ingress
