# Install [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) to reverse-proxy your docker-containers.

Have a look at the [blog post](http://jasonwilder.com/blog/2014/03/25/automated-nginx-reverse-proxy-for-docker/) why this could help you.

## TL;DR
You can reach your dockerized services via http://yourservice.docker after this is installed.

To install just download the [docker-compose file](docker-compose.yml) and run it or

    curl -sq https://raw.githubusercontent.com/searchmetrics/public_gists/master/installers/install.sh \
             | bash -s nginx_proxy
