# Render defaults some repos to native Go builds; this Dockerfile pins the runtime
# to the official InfluxDB image so deploys never run `go build`.
FROM influxdb:2.7.4
