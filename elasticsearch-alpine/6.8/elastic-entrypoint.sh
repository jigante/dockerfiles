#!/bin/bash

set -e

umask 0002

declare -a es_opts

while IFS='=' read -r envvar_key envvar_value
do
    # Elasticsearch env vars need to have at least two dot separated lowercase words, e.g. `cluster.name`
    if [[ "$envvar_key" =~ ^[a-z0-9_]+\.[a-z0-9_]+ ]]; then
        if [[ ! -z $envvar_value ]]; then
          es_opt="-E${envvar_key}=${envvar_value}"
          es_opts+=("${es_opt}")
        fi
    fi
done < <(env)

export ES_JAVA_OPTS="-Des.cgroups.hierarchy.override=/ $ES_JAVA_OPTS"

# Temporary workaround to install all needed Elasticsearch plugins for multi platforms image buildings
if ! elasticsearch-plugin list -s | grep -q analysis-icu; then
    elasticsearch-plugin install -s analysis-icu
fi
if ! elasticsearch-plugin list -s | grep -q analysis-smartcn; then
    elasticsearch-plugin install -s analysis-smartcn
fi
if ! elasticsearch-plugin list -s | grep -q analysis-kuromoji; then
    elasticsearch-plugin install -s analysis-kuromoji
fi

# Determine if x-pack is enabled
if elasticsearch-plugin list -s | grep -q x-pack; then
    if [[ -n "$ELASTIC_PASSWORD" ]]; then
        [[ -f config/elasticsearch.keystore ]] ||  elasticsearch-keystore create
        echo "$ELASTIC_PASSWORD" | elasticsearch-keystore add -x 'bootstrap.password'
    fi
fi

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- elasticsearch "$@"
fi

# Drop root privileges if we are running elasticsearch
# allow the container to be started with `--user`
if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
	# Change the ownership of user-mutable directories to elasticsearch
	chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/{data,logs}

	set -- su-exec elasticsearch "$@" "${es_opts[@]}"
fi

exec "$@"
