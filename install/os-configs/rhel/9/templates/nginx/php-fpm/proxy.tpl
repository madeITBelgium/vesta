server {
    listen      %ip%:%web_port%;
    server_name %domain_idn% %alias_idn%;
    access_log  /var/log/nginx/domains/%domain%.access.log combined;
    access_log  /var/log/nginx/domains/%domain%.bytes bytes;
    error_log   /var/log/nginx/domains/%domain%.error.log error;
    
    include     %home%/%user%/conf/web/nginx.%domain_idn%.conf_before*;

    location / {
        proxy_pass      %docroot%;
    }

    location @fallback {
        proxy_pass      %docroot%;
    }

    location ~ /\.ht    {return 404;}
    location ~ /\.svn/  {return 404;}
    location ~ /\.git/  {return 404;}
    location ~ /\.hg/   {return 404;}
    location ~ /\.bzr/  {return 404;}

    include %home%/%user%/conf/web/nginx.%domain%.conf*;
}

