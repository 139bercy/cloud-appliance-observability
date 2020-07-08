# cloud-appliance-observability

## Description

This module deploys a pair of instances to provide:

* Graylog log manager ;
* InfluxDB / Grafana metrics management solutions.

The deployment is `cloud-init`-based. The instances need to clone this 
repository (use `git_repo_url` and `git_repo_checkout` for customisation).

## Usage

### Standalone

The deployment is managed by `make` and `terraform`.

```bash
# Get help
make help
all                 Deploy the appliances at once
apply               Terraform apply
clean-containers    Remove objects from containers
clean               Destroy the appliances
destroy             Destroy terraform deployment
dist-clean          Remove terraform distributions files (plugins, modules...)
force-destroy       Destroy terraform deployment
graph               Generate an SVG deployment graph
help                This help message
reinit              Download terraform artifacts again
status              Get some information about what is running
taint               Terraform taint appliances
```

### As a module

The module creates two instances (log management and metrics management). It 
can use invoqued like this:

```hcl
module observability {
  source = "git::https://github.com/139bercy/cloud-appliance-observability.git?ref=terraform-modules"

  #############################################################################
  # Common variables

  image_id            = var.image_id
  
  # The front net is the "public" network. The services are not published there.
  # They can be used to connect against standard resources (internet, repositories…).
  front_net_id        = 
  # The back net is used to publish services.
  back_net_id         = 
  
  # The default security group is usually "allow out, deny in"
  default_secgroup_id = 
 
  os_username          = var.os_username
  os_password          = var.os_password
  os_auth_url          = var.os_auth_url
  os_region_name       = var.os_region_name
  os_swift_region_name = var.os_swift_region_name

  #git_repo_url      = var.observability_git_repo_url
  git_repo_checkout = "terraform-modules"

  internet_http_proxy_url = var.internet_http_proxy_url
  internet_http_no_proxy  = var.internet_http_no_proxy
  ntp_server              = var.ntp_server
  static_hosts            = var.static_hosts

  consul_usage      = var.consul_usage
  consul_servers    = var.consul_servers
  consul_dns_domain = var.consul_dns_domain
  consul_datacenter = var.consul_datacenter
  consul_encrypt    = var.consul_encrypt
  consul_dns_server = var.consul_dns_server

  syslog_hostname = tostring(module.observability.logs-back-port.all_fixed_ips[0])

  #############################################################################
  # Logs variables

  logs_flavor_id        = var.logs_flavor_id
  elasticsearch_size_gb = var.elasticsearch_size_gb
  graylog_size_gb       = var.graylog_size_gb

  graylog_admin_name     = var.graylog_admin_name
  graylog_admin_password = var.grafana_admin_password
  graylog_endpoint_url   = var.graylog_endpoint_url

  influxdb_usage    = var.logs_influxdb_usage
  influxdb_endpoint = var.logs_influxdb_endpoint
  influxdb_org      = var.logs_influxdb_org
  influxdb_token    = var.logs_influxdb_token
  influxdb_bucket   = var.logs_influxdb_bucket
  
  #############################################################################
  # Metrics variables

  metrics_flavor_id = var.metrics_flavor_id
  metrics_size_gb   = var.metrics_size_gb

  grafana_admin_name     = var.grafana_admin_name
  grafana_admin_password = var.grafana_admin_password

  influxdb_admin_name      = var.influxdb_admin_name
  influxdb_admin_password  = var.influxdb_admin_password
  influxdb_organisation    = var.influxdb_organisation
  influxdb_retention_hours = var.influxdb_retention_hours

  metrics_endpoint_url = var.metrics_endpoint_url
  metrics_container    = var.metrics_container
}
```

Each submodule can be used separately too.

