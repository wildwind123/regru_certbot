# regru_certbot

## generate cert

```
docker compose up
```

## renew cert

```bash
docker compose -f docker-compose-renew.yaml up
```


## cert path

```
data/etc/letsencrypt/
data/etc/letsencrypt/
```

## command for see which host generated

```bash
docker compose run --rm certbot certificates
```

## add to crontab

```bash
# sudo crontab -e
0 2 * * * /home/user/projects/github/regru_certbot/renew.sh >> /home/user/projects/github/regru_certbot/data/cron.log 2>&1
```

## for update remote cert

```bash

# crontab -e
rsync -azL --out-format="%n" /home/user/projects/github/regru_certbot/data/etc/letsencrypt/live/host.ru/fullchain.pem /home/host/projects/github/regru_certbot/data/etc/letsencrypt/live/host.ru/privkey.pem root@host.ru:/root/projects/github/cert/_.host.ru/ | grep -q . && ssh root@host.ru "sudo /usr/sbin/nginx -s reload"
```

###

tested on certbot v5.0.0