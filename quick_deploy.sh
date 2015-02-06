#!/bin/sh

function die { echo Dying: $@; exit 1; }

REPO=git@github.com:ifsmirnov/dotrc.git
which git >/dev/null || die Git not found

echo conf=$CONFIG_DIR
if test -z "$CONFIG_DIR"; then
    CONFIG_DIR=~/config
fi

mkdir -p $CONFIG_DIR && rm -rf $CONFIG_DIR || Die Cannot initialize directory for cloning
echo Cloning into $CONFIG_DIR

git clone $REPO $CONFIG_DIR || die Cannot checkout repository into directory $DIR
echo Cloned OK

cd $CONFIG_DIR
./deploy.sh || die Cannot run deploy

echo Done deploying, quitting
