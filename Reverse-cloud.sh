#!/bin/bash

# installera nginx
apt update && apt install nginx -y

# Ta bort gammal konfig
rm /etc/nginx/sites-available/default

# Skapa ny konfig
cat <<EOF > /etc/nginx/sites-available/default
server {
  listen        80 default_server;

  location / {
    proxy_pass         http://10.0.0.15:5000/;
    proxy_http_version 1.1;
    proxy_set_header   Upgrade '$http_upgrade';
    proxy_set_header   Connection "keep-alive";
    proxy_set_header   Host '$host';
    proxy_cache_bypass '$http_upgrade';
    proxy_set_header   X-Forwarded-For '$proxy_add_x_forwarded_for';
    proxy_set_header   X-Forwarded-Proto '$scheme';
  }
}
EOF

# Reloada nginx
systemctl reload nginx

# Sätt på automatisk start vid omstart
systemctl enable nginx