# Terraform details

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| back\_net\_id | Backoffice network ID to use for the appliance | `string` | n/a | yes |
| consul\_datacenter | Datacenter name used by Consul agent | `string` | `""` | no |
| consul\_dns\_domain | DNS domain used by Consul agent | `string` | `""` | no |
| consul\_dns\_server | IP address to use for non-consul-managed domains | `string` | `""` | no |
| consul\_encrypt | Consul shared secret for cluster communication | `string` | n/a | yes |
| consul\_servers | List of consul servers | `string` | `""` | no |
| consul\_usage | Do we use consul? | `bool` | `false` | no |
| default\_secgroup\_id | Default security group to use | `string` | n/a | yes |
| elasticsearch\_size\_gb | Elasticsearch data size (Gb) | `number` | `100` | no |
| front\_net\_id | Network ID to use for the appliance | `string` | n/a | yes |
| git\_repo\_checkout | branch/tag/commit to use | `string` | `"master"` | no |
| git\_repo\_url | cloud-appliance-observability repo | `string` | `"https://github.com/139bercy/cloud-appliance-observability"` | no |
| grafana\_admin\_name | Grafana admin username | `string` | n/a | yes |
| grafana\_admin\_password | Grafana admin password | `string` | n/a | yes |
| grafana\_usage | Do we use Grafana? | `bool` | `false` | no |
| graylog\_admin\_name | Graylog admin username | `string` | n/a | yes |
| graylog\_admin\_password | Grafana admin password | `string` | n/a | yes |
| graylog\_endpoint\_url | Public hostname used to connect against Graylog | `string` | n/a | yes |
| graylog\_size\_gb | Graylog data size (Gb) | `number` | `10` | no |
| image\_id | Operating system image to use | `string` | n/a | yes |
| influxdb\_admin\_name | InfluxDB admin username | `string` | n/a | yes |
| influxdb\_admin\_password | InfluxDB admin password | `string` | n/a | yes |
| influxdb\_bucket | InfluxDB bucket to use to send metrics | `string` | `""` | no |
| influxdb\_endpoint | Remote InfluxDB service to use to send metrics | `string` | `""` | no |
| influxdb\_org | InfluxDB organization to use | `string` | `""` | no |
| influxdb\_organisation | InfluxDB Org name | `string` | n/a | yes |
| influxdb\_retention\_hours | InfluxDB default retention (hours) | `number` | n/a | yes |
| influxdb\_token | InfluxDB token to use to send metics | `string` | `""` | no |
| influxdb\_usage | Do we send metrics to InfluxDB? | `bool` | `false` | no |
| internet\_http\_no\_proxy | Proxy skiplist | `string` | `""` | no |
| internet\_http\_proxy\_url | HTTP proxy | `string` | `""` | no |
| logs\_flavor\_id | Cloud flavor to use | `string` | n/a | yes |
| metrics\_container | Swift container to use for backups | `string` | n/a | yes |
| metrics\_endpoint\_url | Public hostname used to connect against the tools | `string` | n/a | yes |
| metrics\_flavor\_id | Cloud flavor to use | `string` | n/a | yes |
| metrics\_size\_gb | InfluxDB and Grafana data size (Gb) | `number` | `100` | no |
| ntp\_server | Remote NTP to use for sync | `string` | `""` | no |
| os\_auth\_url | Cloud auth URL | `string` | n/a | yes |
| os\_password | Cloud password for some internal batches | `string` | n/a | yes |
| os\_region\_name | Cloud region name | `string` | n/a | yes |
| os\_swift\_region\_name | Cloud region name used by objets storage | `string` | n/a | yes |
| os\_username | loud username for some internal batches | `string` | n/a | yes |
| static\_hosts | JSON array of host:ip tuples | `string` | `""` | no |
| syslog\_hostname | Hostname or address of the remote log management endpoint | `string` | n/a | yes |
| syslog\_log\_format | Log format used to send logs: gelf or syslog | `string` | `"gelf"` | no |
| syslog\_port | Port number of the remote log management endpoint | `number` | `12201` | no |
| syslog\_protocol | Protocol used to send logs: udp, tcp or http | `string` | `"udp"` | no |
| traefik\_consul\_prefix | Consul catalog prefix used to configure Traefik | `string` | `"admin"` | no |

## Outputs

| Name | Description |
|------|-------------|
| logs-back-port | Logs Appliance back-office port |
| metrics-back-port | Metrics Appliance back-office port |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

# Post-install tasks

## Getting resousces' info

First, go to the deployment root directory. Then, `terraform show` can be used.

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
