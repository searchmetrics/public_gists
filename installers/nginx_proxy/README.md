# Install [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) to reverse-proxy your docker-containers.

Have a look at the [blog post](http://jasonwilder.com/blog/2014/03/25/automated-nginx-reverse-proxy-for-docker/) why this could help you.

## TL;DR
You can reach your dockerized services via http://yourservice.docker after this is installed.

To install just run

    curl -sq https://raw.githubusercontent.com/searchmetrics/public_gists/master/installers/install.sh \
             | bash -s nginx_proxy


## What's in this tool?
### jwilder/nginx-proxy
[nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) is a reverse proxy that will direct traffic to the correct containers based on DNS names.

Just pass the environment-variable(s) `VIRTUAL_HOST` (and if the service exposes more than one port `VIRTUAL_PORT`) to your docker-container and nginx-proxy will
direct traffic to the correct service. This only works, if the dns you passed as `VIRTUAL_HOST` is actually pointing to your reverse-proxy.
For this purpose this tool also installs dnsmasq that resolves all requests to *.docker to your local host (i.e. nginx-proxy)

### dnsmasq
This will resolve any request to *.docker to `127.0.0.1`. To make dnsmasq actually answer request a custom resolver is placed in `/etc/resolver` (works only on OSX).
You find the management GUI here: http://dns.docker

### portainer
Portainer is a GUI to manage you docker-containers. You can reach it on http://portainer.docker
