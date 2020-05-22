#! /usr/bin/env/bash

cat > /root/appliance/logs/graylog.appliance.reconf.sh <<EOF
export ETC_PATH=$ETC_PATH
export REPO_PATH=$REPO_PATH

export HTTP_PROXY=$HTTP_PROXY
export NO_PROXY=$NO_PROXY
export http_proxy=$http_proxy
export no_proxy=$no_proxy

if echo $PLAYBOOK | egrep -qv "v$" ; then
	export PLAYBOOK="$PLAYBOOK -v"
fi

export CONTAINERS_VOLUME=$CONTAINERS_VOLUME
export ELASTICSEARCH_VOLUME=$ELASTICSEARCH_VOLUME
export GRAYLOG_ADMIN_NAME="$GRAYLOG_ADMIN_NAME"
export GRAYLOG_ADMIN_PASSWORD="$GRAYLOG_ADMIN_PASSWORD"
export GRAYLOG_ENDPOINT_URL="$GRAYLOG_ENDPOINT_URL"
export GRAYLOG_VOLUME=$GRAYLOG_VOLUME

export OS_AUTH_URL=$OS_AUTH_URL
export OS_IDENTITY_API_VERSION=$OS_IDENTITY_API_VERSION
export OS_INTERFACE=$OS_INTERFACE
export OS_PASSWORD=$OS_PASSWORD
export OS_PROJECT_DOMAIN_ID=$OS_PROJECT_DOMAIN_ID
export OS_PROJECT_ID=$OS_PROJECT_ID
export OS_PROJECT_NAME=$OS_PROJECT_NAME
export OS_REGION_NAME=$OS_REGION_NAME
export OS_USERNAME=$OS_USERNAME
export OS_USER_DOMAIN_NAME=$OS_USER_DOMAIN_NAME

export CONSUL_USAGE=$CONSUL_USAGE
export CONSUL_SERVERS=$CONSUL_SERVERS
export CONSUL_DNS_DOMAIN=$CONSUL_DNS_DOMAIN
export CONSUL_DATACENTER=$CONSUL_DATACENTER
export CONSUL_ENCRYPT=$CONSUL_ENCRYPT

sed -i 's/exit 1/false/' $REPO_PATH/logs/graylog.appliance.autoconf.sh

. $REPO_PATH/logs/graylog.appliance.autoconf.sh
EOF

if curl -qs https://github.com 2>&1 > /dev/null ; then
	export remote_repo=internet
else
	export remote_repo=intranet
fi

ansible-galaxy install -r $ETC_PATH/appliance.ansible_requirements.${remote_repo}.yml
ansible-galaxy install -r $ETC_PATH/graylog.ansible_requirements.${remote_repo}.yml

ansible-playbook $PLAYBOOK \
	-e @$ETC_PATH/graylog.variables.yml \
	-e dnsmasq_listening_interfaces="{{['lo']|from_yaml}}" \
	|| exit 1

