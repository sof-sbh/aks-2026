# AKS 2026 — Infrastructure Terraform

Infrastructure Kubernetes sur Azure (AKS) provisionnée via Terraform, avec modules réutilisables.

## Architecture

```
aks-2026/
└── terraform/
    ├── 00-terraform-bootstrap-backend/
    │   ├── 01-main.tf
    │   ├── 02-variables.tf
    │   └── 03-outputs.tf
    ├── 01-terraform-manifests-aks/
    │   ├── 01-main.tf
    │   ├── 02-variables.tf
    │   ├── 03-resource-group.tf
    │   ├── 04-aks-versions-datasource.tf
    │   ├── 05-aks-cluster.tf
    │   └── 99-outputs.tf
    └── 02-modules/
        ├── az_aks/
        ├── az_ad_group/
        └── az_log_analytics/
```

## Modules

### az_aks
Provisionne un cluster AKS avec :
- Node pool avec autoscaling
- Identité MSI SystemAssigned
- Intégration Azure AD RBAC
- Monitoring via OMS Agent

### az_ad_group
Crée un groupe Azure AD pour les admins du cluster.

### az_log_analytics
Crée un Log Analytics Workspace pour la collecte des logs AKS.

## Prérequis

- Terraform >= 1.0
- Azure CLI authentifié (`az login`)
- Permissions : Contributor sur la subscription + Group.ReadWrite sur Azure AD

## Déploiement

### 1. Bootstrap du backend

```bash
cd terraform/00-terraform-bootstrap-backend
terraform init
terraform apply
```

### 2. Déploiement AKS

```bash
cd terraform/01-terraform-manifests-aks
terraform init
terraform plan
terraform apply
```

## Providers

| Provider | Version |
|---|---|
| azurerm | ~> 4.0 |
| azuread | ~> 3.0 |
| random | ~> 3.0 |

## Auteur

Sofiene Belharbi

