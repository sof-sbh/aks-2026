# Bootstrap — Key Vault

## Fichiers à ajouter

| Fichier | Destination |
|---|---|
| `04-keyvault.tf` | `00-terraform-bootstrap-backend/04-keyvault.tf` |
| `05-secrets.tf` | `00-terraform-bootstrap-backend/05-secrets.tf` |
| Contenu de `02-variables-addition.tf` | Ajouter à la fin de `00-terraform-bootstrap-backend/02-variables.tf` |
| Contenu de `03-outputs-addition.tf` | Ajouter à la fin de `00-terraform-bootstrap-backend/03-outputs.tf` |

## Avant le apply

Exporter les secrets via variables d'environnement :

```bash
export TF_VAR_windows_admin_password="TonMotDePasse"
export TF_VAR_ssh_public_key="$(cat ~/.ssh/aks-prod-sshkeys-terraform/aksprodsshkey.pub)"
```

## Apply

```bash
make deploy ENV=dev
```

## Résultat

- Key Vault `sbh-aks-kv-bootstrap` créé dans le RG bootstrap
- 2 secrets stockés :
  - `aks-windows-admin-password`
  - `aks-ssh-public-key`
- Plus jamais de mot de passe en clair dans le code
