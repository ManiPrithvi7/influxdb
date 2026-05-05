#!/usr/bin/env sh
set -e

# PaaS (Render/Railway/etc.) usually proxies to $PORT. InfluxDB must bind to that port.
# Keep compatibility with platforms that explicitly set INFLUXD_HTTP_BIND_ADDRESS already.
if [ -z "${INFLUXD_HTTP_BIND_ADDRESS:-}" ]; then
  bind_port="${PORT:-8086}"
  export INFLUXD_HTTP_BIND_ADDRESS=":${bind_port}"
fi

exec /entrypoint.sh influxd

