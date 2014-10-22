#!/bin/bash

git clone https://github.com/wikimedia/mediawiki.git
pushd mediawiki
    ln -s ../LocalSettings.php LocalSettings.php
    # install plugins and whatever
    git checkout 1.23.5
popd
