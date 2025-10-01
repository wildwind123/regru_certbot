#!/bin/bash
set -e

/renew.sh

rsync -azLe "ssh -i /home/host/.ssh/id_rsa" \
 --out-format="%n" \
 /home/host/projects/github/regru/data/etc/letsencrypt/live/host.ru/fullchain.pem \
 /home/host/projects/github/regru/data/etc/letsencrypt/live/host.ru/privkey.pem \
 root@host.ru:/root/projects/github/cert/_.host.ru/ | grep -q . && \
 ssh -i /home/host/.ssh/id_rsa root@host.ru "sudo /usr/sbin/nginx -s reload" && \
 echo "remote nginx reloaded"