#/bin/bash
if [ -z $APPS_CONFIG_PATH ]; then
  APPS_CONFIG_PATH=./config/apps.json
fi

if [ -z $TEMPLATE_PATH ]; then
  TEMPLATE_PATH=./template/config
fi

if [ -z $SCRIPTS_PATH ]; then
    SCRIPTS_PATH=./template/scripts
fi

if [ -z $OUTPUT_PATH ]; then
    OUTPUT_PATH=./output
fi

function replaceOccurence {
    echo "Replacing $1 for $2 in $3"
    local search=$1
    local replace=$2
    local file=$3
    sed -i "" "s/${search}/${replace}/g" $file
}

function setup {
  rm -rf $OUTPUT_PATH/
  mkdir -p $OUTPUT_PATH/scripts
  mkdir -p $OUTPUT_PATH/config
  cp -r $SCRIPTS_PATH $OUTPUT_PATH/scripts
  # Only copy files that don't need replacements
  cp $TEMPLATE_PATH/nginx.yaml $OUTPUT_PATH/config
  # Handle namespace
  cp $TEMPLATE_PATH/namespace.yaml $OUTPUT_PATH/config
  replaceOccurence __K8_APP_NAMESPACE__ $K8_APP_NAMESPACE $OUTPUT_PATH/config/namespace.yaml
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
    app_port=$(_jq '.port')
    app_image=$(_jq '.image')
    
    echo "Generating site config for app: $app_name"
    
    filelist="deployment-container.yaml service.yaml ingress.yaml"
    for f in $filelist; 
      do
        echo "Found file: $file"
        file=$OUTPUT_PATH/config/${app_name}-$f
        cp $TEMPLATE_PATH/$f $file
        if [ -f "$file" ]; then
          replaceOccurence __K8_APP_NAMESPACE__ $K8_APP_NAMESPACE $file
          replaceOccurence __K8_APP_NAME__ $app_name $file
          replaceOccurence __K8_APP_IMAGE__ $app_image $file
          replaceOccurence __K8_APP_PORT__ $app_port $file
          replaceOccurence __K8_APP_HOST_PORT__ $host_port $file
          replaceOccurence __K8_DOCKER_APP_NAME__ $K8_DOCKER_APP_NAME $file
          replaceOccurence __K8_APP_DNS__ $app_dns $file
        fi
      done
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

  echo "Generating site docker cmd for app: $app_name"
  echo -e "echo \"Running $app_name...\"" >> $APP_SETUP_SCRIPT_OUTPUT_PATH
  echo "docker rm $app_name" >> $APP_SETUP_SCRIPT_OUTPUT_PATH
  echo "docker run --publish $host_port:$app_port --detach --name $app_name $app_image" >> $APP_SETUP_SCRIPT_OUTPUT_PATH
}

function handleContainers {
   deployment_file=$OUTPUT_PATH/config/deployment.yaml
   cp $TEMPLATE_PATH/deployment.yaml $deployment_file
   replaceOccurence __K8_APP_NAMESPACE__ $K8_APP_NAMESPACE $deployment_file
   replaceOccurence __K8_APP_NAME__ $app_name $deployment_file
   replaceOccurence __K8_APP_IMAGE__ $app_image $deployment_file
   replaceOccurence __K8_APP_PORT__ $app_port $deployment_file
   replaceOccurence __K8_APP_HOST_PORT__ $host_port $deployment_file
   replaceOccurence __K8_DOCKER_APP_NAME__ $K8_APP_DOCKER_NAME $deployment_file
   replaceOccurence __K8_DOCKER_APP_DNS__ $app_dns $deployment_file
   CONTAINERS=$(cat $OUTPUT_PATH/config/*-deployment-container.yaml | sed ':a;N;$!ba;s/\n/\\n/g')
   echo "CONTAINERS: "$CONTAINERS
   replaceOccurence __K8_APP_CONTAINERS__ "$CONTAINERS" $deployment_file
}

function cleanup {
  mkdir -p $OUTPUT_PATH/config/deployment
  mkdir -p $OUTPUT_PATH/config/service
  mkdir -p $OUTPUT_PATH/config/ingress
  mv $OUTPUT_PATH/config/deployment.yaml $OUTPUT_PATH/config/deployment
  mv $OUTPUT_PATH/config/*-service.yaml $OUTPUT_PATH/config/service
  mv $OUTPUT_PATH/config/*-ingress.yaml $OUTPUT_PATH/config/ingress
  # rm $OUTPUT_PATH/*-deployment-container.yaml
}

function parseConfig {
  echo "Generating magic from $APPS_CONFIG_PATH..."
  for row in $(cat $APPS_CONFIG_PATH | jq -c '.[]'); do
    generateSiteConfig $row
  done
  handleContainers
}

function hello {
  echo "Welcome to magician! 🎩"
}

function fin {
  echo "For brand new installations, run the ./scripts/playbook.sh script on the target machine and you're good to go!"
  echo "For patching/updating/adding apps, run ./scripts/install-apps.sh && ./scripts/boot-nginx.sh script on the target machine and you're good to go!"
}

# Order of ops
hello
setup
parseConfig
cleanup
fin
