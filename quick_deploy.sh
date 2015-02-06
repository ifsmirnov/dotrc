#!/bin/sh

function die { echo Dying: $@; exit 1; }

REPO=https://github.com/ifsmirnov/dotrc.git
which git || die Git not found

DIR=$1
if test -z $DIR; then
    DIR=~/config
fi

git clone $REPO $DIR || Cannot checkout repository into directory $DIR

$DIR/deploy.sh
