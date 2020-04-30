################################################################################
# Ports
#

resource "openstack_networking_port_v2" "appliance-metrics-front-port" {
  name = "appliance-metrics-front-port"
  security_group_ids = [
    var.default_secgroup_id
  ]
  network_id = var.front_net_id
}

resource "openstack_networking_port_v2" "appliance-metrics-back-port" {
  name = "appliance-metrics-back-port"
  security_group_ids = [
    var.default_secgroup_id,
    openstack_networking_secgroup_v2.appliance-metrics-secgroup.id
  ]
  network_id = var.back_net_id
}

