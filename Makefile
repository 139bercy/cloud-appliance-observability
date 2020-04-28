TF_DOCS_OPTS = 	markdown \
		--sort-by-required \
		--indent 1 table

.PHONY: help # This help message
help:
	@grep '^.PHONY: .* #' Makefile \
	| sed 's/\.PHONY: \(.*\) # \(.*\)/\1\t\2/' \
	| expand -t20 \
	| sort

.PHONY: test # Test syntax using terraform fmt
test:
	which terraform
	terraform fmt -check=true -write=false -diff=true .
	terraform fmt -check=true -write=false -diff=true metrics
	terraform fmt -check=true -write=false -diff=true logs

.PHONY: docs # Generate README.md using terrafom-docs
docs:
	which terraform-docs
	terraform-docs $(TF_DOCS_OPTS) . > README.md
	terraform-docs $(TF_DOCS_OPTS) metrics > metrics/README.md
	terraform-docs $(TF_DOCS_OPTS) logs > logs/README.md

.PHONY: all # Run test and docs
all: test docs
	@echo

