#!/bin/sh
#
# assumption:
# mkdir /path
# chgrp groupname /path
# chmod 2770 /path
#
# example usage:
# create_git_repo.sh /git/techops/repo sso-admin@domain.tld

if [ "x" == "x$2" ]; then
    echo "usage: $0 /path/to/repo <email addr>"
    exit
fi

path=$1
email=$2
repo_name=`basename $path`

mkdir $path
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
