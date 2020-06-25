################################################################################
# Instances
#
resource "openstack_compute_instance_v2" "appliance-logs" {
  name      = "logs"
  image_id  = var.image_id
  flavor_id = var.flavor_id

  network {
    port = openstack_networking_port_v2.appliance-logs-front-port.id
  }

  network {
    port = openstack_networking_port_v2.appliance-logs-back-port.id
  }

  depends_on = [
    openstack_networking_port_v2.appliance-logs-front-port,
    openstack_networking_port_v2.appliance-logs-back-port
  ]

  user_data = templatefile(
    "${path.module}/cloud-init.sh",
    {
      internet_http_proxy_url = var.internet_http_proxy_url,
      internet_http_no_proxy  = var.internet_http_no_proxy,
      static_hosts            = var.static_hosts,

      os_auth_url    = var.os_auth_url,
      os_username    = var.os_username,
      os_password    = var.os_password,
      os_region_name = var.os_region_name,

      cinder_containers_volume    = openstack_blockstorage_volume_v2.appliance-logs-containers.id,
      cinder_elasticsearch_volume = openstack_blockstorage_volume_v2.appliance-logs-elasticsearch.id,
      cinder_graylog_volume       = openstack_blockstorage_volume_v2.appliance-logs-graylog.id,

      logs_container = openstack_objectstorage_container_v1.appliance-logs-objects-logs.id,

      graylog_admin_name     = var.graylog_admin_name,
      graylog_admin_password = var.graylog_admin_password,

      graylog_endpoint_url = var.graylog_endpoint_url,

      consul_usage      = var.consul_usage,
      consul_dns_domain = var.consul_dns_domain,
      consul_datacenter = var.consul_datacenter,
      consul_encrypt    = var.consul_encrypt,
      consul_dns_server = var.consul_dns_server,

      influxdb_usage    = var.influxdb_usage,
      influxdb_endpoint = var.influxdb_endpoint,
      influxdb_token    = var.influxdb_token,
      influxdb_org      = var.influxdb_org,
      influxdb_bucket   = var.influxdb_bucket,

      ntp_server = var.ntp_server,

      git_repo_checkout = var.git_repo_checkout,
      git_repo_url      = var.git_repo_url
    }
  )
}

################################################################################
# Security groups
#
resource "openstack_networking_secgroup_v2" "appliance-logs-secgroup" {
  name        = "appliance-logs-secgroup"
  description = "Logs management service"
}

resource "openstack_networking_secgroup_rule_v2" "appliance-logs-secgroup-http" {
  description       = "HTTP API endpoint"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.appliance-logs-secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "appliance-logs-secgroup-gelf-http" {
  description       = "GELF over HTTP"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 81
  port_range_max    = 81
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.appliance-logs-secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "appliance-logs-secgroup-syslog-udp" {
  description       = "Syslog over UDP"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 514
  port_range_max    = 514
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.appliance-logs-secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "appliance-logs-secgroup-syslog-tcp" {
  description       = "Syslog over TCP"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 514
  port_range_max    = 514
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.appliance-logs-secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "appliance-logs-secgroup-gelf-tcp" {
  description       = "GELF over TCP"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 12201
  port_range_max    = 12201
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.appliance-logs-secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "appliance-logs-secgroup-gelf-udp" {
  description       = "GELF over UDP"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 12201
  port_range_max    = 12201
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.appliance-logs-secgroup.id
}

