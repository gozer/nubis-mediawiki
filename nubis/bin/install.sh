#!/bin/bash
#
# TODO:
# All of the secrets stuff is just hacked in here right now this needs to be moved to Consul.
#+ The package installation stuff needs to move to puppet.
#+ Apache could use a cool script to interrigate Consul and we could get rid of the environment variables.
#+ The INSTALL_DIR is set in puppet and should be passed to this script or route through Consul.
#

#set -x

#INSTALL_ROOT='/var/www/mediawiki'
#DB_HOST='localhost'
#DB_NAME='mediawiki'
#DB_USER='mediawiki'
#DB_PASSWORD='yXzeXEic7vgeCYFN'
#DB_ROOT_PASSWORD='UboD3HBdi7qE9Edb'
#APP_SERVER_NAME='www.mediawiki.nubis.allizom.org'
#APP_SECRET_KEY='6d5790ff-90ca-4b7d-8699-e09f2cc6bccd'
#APP_UPGRADE_KEY='c832c4d8-2993-4d93-b56c-bb8e07ad04e8'

echo "Executing install.sh"

#sudo sh -c "echo \"PROVISION_app_db_server=$DB_HOST\\nPROVISION_db_name=$DB_NAME\\nPROVISION_db_username=$DB_USER\\nPROVISION_db_password=$DB_PASSWORD\\nPROVISION_db_root_password=$DB_ROOT_PASSWORD\\nPROVISION_app_server_name=$APP_SERVER_NAME\\nPROVISION_app_secret_key=$APP_SECRET_KEY\\nPROVISION_app_upgrade_key=$APP_UPGRADE_KEY\" >> /etc/environment"

#if [ `grep -c 'cat /etc/environment' /etc/apache2/envvars` != 1 ]; then
#    sudo sh -c "echo '\\nfor i in \`cat /etc/environment | grep \"^PROVISION\"\`; do export \$i ; done' >> /etc/apache2/envvars"
#fi

sudo aptitude -y install php-apc php5-gd php5-mysql makepasswd

#echo "Generating MySql tables."
#echo -e "[client]\npassword=$DB_PASSWORD" > .DBPASSWORD
#cat $INSTALL_ROOT/maintenance/tables.sql | mysql --defaults-file=.DBPASSWORD --host=$DB_HOST --user=$DB_USER $DB_NAME
#rm -f .DBPASSWORD

#echo "Updating MySql tables."
#for i in `cat /etc/environment | grep "^PROVISION"`; do export $i ; done
#php $INSTALL_ROOT/maintenance/update.php --quick
