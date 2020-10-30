#/bin/bash
alias NGINX_STATUS='sudo service nginx status'
alias NGINX_RELOAD='sudo service nginx reload'
alias NGINX_RESTART='sudo service nginx restart'

NGINX_STATUS
NGINX_RELOAD
NGINX_RESTART && NGINX_STATUS

