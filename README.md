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

###

tested on certbot v5.0.0