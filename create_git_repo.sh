#!/bin/sh
#

git_dir=/git

if [ "x" == "x$3" ]; then
    echo "usage: $0 <group name> <repo name> <repo description>"
    exit
fi

group=$1
repo=$2
desc=$3

if [ `whoami` != "root" ]; then
    echo "run as root!"
    exit
fi

if [ `getent group|cut -d: -f1|egrep "^${group}$"` != "$1" ]; then
    echo $group is not a valid unix group
    exit
fi

umask 002
cd /git
if [ -d $group ]; then
    cd $group
fi

mkdir $repo
chgrp $group $repo
chmod 2770 $repo

cd $repo
git --bare init
ln -s /usr/share/git-core/contrib/hooks/post-receive-email hooks/post-receive
echo $desc > description
git config hooks.mailinglist ldap-admin@philasd.org
git config hooks.emailprefix "[git] "
git repo-config core.sharedRepository true