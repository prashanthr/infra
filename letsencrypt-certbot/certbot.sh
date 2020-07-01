#/bin/bash
certbot --authenticator webroot --installer nginx -n --agree-tos --redirect --staging -d $DOMAIN --email $EMAIL --webroot-path $WEB_ROOT_PATH