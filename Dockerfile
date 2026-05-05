# Official InfluxDB image. Defaults below apply even when Render does not inject
# every variable from the dashboard/Blueprint (fixes init + port warnings in logs).
FROM influxdb:2.7.4

COPY influx-entrypoint.sh /influx-entrypoint.sh
RUN chmod +x /influx-entrypoint.sh

# First-boot automated setup (requires secrets from Render → Environment).
ENV DOCKER_INFLUXDB_INIT_MODE=setup
ENV DOCKER_INFLUXDB_INIT_USERNAME=admin
ENV DOCKER_INFLUXDB_INIT_ORG=statsmqtt
ENV DOCKER_INFLUXDB_INIT_BUCKET=metrics

# Do not bake passwords/tokens into the image. Set on Render:
# DOCKER_INFLUXDB_INIT_PASSWORD, DOCKER_INFLUXDB_INIT_ADMIN_TOKEN

ENTRYPOINT ["/influx-entrypoint.sh"]
