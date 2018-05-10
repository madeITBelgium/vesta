#!/bin/bash
source /etc/profile.d/vesta.sh
source /usr/local/vesta/func/main.sh

touch $VESTA/conf/plugin.conf
#if [ -z "$(grep "'hello-world'" $VESTA/conf/plugin.conf)" ]; then
#    echo "PLUGIN='hello-world' NAME='Hello World' VERSION='1.0.0' BUILDNUMBER='1' LATEST_VERSION='1.0.0' LATEST_BUILDNUMBER='1' KEY='' ACTIVE='no' TIME='22:28:00' DATE='2017-09-23'" >> $VESTA/conf/plugin.conf 
#fi
#if [ -z "$(grep "'monitor'" $VESTA/conf/plugin.conf)" ]; then
#    echo "PLUGIN='monitor' NAME='Monitor' VERSION='1.0.0' BUILDNUMBER='1' LATEST_VERSION='1.0.0' LATEST_BUILDNUMBER='1' KEY='' ACTIVE='no' TIME='21:59:00' DATE='2017-10-09'" >> $VESTA/conf/plugin.conf 
#fi
#if [ -z "$(grep "'monitor-dashboard'" $VESTA/conf/plugin.conf)" ]; then
#    echo "PLUGIN='monitor-dashboard' NAME='Monitor Dashboard' VERSION='1.0.0' BUILDNUMBER='1' LATEST_VERSION='1.0.0' LATEST_BUILDNUMBER='1' KEY='' ACTIVE='no' TIME='21:59:00' DATE='2017-10-09'" >> $VESTA/conf/plugin.conf 
#fi
#if [ -z "$(grep "'monitor-log'" $VESTA/conf/plugin.conf)" ]; then
#    echo "PLUGIN='monitor-log' NAME='Log monitor' VERSION='1.0.0' BUILDNUMBER='1' LATEST_VERSION='1.0.0' LATEST_BUILDNUMBER='1' KEY='' ACTIVE='no' TIME='22:00:00' DATE='2017-10-29'" >> $VESTA/conf/plugin.conf 
#fi
#if [ -z "$(grep "'monitor-log-dashboard'" $VESTA/conf/plugin.conf)" ]; then
#    echo "PLUGIN='monitor-log-dashboard' NAME='Log dashboard monitor' VERSION='1.0.0' BUILDNUMBER='1' LATEST_VERSION='1.0.0' LATEST_BUILDNUMBER='1' KEY='' ACTIVE='no' TIME='22:00:00' DATE='2017-10-29'" >> $VESTA/conf/plugin.conf 
#fi
#if [ -z "$(grep "'nodejs'" $VESTA/conf/plugin.conf)" ]; then
#    echo "PLUGIN='nodejs' NAME='Node.JS' VERSION='1.0.0' BUILDNUMBER='1' LATEST_VERSION='1.0.0' LATEST_BUILDNUMBER='1' KEY='' ACTIVE='no' TIME='22:00:00' DATE='2018-02-17'" >> $VESTA/conf/plugin.conf 
#fi
#if [ -z "$(grep "'wpcli'" $VESTA/conf/plugin.conf)" ]; then
#    echo "PLUGIN='wpcli' NAME='WP-CLI' VERSION='1.0.0' BUILDNUMBER='1' LATEST_VERSION='1.0.0' LATEST_BUILDNUMBER='1' KEY='' ACTIVE='no' TIME='22:00:00' DATE='2018-02-17'" >> $VESTA/conf/plugin.conf 
#fi