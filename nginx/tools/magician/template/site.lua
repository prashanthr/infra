server {
  listen        __SERVER_PORT__;
  server_name   __APP_DNS_NAME__;

  location / {
    proxy_pass  http://localhost:__APP_PORT__;
  }
}
