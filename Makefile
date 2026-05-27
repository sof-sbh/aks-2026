# =============================================================================
# MAKEFILE - AKS-2026 Terraform
# Usage : make <target> ENV=<dev|staging|prod>
# =============================================================================

TERRAFORM_DIR := 01-terraform-manifests-aks
ENVS_DIR      := $(TERRAFORM_DIR)/envs
TFVARS        := $(ENVS_DIR)/$(ENV).tfvars

# Couleurs
RED    := \033[0;31m
GREEN  := \033[0;32m
YELLOW := \033[0;33m
CYAN   := \033[0;36m
RESET  := \033[0m

# ---------------------------------------------------------------------------
# Validation ENV
# ---------------------------------------------------------------------------
.PHONY: check-env
check-env:
	@if [ -z "$(ENV)" ]; then \
		echo "$(RED)[ERROR] ENV is required. Usage: make <target> ENV=dev|staging|prod$(RESET)"; \
		exit 1; \
	fi
	@if [ ! -f "$(TFVARS)" ]; then \
		echo "$(RED)[ERROR] $(TFVARS) not found$(RESET)"; \
		exit 1; \
	fi
	@echo "$(CYAN)[INFO] Environment : $(ENV)$(RESET)"
	@echo "$(CYAN)[INFO] Vars file   : $(TFVARS)$(RESET)"

# ---------------------------------------------------------------------------
# Init
# ---------------------------------------------------------------------------
.PHONY: init
init: check-env
	@echo "$(YELLOW)[INIT] terraform init - ENV=$(ENV)$(RESET)"
	cd $(TERRAFORM_DIR) && terraform init \
		-backend-config="../$(ENVS_DIR)/$(ENV).tfvars" \
		-reconfigure

# ---------------------------------------------------------------------------
# Validate
# ---------------------------------------------------------------------------
.PHONY: validate
validate: check-env
	@echo "$(YELLOW)[VALIDATE] terraform validate - ENV=$(ENV)$(RESET)"
	cd $(TERRAFORM_DIR) && terraform validate

# ---------------------------------------------------------------------------
# Plan
# ---------------------------------------------------------------------------
.PHONY: plan
plan: check-env
	@echo "$(YELLOW)[PLAN] terraform plan - ENV=$(ENV)$(RESET)"
	cd $(TERRAFORM_DIR) && terraform plan \
		-var-file="../$(TFVARS)" \
		-out=$(ENV).tfplan

# ---------------------------------------------------------------------------
# Apply
# ---------------------------------------------------------------------------
.PHONY: apply
apply: check-env
	@echo "$(GREEN)[APPLY] terraform apply - ENV=$(ENV)$(RESET)"
	cd $(TERRAFORM_DIR) && terraform apply \
		$(ENV).tfplan

# ---------------------------------------------------------------------------
# Apply auto-approve (CI/CD uniquement)
# ---------------------------------------------------------------------------
.PHONY: apply-auto
apply-auto: check-env
	@echo "$(GREEN)[APPLY-AUTO] terraform apply auto-approve - ENV=$(ENV)$(RESET)"
	cd $(TERRAFORM_DIR) && terraform apply \
		-var-file="../$(TFVARS)" \
		-auto-approve