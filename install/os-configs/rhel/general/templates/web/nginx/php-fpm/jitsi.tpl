server {
    listen      %ip%:%web_port%;
    server_name %domain_idn% %alias_idn%;
    access_log  /var/log/nginx/domains/%domain%.access.log combined;
    access_log  /var/log/nginx/domains/%domain%.bytes bytes;
    error_log   /var/log/nginx/domains/%domain%.error.log error;
    
    include     %home%/%user%/conf/web/nginx.%domain_idn%.conf_before*;


   location / {
            ssi on;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $http_host;

            proxy_pass http://193.58.112.138:8000/;

            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
    }

    location ~ ^/(?!(http-bind|external_api\.|xmpp-websocket))([a-zA-Z0-9=_äÄöÖüÜß\?\-]+)$ {
            rewrite ^/(.*)$ / break;
    }
    # BOSH
    location /http-bind {
            proxy_pass      http://193.58.112.138:5280/http-bind;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header Host $http_host;
    }
    # xmpp websockets
    location /xmpp-websocket {
            proxy_pass http://193.58.112.138:5280/xmpp-websocket;
            proxy_http_version      1.1;
            proxy_set_header        Upgrade $http_upgrade;
            proxy_set_header        Connection "upgrade";
            proxy_set_header        Host $host;
            tcp_nodelay             on;
    }

    location @fallback {
        proxy_pass      http://193.58.112.138:8000;
    }

    location ~ /\.ht    {return 404;}
    location ~ /\.svn/  {return 404;}
    location ~ /\.git/  {return 404;}
    location ~ /\.hg/   {return 404;}
    location ~ /\.bzr/  {return 404;}

    include %home%/%user%/conf/web/nginx.%domain%.conf*;
}

