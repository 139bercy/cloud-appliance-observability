###############################################################################
#
# Configuration
#

.PHONY: status # Get some information about what is running
status: .terraform/
	@echo "Projet: ${OS_PROJECT_NAME}"
	@echo "Cloud: ${OS_AUTH_URL}"
	@echo "#######################################################"
	@terraform show

.PHONY: help # This help message
help:
	@grep '^.PHONY: .* #' Makefile \
		| sed 's/\.PHONY: \(.*\) # \(.*\)/\1\t\2/' \
		| expand -t20 \
		| sort

###############################################################################
#
# Resources deployment
#

.terraform/:
	terraform init

.PHONY: dist-clean # Remove terraform distributions files (plugins, modules...)
dist-clean:
	rm -rf .terraform
	rm -f graph.svg

.PHONY: reinit # Download terraform artifacts again
reinit: dist-clean .terraform/
	@echo

.PHONY: clean # Destroy the appliances
clean:
	@terraform destroy

.PHONY: taint # Terraform taint appliances
taint:
	@terraform taint module.observability.module.logs_appliance.openstack_compute_instance_v2.appliance-logs
	@terraform taint module.observability.module.metrics_appliance.openstack_compute_instance_v2.appliance-metrics
	@terraform taint module.observability.module.metrics_appliance.openstack_blockstorage_volume_v2.appliance-metrics-containers
	@terraform taint module.observability.module.logs_appliance.openstack_blockstorage_volume_v2.appliance-logs-containers

plan.tfplan: .terraform/
	@terraform plan -input=false -out=plan.tfplan

.PHONY: apply # Terraform apply
apply: plan.tfplan
	@terraform apply plan.tfplan
	@rm -f plan.tfplan

.PHONY: clean-containers # Remove objects from containers
clean-containers:
	@swift list |grep metrics && for o in $$(swift list metrics | grep -v metrics) ; do swift delete metrics $o ; done || echo

.PHONY: destroy # Destroy terraform deployment
destroy: clean-containers
	@terraform destroy -input=false
	@rm -f plan.tfplan

.PHONY: force-destroy # Destroy terraform deployment
force-destroy: clean-containers
	@terraform destroy -input=false -auto-approve
	@rm -f plan.tfplan

graph.svg: .terraform/
	@which dot > /dev/null
	@terraform graph | dot -Tsvg > graph.svg

.PHONY: graph # Generate an SVG deployment graph
graph: graph.svg
	@echo graph.svg

.PHONY: test # Use molecule to test deployment
test:
	@cd logs && molecule destroy && molecule converge && molecule destroy
	@cd metrics && molecule destroy && molecule converge && molecule destroy

.PHONY: all # Deploy the appliances at once
all: apply
	@echo

