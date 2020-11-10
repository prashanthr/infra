# Magician

## USAGE

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

2) Let the magic happen

  ```
  # For a self-service setup - Run the following command
  ./magician

  # OR

  # For a docker setup - Run the following command
  DOCKER_OP=true ./magician
  ```
