server {
  listen        __SERVER_PORT__;
  #listen        __SERVER_PORT_HTTPS__;
  server_name   __APP_DNS_NAME__;

  location / {
    proxy_pass  http://localhost:__APP_PORT__;
  }
}
