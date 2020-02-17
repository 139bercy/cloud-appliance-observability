# cloud-appliance-observability

## Description

Deploy logs and metrics management appliances using Openstack HEAT.

## Usage

You must source your Openstack credentials first. Then, some variables need to 
be set.

```bash
export GIT_REPO_URL=https://github.com/139bercy/cloud-appliance-observability

# Log management
export GRAYLOG_ENDPOINT=
export GRAYLOG_FLAVOR=
export GRAYLOG_IMAGE_ID=
export GRAYLOG_NET_ID=
export GRAYLOG_SECGROUP_ID=

export GRAYLOG_SIZE_GB=
export ELASTECSEARCH_SIZE_GB=

export GRAYLOG_HTTP_PROXY=
export GRAYLOG_NO_PROXY=

export GRAYLOG_ADMIN=
export GRAYLOG_PASSWORD=

# Metrics management
export METRICS_ENDPOINT=
export METRICS_FLAVOR=
export METRICS_IMAGE_ID=
export METRICS_NET_ID=
export METRICS_SECGROUP_ID=
export METRICS_SIZE_GB=

export METRICS_HTTP_PROXY=
export METRICS_NO_PROXY=

export GRAFANA_ADMIN=
export GRAFANA_PASSWORD=

export INFLUXDB_ADMIN=
export INFLUXDB_PASSWORD=
```

Control the deployments

```bash
# Get help
make help

# Testing
make syntax
make test
make status

# Deployements
make all
make logs
make metrics

# Cleanups
make clean
make clean-logs
make clean-metrics

# Rebuilds
make rebuild
make rebuild-logs
make rebuild-metrics
```

