#!/bin/bash
if [ -z $APPS_CONFIG_PATH ]; then
  APPS_CONFIG_PATH=./config/apps.json
fi

if [ -z $TEMPLATE_PATH ]; then
  TEMPLATE_PATH=./template/command.txt
fi

if [ -z $SCRIPTS_PATH ]; then
    SCRIPTS_PATH=./template/scripts
fi

if [ -z $OUTPUT_PATH ]; then
    OUTPUT_PATH=./output
fi

function replaceOccurence {
    # echo "Replacing $1 for $2 in $3"
    local search=$1
    local replace=$2
    local file=$3
    sed -i "" "s/${search}/${replace}/g" $file
}

function setup {
  echo "Setting things up..."
  rm -rf $OUTPUT_PATH/
  mkdir -p $OUTPUT_PATH/scripts
  cp -r $SCRIPTS_PATH/ $OUTPUT_PATH/scripts
}

function generateSiteConfig {
  echo "Generating configs..."
    siteCfg=$1
    _jq() {
        echo ${siteCfg} | jq -r ${1}
    }
    app_name=$(_jq '.name')
    app_namespace=$(_jq '.namespace')
    app_deployment_name=$(_jq '.deploymentName')
    
    echo "Generating site cmd for app: $app_name"

    local TARGET_FILE=$OUTPUT_PATH/scripts/patch-apps.sh
    cat $TEMPLATE_PATH >> $TARGET_FILE
    replaceOccurence __K8_APP_NAMESPACE__ $app_namespace $TARGET_FILE
    replaceOccurence __K8_APP_NAME__ $app_deployment_name $TARGET_FILE
}

function cleanup {
  echo "Cleaning up..."
}

function parseConfig {
  echo "Generating script for apps from $APPS_CONFIG_PATH..."
  for row in $(cat $APPS_CONFIG_PATH | jq -c '.[]'); do
    generateSiteConfig $row
  done
}

function hello {
  echo "Welcome to patchy! 🩹"
}

function fin {
  echo "Your apps are ready to be patched! Find your scripts in the output folder."
  echo "Onward and upwards 🚀"
}

# Order of ops
hello
setup
parseConfig
cleanup
fin
