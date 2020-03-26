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

### Resources management

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

clean-logs-single-network # Destroy logs service
clean-metrics-single      # Destroy the logs appliance

help                      # This help message

logs-check                # Check graylog env variables
logs-single-network       # Configure logs service

metrics-check             # Check metrics env variables
metrics-single-network    # Configure metrics service

prepare           # Download atifacts from internet to Swift

rebuild           # Rebuild all the servers at once
rebuild-logs      # Rebuild the logs appliance
rebuild-metrics   # Rebuild the metrics appliance

status            # Get some information about what is running
syntax            # Testing YAML syntax
test              # Test pre-requisites
```

### Getting resources info

First, go to the right directory. Then, `terraform show` can be used.
```bash
# Get appliance attributes
terraform show -json \
| jq -r '.values.root_module.resources[] | select(.address | contains("openstack_compute_instance_v2.appliance-")).values'

# Get appliance address
terraform show -json \
| jq -r '.values.root_module.resources[] | select(.address | contains("openstack_compute_instance_v2.appliance-")).values.access_ip_v4'
```

## Day-2 operations

### Manage InfluxDB

```bash
# TODO: Get the token from swift
# Use influx CLI
influx --host=http://$METRICS_ENDPOINT ping
```

### Manage Graylog

A terraform-community-provided provider is available at 
https://github.com/suzuki-shunsuke/go-graylog/blob/master/docs/README.md
```bash
# TODO
```
