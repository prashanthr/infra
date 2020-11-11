# Magician

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


# Digital Ocean Setup

1. Ensure the load balancer created for the nignx ingress has the following config
   
   ```
    TCP on port 80  -> TCP on port xxxxx
    HTTPS on port 443 -> HTTPS on port yyyyy # (add the certificate here using DO UI)
   ```

2. Setup secrets as needed using the `output/config/secrets.yaml` and update `output/config/deployment.yaml` for the respective container and redeploy

3. test by curl-ing domains on both http and https and you're good to go!

4. Enable any other DO Load balancer settings as needed
