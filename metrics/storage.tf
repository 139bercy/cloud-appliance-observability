################################################################################
# Volumes
#
resource "openstack_blockstorage_volume_v2" "appliance-metrics-metrics" {
  name = "metrics"
  size = 10
}

resource "openstack_blockstorage_volume_v2" "appliance-metrics-containers" {
  name = "containers"
  size = 3
}

resource "openstack_compute_volume_attach_v2" "appliance-metrics-metrics" {
  instance_id = openstack_compute_instance_v2.appliance-metrics.id
  volume_id   = openstack_blockstorage_volume_v2.appliance-metrics-metrics.id
}

resource "openstack_compute_volume_attach_v2" "appliance-metrics-containers" {
  instance_id = openstack_compute_instance_v2.appliance-metrics.id
  volume_id   = openstack_blockstorage_volume_v2.appliance-metrics-containers.id
}

################################################################################
# Objects storage
#
resource "openstack_objectstorage_container_v1" "appliance-metrics-objects-metrics" {
  name   = "metrics"
  region = "GRA"
}
