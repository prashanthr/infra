
#/bin/bash
CFG_PATH=./config
NGINX_PATH=/etc/nginx
SITES_AVAILABLE_PATH=$NGINX_PATH/sites-available
SITES_ENABLED_PATH=$NGINX_PATH/sites-enabled
echo "Copying app NGINX configs to $SITES_AVAILABLE_PATH..."
cp -r $CFG_PATH/*.lua $SITES_AVAILABLE_PATH
for cfgFile in $CFG_PATH/*.lua; do
  echo "Creating symlink for $SITES_AVAILABLE_PATH/$cfgFile at $SITES_ENABLED_PATH/$cfgFile..."
  sudo ln -s $SITES_AVAILABLE_PATH/$cfgFile $SITES_ENABLED_PATH/$cfgFile
done
