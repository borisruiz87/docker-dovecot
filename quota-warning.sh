#!/bin/sh
PERCENT=$1
USER=$2
cat << EOF | /usr/libexec/dovecot/dovecot-lda -d $USER -o "plugin/quota=count:User quota:noenforcing"
From: admin@othar.cu
Subject: quota warning

Your mailbox is now $PERCENT% full.
EOF