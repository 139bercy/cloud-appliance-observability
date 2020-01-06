#! /usr/bin/env/bash

ansible-galaxy install -r $ETC_PATH/appliance.ansible_requirements.yml

ansible-playbook -t os-ready $PLAYBOOK \
	-e dnsmasq_listening_interfaces="{{['lo']|from_yaml}}" \
	-e bootstrap_http_proxy="$HTTP_PROXY" \
	-e bootstrap_no_proxy="$NO_PROXY"

ansible-playbook -t docker $PLAYBOOK \
	-e docker_http_proxy="$HTTP_PROXY" \
	-e docker_no_proxy="$NO_PROXY"

ansible-playbook -t elasticsearch $PLAYBOOK

ansible-playbook -t graylog $PLAYBOOK \
	-e graylog_login_admin_local="$GRAYLOG_ADMIN_NAME" \
	-e graylog_root_password="$GRAYLOG_ADMIN_PASSWORD"
