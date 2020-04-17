################################################################################
# Ports
#

# Front port is attached by default
resource "openstack_networking_port_v2" "appliance-metrics-front-port" {
  name = "appliance-metrics-front-port"
  security_group_ids = [
    var.default_secgroup_id
  ]
  network_id = var.front_net_id
}

# Additional port with attachement
resource "openstack_networking_port_v2" "appliance-metrics-back-port" {
  name = "appliance-metrics-back-port"
  security_group_ids = [
    var.default_secgroup_id,
    openstack_networking_secgroup_v2.appliance-metrics-secgroup.id
  ]
  network_id = var.back_net_id
}

resource "openstack_compute_interface_attach_v2" "appliance-metrics-back-port" {
  instance_id = openstack_compute_instance_v2.appliance-metrics.id
  port_id     = openstack_networking_port_v2.appliance-metrics-back-port.id
}
