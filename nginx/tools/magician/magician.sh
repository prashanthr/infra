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

function replaceOccurence {
    echo "Replacing $1 for $2 in $3"
    local search=$1
    local replace=$2
    local file=$3
    sed -i "" "s/${search}/${replace}/g" $file
}

function generateSiteConfig {
    siteCfg=$1
    _jq() {
        echo ${siteCfg} | jq -r ${1}
    }
    app_name=$(_jq '.name')
    app_dns=$(_jq '.dns')
    app_port=$(_jq '.port')
    app_https=$(_jq '.https')
    echo "Generating site config for: $app_name"
    
    mkdir -p $OUTPUT_PATH
    cp -r $SCRIPTS_PATH $OUTPUT_PATH
    mkdir -p $OUTPUT_PATH/config
    OUTPUT_FILE_PATH=$OUTPUT_PATH/config/$app_name.lua
    cp $TEMPLATE_PATH $OUTPUT_FILE_PATH
    
    replaceOccurence __SERVER_PORT__ $SERVER_PORT $OUTPUT_FILE_PATH
    replaceOccurence __APP_DNS_NAME__ $app_dns $OUTPUT_FILE_PATH
    replaceOccurence __APP_PORT__ $app_port $OUTPUT_FILE_PATH
}


echo "Generating magic from $APPS_CONFIG_PATH..."
for row in $(cat $APPS_CONFIG_PATH | jq -c '.[]'); do
  generateSiteConfig $row
done
