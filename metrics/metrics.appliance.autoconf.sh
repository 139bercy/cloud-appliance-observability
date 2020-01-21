#! /usr/bin/env/bash

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

ansible-playbook -t metrics $PLAYBOOK \
	-e@$ETC_PATH/metrics.variables.yml \
	|| exit 1
