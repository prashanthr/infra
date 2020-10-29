server {
  listen 9005 default_server;

  server_name demo.site;
  root /var/www/deploy/app/build;

  location / {
      proxy_pass http://localhost:9000;
      #proxy_http_version 1.1;
      #proxy_set_header Upgrade $http_upgrade;
      #proxy_set_header Connection 'upgrade';
      #proxy_set_header Host $host;
      #proxy_cache_bypass $http_upgrade;
  }

  location ^~ /.well-known/acme-challenge/ {
    allow all;
    default_type "text/plain";
    root  /var/www/deploy/app/build;
  }

  # Hide /acme-challenge subdirectory and return 404 on all requests.
  # It is somewhat more secure than letting Nginx return 403.
  # Ending slash is important!
  location = /.well-known/acme-challenge/ {
      return 404;
  }
}
