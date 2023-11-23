# Tailscale Derp Server

Although tailscale derp supports automatic SSL certificate generation, it is not always convenient. This repository uses [NginxProxyManager](https://github.com/NginxProxyManager/nginx-proxy-manager)(NPM) as a reverse proxy for derp, Which provides a more convenient and flexible way to configure SSL.

With NPM, you can use the DNS-01 challenge to obtain an SSL certificate or even upload the SSL certificate manually. This is extremely convenient in countries where certain HTTP-01 challenge are blocked.

##  TL;DR

1. Modify the port configuration in `docker-compose.yaml` as desired.

```yaml
version: '3'
services:
  npm:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
    ports:
      - '127.0.0.1:81:81'
      - '23333:443'
  derp:
    build: .
    restart: always
    ports:
      - "33478:33478"
    volumes:
      - "/var/run/tailscale/tailscaled.sock:/var/run/tailscale/tailscaled.sock"
```

2. start with docker-compse

```shell
docker compose up -d	
```

3. login to NPM with SSH Local forward http://127.0.0.1:8881 with default username `admin@example.com` and password `changeme`

```
ssh -L 8881:127.0.0.1:81 username@host
```

4. NPM provides a user-friendly interface that simplifies the process of setting up a reverse proxy and SSL. You can find detailed instructions on how to configure it in the documentation available at [doc](https://nginxproxymanager.com/guide/). By the way, **please ensure that the proxy is set to point to http://derp:80**.
# With Headscale

As [derp example](https://github.com/juanfont/headscale/blob/main/derp-example.yaml) in Headscale repo:

```yaml
regions:
  900:
    regionid: 900
    regioncode: custom
    regionname: My Region
    nodes:
      - name: 900a
        regionid: 900
        hostname: myderp.mydomain.no
        ipv4: 123.123.123.123
        ipv6: "2604:a880:400:d1::828:b001"
        stunport: 33478
        stunonly: false
        derpport: 23333
```
