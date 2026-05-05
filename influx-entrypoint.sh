#!/usr/bin/env sh
set -e

# PaaS (Render/Railway/etc.) proxies to $PORT. InfluxDB must bind to that port.
# If an old deployment left INFLUXD_HTTP_BIND_ADDRESS set (e.g. :10000),
# it can cause 502s when the platform assigns a different PORT.
bind_port="${PORT:-8086}"
desired=":${bind_port}"
if [ "${INFLUXD_HTTP_BIND_ADDRESS:-}" != "$desired" ]; then
  export INFLUXD_HTTP_BIND_ADDRESS="$desired"
fi

exec /entrypoint.sh influxd

