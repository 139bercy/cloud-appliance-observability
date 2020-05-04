###############################################################################
#
# Configuration
#

GIT_REPO_URL=$(shell git remote get-url origin)
#GIT_REPO_CHECKOUT=$(shell git rev-parse --abbrev-ref HEAD)

.PHONY: syntax # Testing YAML syntax
syntax:
	@which ansible-lint
	@find . -type f -name "*.playbook.yml" -exec ansible-lint {} \;

.PHONY: test # Testing YAML syntax, env variables and openstack connectivity
test: syntax
	@openstack stack list 1>/dev/null

.PHONY: status # Get some information about what is running
status:
	@echo "Projet: ${OS_PROJECT_NAME}"
	@echo "Cloud: ${OS_AUTH_URL}"
	@echo "#######################################################"
	@openstack stack list

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
.PHONY: logs # Configure graylog service
logs:
	@test ! -z ${GRAYLOG_SIZE_GB} \
		|| (echo GRAYLOG_SIZE_GB is empty ; exit 1)
	@test ! -z ${ELASTECSEARCH_SIZE_GB} \
		|| (echo ELASTECSEARCH_SIZE_GB is empty ; exit 1)

	# TODO: check OS_USERNAME instead of OS_USERNAME when swift is used
	@test ! -z ${OS_USERNAME} \
		|| (echo OS_USERNAME is empty ; exit 1)
	# TODO: check OS_PASSWORD instead of OS_PASSWORD when swift is used
	@test ! -z ${OS_PASSWORD} \
		|| (echo OS_PASSWORD is empty ; exit 1)
	# TODO: check OS_AUTH_URL instead of OS_AUTH_URL when swift is used
	@test ! -z ${OS_AUTH_URL} \
		|| (echo OS_AUTH_URL is empty ; exit 1)

	@test ! -z ${GRAYLOG_FLAVOR_ID} \
		|| (echo GRAYLOG_FLAVOR_ID is empty ; exit 1)
	@test ! -z ${GRAYLOG_IMAGE_ID} \
		|| (echo GRAYLOG_IMAGE_ID is empty ; exit 1)
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
		|| (echo GRAYLOG_ENDPOINT must begin with http:// or https:// ; exit 1)

	@test ! -z ${INTERNET_HTTP_PROXY_URL} \
		|| (echo INTERNET_HTTP_PROXY_URL is empty ; exit 1)
	@test ! -z ${INTERNET_HTTP_NO_PROXY} \
		|| (echo INTERNET_HTTP_NO_PROXY is empty ; exit 1)

	@echo ${GRAYLOG_CONSUL_USAGE} | egrep -q "^(true|false)$$" \
		|| ( echo GRAYLOG_CONSUL_USAGE must be set to true or false ; exit 1)
	@(test -z ${GRAYLOG_CONSUL_DNS_DOMAIN} && echo ${GRAYLOG_CONSUL_USAGE} | fgrep true ) \
		&& ( echo GRAYLOG_CONSUL_DNS_DOMAIN is empty ; exit 1) \
		|| true
	@(test -z ${GRAYLOG_CONSUL_DATACENTER} && echo ${GRAYLOG_CONSUL_USAGE} | fgrep true ) \
		&& ( echo GRAYLOG_CONSUL_DATACENTER is empty ; exit 1) \
		|| true
	@(test -z ${GRAYLOG_CONSUL_ENCRYPT} && echo ${GRAYLOG_CONSUL_USAGE} | fgrep true ) \
		&& ( echo GRAYLOG_CONSUL_ENCRYPT is empty ; exit 1) \
		|| true
	@(test -z ${GRAYLOG_CONSUL_DNS_SERVER} && echo ${GRAYLOG_CONSUL_USAGE} | fgrep true ) \
		&& ( echo GRAYLOG_CONSUL_DNS_SERVER is empty ; exit 1) \
		|| true

	@openstack stack create \
		\
		--parameter graylog_size_gb=${GRAYLOG_SIZE_GB} \
		--parameter elasticsearch_size_gb=${ELASTECSEARCH_SIZE_GB} \
		\
		--parameter flavor=${GRAYLOG_FLAVOR_ID} \
		--parameter image_id=${GRAYLOG_IMAGE_ID} \
		--parameter node_net_id=${GRAYLOG_NET_ID} \
		--parameter default_secgroup_id=$(GRAYLOG_SECGROUP_ID) \
		\
		--parameter graylog_admin_name=${GRAYLOG_ADMIN} \
		--parameter graylog_admin_password=${GRAYLOG_PASSWORD} \
		--parameter graylog_endpoint_url=${GRAYLOG_ENDPOINT} \
		\
		--parameter internet_http_proxy_url=${INTERNET_HTTP_PROXY_URL} \
		--parameter internet_http_no_proxy=${INTERNET_HTTP_NO_PROXY} \
		\
		--parameter git_repo_checkout=${GIT_REPO_CHECKOUT} \
		--parameter git_repo_url=${GIT_REPO_URL} \
		\
		--parameter consul_usage=${GRAYLOG_CONSUL_USAGE} \
		--parameter consul_dns_domain=${GRAYLOG_CONSUL_DNS_DOMAIN} \
		--parameter consul_datacenter=${GRAYLOG_CONSUL_DATACENTER} \
		--parameter consul_encrypt=${GRAYLOG_CONSUL_ENCRYPT} \
		--parameter consul_dns_server=${GRAYLOG_CONSUL_DNS_SERVER} \
		\
		--template ${PWD}/logs/graylog.appliance.heat.yml \
		--wait \
		--timeout 60 \
		\
		logs

.PHONY: metrics # Configure metrics service
metrics:
	@test ! -z ${METRICS_SIZE_GB} \
		|| (echo METRICS_SIZE_GB is empty ; exit 1)

	@test ! -z ${OS_USERNAME} \
		|| (echo OS_USERNAME is empty ; exit 1)
	@test ! -z ${OS_PASSWORD} \
		|| (echo OS_PASSWORD is empty ; exit 1)
	@test ! -z ${OS_AUTH_URL} \
		|| (echo OS_AUTH_URL is empty ; exit 1)

	@test ! -z ${METRICS_FLAVOR_ID} \
		|| (echo METRICS_FLAVOR_ID is empty ; exit 1)
	@test ! -z ${METRICS_IMAGE_ID} \
		|| (echo METRICS_IMAGE_ID is empty ; exit 1) 
	@test ! -z ${METRICS_SECGROUP_ID} \
		|| (echo METRICS_SECGROUP_ID is empty ; exit 1) 

	@test ! -z ${GRAFANA_ADMIN_NAME} \
		|| (echo GRAFANA_ADMIN_NAME is empty ; exit 1) 
	@test ! -z ${GRAFANA_ADMIN_PASSWORD} \
		|| (echo GRAFANA_ADMIN_PASSWORD is empty ; exit 1) 
	@test ! -z ${INFLUXDB_ADMIN_NAME} \
		|| (echo INFLUXDB_ADMIN_NAME is empty ; exit 1) 
	@test ! -z ${INFLUXDB_ADMIN_PASSWORD} \
		|| (echo INFLUXDB_ADMIN_PASSWORD is empty ; exit 1)
	@test ! -z ${INFLUXDB_ORGANISATION} \
		|| (echo INFLUXDB_ORGANISATION is empty ; exit 1)

	@test ! -z ${METRICS_ENDPOINT_URL} \
		|| (echo METRICS_ENDPOINT_URL is empty ; exit 1) 

	@echo ${CONSUL_USAGE} | egrep -q "^(true|false)$$" \
		|| ( echo CONSUL_USAGE must be set to true or false ; exit 1)
	@(test -z ${CONSUL_DNS_DOMAIN} && echo ${CONSUL_USAGE} | fgrep true ) \
		&& ( echo CONSUL_DNS_DOMAIN is empty ; exit 1) \
		|| true
	@(test -z ${CONSUL_DATACENTER} && echo ${CONSUL_USAGE} | fgrep true ) \
		&& ( echo CONSUL_DATACENTER is empty ; exit 1) \
		|| true
	@(test -z ${CONSUL_ENCRYPT} && echo ${CONSUL_USAGE} | fgrep true ) \
		&& ( echo CONSUL_ENCRYPT is empty ; exit 1) \
		|| true
	@(test -z ${CONSUL_DNS_SERVER} && echo ${CONSUL_USAGE} | fgrep true ) \
		&& ( echo CONSUL_DNS_SERVER is empty ; exit 1) \
		|| true
			
	openstack stack create \
		\
		--parameter metrics_size_gb=${METRICS_SIZE_GB} \
		\
		--parameter flavor=${METRICS_FLAVOR_ID} \
		--parameter image_id=${METRICS_IMAGE_ID} \
		--parameter front_net_id=${METRICS_FRONT_NET_ID} \
		--parameter back_net_id=${METRICS_BACK_NET_ID} \
		--parameter default_secgroup_id=$(METRICS_SECGROUP_ID) \
		--parameter os_username=$(OS_USERNAME) \
		--parameter os_password=$(OS_PASSWORD) \
		--parameter os_auth_url=$(OS_AUTH_URL) \
		--parameter os_region_name=$(OS_REGION_NAME) \
		\
		--parameter grafana_admin_name=${GRAFANA_ADMIN_NAME} \
		--parameter grafana_admin_password=${GRAFANA_ADMIN_PASSWORD} \
		\
		--parameter influxdb_admin_name=${INFLUXDB_ADMIN_NAME} \
		--parameter influxdb_admin_password=${INFLUXDB_ADMIN_PASSWORD} \
		--parameter influxdb_organisation=${INFLUXDB_ORGANISATION} \
		--parameter influxdb_retention_hours=${INFLUXDB_RETENTION_HOURS} \
		--parameter metrics_endpoint_url=${METRICS_ENDPOINT_URL} \
		--parameter metrics_container=${METRICS_CONTAINER} \
		\
		--parameter internet_http_proxy_url=${INTERNET_HTTP_PROXY_URL} \
		--parameter internet_http_no_proxy=${INTERNET_HTTP_NO_PROXY} \
		--parameter static_hosts=${STATIC_HOSTS} \
		--parameter ntp_server=${METRICS_NTP_SERVER} \
		\
		--parameter git_repo_checkout=${GIT_REPO_CHECKOUT} \
		--parameter git_repo_url=${GIT_REPO_URL} \
		\
		--parameter consul_usage=${CONSUL_USAGE} \
		--parameter consul_dns_domain=${CONSUL_DNS_DOMAIN} \
		--parameter consul_datacenter=${CONSUL_DATACENTER} \
		--parameter consul_encrypt=${CONSUL_ENCRYPT} \
		--parameter consul_dns_server=${CONSUL_DNS_SERVER} \
		\
		--template ${PWD}/metrics/metrics.appliance.heat.yml \
		--wait \
		--timeout 60 \
		\
		metrics

###############################################################################
#
# Maintenance
#

# Prepare
.PHONY: prepare # Download atifacts from internet to Swift
prepare:
	@./bin/copy_binaries.sh
	@./bin/copy_packages.sh
	@./bin/copy_containers.sh

# Clean
.PHONY: clean-logs # Destroy the logs appliance
clean-logs:
	@openstack stack list | fgrep -q logs \
		&& openstack stack delete --wait --yes logs \
		|| echo

.PHONY: clean-metrics # Destroy the metrics appliance
clean-metrics:
	@openstack stack list | fgrep -q metrics \
		&& openstack stack delete --wait --yes metrics \
		|| echo

.PHONY: clean # Destroy the appliances
clean: clean-logs clean-metrics
	@echo

# Rebuild
.PHONY: rebuild-logs # Rebuild the logs appliance
rebuild-logs:
	@openstack server rebuild --wait graylog

.PHONY: rebuild-metrics # Rebuild the metrics appliance
rebuild-metrics:
	@openstack server rebuild --wait metrics

.PHONY: rebuild # Rebuild all the servers at once
rebuild: rebuild-logs rebuild-metrics
	@echo

.PHONY: all # Deploy the appliances at once
all: logs metrics
	@echo
