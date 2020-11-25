# Magician

This script will provide you with a deployable kubernetes configuration for a suite of apps using either a standard (single nginx ingress backed by services) or docker-in-docker (dind) style architecture with an nginx ingress controller, and a deployment plus ingress service for each app. You can also manage secrets for the namespace. Think of this as traditional multi domain nginx apps in Kubernetes.

## USAGE

`cd ./kubernetes/tools/magician`

1) Edit ./config/apps.json for the list of apps your want to setup

  ```
  [{
    "name": "app-1",
    "port": "9000",
    "hostPort": "9001",
    "dns": "1.example.com",
    "image": "hello-world:latest",
    "https": false
  }, {
    "name": "app-2",
    "port": "9000",
    "hostPort": "9002",
    "dns": "2.example.com",
    "image": "hello-world:latest",
    "https": false
  }]

  ```

2. Run the script with minimal params

```
K8_APP_NAMESPACE=namespace \
K8_DOCKER_APP_NAME=dind \
./scripts/magician.sh
```

```
# DEPLOYMENT_STYLE can be "std" (default) or "dind"
DEPLOYMENT_STYLE="dind"
K8_APP_NAMESPACE=namespace \
K8_DOCKER_APP_NAME=dind \
./scripts/magician.sh
```

3. You can now safely view/edit under `./kubernetes/tools/magician/output`. Remember to edit any secrets you need, add any jobs you require and change any configuration settings. Ensure that you use `-e ENV_KEY=ENV_VALUE` to forward any secrets to the respective docker app containers in the `docker run ...` command inside `./kubernetes/tools/magician/output/config/deployment/deployment.yaml` before proceeding

4. Finally, you can deploy the files on a kubernetes cluster
   ```
    ./output/scripts/deploy.sh
   ```

## Cloud Provider Setup

1. Ensure the load balancer created for the ingress has the following config
   
   ```
    HTTP on port 80  -> HTTP on port xxxxx
    HTTPS on port 443 -> HTTPS on port yyyyy # (add the certificate here using the UI)
   ```

2. Point your domain A records to the load balancer IP
   
3. test by curl-ing the domain on both http and https and you're good to go!

4. Enable any other load balancer settings as needed (force ssl re-direct etc.)
