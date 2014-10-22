#!/bin/bash

grep '. /etc/environment' /etc/apache2/envvars

if [ $? -eq 1 ]; then
        echo '. /etc/environment' >> /etc/apache2/envvars
fi

git clone https://github.com/wikimedia/mediawiki.git
pushd mediawiki
    ln -s ../LocalSettings.php LocalSettings.php
    # install plugins and whatever
    git checkout 1.23.5
popd

service apache2 restart

