#!/bin/bash

set -x
set -e

if [[ -z $1 ]] || [[ -z $2 ]] || [[ -z $3 ]]; then
    echo "USAGE: setupdb.sh <sql-dump-file> <user-name> <webserver-ip>"
    exit 1
fi
db_file=$(basename $1)
SSH_OPTIONS="-o StrictHostKeyChecking=no"
scp $SSH_OPTIONS $1 $2@$3:/tmp/
ssh $SSH_OPTIONS $2@$3 'bash -c "source /etc/environment && \
    mysql -h$PROVISION_app_db_server --user=$PROVISION_db_username --password=$PROVISION_db_password --database=$PROVISION_db_name < /tmp/'$db_file'"'
ssh $SSH_OPTIONS $2@$3 service apache2 graceful
