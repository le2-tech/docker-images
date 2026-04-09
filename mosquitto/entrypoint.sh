#!/bin/sh
set -eu

if [ "${1#-}" != "$1" ]; then
	set -- /opt/usr/sbin/mosquitto -c /mosquitto/config/mosquitto.conf "$@"
fi

mkdir -p /app/data /mosquitto/data /mosquitto/log

exec "$@"
