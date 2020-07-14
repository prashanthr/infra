#/bin/bash
# Example usage
# cd ./kubernetes/tools/kubify
# 
# K8_APP_NAMESPACE=namespace \
# K8_APP_NAME=test \
# K8_APP_PORT=7000 \
# K8_APP_IMAGE="hello\/hello" \
# ./scripts/kubify.sh

# K8_APP_SSL=TRUE \
# K8_APP_NAMESPACE=namespace \
# K8_APP_NAME=test \
# K8_APP_PORT=7000 \
# K8_APP_IMAGE="hello\/hello" \
# ./scripts/kubify.sh

function replaceOccurence {
    echo "Replacing $1 for $2 in $3"
    local search=$1
    local replace=$2
    local file=$3
    sed -i "" "s/${search}/${replace}/g" $file
}

# Copy template
echo "Copying from template to output dir..."
cp -r ./template/ ./output/

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
          replaceOccurence __K8_APP_NAMESPACE__ $K8_APP_NAMESPACE $file
          replaceOccurence __K8_APP_NAME__ $K8_APP_NAME $file
          replaceOccurence __K8_APP_IMAGE__ "$K8_APP_IMAGE" $file
          replaceOccurence __K8_APP_PORT__ $K8_APP_PORT $file
          if [[ $K8_APP_SSL == "TRUE" ]]; then
            replaceOccurence "  #" " " $file
          fi
        fi
      done
    fi
  done

echo "Fin."
