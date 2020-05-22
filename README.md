# cloud-appliance-observability

## Description

Deploy logs and metrics management appliances using Openstack HEAT.

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

Your project must contain two networks:

* front-office: used to access the internet and other public resources ;
* back-office: used to publish los and metrics services.

You must set your Openstack credentials in your environment. Then, some 
variables need to be set.

```bash
# Common
export IMAGE_ID=$(openstack image list | awk '/_server/{ print $2 }')
export DEFAULT_SECGROUP_ID=$(openstack security group list | awk '/default-secgroup/ {print $2}')
export FRONT_NET_ID=$(openstack network list | awk '/front-office/ {print $2}')
export BACK_NET_ID=$(openstack network list | awk '/back-office/ {print $2}')
export STATIC_HOSTS='[{"gitlab.cloud":"3.4.5.6"},{"api.cloud":"5.4.3.2"}]'
export GIT_REPO_URL="https://github.com/139bercy/cloud-appliance-observability"
export GIT_REPO_CHECKOUT=heat-stacks
export OS_SWIFT_REGION_NAME=RegionOne

export OS_AUTH_URL=$OS_AUTH_URL
export OS_PASSWORD=$OS_PASSWORD
export OS_REGION_NAME=$OS_REGION_NAME
export OS_USERNAME=$OS_USERNAME

export NTP_SERVER=192.168.0.1 # Set your own NTP address

export CONSUL_DATACENTER=
export CONSUL_DNS_DOMAIN=
export CONSUL_DNS_SERVER=
export CONSUL_ENCRYPT=EMkFSodo5bE2JZdYoRah/nWYi+c/vCcTHOaUNj2k01k=
export CONSUL_SERVERS=
export CONSUL_USAGE=false

# Logs
export LOGS_FRONT_NET_ID=$FRONT_NET_ID
export LOGS_BACK_NET_ID=$BACK_NET_ID
export LOGS_IMAGE_ID=$IMAGE_ID
export LOGS_FLAVOR_ID=$(openstack flavor list | awk '/ CO1.2 / {print $2}')
export LOGS_SECGROUP_ID=$DEFAULT_SECGROUP_ID
export GRAYLOG_ADMIN_NAME=ADMIN
export GRAYLOG_ADMIN_PASSWORD=ADMIN
export GRAYLOG_ENDPOINT_URL=http://logs.cloud
export GRAYLOG_SIZE_GB=10
export ELASTICSEARCH_SIZE_GB=10

export LOGS_INFLUXDB_USAGE=false
export LOGS_INFLUXDB_BUCKET=
export LOGS_INFLUXDB_ENDPOINT=
export LOGS_INFLUXDB_ORG=
export LOGS_INFLUXDB_TOKEN=

export INTERNET_HTTP_PROXY_URL=http://proxy:3128
export INTERNET_HTTP_NO_PROXY=cloud,$CONSUL_DNS_DOMAIN # add your internal RPM / deb repo

export FIP_LOGS_APPLIANCE=1.2.3.4

# Metrics
export METRICS_FRONT_NET_ID=$FRONT_NET_ID
export METRICS_BACK_NET_ID=$BACK_NET_ID
export METRICS_IMAGE_ID=$IMAGE_ID
export METRICS_FLAVOR_ID=$(openstack flavor list | awk '/ CO1.1 / {print $2}')
export METRICS_SECGROUP_ID=$DEFAULT_SECGROUP_ID
export METRICS_SIZE_GB=10
export METRICS_CONTAINER=metrics
export METRICS_ENDPOINT_URL=http://metrics.cloud

export INFLUXDB_RETENTION_HOURS=24
export INFLUXDB_ORGANISATION=cloud
export INFLUXDB_ADMIN_PASSWORD=ADMIN01ADMIN
export INFLUXDB_ADMIN_NAME=ADMIN

export GRAFANA_ADMIN_NAME=ADMIN
export GRAFANA_ADMIN_PASSWORD=ADMIN

export FIP_METRICS_APPLIANCE=2.3.4.5
```

Control the deployments

```bash
# Get help
make help
all                 Deploy the appliances at once
clean               Destroy the appliances
clean-logs          Destroy the logs appliance
clean-metrics       Destroy the metrics appliance
help                This help message
logs                Configure graylog service
metrics             Configure metrics service
prepare             Download atifacts from internet to Swift
rebuild-logs        Rebuild the logs appliance
rebuild-metrics     Rebuild the metrics appliance
rebuild             Rebuild all the servers at once
status              Get some information about what is running
syntax              Testing YAML syntax
test                Testing YAML syntax, env variables and openstack connectivity
```

### Getting resources info

```bash
# Get appliance attributes
openstack server show metrics
openstack server show graylog
```

## Day-2 operations

### Manage InfluxDB

```bash
# TODO: Get the token from swift
# Use influx CLI
influx --host=$METRICS_ENDPOINT ping
```

### Manage Graylog

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

