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
