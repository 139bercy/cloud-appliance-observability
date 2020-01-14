#! /usr/bin/env/bash

ansible-galaxy install -r $ETC_PATH/appliance.ansible_requirements.yml
ansible-galaxy install -r $ETC_PATH/graylog.ansible_requirements.yml

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

ansible-playbook -t elasticsearch $PLAYBOOK \
	|| exit 1

ansible-playbook -t graylog $PLAYBOOK \
	-e graylog_login_admin_local="$GRAYLOG_ADMIN_NAME" \
	-e graylog_root_password="$GRAYLOG_ADMIN_PASSWORD" \
	-e @$ETC_PATH/graylog.variables.yml \
	|| exit 1
