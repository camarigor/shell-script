#!/bin/bash

#you will need SSH Key-Based Authentication

#compressing files
sudo tar czpf /home/user/foo-`date +%Y_%m_%d`$.tgz /etc/foo/bar /home/user/foo 

#encrypting whit gpg
gpg -e -r email@email.com /home/user/*.tgz

rsync -Cravzp -e 'ssh -p 22' /home/user/*.tgz.gpg user@192.168.0.2:/mnt/backup/

rm -fr *.tgz *.tgz.gpg

exit
