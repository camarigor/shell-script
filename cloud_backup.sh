#!/bin/bash

#you will need SSH Key-Based Authentication                                                          
#conf files backup
tar czpf /home/user/conf-`date +%Y_%m_%d`$.tgz /etc/postfix /etc/httpd /etc/foo

#mysql backup
mysqldump -u backup -pPASSWD --all-databases > db-`date +%Y_%m_%d`$.sql

tar czpf db-`date +%Y_%m_%d`$.tgz db-`date +%Y_%m_%d`$.sql

rm -fr db-`date +%Y_%m_%d`$.sql

#postfix users mailbox backup
tar czpf mail-`date +%Y_%m_%d`$.tgz /var/spool/mail/vhost/foo

#backup http files
tar czpf http-`date +%Y_%m_%d`$.tgz /srv/http /home/user/foo

#rsync into storage
rsync -Cravzp -e 'ssh -p 22' *-`date +%Y_%m_%d`$.tgz user@192.168.0.2:/mnt/backup/foo

rm -fr *-`date +%Y_%m_%d`.tgz

exit
