#!/bin/bash

if [ -e "/usr/local/vesta/conf/sftp.backup.conf" ]; then
    source /usr/local/vesta/conf/sftp.backup.conf;
    
    if [ -z "$ROTATE" ];
    then
        echo "ROTATE='yes'" > /usr/local/vesta/conf/sftp.backup.conf
    fi
fi

if [ -e "/usr/local/vesta/conf/s3.backup.conf" ]; then
    source /usr/local/vesta/conf/s3.backup.conf;
    
    if [ -z "$ROTATE" ];
    then
        echo "ROTATE='yes'" > /usr/local/vesta/conf/s3.backup.conf
    fi
fi

if [ -e "/usr/local/vesta/conf/ftp.backup.conf" ]; then
    source /usr/local/vesta/conf/ftp.backup.conf;
    
    if [ -z "$ROTATE" ];
    then
        echo "ROTATE='yes'" > /usr/local/vesta/conf/ftp.backup.conf
    fi
fi

exit
