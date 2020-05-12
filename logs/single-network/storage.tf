################################################################################
# Objects storage
#
resource "openstack_objectstorage_container_v1" "appliance-logs-objects-logs" {
  name   = "logs"
}

################################################################################
# Volumes
#
resource "openstack_blockstorage_volume_v2" "appliance-logs-elasticsearch" {
  name = "appliance-logs-elasticsearch"
  size = var.elasticsearch_size_gb
}

resource "openstack_blockstorage_volume_v2" "appliance-logs-containers" {
  name = "appliance-logs-containers"
  size = 3
}

resource "openstack_blockstorage_volume_v2" "appliance-logs-graylog" {
  name = "appliance-logs-graylog"
  size = var.graylog_size_gb
}

resource "openstack_compute_volume_attach_v2" "appliance-logs-elasticsearch" {
  instance_id = openstack_compute_instance_v2.appliance-logs.id
  volume_id   = openstack_blockstorage_volume_v2.appliance-logs-elasticsearch.id
}

resource "openstack_compute_volume_attach_v2" "appliance-logs-containers" {
  instance_id = openstack_compute_instance_v2.appliance-logs.id
  volume_id   = openstack_blockstorage_volume_v2.appliance-logs-containers.id
}

resource "openstack_compute_volume_attach_v2" "appliance-logs-graylog" {
  instance_id = openstack_compute_instance_v2.appliance-logs.id
  volume_id   = openstack_blockstorage_volume_v2.appliance-logs-graylog.id
}
