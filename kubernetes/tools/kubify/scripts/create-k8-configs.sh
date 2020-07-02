#/bin/bash
function replaceOccurence {
    echo "Replacing $1 for $2 in $3"
    local search=$1
    local replace=$2
    local file=$3
    sed -i "" "s/${search}/${replace}/g" $file
}

# Copy template
cp -r ./template/ ./output/

# Replace occurences
TARGET_DIR=./output
for directory in $(find $TARGET_DIR -type d);
  do
    echo "Dir: $directory";
    if [ -d "$directory" ]; then
      for file in $(find $directory -type f);
      do
        echo "File: $file"
        if [ -f "$file" ]; then
          replaceOccurence __K8_APP_NAMESPACE__ $K8_APP_NAMESPACE $file
          replaceOccurence __K8_APP_NAME__ $K8_APP_NAME $file
          replaceOccurence __K8_APP_IMAGE__ "$K8_APP_IMAGE" $file
          replaceOccurence __K8_APP_PORT__ $K8_APP_PORT $file
        fi
      done
    fi
  done
