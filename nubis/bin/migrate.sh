#!/bin/bash
#
# This script is run by the migrator instance on every ami change.
#+ This is the place to do things like database initilizations and migrations.
#
set -x
# TODO This should be passed in somehow.
INSTALL_ROOT='/var/www/mediawiki'

# Source the consul connection details from the metadata api
eval `ec2metadata --user-data`

echo "Environment: $NUBIS_ENVIRONMENT"
echo "Project: $NUBIS_PROJECT"

CONSUL="http://localhost:8500/v1/kv/$NUBIS_PROJECT/$NUBIS_ENVIRONMENT/config"

# We run early, so we need to account for Consul's startup time, unfortunately, magic isn't
# always free
CONSUL_UP=-1
while [ "$CONSUL_UP" != "0" ]; do
  QUERY=`curl -s http://localhost:8500/v1/kv/$NUBIS_PROJECT/$NUBIS_ENVIRONMENT/config?raw=1`
  CONSUL_UP=$?

  if [ "$QUERY" != "" ]; then
    CONSUL_UP=-2
  fi

  echo "Consul not ready yet ($CONSUL_UP), retrying..."
  sleep 1
done

# Generate and set the secrets for the app
wgDBpassword=`curl -s $CONSUL/wgDBpassword?raw=1`
if [ "$wgDBpassword" == "" ]; then
  wgDBpassword=`makepasswd --minchars=12 --maxchars=16`
  curl -s -X PUT -d $wgDBpassword $CONSUL/wgDBpassword
fi
echo " + wgSecretKey=$wgSecretKey"

wgSecretKey=`curl -s $CONSUL/wgSecretKey?raw=1`
if [ "$wgSecretKey" == "" ]; then
  wgSecretKey=`uuidgen`
  curl -s -X PUT -d $wgSecretKey $CONSUL/wgSecretKey 
fi
echo " + wgSecretKey=$wgSecretKey"

wgUpgradeKey=`curl -s $CONSUL/wgUpgradeKey?raw=1`
if [ "$wgUpgradeKey" == "" ]; then
  wgUpgradeKey=`uuidgen`
  curl -s -X PUT -d $wgUpgradeKey $CONSUL/wgUpgradeKey 
fi
echo " + wgUpgradeKey=$wgUpgradeKey"

# Grab the variables from consul
#source /etc/nubis-config/mediawiki.php
wgDBserver=`curl -s $CONSUL/wgDBserver?raw=1`
wgDBname=`curl -s $CONSUL/wgDBname?raw=1`
wgDBuser=`curl -s $CONSUL/wgDBuser?raw=1`

# Reset the database password on first run

# Create mysql defaults file
echo -e "[client]\npassword=$wgDBpassword\nhost=$wgDBserver\nuser=$wgDBuser" > .DB_DEFAULTS
# Test the current password
TEST_PASS=`mysql --defaults-file=.DB_DEFAULTS $wgDBname -e "show tables" 2>&1`
if [ `echo $TEST_PASS | grep -c 'ERROR 1045'` == 1 ]; then
    # Use the provisioner pasword to cange the password
    echo -e "[client]\npassword=provisioner_password\nhost=$wgDBserver\nuser=$wgDBuser" > .DB_DEFAULTS
    echo "Reseting db password"
    mysql --defaults-file=.DB_DEFAULTS $wgDBname -e "SET PASSWORD FOR '$wgDBuser'@'%' = password('$wgDBpassword')"
    if [ $? != 0 ]; then
        echo "ERROR: could not access mysql database"
        exit $RV
    fi
    # Rewrite defaults file with updated password
    echo -e "[client]\npassword=$wgDBpassword\nhost=$wgDBserver\nuser=$wgDBuser" > .DB_DEFAULTS
fi

# Initilize the database if it is not already done
if [ `mysql --defaults-file=.DB_DEFAULTS $wgDBname -e "show tables" | grep -c ^` == 0 ];then
    mysql --defaults-file=.DB_DEFAULTS $wgDBname < $INSTALL_ROOT/maintenance/tables.sql
fi

# Clean up
rm -f .DB_DEFAULTS

# Run the database migrations
#+ This command is safe to run multiple times
echo "Running database migrations"
php /var/www/mediawiki/maintenance/update.php --quick
