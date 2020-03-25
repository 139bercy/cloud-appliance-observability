# cloud-appliance-observability

## Description

Deploy logs and metrics management appliances using Hashicorp Terraform.

## Prerequisites

You need to install consul localy in order to fix a value for `GRAYLOG_CONSUL_ENCRYPT` 
and `METRICS_CONSUL_ENCRYPT` if consul is enabled using `GRAYLOG_CONSUL_USAGE=true` or 
`METRICS_CONSUL_USAGE=true`.

Then, you can get a value:
```bash
export GRAYLOG_CONSUL_ENCRYPT=$(consul keygen)
export METRICS_CONSUL_ENCRYPT=$(consul keygen)
```

## Usage

You must add a Terraform-provider file on the right directory:

* `logs/single-network` : one network interface
* `logs/dual-network` : two network interfaces
* `metrics/single-network` : one network interface
* `metrics/dual-network` : two network interfaces

Then, some variables need to be set.

```bash
export GIT_REPO_URL=$(git remote show github -n| awk '/Fetch/ {print $NF}')

# Logs management
export GRAYLOG_SIZE_GB=
export ELASTECSEARCH_SIZE_GB=
export GRAYLOG_FLAVOR=
export GRAYLOG_IMAGE_ID=
export GRAYLOG_FRONT_NET_ID=
export GRAYLOG_BACK_NET_ID= # dual network
export GRAYLOG_SECGROUP_ID=

export GRAYLOG_ADMIN=
export GRAYLOG_PASSWORD=
export GRAYLOG_ENDPOINT=

export GRAYLOG_HTTP_PROXY=
export GRAYLOG_NO_PROXY=

export GRAYLOG_CONSUL_USAGE=false
export GRAYLOG_CONSUL_DNS_DOMAIN=
export GRAYLOG_CONSUL_DATACENTER=
export GRAYLOG_CONSUL_ENCRYPT=$(consul keygen)
export GRAYLOG_CONSUL_DNS_SERVER=
export GRAYLOG_CONSUL_SERVER=

export GRAYLOG_OS_USERNAME=
export GRAYLOG_OS_PASSWORD=
export GRAYLOG_OS_AUTH_URL=

# Metrics management
export GRAFANA_ADMIN=
export GRAFANA_PASSWORD=
export INFLUXDB_ADMIN=
export INFLUXDB_ORG=
export INFLUXDB_PASSWORD=
export INFLUXDB_RETENTION_HOURS=

export METRICS_CONSUL_ENCRYPT=$(consul keygen)
export METRICS_CONSUL_USAGE=false

export METRICS_ENDPOINT=
export METRICS_FLAVOR=
export METRICS_FRONT_NET_ID=
export METRICS_BACK_NET_ID= # dual network
export METRICS_IMAGE_ID=

export METRICS_OS_AUTH_URL=
export METRICS_OS_PASSWORD=
export METRICS_OS_USERNAME=
export METRICS_OS_REGIONS_NAME=

export METRICS_SECGROUP_ID=
export METRICS_SIZE_GB=
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

