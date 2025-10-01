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