#/bin/bash
function NGINX_STATUS {
  sudo service nginx status
}
function NGINX_RELOAD {
  sudo service nginx reload
}
function NGINX_RESTART {
  sudo service nginx restart
}

NGINX_STATUS
NGINX_RELOAD
NGINX_RESTART && NGINX_STATUS

