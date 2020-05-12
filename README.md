# cloud-appliance-observability

## Description

Deploy logs and metrics management appliances using Hashicorp Terraform.

## Prerequisites

You need to install consul locally in order to fix a value for
`GRAYLOG_CONSUL_ENCRYPT` and `METRICS_CONSUL_ENCRYPT` if consul is enabled using
`GRAYLOG_CONSUL_USAGE=true` or `METRICS_CONSUL_USAGE=true`.

Then, you can get a value:

```bash
export METRICS_CONSUL_USAGE=false
export GRAYLOG_CONSUL_USAGE=false
export GRAYLOG_CONSUL_ENCRYPT=$(consul keygen) # fake value
export METRICS_CONSUL_ENCRYPT=$(consul keygen) # fake value
```

If you want to connect against an existing `consul` service you should use your
existing secret.

```bash
export GRAYLOG_CONSUL_ENCRYPT=$CONSUL_SERVICE_ENCRYPT
export METRICS_CONSUL_ENCRYPT=$CONSUL_SERVICE_ENCRYPT
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
influx --host=$METRICS_ENDPOINT ping
```

### Manage Graylog

[A terraform-community-provided provider is available](https://github.com/suzuki-shunsuke/go-graylog/blob/master/docs/README.md)

```bash
# TODO
```

### Send metrics to the appliance

#### Using telegraf

An [ansible role is available](https://github.com/mgrzybek/ansible-telegraf)
to configure a telegraf agent:

* system metrics ;
* open a local InfluxDB v1 endpoint to allow business softwares to send metrics.

```yaml
- hosts: all
  roles:
     - ansible-telegraf
  vars:
     # Main InfluxDB v2 output configuration
     telegraf_output_influxdbv2_config:
         urls: ["http://localhost:8086"] # use $METRICS_ENDPOINT
         token: "secret"                 # get the bucket's token from swift
         org: "my-org"                   # use $INFLUXDB_ORG or any post-configured organization
         bucket: "default"               # use a pre-configured or post-configured bucket
         bucket_tag: ""
         exclude_bucket_tag: false
         insecure_skip_verify: false

     # Add local InfluxDB v1 endpoint
     telegraf_influxdb_listener_config:
         service_address: ":8086"
         read_timeout: 10s
         write_timeout: 10s
         max_body_size: 0
         max_line_size: 0

     # Main configuration
     telegraf_main_config:
         global_tags:
            os_project: "cloud-1" # You can add any tag you want
         add_node_type: false
         agent:
            interval: "{{ telegraf_metrics_agent_interval_seconds }}"
            round_interval: false
            metric_batch_size: 1024
            metric_buffer_limit: 10240
            collection_jitter: 8s
            flush_jitter: 8s
            precision: ""
            debug: false
            quiet: false
            logfile: ""
            omit_hostname: false

     telegraf_custom_inputs:
       # Kubernetes Inventory
       # https://github.com/influxdata/telegraf/tree/master/plugins/inputs/kube_inventory
       - name: kube_inventory
         plugin: kube_inventory
         options:
           - 'url = "https://127.0.0.1"'
           - 'namespace = ""'
       # Kubernetes
       # https://github.com/influxdata/telegraf/tree/master/plugins/inputs/kubernetes
       - name: kubernetes
         plugin: kubernetes
         options:
           - 'url = "http://127.0.0.1:10255"'
       # Docker
       # https://github.com/influxdata/telegraf/tree/master/plugins/inputs/docker
       - name: docker
         plugin: docker
         options:
           - 'endpoint = "unix:///var/run/docker.sock"'
           - 'gather_services = false'
           - 'source_tag = false'
```

#### Using Java-based softwares

#### Using PHP-based softwares

### Send logs to the appliance

#### Syslog configuration

An [ansible role is available](
https://github.com/mgrzybek/ansible-bootstrap-system) to configure syslog:

```yaml
- name: Do OS-ready configuration
  hosts: all
  roles:
    - role: bootstrap-system
  vars:
    bootstrap_syslog_target_host: graylog.local # use $GRAYLOG_ENDPOINT
    bootstrap_syslog_target_port:               # use $GRAYLOG_ENDPOINT
    bootstrap_syslog_target_protocol: http
    bootstrap_syslog_additional_tags:           # add needed custom tags
      environment: production
      tenant: my-custom-tenant
      cloud: amazon
      region: us-west-1
      az: seattle
```

#### Docker

An [ansible role is available](
https://github.com/mgrzybek/ansible-docker/) to configure docker.

`journald` / `syslog` can to used to send logs to Graylog. This is the default
behaviour. `docker` can send logs directly to Graylog using GELF over TCP / UDP.

```yaml
- hosts: all
  roles:
     - ansible-docker
  vars:
     # Log management
     # Default: journald
     # https://docs.docker.com/config/containers/logging/configure/#supported-logging-drivers
     docker_log_driver: gelf
     docker_log_options:
       - "gelf-address=udp://<graylog_endpoint>:<graylog_gelf_port>" # UDP or TCP port must be available
```

#### Java and PHP

`log4j` appender for Java:

* [GELF layout](https://logging.apache.org/log4j/2.x/manual/layouts.html#GELFLayout)
* [HTTP Appender](https://logging.apache.org/log4j/2.x/manual/appenders.html#HttpAppender)

```xml
<Appenders>
  <!-- graylog-endpoint: GELF over HTTP endpoint -->
  <Http name="Http" url="graylog-endpoint">
    <Property name="X-Java-Runtime" value="$${java:runtime}" />
    <GelfLayout compressionType="OFF" includeNullDelimiter="true"/>
  </Http>
</Appenders>
```
