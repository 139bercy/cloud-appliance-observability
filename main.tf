terraform {
  required_version = ">= 0.12"
}

module logs_appliance {
  source = "./logs"

  back_net_id             = var.back_net_id
  image_name                = var.image_name
  front_net_id            = var.front_net_id
  os_username             = var.os_username
  os_password             = var.os_password
  os_auth_url             = var.os_auth_url
  os_region_name          = var.os_region_name
  os_swift_region_name    = var.os_swift_region_name
  git_repo_url            = var.git_repo_url
  git_repo_checkout       = var.git_repo_checkout
  default_secgroup_id     = var.default_secgroup_id
  internet_http_proxy_url = var.internet_http_proxy_url
  internet_http_no_proxy  = var.internet_http_no_proxy
  ntp_server              = var.ntp_server
  static_hosts            = var.static_hosts
  flavor_name               = var.logs_flavor_name

  elasticsearch_size_gb  = var.elasticsearch_size_gb
  graylog_size_gb        = var.graylog_size_gb
  graylog_admin_name     = var.graylog_admin_name
  graylog_admin_password = var.graylog_admin_password
  graylog_endpoint_url   = var.graylog_endpoint_url

  consul_usage      = var.consul_usage
  consul_dns_domain = var.consul_dns_domain
  consul_datacenter = var.consul_datacenter
  consul_encrypt    = var.consul_encrypt
  consul_dns_server = var.consul_dns_server
  consul_servers    = var.consul_servers
}

module metrics_appliance {
  source = "./metrics"

  back_net_id             = var.back_net_id
  image_name                = var.image_name
  front_net_id            = var.front_net_id
  os_username             = var.os_username
  os_password             = var.os_password
  os_auth_url             = var.os_auth_url
  os_region_name          = var.os_region_name
  os_swift_region_name    = var.os_swift_region_name
  git_repo_url            = var.git_repo_url
  git_repo_checkout       = var.git_repo_checkout
  default_secgroup_id     = var.default_secgroup_id
  internet_http_proxy_url = var.internet_http_proxy_url
  internet_http_no_proxy  = var.internet_http_no_proxy
  ntp_server              = var.ntp_server
  static_hosts            = var.static_hosts
  flavor_name               = var.metrics_flavor_name

  metrics_size_gb          = var.metrics_size_gb
  grafana_admin_name       = var.grafana_admin_name
  grafana_admin_password   = var.grafana_admin_password
  influxdb_admin_name      = var.influxdb_admin_name
  influxdb_admin_password  = var.influxdb_admin_password
  influxdb_organisation    = var.influxdb_organisation
  influxdb_retention_hours = var.influxdb_retention_hours
  metrics_endpoint_url     = var.metrics_endpoint_url
  metrics_container        = var.metrics_container

  consul_usage      = var.consul_usage
  consul_dns_domain = var.consul_dns_domain
  consul_datacenter = var.consul_datacenter
  consul_encrypt    = var.consul_encrypt
  consul_dns_server = var.consul_dns_server
  consul_servers    = var.consul_servers

  syslog_hostname = var.syslog_hostname
}
