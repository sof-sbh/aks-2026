# AKS 2026 — Infrastructure Terraform

Infrastructure Kubernetes sur Azure (AKS) provisionnée via Terraform, avec modules réutilisables.

## Architecture

```
AKS-2026/
├── Makefile
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
    │   ├── 06-aks-cluster-linux-user-nodepools.tf
    │   ├── 07-virtual-network.tf
    │   ├── 99-outputs.tf
    │   └── envs/
    │       ├── dev.tfvars
    │       ├── staging.tfvars
    │       └── prod.tfvars
    └── 02-modules/
        ├── az_06_aks_linux_user_nodepools/
        ├── az_ad_group/
        ├── az_aks/
        ├── az_helm/
        ├── az_keyvault/
        └── az_log_analytics/
```

---

## Environments

### FinOps — Sizing par environnement

| Paramètre | Dev | Staging | Prod |
|---|---|---|---|
| **AKS SKU Tier** | Free | Standard | Standard |
| **Kubernetes version** | 1.30 | 1.30 | 1.30 |
| **Resource Group** | rg-aks-dev-weu | rg-aks-staging-weu | rg-aks-prod-weu |
| **Criticality** | low | medium | high |

### System Node Pool

| Paramètre | Dev | Staging | Prod |
|---|---|---|---|
| **VM SKU** | Standard_D2s_v3 | Standard_D4s_v3 | Standard_D8s_v3 |
| **OS Disk** | 64 GB | 128 GB | 256 GB |
| **Node count** | 1 (fixe) | 2 (auto) | 3 (auto) |
| **Autoscaling** | ❌ | ✅ min 2 / max 4 | ✅ min 3 / max 6 |

### User Node Pool (apppool)

| Paramètre | Dev | Staging | Prod |
|---|---|---|---|
| **VM SKU** | Standard_D2s_v3 | Standard_D4s_v3 | Standard_D8s_v3 |
| **OS Disk** | 64 GB | 128 GB | 256 GB |
| **Node count** | 1 (fixe) | 2 (auto) | 3 (auto) |
| **Autoscaling** | ❌ | ✅ min 2 / max 6 | ✅ min 3 / max 10 |

### Virtual Network

| Paramètre | Dev | Staging | Prod |
|---|---|---|---|
| **VNet name** | vnet-aks-dev-weu | vnet-aks-staging-weu | vnet-aks-prod-weu |
| **Address space** | 10.10.0.0/16 | 10.20.0.0/16 | 10.30.0.0/16 |
| **Subnet** | 10.10.1.0/24 | 10.20.1.0/24 | 10.30.1.0/24 |

### Key Vault & Logs

| Paramètre | Dev | Staging | Prod |
|---|---|---|---|
| **KV SKU** | standard | standard | premium (HSM) |
| **Purge protection** | ❌ | ❌ | ✅ |
| **Soft delete retention** | 7 j | 30 j | 90 j |
| **Log retention** | 30 j | 60 j | 90 j |

### Terraform State (Backend Azure Blob)

| Paramètre | Valeur |
|---|---|
| **Storage Account** | terraformstatesbh2030 |
| **Resource Group** | terraform-aks-storage-rg |
| **Container** | tfstate |
| **Key Dev** | aks-dev.terraform.tfstate |
| **Key Staging** | aks-staging.terraform.tfstate |
| **Key Prod** | aks-prod.terraform.tfstate |

---

## Makefile

### Targets disponibles

| Target | Description |
|---|---|
| `init` | `terraform init` + backend config |
| `validate` | `terraform validate` |
| `plan` | `terraform plan` → génère `<ENV>.tfplan` |
| `apply` | `terraform apply` → consomme `<ENV>.tfplan` |
| `apply-auto` | `terraform apply -auto-approve` (CI/CD) |
| `deploy` | init + validate + plan + apply |
| `destroy` | `terraform destroy` avec confirmation |
| `fmt` | `terraform fmt -recursive` |
| `output` | `terraform output` |
| `state` | `terraform state list` |
| `clean` | Supprime les fichiers `.tfplan` |

### Usage

```bash
# Init + plan + apply sur un env
make init    ENV=dev
make plan    ENV=dev
make apply   ENV=dev

# Deploy complet en une commande
make deploy  ENV=staging

# Destroy avec confirmation interactive
make destroy ENV=dev

# CI/CD auto-approve
make apply-auto ENV=prod

# Aide
make help
```

---

## Modules

### az_aks
Provisionne un cluster AKS avec :
- Node pool système avec autoscaling
- Identité MSI SystemAssigned
- Intégration Azure AD RBAC
- Monitoring via OMS Agent

### az_06_aks_linux_user_nodepools
Gère les user node pools Linux avec labels et taints configurables.

### az_ad_group
Crée un groupe Azure AD pour les admins du cluster.

### az_keyvault
Provisionne un Key Vault avec RBAC, soft delete et purge protection configurables par env.

### az_log_analytics
Crée un Log Analytics Workspace pour la collecte des logs AKS.

### az_helm
Déploiement de charts Helm sur le cluster AKS.

---

## Prérequis

- Terraform >= 1.0
- Azure CLI authentifié (`az login`)
- Permissions : Contributor sur la subscription + Group.ReadWrite sur Azure AD
- `make` installé

---

## Providers

| Provider | Version |
|---|---|
| azurerm | ~> 4.0 |
| azuread | ~> 3.0 |
| random | ~> 3.0 |

---

## Auteur

Sofiene Belharbi

