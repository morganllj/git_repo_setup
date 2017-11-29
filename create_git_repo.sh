#!/bin/sh
#
# example usage:
# create_git_repo.sh groupname /git/techops/repo sso-admin@domain.tld

if [ "x" == "x$2" ]; then
    echo "usage: $0 groupname /path/to/repo <email addr>"
    exit
fi

group=$1
path=$2
email=$3
repo_name=`basename $path`
umask 002

mkdir $path
chgrp $group $path
chmod 2770 $path

if [ $? -ne 0 ]; then
    exit
fi

cd $path
git init --bare

ln -s /usr/local/share/git-core/contrib/hooks/git_multimail.py hooks/post-receive
git config multimailhook.commitlist ''
git config multimailhook.emailprefix "[git] ${repo_name} "
git config multimailhook.mailingList $email
git config core.sharedRepository true
