![kibana-logo](https://raw.githubusercontent.com/blacktop/docker-kibana-alpine/master/kibana-logo.png)

# docker-kibana-alpine

Alpine Linux based [Kibana](https://www.elastic.co/products/kibana) Docker Image

**Table of Contents**

- [docker-kibana-alpine](#docker-kibana-alpine)
    - [Why?](#why)
    - [Dependencies](#dependencies)
    - [Documentation](#documentation)
        - [Customize at runtime via environment variables](#customize-at-runtime-via-environment-variables)
        - [To use your own elasticsearch address via `KIBANA_ELASTICSEARCH_URL`](#to-use-your-own-elasticsearch-address-via-kibana_elasticsearch_url)
    - [Credits](#credits)

## Why?

Compare Image Sizes:

* official kibana = 1.01GB
* kibana-alpine = 322MB

**Alpine version is 688 MB smaller !**

## Dependencies

* [node:alpine](https://hub.docker.com/_/node/)

## Documentation

### Customize at runtime via environment variables

There are two types of env vars:

* `KIBANA_ELASTICSEARCH_URL=http://localhost:9200`
* `elasticsearch.url=http://localhost:9200`

### To use your own elasticsearch address via `KIBANA_ELASTICSEARCH_URL`

``` bash
$ docker run --init -d --name kibana -e KIBANA_ELASTICSEARCH_URL=http://some-elasticsearch:9200 -p 5601:5601 blacktop/kibana
```

For elasticsearch running on a OSX host it would be

``` bash
$ docker run --init -d --name kibana \
  -p 5601:5601 \
  --net host \
  -e KIBANA_ELASTICSEARCH_URL="http://$(ipconfig getifaddr en0):9200" \
  blacktop/kibana
```

For `x-pack` with basic auth:

``` bash
$ docker run --init -d --name kibana \
             --restart unless-stopped \
             -p 443:5601 \
             -v /etc/letsencrypt/archive/demo.malice.io:/certs \
             -e KIBANA_SERVER_SSL_ENABLED=true \
             -e KIBANA_SERVER_SSL_KEY=/certs/privkey1.pem \
             -e KIBANA_SERVER_SSL_CERTIFICATE=/certs/cert1.pem \
             -e KIBANA_ELASTICSEARCH_URL=$KIBANA_ELASTICSEARCH_URL \
             -e KIBANA_ELASTICSEARCH_USERNAME=$KIBANA_ELASTICSEARCH_USERNAME \
             -e KIBANA_ELASTICSEARCH_PASSWORD=$KIBANA_ELASTICSEARCH_PASSWORD \
             --log-opt max-size=100m \
             --log-opt max-file=3 \
             blacktop/kibana:x-pack
```

## Credits

Based on https://github.com/blacktop/docker-kibana-alpine
