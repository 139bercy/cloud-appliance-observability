################################################################################
# Cloud
#

# Image
variable "image_name" {
  type        = string
  description = "Operating system image to use"
  default     = "ubuntu18.04_server"
}

# Networking
variable "front_net_id" {
  type        = string
  description = "Network ID to use for the appliance"
}

variable "back_net_id" {
  type        = string
  description = "Backoffice network ID to use for the appliance"
}

variable "default_secgroup_id" {
  type        = string
  description = "Default security group to use"
}

# Provider endpoint and attributes
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

################################################################################
# Cloud-init
#

# Git-ops
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

# Internet proxy
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

# Time sync
variable "ntp_server" {
  type        = string
  description = "Remote NTP to use for sync"
  default     = ""
}

# Direct hostname resolution
variable "static_hosts" {
  type        = string
  description = "JSON array of host:ip tuples"
  default     = ""
}

# Sending metrics to a remote InfluxDB endpoint
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

# Sending logs to a remote Graylog endpoint
variable "syslog_protocol" {
  type        = string
  description = "Protocol used to send logs: udp, tcp or http"
  default     = "udp"

  #  validation {
  #    condition     = var.syslog_protocol == "udp" || var.syslog_protocol == "tcp" || var.syslog_protocol == "http"
  #    error_message = "The log management protocol must be 'udp', 'tcp' or 'http'."
  #  }
}

variable "syslog_log_format" {
  type        = string
  description = "Log format used to send logs: gelf or syslog"
  default     = "gelf"

  #  validation {
  #    condition     = var.syslog_log_format == "gelf" || var.syslog_log_format == "syslog"
  #    error_message = "The log format must be 'gelf' or 'syslog'."
  #  }
}

variable "syslog_hostname" {
  type        = string
  description = "Hostname or address of the remote log management endpoint"
}

variable "syslog_port" {
  type        = number
  description = "Port number of the remote log management endpoint"
  default     = 12201
}

################################################################################
# Consul
#

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

variable "traefik_consul_prefix" {
  type        = string
  description = "Consul catalog prefix used to configure Traefik"
  default     = "admin"
}

################################################################################
# Logs
#

# System sizing
variable "logs_flavor_name" {
  type        = string
  description = "Cloud flavor to use"
  default     = "CO1.2"
}

# Storage sizing
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

# Graylog configuration
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

################################################################################
# Metrics
#

# System sizing
variable "metrics_flavor_name" {
  type        = string
  description = "Cloud flavor to use"
  default     = "CO1.1"
}

# Storage sizing
variable "metrics_size_gb" {
  type        = number
  description = "InfluxDB and Grafana data size (Gb)"
  default     = 100
}

# Grafana configuration
variable "grafana_usage" {
  type        = bool
  description = "Do we use Grafana?"
  default     = false
}

variable "grafana_admin_name" {
  type        = string
  description = "Grafana admin username"
}

variable "grafana_admin_password" {
  type        = string
  description = "Grafana admin password"
}

# InfluxDB configuration
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

