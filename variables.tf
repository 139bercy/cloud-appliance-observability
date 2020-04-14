################################################################################
# Common
#

variable "image_id" {
  type        = string
  description = "Operating system image to use"
}

variable "front_net_id" {
  type        = string
  description = "Network ID to use for the appliance"
}

variable "back_net_id" {
  type        = string
  description = "Backoffice network ID to use for the appliance"
}

variable "os_username" {
  type        = string
  description = "loud username for some internal batches"
}

variable "os_password" {
  type        = string
  description = "Cloud password for some internal batches"
}

variable "os_auth_url" {
  type        = string
  description = "Cloud auth URL"
}

variable "os_region_name" {
  type        = string
  description = "Cloud region name"
}

variable "os_swift_region_name" {
  type        = string
  description = "Cloud region name used by objets storage"
}

variable "git_repo_url" {
  type        = string
  description = "cloud-appliance-observability repo"
  default     = "https://github.com/139bercy/cloud-appliance-observability"
}

variable "git_repo_checkout" {
  type        = string
  description = "branch/tag/commit to use"
  default     = "master"
}

variable "default_secgroup_id" {
  type        = string
  description = "Default security group to use"
}

variable "internet_http_proxy_url" {
  type        = string
  description = "HTTP proxy"
  default     = ""
}

variable "internet_http_no_proxy" {
  type        = string
  description = "Proxy skiplist"
  default     = ""
}

variable "ntp_server" {
  type        = string
  description = "Remote NTP to use for sync"
  default     = ""
}

variable "static_hosts" {
  type        = string
  description = "JSON array of host:ip tuples"
  default     = ""
}

################################################################################
# Logs

variable "logs_flavor_id" {
  type        = string
  description = "Cloud flavor to use"
}

variable "elasticsearch_size_gb" {
  type        = number
  description = "Elasticsearch data size (Gb)"
  default     = 100
}

variable "graylog_size_gb" {
  type        = number
  description = "Graylog data size (Gb)"
  default     = 10
}

variable "graylog_admin_name" {
  type        = string
  description = "Graylog admin username"
}

variable "graylog_admin_password" {
  type        = string
  description = "Grafana admin password"
}

variable "graylog_endpoint_url" {
  type        = string
  description = "Public hostname used to connect against Graylog"
}

variable "consul_usage" {
  type        = bool
  description = "Do we use consul?"
  default     = false
}

variable "consul_servers" {
  type        = string
  description = "List of consul servers"
  default     = ""
}

variable "consul_dns_domain" {
  type        = string
  description = "DNS domain used by Consul agent"
  default     = ""
}

variable "consul_datacenter" {
  type        = string
  description = "Datacenter name used by Consul agent"
  default     = ""
}

variable "consul_encrypt" {
  type        = string
  description = "Consul shared secret for cluster communication"
}

variable "consul_dns_server" {
  type        = string
  description = "IP address to use for non-consul-managed domains"
  default     = ""
}

variable "influxdb_usage" {
  type        = bool
  description = "Do we send metrics to InfluxDB?"
  default     = false
}

variable "influxdb_endpoint" {
  type        = string
  description = "Remote InfluxDB service to use to send metrics"
  default     = ""
}

variable "influxdb_org" {
  type        = string
  description = "InfluxDB organization to use"
  default     = ""
}

variable "influxdb_token" {
  type        = string
  description = "InfluxDB token to use to send metics"
  default     = ""
}

variable "influxdb_bucket" {
  type        = string
  description = "InfluxDB bucket to use to send metrics"
  default     = ""
}

################################################################################
# Metrics
#

variable "metrics_flavor_id" {
  type        = string
  description = "Cloud flavor to use"
}

variable "metrics_size_gb" {
  type        = number
  description = "InfluxDB and Grafana data size (Gb)"
  default     = 100
}

variable "grafana_admin_name" {
  type        = string
  description = "Grafana admin username"
}

variable "grafana_admin_password" {
  type        = string
  description = "Grafana admin password"
}

variable "influxdb_admin_name" {
  type        = string
  description = "InfluxDB admin username"
}

variable "influxdb_admin_password" {
  type        = string
  description = "InfluxDB admin password"
}

variable "influxdb_organisation" {
  type        = string
  description = "InfluxDB Org name"
}

variable "influxdb_retention_hours" {
  type        = number
  description = "InfluxDB default retention (hours)"
}

variable "metrics_endpoint_url" {
  type        = string
  description = "Public hostname used to connect against the tools"
}

variable "metrics_container" {
  type        = string
  description = "Swift container to use for backups"
}
