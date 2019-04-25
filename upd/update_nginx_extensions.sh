#!/bin/bash
source /etc/profile.d/vesta.sh
source /usr/local/vesta/func/main.sh

userlist=$(ls --sort=time $VESTA/data/users/)
for user in $userlist; do
    USER_DATA="$VESTA/data/users/$user"

    #UPDATE WEB
    conf="$USER_DATA/web.conf"
    while read line ; do
        eval $line
        
        extensions="jpeg,jpg,png,gif,bmp,ico,svg,tif,tiff,css,js,htm,html,ttf,otf,webp,woff,woff2,txt,csv,rtf,doc,docx,xls,xlsx,ppt,pptx,odf,odp,ods,odt,pdf,psd,ai,eot,eps,ps,zip,tar,tgz,gz,rar,bz2,7z,aac,m4a,mp3,mp4,ogg,wav,wma,3gp,avi,flv,m4v,mkv,mov,mp4,mpeg,mpg,wmv,exe,iso,dmg,swf"
        update_object_value 'web' 'DOMAIN' "$DOMAIN" '$PROXY_EXT' "$extensions"
    done < $conf
    
    $BIN/v-rebuild-user $user
done