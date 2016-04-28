#!/bin/sh
#
# cd /path/to/new/repo
# git init --bare
# /path/to/setup_git_repo.sh "description" email

if [ "x" == "x$2" ]; then
    echo "usage: $0 \"description\" <email addr>"
    exit
fi

desc=$1
email=$2

if [ `whoami` != "root" ]; then
    echo "run as root!"
    exit
fi

umask 002

chmod 2770 .
ln -s /usr/share/git-core/contrib/hooks/post-receive-email hooks/post-receive
echo $desc > description
git config hooks.mailinglist $email
git config hooks.emailprefix "[git] "
git config core.sharedRepository true