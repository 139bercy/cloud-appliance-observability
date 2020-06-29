# cloud-appliance-observability

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

## Outputs

| Name | Description |
|------|-------------|
| logs-back-port | Logs Appliance back-office port |
| metrics-back-port | Metrics Appliance back-office port |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

