###############################################################################
#
# Configuration
#

GIT_REPO_URL=https://github.com/139bercy/cloud-appliance-observability
GIT_REPO_CHECKOUT=master

.PHONY: syntax # Testing YAML syntax
syntax:
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
	test -z ${GRAYLOG_SIZE_GB} \
		&& (echo ${GRAYLOG_SIZE_GB} is empty ; exit 1)
	test -z ${ELASTECSEARCH_SIZE_GB} \
		&& (echo ${ELASTECSEARCH_SIZE_GB} is empty ; exit 1)

	test -z ${OS_USERNAME} \
		&& (echo ${OS_USERNAME} is empty ; exit 1)
	test -z ${OS_PASSWORD} \
		&& (echo ${OS_PASSWORD} is empty ; exit 1)
	test -z ${OS_AUTH_URL} \
		&& (echo ${OS_AUTH_URL} is empty ; exit 1)

	test -z ${GRAYLOG_FLAVOR} \
		&& (echo ${GRAYLOG_FLAVOR} is empty ; exit 1)
	test -z ${GRAYLOG_IMAGE_ID} \
		&& (echo ${GRAYLOG_IMAGE_ID} is empty ; exit 1)
	test -z ${GRAYLOG_NET_ID} \
		&& (echo ${GRAYLOG_NET_ID} is empty ; exit 1)
	test -z $(GRAYLOG_SECGROUP_ID) \
		&& (echo ${GRAYLOG_SECGROUP_ID} is empty ; exit 1)

	test -z ${GRAYLOG_ADMIN} \
		&& (echo ${GRAYLOG_ADMIN} is empty ; exit 1)
	test -z ${GRAYLOG_PASSWORD} \
		&& (echo ${GRAYLOG_PASSWORD} is empty ; exit 1)

	test -z ${GRAYLOG_ENDPOINT} \
		&& (echo ${GRAYLOG_ENDPOINT} is empty ; exit 1)

	test -z ${GRAYLOG_HTTP_PROXY} \
		&& (echo ${GRAYLOG_HTTP_PROXY} is empty ; exit 1)
	test -z ${GRAYLOG_NO_PROXY} \
		&& (echo ${GRAYLOG_NO_PROXY} is empty ; exit 1)

	openstack stack create \
		\
		--parameter graylog_size_gb=${GRAYLOG_SIZE_GB} \
		--parameter elasticsearch_size_gb=${ELASTECSEARCH_SIZE_GB} \
		--parameter os_username=${OS_USERNAME} \
		--parameter os_password=${OS_PASSWORD} \
		--parameter os_auth_url=${OS_AUTH_URL} \
		\
		--parameter flavor=${GRAYLOG_FLAVOR} \
		--parameter image_id=${GRAYLOG_IMAGE_ID} \
		--parameter node_net_id=${GRAYLOG_NET_ID} \
		--parameter default_secgroup_id=$(GRAYLOG_SECGROUP_ID) \
		\
		--parameter graylog_admin_name=${GRAYLOG_ADMIN} \
		--parameter graylog_admin_password=${GRAYLOG_PASSWORD} \
		--parameter graylog_endpoint_url=${GRAYLOG_ENDPOINT} \
		\
		--parameter internet_http_proxy_url=${GRAYLOG_HTTP_PROXY} \
		--parameter internet_http_no_proxy=${GRAYLOG_NO_PROXY} \
		\
		--parameter git_repo_checkout=${GIT_REPO_CHECKOUT} \
		--parameter git_repo_url=${GIT_REPO_URL} \
		\
		--template ${PWD}/logs/graylog.appliance.heat.yml \
		--wait \
		\
		logs

.PHONY: metrics # 
metrics:
	exit 1

###############################################################################
#
# Maintenance
#

# Clean
.PHONY: clean-logs # Destroy the logs appliance
clean-logs:
	openstack stack list | fgrep -q logs \
		&& openstack stack delete --wait --yes logs

.PHONY: clean-logs # Destroy the metrics appliance
clean-metrics:
	openstack stack list | fgrep -q metrics \
		&& openstack stack delete --wait --yes metrics

.PHONY: clean # Destroy the appliances
clean: clean-logs clean-metrics
	@echo

# Rebuild
.PHONY: rebuild-logs # Rebuild the logs appliance
rebuild-logs:
	exit 1

.PHONY: rebuild-metrics # Rebuild the metrics appliance
rebuild-metrics:
	exit 1

.PHONY: rebuild # Rebuild all the servers at once
rebuild: rebuild-logs rebuild-metrics
	@echo

.PHONY: all # Deploy the appliances at once
all: logs metrics
	@echo
