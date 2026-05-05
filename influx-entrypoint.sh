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

# InfluxDB's official entrypoint exits hard if INIT_MODE=setup but required secrets
# are missing. On PaaS this turns into edge 502s ("app failed to respond").
if [ "${DOCKER_INFLUXDB_INIT_MODE:-}" = "setup" ]; then
  if [ -z "${DOCKER_INFLUXDB_INIT_PASSWORD:-}" ] || [ -z "${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN:-}" ]; then
    echo "[influx] WARN: DOCKER_INFLUXDB_INIT_MODE=setup but init secrets missing; starting without auto-setup." >&2
    echo "[influx]       Set DOCKER_INFLUXDB_INIT_PASSWORD and DOCKER_INFLUXDB_INIT_ADMIN_TOKEN in the platform variables, then redeploy." >&2
    unset DOCKER_INFLUXDB_INIT_MODE
  fi
fi

exec /entrypoint.sh influxd

