# Dockify

This tool will will generate a stock Docker image based on app language and optional custom settings

## USAGE

`cd ./docker/tools/dockify`

Run as follows by using the following examples

```
DOCKER_IMAGE_VERSION=latest \
DOCKER_IMAGE_NAME=test \
DOCKER_IMAGE_DESCRIPTION="test description" \
DOCKER_IMAGE_MAINTAINER="author" \
DOCKER_WORKDIR="\/var\/www\/deploy\/app\/" \
DOCKER_PORT=9000 \
./scripts/dockify.sh

DOCKER_IMAGE_VERSION=latest \
DOCKER_IMAGE_NAME=test \
DOCKER_IMAGE_DESCRIPTION="test description" \
DOCKER_IMAGE_MAINTAINER="author \<http\:\/\/github.com\/author\>" \
DOCKER_PORT=9000 \
./scripts/dockify.sh

APP_LANGUAGE="node" \
APP_TYPE="backend" \
DOCKER_IMAGE_VERSION=latest \
DOCKER_IMAGE_NAME=test \
DOCKER_IMAGE_DESCRIPTION="test description" \
DOCKER_IMAGE_MAINTAINER="author \<http\:\/\/github.com\/author\>" \
DOCKER_PORT=9000 \
./scripts/dockify.sh

APP_LANGUAGE="rust" \
APP_NAME="demo" \
DOCKER_IMAGE_VERSION=latest \
DOCKER_IMAGE_NAME=test \
DOCKER_IMAGE_DESCRIPTION="test description" \
DOCKER_IMAGE_MAINTAINER="author \<http\:\/\/github.com\/author\>" \
DOCKER_PORT=9000 \
./scripts/dockify.sh
```

Find your output docker files and scripts in the `./docker/tools/dockify/output` folder.
