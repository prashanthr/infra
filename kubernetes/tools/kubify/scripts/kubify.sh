#/bin/bash
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
