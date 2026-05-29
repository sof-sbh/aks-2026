# 01-SBH-AKS-CLUSTER — Infrastructure Terraform

Infrastructure Kubernetes sur Azure (AKS) provisionnée via Terraform, avec modules réutilisables.  
By [SBH Consulting](https://sbhconsulting-tech.fr)

---

## Architecture

```
01-SBH-AKS-CLUSTER/
├── .env                          ← secrets locaux (jamais commité)
├── .gitignore
├── Makefile
├── README.md
└── terraform/
    ├── 00-terraform-bootstrap-backend/
    │   ├── 01-main.tf            ← Storage Account + Key Vault
    │   ├── 02-variables.tf
    │   ├── 03-keyvault.tf
    │   ├── 04-secrets.tf         ← secrets stockés dans KV
    │   └── 05-outputs.tf
    ├── 01-terraform-manifests-aks/
    │   ├── 01-main.tf            ← backend + providers
    │   ├── 02-variables.tf
    │   ├── 03-resource-group.tf
    │   ├── 04-aks-versions-datasource.tf
    │   ├── 05-aks-cluster.tf
    │   ├── 06-aks-cluster-linux-user-nodepools.tf
    │   ├── 07-virtual-network.tf
    │   ├── 08-acr.tf             ← Azure Container Registry
    │   ├── 99-outputs.tf
    │   └── envs/
    │       ├── dev.tfvars
    │       ├── staging.tfvars
    │       └── prod.tfvars
    └── 02-modules/
        ├── az_acr/               ← Container Registry + AcrPull
        ├── az_06_aks_linux_user_nodepools/
        ├── az_ad_group/
        ├── az_aks/
        ├── az_helm/
        ├── az_keyvault/
        └── az_log_analytics/
```

---

## Bootstrap — Ordre de déploiement

Le bootstrap doit toujours être déployé **avant** le cluster AKS.

```
┌─────────────────────────────────────────────┐
│  00-terraform-bootstrap-backend             │
│                                             │
│  rg-tfstate-bootstrap-weu                   │
│    └── Storage Account (tfstate)            │
│                                             │
│  rg-keyvault-bootstrap-weu                  │
│    └── Key Vault sbh-aks-kv-bootstrap       │
│          ├── aks-windows-admin-password     │
│          └── aks-ssh-public-key             │
└─────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│  01-terraform-manifests-aks                 │
│                                             │
│  rg-aks-dev                                 │
│    ├── AKS Cluster                          │
│    ├── ACR (sbhaksdev.azurecr.io)           │
│    ├── VNet / Subnet                        │
│    ├── Log Analytics Workspace              │
│    └── Azure AD Group (admins)              │
└─────────────────────────────────────────────┘
```

---

## Environments

### FinOps — Sizing par environnement

| Paramètre | Dev | Staging | Prod |
|---|---|---|---|
| **AKS SKU Tier** | Free | Standard | Standard |
| **Kubernetes version** | latest | latest | latest |
| **Resource Group** | rg-aks-dev | rg-aks-staging | rg-aks-prod |
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

### ACR

| Paramètre | Dev | Staging | Prod |
|---|---|---|---|
| **SKU** | Basic | Standard | Premium |
| **Login server** | sbhaksdev.azurecr.io | sbhaksstaging.azurecr.io | sbhaksprod.azurecr.io |
| **Admin enabled** | ❌ | ❌ | ❌ |
| **Intégration AKS** | Managed Identity (AcrPull) | Managed Identity (AcrPull) | Managed Identity (AcrPull) |

### Key Vault Bootstrap

| Paramètre | Valeur |
|---|---|
| **Nom** | sbh-aks-kv-bootstrap |
| **Resource Group** | rg-keyvault-bootstrap-weu |
| **SKU** | Standard |
| **Soft delete** | 7 jours |
| **Purge protection** | ❌ (dev/bootstrap) |

### Terraform State

| Paramètre | Valeur |
|---|---|
| **Storage Account** | terraformstatesbh2031 |
| **Resource Group** | rg-tfstate-bootstrap-weu |
| **Container** | tfstatefiles |
| **Key Dev** | dev.terraform.tfstate |
| **Key Staging** | staging.terraform.tfstate |
| **Key Prod** | prod.terraform.tfstate |

---

## Workflow complet

### 1. Prérequis

```bash
# Authentification Azure
az login

# Charger les secrets (mot de passe Windows + SSH key)
source .env
```

### 2. Bootstrap (première fois uniquement)

```bash
cd terraform/00-terraform-bootstrap-backend
terraform init
terraform apply
```

Crée :
- `rg-tfstate-bootstrap-weu` + Storage Account
- `rg-keyvault-bootstrap-weu` + Key Vault + secrets

### 3. Cluster AKS

```bash
# Depuis la racine du repo
make init    ENV=dev
make plan    ENV=dev
make apply   ENV=dev
```

### 4. Destroy (fin de session)

```bash
make destroy ENV=dev

# Si destroy complet du bootstrap
cd terraform/00-terraform-bootstrap-backend
terraform destroy
```

---

## Makefile

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

---

## Modules

### az_aks
Provisionne un cluster AKS avec :
- Node pool système avec autoscaling
- Identité MSI SystemAssigned
- Intégration Azure AD RBAC
- Monitoring via OMS Agent

### az_acr
Provisionne un Azure Container Registry avec :
- SKU configurable par environnement (Basic/Standard/Premium)
- Role assignment AcrPull sur la Managed Identity kubelet AKS
- Pas de credentials — authentification via Managed Identity

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

## Sécurité

- Mots de passe et clés SSH **jamais en clair** dans le code
- Secrets injectés via `TF_VAR_` depuis `.env` (non commité)
- `.env` protégé par `.gitignore` (`*.env`)
- Secrets stockés dans **Azure Key Vault** après bootstrap
- `*.tfvars` non commités (sauf variables non sensibles)
- `*.tfstate` exclus du repo

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

**Sofiene Belharbi** — SBH Consulting  
Cloud Platform | DevOps | SRE  
[sbhconsulting-tech.fr](https://sbhconsulting-tech.fr)
