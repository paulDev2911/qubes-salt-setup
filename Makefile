.PHONY: help install validate test clean backup docs

SHELL := /bin/bash
SALT_DIR := salt/
DOM0_SALT := /srv/salt/

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: validate ## Install Salt states to dom0
	@echo "Installing Salt states..."
	sudo qubesctl top.enable qubes-salt-setup
	sudo qubesctl --all state.highstate

validate: ## Validate Salt syntax
	@echo "Validating Salt states..."
	@find $(SALT_DIR) -name "*.sls" -exec salt-call --local state.show_sls {} \;

test: ## Run tests
	@echo "Running tests..."
	pytest tests/

clean: ## Clean temporary files
	@echo "Cleaning..."
	find . -name "*.swp" -delete
	find . -name "__pycache__" -type d -exec rm -rf {} +

backup: ## Create backup
	@echo "Creating backup..."
	tar -czf backup-$(shell date +%Y%m%d-%H%M%S).tar.gz $(SALT_DIR)

docs: ## Generate documentation
	@echo "Generating docs..."
	# Add your doc generation here

dev-setup: ## Setup development environment
	@echo "Setting up dev environment..."
	pre-commit install
	pip install -r requirements-dev.txt