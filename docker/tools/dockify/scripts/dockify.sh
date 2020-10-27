
#/bin/bash
function replaceOccurence {
    echo "Replacing $1 for $2 in $3"
    local search=$1
    local replace=$2
    local file=$3
    sed -i "" "s/${search}/${replace}/g" $file
}

# Copy template
if [ -z $APP_LANGUAGE ]; then
  APP_LANGUAGE="node"
fi

if [ -z $APP_TYPE ]; then
 APP_TYPE="fullstack"
fi

if [ -z $APP_NAME ]; then
 APP_NAME="demo-app"
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
          replaceOccurence __DOCKER_APP_NAME__ $APP_NAME $file
        fi
      done
    fi
  done

echo "Fin."
