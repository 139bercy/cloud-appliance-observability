################################################################################
# Ports
#

resource "openstack_networking_port_v2" "appliance-logs-front-port" {
  name = "appliance-logs-front-port"
  security_group_ids = [
    var.default_secgroup_id,
    openstack_networking_secgroup_v2.appliance-logs-secgroup.id
  ]
  network_id = var.front_net_id
}

resource "openstack_networking_port_v2" "appliance-logs-back-port" {
  name = "appliance-logs-back-port"
  security_group_ids = [
    var.default_secgroup_id,
    openstack_networking_secgroup_v2.appliance-logs-secgroup.id
  ]
  network_id = var.back_net_id
}

