#! /usr/bin/env/bash

cat > /root/appliance/metrics/metrics.appliance.reconf.sh <<EOF
export ETC_PATH=$ETC_PATH
export REPO_PATH=$REPO_PATH

export HTTP_PROXY=$HTTP_PROXY
export NO_PROXY=$NO_PROXY
export http_proxy=$http_proxy
export no_proxy=$no_proxy

export static_hosts=$static_hosts

if echo $PLAYBOOK | egrep -qv "v$" ; then
	export PLAYBOOK="$PLAYBOOK -v"
fi

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

sed -i 's/exit 1/false/' $REPO_PATH/metrics/metrics.appliance.autoconf.sh

. $REPO_PATH/metrics/metrics.appliance.autoconf.sh
EOF

if curl -qs https://github.com 2>&1 > /dev/null ; then
	export remote_repo=internet
else
	export remote_repo=intranet
fi

ansible-galaxy install -r $ETC_PATH/appliance.ansible_requirements.${remote_repo}.yml
ansible-galaxy install -r $ETC_PATH/metrics.ansible_requirements.${remote_repo}.yml

ansible-playbook $PLAYBOOK \
	-e@$ETC_PATH/metrics.variables.yml \
	-e dnsmasq_listening_interfaces="{{['lo']|from_yaml}}"

