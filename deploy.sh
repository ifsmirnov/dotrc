#!/bin/sh

special="bin|ssh_config|deploy.sh"
rc=`\
    find . -mindepth 1 -maxdepth 1\
    | egrep -v "$special|*.swp"\
    | sed "s:^./::g"\
    | sort`

echo "Making symlinks for .rc files"
for f in $rc; do
    echo "  "$f
    ln -sf ~/config/$f ~/.$f
done

echo Proceeding special files
if test -d ~/bin ; then
    echo "  "Error: ~/bin directory exists. Please consider it manually.
else
    echo "  "~/bin
    ln -sf ~/config/bin ~/bin
fi


if ! test -d ~/.ssh  ; then
    echo Create ~/.ssh directory
    mkdir ~/.ssh
    chmod 700 .ssh
fi

echo "  ".ssh/config
ln -sf ~/config/ssh_config ~/.ssh/config

echo Done
