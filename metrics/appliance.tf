################################################################################
# Instances
#
resource "openstack_compute_instance_v2" "appliance-metrics" {
  name      = "metrics"
  image_name  = var.image_name
  flavor_name = var.flavor_name

  network {
    port = openstack_networking_port_v2.appliance-metrics-front-port.id
  }

  network {
    port = openstack_networking_port_v2.appliance-metrics-back-port.id
  }

  depends_on = [
    openstack_networking_port_v2.appliance-metrics-front-port,
    openstack_networking_port_v2.appliance-metrics-back-port
  ]
  user_data = templatefile(
    "${path.module}/cloud-init.sh",
    {
      internet_http_proxy_url = var.internet_http_proxy_url
      internet_http_no_proxy  = var.internet_http_no_proxy
      static_hosts            = var.static_hosts

      os_auth_url    = var.os_auth_url
      os_username    = var.os_username
      os_password    = var.os_password
      os_region_name = var.os_region_name

      cinder_containers_volume = openstack_blockstorage_volume_v2.appliance-metrics-containers.id
      cinder_metrics_volume    = openstack_blockstorage_volume_v2.appliance-metrics-metrics.id

      metrics_container = openstack_objectstorage_container_v1.appliance-metrics-objects-metrics.id

      grafana_usage          = var.grafana_usage
      grafana_admin_name     = var.grafana_admin_name
      grafana_admin_password = var.grafana_admin_password

      influxdb_admin_name      = var.influxdb_admin_name
      influxdb_admin_password  = var.influxdb_admin_password
      influxdb_organisation    = var.influxdb_organisation
      influxdb_retention_hours = var.influxdb_retention_hours

      metrics_endpoint_url = var.metrics_endpoint_url

      consul_usage      = var.consul_usage
      consul_dns_domain = var.consul_dns_domain
      consul_datacenter = var.consul_datacenter
      consul_encrypt    = var.consul_encrypt
      consul_dns_server = var.consul_dns_server
      consul_servers    = var.consul_servers

      traefik_consul_prefix = var.traefik_consul_prefix

      backoffice_ip_address = openstack_networking_port_v2.appliance-metrics-back-port.all_fixed_ips[0]

      ntp_server = var.ntp_server

      git_repo_checkout = var.git_repo_checkout
      git_repo_url      = var.git_repo_url

      syslog_hostname   = var.syslog_hostname
      syslog_port       = var.syslog_port
      syslog_protocol   = var.syslog_protocol
      syslog_log_format = var.syslog_log_format
    }
  )
}

################################################################################
# Security groups
#
resource "openstack_networking_secgroup_v2" "appliance-metrics-secgroup" {
  name        = "appliance-metrics-secgroup"
  description = "Metrics services"
}

resource "openstack_networking_secgroup_rule_v2" "appliance-metrics-secgroup-https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.appliance-metrics-secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "appliance-metrics-secgroup-http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.appliance-metrics-secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "appliance-metrics-secgroup-netdata" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 19999
  port_range_max    = 19999
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.appliance-metrics-secgroup.id
}
