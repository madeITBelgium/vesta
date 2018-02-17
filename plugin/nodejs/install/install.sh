#!/bin/bash
# info: install nodejs plugin
# options: [RESTART]
#
# Install nodejs plugin


#----------------------------------------------------------#
#                    Variable&Function                     #
#----------------------------------------------------------#

# Argument definition
restart="${1-yes}"

# Includes
source $VESTA/func/main.sh

# Additional argument formatting

#----------------------------------------------------------#
#                    Verifications                         #
#----------------------------------------------------------#
check_args '0' "$#" '[RESTART]'


#----------------------------------------------------------#
#                       Action                             #
#----------------------------------------------------------#

curl --silent --location https://rpm.nodesource.com/setup_9.x | sudo bash -
sudo yum -y install nodejs

#----------------------------------------------------------#
#                       Vesta                              #
#----------------------------------------------------------#

exit $RESULT
