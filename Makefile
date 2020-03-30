###############################################################################
#
# Configuration
#

GIT_REPO_CHECKOUT=$(shell git rev-parse --abbrev-ref HEAD)

.PHONY: test # Test terraform pre-requisites
test:
	@which terraform

.PHONY: syntax # Testing Ansible and HCL syntaxes (ansible-lint + terraform fmt)
syntax:
	@which ansible-lint
	@ansible-lint \
		etc/graylog.variables.yml \
		logs/graylog.appliance.playbook.yml
	@ansible-lint \
		etc/metrics.variables.yml \
		metrics/metrics.appliance.playbook.yml
	@terraform fmt -check=true -recursive=true

.PHONY: status # Get some information about what is running
status:
	@test -f logs/single-network/terraform.tfstate \
		&& cd logs/single-network/ \
		&& terraform show \
		|| true
	@test -f logs/dual-network/terraform.tfstate \
		&& cd logs/dual-network/ \
		&& terraform show \
		|| true
	@test -f metrics/single-network/terraform.tfstate \
		&& cd metrics/single-network/ \
		&& terraform show
	@test -f metrics/dual-network/terraform.tfstate \
		&& cd metrics/dual-network/ \
		&& terraform show \
		|| true

.PHONY: help # This help message
help:
	@grep '^.PHONY: .* #' Makefile \
		| sed 's/\.PHONY: \(.*\) # \(.*\)/\1\t\2/' \
		| expand -t20 \
		| sort

###############################################################################
#
# Hosted services
#
.PHONY: metrics-check # Check metrics env variables
metrics-check:
	@test ! -z ${METRICS_SIZE_GB} \
		|| (echo METRICS_SIZE_GB is empty ; exit 1)

	@test ! -z ${METRICS_OS_USERNAME} \
		|| (echo METRICS_OS_USERNAME is empty ; exit 1)
	@test ! -z ${METRICS_OS_PASSWORD} \
		|| (echo METRICS_OS_PASSWORD is empty ; exit 1)
	@test ! -z ${METRICS_OS_AUTH_URL} \
		|| (echo METRICS_OS_AUTH_URL is empty ; exit 1)

	@test ! -z ${METRICS_FLAVOR} \
		|| (echo METRICS_FLAVOR is empty ; exit 1)
	@test ! -z ${METRICS_IMAGE_ID} \
		|| (echo METRICS_IMAGE_ID is empty ; exit 1)
	@test ! -z ${METRICS_FRONT_NET_ID} \
		|| (echo METRICS_FRONT_NET_ID is empty ; exit 1)
	@test ! -z ${METRICS_SECGROUP_ID} \
		|| (echo METRICS_SECGROUP_ID is empty ; exit 1)

	@test ! -z ${GRAFANA_ADMIN} \
		|| (echo GRAFANA_ADMIN is empty ; exit 1)
	@test ! -z ${GRAFANA_PASSWORD} \
		|| (echo GRAFANA_PASSWORD is empty ; exit 1)
	@test ! -z ${INFLUXDB_ADMIN} \
		|| (echo INFLUXDB_ADMIN is empty ; exit 1)
	@test ! -z ${INFLUXDB_PASSWORD} \
		|| (echo INFLUXDB_PASSWORD is empty ; exit 1)
	@test ! -z ${INFLUXDB_ORG} \
		|| (echo INFLUXDB_ORG is empty ; exit 1)
	@test ! -z ${INFLUXDB_RETENTION_HOURS} \
		|| (echo INFLUXDB_RETENTION_HOURS is empty ; exit 1)

	@test ! -z ${METRICS_ENDPOINT} \
		|| (echo METRICS_ENDPOINT is empty ; exit 1)

	@echo ${METRICS_CONSUL_USAGE} | egrep -q "^(true|false)$$" \
		|| ( echo METRICS_CONSUL_USAGE must be set to true or false ; \
			exit 1)
	@(test -z ${METRICS_CONSUL_DNS_DOMAIN} && echo ${METRICS_CONSUL_USAGE} \
		| fgrep true ) \
		&& ( echo METRICS_CONSUL_DNS_DOMAIN is empty ; exit 1) \
		|| true
	@(test -z ${METRICS_CONSUL_DATACENTER} && echo ${METRICS_CONSUL_USAGE} \
		| fgrep true ) \
		&& ( echo METRICS_CONSUL_DATACENTER is empty ; exit 1) \
		|| true
	@(test -z ${METRICS_CONSUL_ENCRYPT} && echo ${METRICS_CONSUL_USAGE} \
		| fgrep true ) \
		&& ( echo METRICS_CONSUL_ENCRYPT is empty ; exit 1) \
		|| true
	@(test -z ${METRICS_CONSUL_DNS_SERVER} && echo ${METRICS_CONSUL_USAGE} \
		| fgrep true ) \
		&& ( echo METRICS_CONSUL_DNS_SERVER is empty ; exit 1) \
		|| true

