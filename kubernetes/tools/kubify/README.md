# Kubify

This script will provide you with a deployable kubernetes configuration for a single application with the support for a deployment, a load balancer service, secrets and jobs.

## USAGE

`cd ./kubernetes/tools/kubify`

1. Run the script by using the following examples
   ```
    # No ssl support
    K8_APP_NAMESPACE=namespace \
    K8_APP_NAME=test \
    K8_APP_PORT=7000 \
    K8_APP_IMAGE="hello\/hello" \
    ./scripts/kubify.sh

    # Add ssl support
    K8_APP_SSL=TRUE \
    K8_APP_NAMESPACE=namespace \
    K8_APP_NAME=test \
    K8_APP_PORT=7000 \
    K8_APP_IMAGE="hello\/hello" \
    ./scripts/kubify.sh
   ```
2. You can now safely view/edit under `./kubernetes/tools/kubify/output`. Remember to edit any secrets you need, add any jobs you require and change any configuration settings

3. Finally, you can deploy the files on a kubernetes cluster
   ```
    ./output/scripts/deploy.sh
   ```


## Cloud Provider Setup

1. Ensure the load balancer created for the service has the following config
   
   If UI Managed
   
   ```
    HTTP on port 80 -> HTTP on port xxxxx
    HTTPS on port 443 -> HTTP on port yyyyy (add the certificate here using the UI)
   ```
   
   If non-UI Managed
   Ensure your load balancer (nginx ingress controller) has the HTTPS port pointing to the HTTP port
   
   `ingress-nginx-controller ingress-nginx LoadBalancer`
   
   ```
    metadata:
      annotations:
        service.beta.kubernetes.io/do-loadbalancer-certificate-id: xxxxxxxx
        service.beta.kubernetes.io/do-loadbalancer-protocol: https
    ....
    spec:
      ports:
         - name: http
           protocol: TCP
           appProtocol: http
           port: 80
           targetPort: http
           nodePort: 32201
         - name: https
           protocol: TCP
           appProtocol: https
           port: 443
           targetPort: http
           nodePort: 32502
   ```

2. Point your domain A records to the load balancer IP
   
3. test by curl-ing the domain on both http and https and you're good to go!

4. Enable any other load balancer settings as needed (force ssl re-direct etc.)
