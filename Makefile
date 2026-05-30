TERRAFORM_DIR := terraform/01-terraform-manifests-aks
ENVS_DIR      := $(TERRAFORM_DIR)/envs
TFVARS        := $(ENVS_DIR)/$(ENV).tfvars

RED    :=
GREEN  :=
YELLOW :=
CYAN   :=
RESET  :=

.PHONY: check-env
check-env:
	@if [ -z "$(ENV)" ]; then echo "$(RED)[ERROR] ENV required. Usage: make <target> ENV=dev|staging|prod$(RESET)"; exit 1; fi
	@if [ ! -f "$(TFVARS)" ]; then echo "$(RED)[ERROR] $(TFVARS) not found$(RESET)"; exit 1; fi
	@echo "$(CYAN)[INFO] Environment : $(ENV)$(RESET)"

.PHONY: init
init: check-env
	@echo "$(YELLOW)[INIT] terraform init - ENV=$(ENV)$(RESET)"
	cd $(TERRAFORM_DIR) && terraform init -reconfigure

.PHONY: validate
validate: check-env
	@echo "$(YELLOW)[VALIDATE] terraform validate - ENV=$(ENV)$(RESET)"
	cd $(TERRAFORM_DIR) && terraform validate

.PHONY: plan
plan: check-env
	@echo "$(YELLOW)[PLAN] terraform plan - ENV=$(ENV)$(RESET)"
	cd $(TERRAFORM_DIR) && terraform plan -var-file="envs/$(ENV).tfvars" -out=$(ENV).tfplan

.PHONY: apply
apply: check-env
	@echo "$(GREEN)[APPLY] terraform apply - ENV=$(ENV)$(RESET)"
	cd $(TERRAFORM_DIR) && terraform apply $(ENV).tfplan

.PHONY: apply-auto
apply-auto: check-env
	@echo "$(GREEN)[APPLY-AUTO] terraform apply auto-approve - ENV=$(ENV)$(RESET)"
	cd $(TERRAFORM_DIR) && terraform apply -var-file="envs/$(ENV).tfvars" -auto-approve

.PHONY: destroy
destroy: check-env
	@echo "$(RED)[DESTROY] terraform destroy - ENV=$(ENV)$(RESET)"
	cd $(TERRAFORM_DIR) && terraform destroy -var-file="envs/$(ENV).tfvars"

.PHONY: deploy
deploy: init validate plan apply
	@echo "$(GREEN)[DONE] Deploy complet - ENV=$(ENV)$(RESET)"

.PHONY: fmt
fmt:
	@echo "$(CYAN)[FMT] terraform fmt$(RESET)"
	cd $(TERRAFORM_DIR) && terraform fmt -recursive

.PHONY: output
output: check-env
	cd $(TERRAFORM_DIR) && terraform output

.PHONY: state
state: check-env
	cd $(TERRAFORM_DIR) && terraform state list

.PHONY: clean
clean:
	rm -f $(TERRAFORM_DIR)/*.tfplan

.PHONY: help
help:
	@echo ""
	@echo "AKS-2026 Terraform Makefile"
	@echo "Usage: make <target> ENV=dev|staging|prod"
	@echo ""
	@echo "Targets:"
	@echo "  init        terraform init + backend config"
	@echo "  validate    terraform validate"
	@echo "  plan        terraform plan"
	@echo "  apply       terraform apply"
	@echo "  apply-auto  terraform apply -auto-approve (CI/CD)"
	@echo "  deploy      init + validate + plan + apply"
	@echo "  destroy     terraform destroy"
	@echo "  fmt         terraform fmt -recursive"
	@echo "  output      terraform output"
	@echo "  state       terraform state list"
	@echo "  clean       supprime les .tfplan"
	@echo ""
	@echo "Exemples:"
	@echo "  make init   ENV=dev"
	@echo "  make plan   ENV=dev"
	@echo "  make deploy ENV=dev"
	@echo ""

.DEFAULT_GOAL := help
