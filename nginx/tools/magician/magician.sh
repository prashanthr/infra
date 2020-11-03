#/bin/bash
if [ -z $APPS_CONFIG_PATH ]; then
  APPS_CONFIG_PATH=./config/apps.json
fi

if [ -z $TEMPLATE_PATH ]; then
  TEMPLATE_PATH=./template/site.lua
fi

if [ -z $OUTPUT_PATH ]; then
  OUTPUT_PATH=./output
fi

if [ -z $SERVER_PORT ]; then
  SERVER_PORT=80
fi

if [ -z $SCRIPTS_PATH ]; then
  SCRIPTS_PATH=./scripts
fi

if [ -z $APP_DOCKER_OUTPUT_PATH ]; then
  APP_DOCKER_OUTPUT_PATH=$OUTPUT_PATH/scripts/setup-apps.sh
fi

function replaceOccurence {
    echo "Replacing $1 for $2 in $3"
    local search=$1
    local replace=$2
    local file=$3
    sed -i "" "s/${search}/${replace}/g" $file
}

function setup {
  echo "Setting up..."
  rm -rf $OUTPUT_PATH
  mkdir -p $OUTPUT_PATH
  cp -r $SCRIPTS_PATH $OUTPUT_PATH
  mkdir -p $OUTPUT_PATH/config
}

function generateSiteConfig {
    siteCfg=$1
    _jq() {
        echo ${siteCfg} | jq -r ${1}
    }
    app_name=$(_jq '.name')
    app_dns=$(_jq '.dns')
    host_port=$(_jq '.hostPort')
    app_https=$(_jq '.https')
    
    echo "Generating site config for: $app_name"
    
    OUTPUT_FILE_PATH=$OUTPUT_PATH/config/$app_name.lua
    cp $TEMPLATE_PATH $OUTPUT_FILE_PATH
    
    replaceOccurence __SERVER_PORT__ $SERVER_PORT $OUTPUT_FILE_PATH
    replaceOccurence __APP_DNS_NAME__ $app_dns $OUTPUT_FILE_PATH
    replaceOccurence __APP_PORT__ $host_port $OUTPUT_FILE_PATH
    replaceOccurence __SERVER_PORT_HTTPS__ 443 $OUTPUT_FILE_PATH
    if [ $app_https = "true" ]; then
      replaceOccurence '#' '' $OUTPUT_FILE_PATH
    fi
}

function generateSiteDockerScript {
  siteCfg=$1
  _jq() {
      echo ${siteCfg} | jq -r ${1}
  }
  app_name=$(_jq '.name')
  app_image=$(_jq '.image')
  app_port=$(_jq '.port')
  host_port=$(_jq '.hostPort')

  echo "Generating site docker cmd for: $app_name"
  echo -e "echo \"Running $app_name...\"" >> $APP_DOCKER_OUTPUT_PATH
  echo "docker rm $app_name" >> $APP_DOCKER_OUTPUT_PATH
  echo "docker run --publish $host_port:$app_port --detach --name $app_name $app_image" >> $APP_DOCKER_OUTPUT_PATH
}

setup
echo "Generating magic from $APPS_CONFIG_PATH..."
for row in $(cat $APPS_CONFIG_PATH | jq -c '.[]'); do
  generateSiteConfig $row
  generateSiteDockerScript $row
done

echo "For brand new installations, run the ./scripts/playbook.sh script on the target machine and you're good to go!"
echo "For patching/updating/adding apps, run ./scripts/install-apps.sh && ./scripts/boot-nginx.sh script on the target machine and you're good to go!"
