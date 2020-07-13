
#/bin/bash
# Example usage
# cd ./docker/tools/dockify
# 
# DOCKER_IMAGE_VERSION=latest \
# DOCKER_IMAGE_NAME=test \
# DOCKER_IMAGE_DESCRIPTION="test description" \
# DOCKER_IMAGE_MAINTAINER="author" \
# DOCKER_WORKDIR="\/var\/www\/deploy\/app\/" \
# DOCKER_PORT=9000 \
# ./scripts/dockify.sh

# DOCKER_IMAGE_VERSION=latest \
# DOCKER_IMAGE_NAME=test \
# DOCKER_IMAGE_DESCRIPTION="test description" \
# DOCKER_IMAGE_MAINTAINER="author \<http\:\/\/github.com/author\>" \
# DOCKER_PORT=9000 \
# ./scripts/dockify.sh

# APP_LANGUAGE="node" \
# APP_TYPE="backend" \
# DOCKER_IMAGE_VERSION=latest \
# DOCKER_IMAGE_NAME=test \
# DOCKER_IMAGE_DESCRIPTION="test description" \
# DOCKER_IMAGE_MAINTAINER="author \<http\:\/\/github.com/author\>" \
# DOCKER_PORT=9000 \
# ./scripts/dockify.sh

function replaceOccurence {
    echo "Replacing $1 for $2 in $3"
    local search=$1
    local replace=$2
    local file=$3
    sed -i "" "s/${search}/${replace}/g" $file
}

# Copy template
if [ -z $LANGUAGE ]; then
  APP_LANGUAGE="node"
fi

if [ -z $APP_TYPE ]; then
 APP_TYPE="fullstack"
fi

SOURCE_PATH=./template/$APP_LANGUAGE/$APP_TYPE/
echo "Copying from $SOURCE_PATH to output dir..."
cp -r $SOURCE_PATH ./output/

# Replace occurences for files in subfolders
TARGET_DIR=./output
for directory in $(find $TARGET_DIR -type d);
  do
    echo "Found directory: $directory";
    if [ -d "$directory" ]; then
      for file in $(find $directory -type f);
      do
        echo "Found file: $file"
        if [ -f "$file" ]; then
          echo "Replacing known occurrences..."
          replaceOccurence __DOCKER_IMAGE_VERSION__ $DOCKER_IMAGE_VERSION $file
          replaceOccurence __DOCKER_IMAGE_NAME__ $DOCKER_IMAGE_NAME $file
          replaceOccurence __DOCKER_IMAGE_DESCRIPTION__ "$DOCKER_IMAGE_DESCRIPTION" $file
          replaceOccurence __DOCKER_IMAGE_MAINTAINER__ "$DOCKER_IMAGE_MAINTAINER" $file
          if [ -z $DOCKER_WORKDIR ]; then
            DOCKER_WORKDIR="\/var\/www\/deploy\/app\/"
          fi
          replaceOccurence __DOCKER_WORKDIR__ "$DOCKER_WORKDIR" $file
          replaceOccurence __DOCKER_PORT__ $DOCKER_PORT $file
        fi
      done
    fi
  done

echo "Fin."
