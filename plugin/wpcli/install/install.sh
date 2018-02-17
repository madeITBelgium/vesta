#!/bin/bash
# info: install wp-cli plugin
# options: [RESTART]
#
# Install wp-cli plugin


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

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

$BIN/v-add-cron-job admin '27' '2' '1' '*' '*' "$VESTA/plugin/wpcli/bin/v-update-wpcli"

#----------------------------------------------------------#
#                       Vesta                              #
#----------------------------------------------------------#

exit 0