.PHONY: logs-check # Check graylog env variables
logs-check:
	@test ! -z ${GRAYLOG_SIZE_GB} \
		|| (echo GRAYLOG_SIZE_GB is empty ; exit 1)
	@test ! -z ${ELASTECSEARCH_SIZE_GB} \
		|| (echo ELASTECSEARCH_SIZE_GB is empty ; exit 1)

	@test ! -z ${GRAYLOG_OS_USERNAME} \
		|| (echo OS_USERNAME is empty ; exit 1)
	@test ! -z ${GRAYLOG_OS_PASSWORD} \
		|| (echo OS_PASSWORD is empty ; exit 1)
	@test ! -z ${GRAYLOG_OS_AUTH_URL} \
		|| (echo OS_AUTH_URL is empty ; exit 1)

	@test ! -z ${GRAYLOG_FLAVOR} \
		|| (echo GRAYLOG_FLAVOR is empty ; exit 1)
	@test ! -z ${GRAYLOG_IMAGE_ID} \
		|| (echo GRAYLOG_IMAGE_ID is empty ; exit 1)
	@test ! -z ${GRAYLOG_FRONT_NET_ID} \
		|| (echo GRAYLOG_FRONT_NET_ID is empty ; exit 1)
	@test ! -z ${GRAYLOG_SECGROUP_ID} \
		|| (echo GRAYLOG_SECGROUP_ID is empty ; exit 1)

	@test ! -z ${GRAYLOG_ADMIN} \
		|| (echo GRAYLOG_ADMIN is empty ; exit 1)
	@test ! -z ${GRAYLOG_PASSWORD} \
		|| (echo GRAYLOG_PASSWORD is empty ; exit 1)
	@test ! -z ${GRAYLOG_ENDPOINT} \
		|| (echo GRAYLOG_ENDPOINT is empty ; exit 1)
	@echo ${GRAYLOG_ENDPOINT} | grep -q /$$ \
		|| (echo GRAYLOG_ENDPOINT must end with a / ; exit 1)
	@echo ${GRAYLOG_ENDPOINT} | egrep -q "^(https|http)://" \
		|| (echo GRAYLOG_ENDPOINT must begin with http(s):// ; exit 1)

#	@test ! -z ${GRAYLOG_HTTP_PROXY} \
#		|| (echo GRAYLOG_HTTP_PROXY is empty ; exit 1)
#	@test ! -z ${GRAYLOG_NO_PROXY} \
#		|| (echo GRAYLOG_NO_PROXY is empty ; exit 1)

	@echo ${GRAYLOG_CONSUL_USAGE} | egrep -q "^(true|false)$$" \
		|| ( echo GRAYLOG_CONSUL_USAGE must be set to true or false ; \
		exit 1)
	@(test -z ${GRAYLOG_CONSUL_DNS_DOMAIN} && echo ${GRAYLOG_CONSUL_USAGE} \
		| fgrep true ) \
		&& ( echo GRAYLOG_CONSUL_DNS_DOMAIN is empty ; exit 1) \
		|| true
	@(test -z ${GRAYLOG_CONSUL_DATACENTER} && echo ${GRAYLOG_CONSUL_USAGE} \
		| fgrep true ) \
		&& ( echo GRAYLOG_CONSUL_DATACENTER is empty ; exit 1) \
		|| true
	@(test -z ${GRAYLOG_CONSUL_ENCRYPT} && echo ${GRAYLOG_CONSUL_USAGE} \
		| fgrep true ) \
		&& ( echo GRAYLOG_CONSUL_ENCRYPT is empty ; exit 1) \
		|| true
	@(test -z ${GRAYLOG_CONSUL_DNS_SERVER} && echo ${GRAYLOG_CONSUL_USAGE} \
		| fgrep true ) \
		&& ( echo GRAYLOG_CONSUL_DNS_SERVER is empty ; exit 1) \
		|| true

logs/single-network/.terraform:
	cd logs/single-network/ && terraform init

logs/dual-network/.terraform:
	cd logs/dual-network/ && terraform init

.PHONY: logs-single-network # Configure logs service
logs-single-network: logs-check logs/single-network/.terraform
	@cd logs/single-network && terraform plan -input=false -out=logs.tfplan \
		\
		-var graylog_size_gb=${GRAYLOG_SIZE_GB} \
		-var elasticsearch_size_gb=${ELASTECSEARCH_SIZE_GB} \
		\
		-var flavor=${GRAYLOG_FLAVOR} \
		-var image_id=${GRAYLOG_IMAGE_ID} \
		-var front_net_id=${GRAYLOG_FRONT_NET_ID} \
		-var default_secgroup_id=$(GRAYLOG_SECGROUP_ID) \
		-var os_username=$(GRAYLOG_OS_USERNAME) \
		-var os_password=$(GRAYLOG_OS_PASSWORD) \
		-var os_auth_url=$(GRAYLOG_OS_AUTH_URL) \
		-var os_region_name=${GRAYLOG_OS_REGION_NAME} \
		\
		-var graylog_admin_name=${GRAYLOG_ADMIN} \
		-var graylog_admin_password=${GRAYLOG_PASSWORD} \
		-var graylog_endpoint_url=${GRAYLOG_ENDPOINT} \
		\
		-var internet_http_proxy_url=${GRAYLOG_HTTP_PROXY} \
		-var internet_http_no_proxy=${GRAYLOG_NO_PROXY} \
		\
		-var git_repo_checkout=${GIT_REPO_CHECKOUT} \
		-var git_repo_url=${GIT_REPO_URL} \
		\
		-var consul_usage=${GRAYLOG_CONSUL_USAGE} \
		-var consul_servers=${GRAYLOG_CONSUL_SERVERS} \
		-var consul_dns_domain=${GRAYLOG_CONSUL_DNS_DOMAIN} \
		-var consul_datacenter=${GRAYLOG_CONSUL_DATACENTER} \
		-var consul_encrypt=${GRAYLOG_CONSUL_ENCRYPT} \
		-var consul_dns_server=${GRAYLOG_CONSUL_DNS_SERVER}
		\
		-var influxdb_usage=${GRAYLOG_INFLUXDB_USAGE} \
		-var influxdb_endpoint=${GRAYLOG_INFLUXDB_ENDPOINT} \
		-var influxdb_token=${GRAYLOG_INFLUXDB_TOKEN} \
		-var influxdb_org=${GRAYLOG_INFLUXDB_ORG} \
		-var influxdb_bucket=${GRAYLOG_INFLUXDB_BUCKET}

	@cd logs/single-network && terraform apply logs.tfplan

metrics/single-network/.terraform:
	cd metrics/single-network/ && terraform init

metrics/dual-network/.terraform:
	cd metrics/dual-network/ && terraform init

.PHONY: metrics-single-network # Configure metrics service
metrics-single-network: metrics-check metrics/single-network/.terraform
	@cd metrics/single-network && terraform plan -input=false -out=metrics.tfplan \
		\
		-var metrics_size_gb=${METRICS_SIZE_GB} \
		\
		-var flavor=${METRICS_FLAVOR} \
		-var image_id=${METRICS_IMAGE_ID} \
		-var front_net_id=${METRICS_FRONT_NET_ID} \
		-var default_secgroup_id=$(METRICS_SECGROUP_ID) \
		-var os_username=$(METRICS_OS_USERNAME) \
		-var os_password=$(METRICS_OS_PASSWORD) \
		-var os_auth_url=$(METRICS_OS_AUTH_URL) \
		-var os_region_name=${METRICS_OS_REGION_NAME} \
		\
		-var grafana_admin_name=${GRAFANA_ADMIN} \
		-var grafana_admin_password=${GRAFANA_PASSWORD} \
		\
		-var influxdb_admin_name=${INFLUXDB_ADMIN} \
		-var influxdb_admin_password=${INFLUXDB_PASSWORD} \
		-var influxdb_organisation=${INFLUXDB_ORG} \
		-var influxdb_retention_hours=${INFLUXDB_RETENTION_HOURS} \
		-var metrics_endpoint_url=${METRICS_ENDPOINT} \
		-var metrics_container=${METRICS_CONTAINER} \
		\
		-var internet_http_proxy_url=${METRICS_HTTP_PROXY} \
		-var internet_http_no_proxy=${METRICS_NO_PROXY} \
		-var static_hosts=${METRICS_STATIC_HOSTS} \
		-var ntp_server=${METRICS_NTP_SERVER} \
		\
		-var git_repo_checkout=${GIT_REPO_CHECKOUT} \
		-var git_repo_url=${GIT_REPO_URL} \
		\
		-var consul_usage=${METRICS_CONSUL_USAGE} \
		-var consul_dns_domain=${METRICS_CONSUL_DNS_DOMAIN} \
		-var consul_datacenter=${METRICS_CONSUL_DATACENTER} \
		-var consul_encrypt=${METRICS_CONSUL_ENCRYPT} \
		-var consul_dns_server=${METRICS_CONSUL_DNS_SERVER}

	@cd metrics/single-network && terraform apply metrics.tfplan

###############################################################################
#
# Maintenance
#

# Prepare
.PHONY: prepare # Download atifacts from internet to Swift
prepare:
	@which skopeo
	@which swift
	@which wget
	@ansible-galaxy

	@./bin/copy_binaries.sh
	@./bin/copy_packages.sh
	@./bin/copy_containers.sh

# Clean
.PHONY: clean-metrics-single # Destroy the logs appliance
clean-metrics-single:
	@cd metrics/single-network && terraform destroy -auto-approve \
		\
		-var metrics_size_gb=${METRICS_SIZE_GB} \
		\
		-var flavor=${METRICS_FLAVOR} \
		-var image_id=${METRICS_IMAGE_ID} \
		-var front_net_id=${METRICS_FRONT_NET_ID} \
		-var default_secgroup_id=$(METRICS_SECGROUP_ID) \
		-var os_username=$(METRICS_OS_USERNAME) \
		-var os_password=$(METRICS_OS_PASSWORD) \
		-var os_auth_url=$(METRICS_OS_AUTH_URL) \
		-var os_region_name=${METRICS_OS_REGION_NAME} \
		\
		-var grafana_admin_name=${GRAFANA_ADMIN} \
		-var grafana_admin_password=${GRAFANA_PASSWORD} \
		\
		-var influxdb_admin_name=${INFLUXDB_ADMIN} \
		-var influxdb_admin_password=${INFLUXDB_PASSWORD} \
		-var influxdb_organisation=${INFLUXDB_ORG} \
		-var influxdb_retention_hours=${INFLUXDB_RETENTION_HOURS} \
		-var metrics_endpoint_url=${METRICS_ENDPOINT} \
		-var metrics_container=${METRICS_CONTAINER} \
		\
		-var internet_http_proxy_url=${METRICS_HTTP_PROXY} \
		-var internet_http_no_proxy=${METRICS_NO_PROXY} \
		-var static_hosts=${METRICS_STATIC_HOSTS} \
		-var ntp_server=${METRICS_NTP_SERVER} \
		\
		-var git_repo_checkout=${GIT_REPO_CHECKOUT} \
		-var git_repo_url=${GIT_REPO_URL} \
		\
		-var consul_usage=${METRICS_CONSUL_USAGE} \
		-var consul_dns_domain=${METRICS_CONSUL_DNS_DOMAIN} \
		-var consul_datacenter=${METRICS_CONSUL_DATACENTER} \
		-var consul_encrypt=${METRICS_CONSUL_ENCRYPT} \
		-var consul_dns_server=${METRICS_CONSUL_DNS_SERVER}

.PHONY: clean-logs-single-network # Destroy logs service
clean-logs-single-network: logs-check
	@cd logs/single-network && terraform destroy -auto-approve \
		\
		-var graylog_size_gb=${GRAYLOG_SIZE_GB} \
		-var elasticsearch_size_gb=${ELASTECSEARCH_SIZE_GB} \
		\
		-var flavor=${GRAYLOG_FLAVOR} \
		-var image_id=${GRAYLOG_IMAGE_ID} \
		-var front_net_id=${GRAYLOG_FRONT_NET_ID} \
		-var default_secgroup_id=$(GRAYLOG_SECGROUP_ID) \
		-var os_username=$(GRAYLOG_OS_USERNAME) \
		-var os_password=$(GRAYLOG_OS_PASSWORD) \
		-var os_auth_url=$(GRAYLOG_OS_AUTH_URL) \
		-var os_region_name=${GRAYLOG_OS_REGION_NAME} \
		\
		-var graylog_admin_name=${GRAYLOG_ADMIN} \
		-var graylog_admin_password=${GRAYLOG_PASSWORD} \
		-var graylog_endpoint_url=${GRAYLOG_ENDPOINT} \
		\
		-var internet_http_proxy_url=${GRAYLOG_HTTP_PROXY} \
		-var internet_http_no_proxy=${GRAYLOG_NO_PROXY} \
		\
		-var git_repo_checkout=${GIT_REPO_CHECKOUT} \
		-var git_repo_url=${GIT_REPO_URL} \
		\
		-var consul_usage=${GRAYLOG_CONSUL_USAGE} \
		-var consul_servers=${GRAYLOG_CONSUL_SERVERS} \
		-var consul_dns_domain=${GRAYLOG_CONSUL_DNS_DOMAIN} \
		-var consul_datacenter=${GRAYLOG_CONSUL_DATACENTER} \
		-var consul_encrypt=${GRAYLOG_CONSUL_ENCRYPT} \
		-var consul_dns_server=${GRAYLOG_CONSUL_DNS_SERVER}

# TODO: write clean target
.PHONY: clean

# Rebuild
# TODO: use terraform taint
.PHONY: rebuild-logs # Rebuild the logs appliance
rebuild-logs:
	@openstack server rebuild --wait graylog

.PHONY: rebuild-metrics # Rebuild the metrics appliance
rebuild-metrics:
	@openstack server rebuild --wait metrics

.PHONY: rebuild # Rebuild all the servers at once
rebuild: rebuild-logs rebuild-metrics
	@echo
