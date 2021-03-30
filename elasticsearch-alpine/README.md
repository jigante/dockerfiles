![es-logo](https://user-images.githubusercontent.com/1072026/112983227-b59ec780-915d-11eb-940e-add328afb8a8.png)

# docker-elasticsearch-alpine

Alpine Linux based [Elasticsearch](https://www.elastic.co/products/elasticsearch) Docker Image

**Table of Contents**

- [docker-elasticsearch-alpine](#docker-elasticsearch-alpine)
    - [Why?](#why)
    - [Dependencies](#dependencies)
    - [Getting Started](#getting-started)
    - [Known Issues :warning:](#known-issues-warning)
    - [Credits](#credits)

## Why?

Compare Image Sizes:

* official elasticsearch = 807 MB
* elasticsearch-alpine = 289 MB

**alpine version is 518 MB smaller !**

## Dependencies

* [alpine:3.13](https://hub.docker.com/_/alpine/)

## Getting Started

``` bash
$ docker run -d --name elastic -p 9200:9200 jigante/elasticsearch:6.8.13-alpine
```
or
```
$ docker run -d --name elastic -p 9200:9200 jigante/elasticsearch:7.10.2-alpine
```

## Known Issues :warning:

Running the new **5.0+** version on a linux host you need to increase the memory map areas with the following command

``` bash
sudo sysctl -w vm.max_map_count=262144
```

## Credits

Based on https://github.com/blacktop/docker-elasticsearch-alpine
