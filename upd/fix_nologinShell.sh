#!/bin/bash

# Register /sbin/nologin and /usr/sbin/nologin
if [ "$(grep /sbin/nologin /etc/shells)" = "" ]; then
    echo "/sbin/nologin" >> /etc/shells
 fi
 
if [ "$(grep /usr/sbin/nologin /etc/shells)" = "" ]; then
    echo "/usr/sbin/nologin" >> /etc/shells
 fi