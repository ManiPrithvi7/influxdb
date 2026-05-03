# Official InfluxDB image. Defaults below apply even when Render does not inject
# every variable from the dashboard/Blueprint (fixes init + port warnings in logs).
FROM influxdb:2.7.4

# Render forwards traffic to PORT (default 10000). Bind HTTP here—not :8086.
ENV PORT=10000
ENV INFLUXD_HTTP_BIND_ADDRESS=:10000

# First-boot automated setup (requires secrets from Render → Environment).
ENV DOCKER_INFLUXDB_INIT_MODE=setup
ENV DOCKER_INFLUXDB_INIT_USERNAME=admin
ENV DOCKER_INFLUXDB_INIT_ORG=statsmqtt
ENV DOCKER_INFLUXDB_INIT_BUCKET=metrics

# Do not bake passwords/tokens into the image. Set on Render:
# DOCKER_INFLUXDB_INIT_PASSWORD, DOCKER_INFLUXDB_INIT_ADMIN_TOKEN
