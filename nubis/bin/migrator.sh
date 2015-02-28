#!/bin/bash
#
# This script is run by the migrator instance on every ali change.
#+ This is the place to do things like database initilizations and migrations.
#

# TODO This script will move to packer to be baked into the image once the debugging is complete.

# Source the variables file put in place by confd
source /etc/nubis/mediawiki.sh

# Reset the database password on first run
if [ $db_password == 'provisioner_password' ]; then
    echo "Reset db password here"
fi

# Initilize the database if it is not already done
if [ `mysql -u -p -h mediawiki -e "show tables"` == 0 ];then
#echo -e "[client]\npassword=$DB_PASSWORD" > .DBPASSWORD
#cat $INSTALL_ROOT/maintenance/tables.sql | mysql --defaults-file=.DBPASSWORD --host=$DB_HOST --user=$DB_USER $DB_NAME
#rm -f .DBPASSWORD
fi

# Run the database migrations
#+ This command is safe to run multiple times
php /var/www/mediawiki/maintenance/update.php --quick



