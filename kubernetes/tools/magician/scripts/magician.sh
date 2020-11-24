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
  mkdir -p $OUTPUT_PATH/config
  cp -r $SCRIPTS_PATH/ $OUTPUT_PATH/scripts
  # Only copy files that don't need replacements
  cp $TEMPLATE_PATH/nginx.yaml $OUTPUT_PATH/config
  # For files that need replacements, copy and replace
  cp $TEMPLATE_PATH/namespace.yaml $OUTPUT_PATH/config
  cp $TEMPLATE_PATH/secrets.yaml $OUTPUT_PATH/config
  replaceOccurence __K8_APP_NAMESPACE__ $K8_APP_NAMESPACE $OUTPUT_PATH/config/namespace.yaml
  replaceOccurence __K8_APP_NAMESPACE__ $K8_APP_NAMESPACE $OUTPUT_PATH/config/secrets.yaml
}

function generateSiteConfig {
  echo "Generating configs..."
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

function handleDeployment {
  echo "Creating custom app deployment file..."
  deployment_file=$OUTPUT_PATH/config/deployment.yaml
  cat $TEMPLATE_PATH/deployment-header.yaml >> $deployment_file
  for file in $OUTPUT_PATH/config/*-deployment-container.yaml; 
    do
      cat $file >> $deployment_file
    done
  cat $TEMPLATE_PATH/deployment-footer.yaml >> $deployment_file
  replaceOccurence __K8_APP_NAMESPACE__ $K8_APP_NAMESPACE $deployment_file
  replaceOccurence __K8_APP_NAME__ $app_name $deployment_file
  replaceOccurence __K8_APP_IMAGE__ $app_image $deployment_file
  replaceOccurence __K8_APP_PORT__ $app_port $deployment_file
  replaceOccurence __K8_APP_HOST_PORT__ $host_port $deployment_file
  replaceOccurence __K8_DOCKER_APP_NAME__ $K8_DOCKER_APP_NAME $deployment_file
  replaceOccurence __K8_DOCKER_APP_DNS__ $app_dns $deployment_file
}

function handleDeploymentSecrets {
   echo "Handling secrets..."
    siteCfg=$1
    local app_name=$(echo "$siteCfg" | jq -r '.name')
    local app_secrets=$(echo "$siteCfg" | jq '.envSecrets')
    local secrets_length=$(echo "$siteCfg" | jq '.envSecrets | keys | length')
    local target_deployment_file=$OUTPUT_PATH/config/${app_name}-deployment-container.yaml
    if [[ $secrets_length != "0" ]]; then
      echo "$app_name has $secrets_length secrets"
      echo "$siteCfg" | jq -r '.envSecrets | to_entries | map(.key + "|" + (.value | tostring)) | .[]' | \
        while IFS='|' read key value; do
          secret_file_name=deployment-container-secrets.yaml
          target_secret_file=$OUTPUT_PATH/config/${app_name}-$secret_file_name
          cp $TEMPLATE_PATH/$secret_file_name $target_secret_file
          replaceOccurence __K8_APP_SECRET_ENV_NAME__ $key $target_secret_file
          replaceOccurence __K8_APP_SECRET_KEY__ $value $target_secret_file
          cat $target_secret_file >> $target_deployment_file
          rm $target_secret_file
        done
      local docker_env=$(echo "$siteCfg" | jq -r '.envSecrets | to_entries|map("-e \(.key)=\(.key) ")|.[]')
      docker_env=${docker_env//[$'\r\n']} # remove newlines
      replaceOccurence __K8_APP_ENV__ "$docker_env" $target_deployment_file
    else 
      echo "$app_name has no secrets"
      replaceOccurence __K8_APP_ENV__ '' $target_deployment_file
    fi
}

function cleanup {
  echo "Cleaning up..."
  mkdir -p $OUTPUT_PATH/config/deployment
  mkdir -p $OUTPUT_PATH/config/service
  mkdir -p $OUTPUT_PATH/config/ingress
  mv $OUTPUT_PATH/config/deployment.yaml $OUTPUT_PATH/config/deployment
  mv $OUTPUT_PATH/config/*-service.yaml $OUTPUT_PATH/config/service
  mv $OUTPUT_PATH/config/*-ingress.yaml $OUTPUT_PATH/config/ingress
  rm $OUTPUT_PATH/config/*-deployment-container.yaml
}

function parseConfig {
  echo "Generating magic from $APPS_CONFIG_PATH..."
  local num_apps=$(cat $APPS_CONFIG_PATH | jq -r '. | length')
  echo -e "Found $num_apps apps\n"
  for row in $(cat $APPS_CONFIG_PATH | jq -c '.[]'); do
    generateSiteConfig $row
    handleDeploymentSecrets $row
    echo -e "\n"
  done
  handleDeployment
}

function hello {
  echo "Welcome to magician! 🎩"
}

function fin {
  echo "Your apps are ready to be deployed! Find your config files and scripts in the output folder."
  echo "Onward and upwards 🚀"
}

# Order of ops
hello
setup
parseConfig
cleanup
fin
