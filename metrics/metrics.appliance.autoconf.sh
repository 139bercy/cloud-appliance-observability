#! /usr/bin/env/bash

cat > /root/appliance/metrcis/metrics.appliance.reconf.sh <<EOF
export ETC_PATH=$ETC_PATH
export REPO_PATH=$REPO_PATH

export HTTP_PROXY=$HTTP_PROXY
export NO_PROXY=$NO_PROXY
export http_proxy=$http_proxy
export no_proxy=$no_proxy

export PLAYBOOK=$PLAYBOOK

export CONTAINERS_VOLUME=$CONTAINERS_VOLUME
export METRICS_VOLUME=$METRICS_VOLUME

export METRICS_ENDPOINT_URL=$METRICS_ENDPOINT_URL
export METRICS_CONTAINER=$METRICS_CONTAINER

export GRAFANA_ADMIN_NAME=$GRAFANA_ADMIN_NAME
export GRAFANA_ADMIN_PASSWORD=$GRAFANA_ADMIN_PASSWORD

export INFLUXDB_ADMIN_NAME=$INFLUXDB_ADMIN_NAME
export INFLUXDB_ADMIN_PASSWORD=$INFLUXDB_ADMIN_PASSWORD
export INFLUXDB_ORG=$INFLUXDB_ORG
export INFLUXDB_RETENTION_HOURS=$INFLUXDB_RETENTION_HOURS

/root/appliance/metrics/metrics.appliance.autoconf.sh
EOF

ansible-galaxy install -r $ETC_PATH/appliance.ansible_requirements.yml
ansible-galaxy install -r $ETC_PATH/metrics.ansible_requirements.yml

# Sometimes cinder volumes are not linked against /dev/disk/by-id/
udevadm trigger

ansible-playbook -t os-ready $PLAYBOOK \
	-e dnsmasq_listening_interfaces="{{['lo']|from_yaml}}" \
	-e bootstrap_http_proxy="$HTTP_PROXY" \
	-e bootstrap_no_proxy="$NO_PROXY" \
	|| exit 1

ansible-playbook -t containers $PLAYBOOK \
	-e podman_http_proxy="$HTTP_PROXY" \
	-e podman_no_proxy="$NO_PROXY" \
	|| exit 1

ansible-playbook -t metrics,configuration $PLAYBOOK \
	-e@$ETC_PATH/metrics.variables.yml \
	|| exit 1
