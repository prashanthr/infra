
#/bin/bash
echo "Copying app NGINX configs..."
CFG_PATH=./config
NGINX_PATH=/etc/nginx

cp -r $CFG_PATH/*.lua $NGINX_PATH/sites-available
for cfgFile in $CFG_PATH; do
  sudo ln -s $NGINX_PATH/sites-available/$cfgFile $NGINX_PATH/sites-enabled/
done
