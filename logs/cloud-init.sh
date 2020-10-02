#!/bin/bash
set -x

send_logs() {
	# Sending logs to swift
	swift upload \
		--object-name "$HOSTNAME.cloud-init.$(date -u +"%Y-%m-%dT%H:%M:%SZ").log" \
		$METRICS_CONTAINER /var/log/cloud-init-output.log
	journalctl | swift upload \
		--object-name "$HOSTNAME.journal.$(date -u +"%Y-%m-%dT%H:%M:%SZ").log" \
		$METRICS_CONTAINER -
}

# Proxy
export HTTPS_PROXY=${internet_http_proxy_url}
export HTTP_PROXY=${internet_http_proxy_url}
export NO_PROXY=${internet_http_no_proxy},127.0.0.1,localhost,0.0.0.0
export https_proxy=${internet_http_proxy_url}
export http_proxy=${internet_http_proxy_url}
export no_proxy=${internet_http_no_proxy},127.0.0.1,localhost,0.0.0.0

# Install required packages to start git-ops-based auto-configuratiom
if which yum > /dev/null 2>&1 ; then
	sed -i 's/gpgcheck=1/gpgcheck=1\nproxy=_none_/g' /etc/yum.repos.d/centos.repo
	sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/epel.repo

	if [ ! -z "$HTTP_PROXY" ] ; then
		grep -q proxy= /etc/yum.conf || echo "proxy=$HTTP_PROXY" >> /etc/yum.conf
	fi

	yum install --assumeyes ansible git jq > /dev/null
	if [ $? -ne 0 ] ; then
		send_logs
		exit 1
	fi
else
	apt update > /dev/null
	apt -y install \
		ansible git jq \
		python3-swiftclient python3-openstackclient \
		unzip \
		libgpgme11 > /dev/null
	if [ $? -ne 0 ] ; then
		send_logs
		exit 1
	fi
fi

# DNS: Populate /etc/hosts
if [ ! -z "${static_hosts}" ] ; then
	echo ${static_hosts} > /tmp/static_hosts
	cat /tmp/static_hosts \
	| perl -pe 's/\[|\]|{|}//g' \
	|  tr ',' '\n' \
	| awk -F: '{print $2,$1}' \
	| awk '{print $1,$2}' \
	>> /etc/hosts
fi

# Configure ansible to work without an entire environment set
sed -i 's/~/\/root/' /etc/ansible/ansible.cfg
sed -i 's/^#remote_tmp/remote_tmp/' /etc/ansible/ansible.cfg
sed -i 's/^#local_tmp/remote_tmp/' /etc/ansible/ansible.cfg

# Create local facts folder
mkdir -p /etc/ansible/facts.d

# Clone the bootstrap git repository
export REPO_PATH=/root/appliance
export ETC_PATH=$REPO_PATH/etc
export PLAYBOOK=$REPO_PATH/logs/graylog.appliance.playbook.yml

## Set the Openstack credentials
export OS_AUTH_URL="${os_auth_url}"
export OS_PROJECT_ID=$(awk -F'"' '/project_id/ {print $4}' /run/cloud-init/instance-data.json)
export OS_USER_DOMAIN_NAME="Default"
export OS_USERNAME="${os_username}"
export OS_PASSWORD="${os_password}"
export OS_REGION_NAME="${os_region_name}"
export OS_INTERFACE=public
export OS_IDENTITY_API_VERSION=3

# Swift container
export LOGS_CONTAINER=${logs_container}

# Set the volumes' IDs
export CONTAINERS_VOLUME=${cinder_containers_volume}
export ELASTICSEARCH_VOLUME=${cinder_elasticsearch_volume}
export GRAYLOG_VOLUME=${cinder_graylog_volume}

# Set the Graylog credentials
export GRAYLOG_ADMIN_NAME="${graylog_admin_name}"
export GRAYLOG_ADMIN_PASSWORD="${graylog_admin_password}"
# Set Graylog endpoint
export GRAYLOG_ENDPOINT_URL="${graylog_endpoint_url}"

# Set Consul variables
export CONSUL_USAGE="${consul_usage}"
export CONSUL_DNS_DOMAIN="${consul_dns_domain}"
export CONSUL_DATACENTER="${consul_datacenter}"
export CONSUL_ENCRYPT="${consul_encrypt}"
export CONSUL_DNS_SERVER="${consul_dns_server}"
export CONSUL_SERVERS="${consul_servers}"
export BACK_IP="${backoffice_ip_address}"
export TRAEFIK_CONSUL_PREFIX="${traefik_consul_prefix}"

# Set InfluxDB variables
export INFLUXDB_USAGE="${influxdb_usage}"
export INFLUXDB_ENDPOINT="${influxdb_endpoint}"
export INFLUXDB_TOKEN="${influxdb_token}"
export INFLUXDB_BUCKET="${influxdb_bucket}"

# Test proxy and Openstack endpoint
if [ ! -z $HTTP_PROXY ] ; then
	curl -m1 -iks $HTTP_PROXY > /dev/null
	if [ $? -ne 0 ] ; then
		send_logs
		exit 1
	fi
fi

openstack server list
if [ $? -ne 0 ] ; then
	send_logs
	exit 1
fi
# Set NTP variables
export NTP_SERVER=${ntp_server}

# Autoconf the appliance
if curl -m1 -iks ${git_repo_url} > /dev/null ; then
	which setenforce && setenforce 0

	# Wait for udev to complete pending events (populating /dev/disk/ for example)
	time udevadm trigger
	ls -l /dev/disk/by-id | awk '/virtio/'
	time udevadm settle
	ls -l /dev/disk/by-id | awk '/virtio/'

	if git clone -b ${git_repo_checkout} ${git_repo_url} $REPO_PATH ; then
		. $REPO_PATH/logs/graylog.appliance.autoconf.sh
	else
		send_logs
		exit 1
	fi

	# Stop secure shell
	#systemctl stop ssh
	#systemctl disable ssh
else
	send_logs
	exit 1
fi

send_logs
