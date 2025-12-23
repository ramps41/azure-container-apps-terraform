# Azure Container Apps Terraform

Infrastructure-as-code for a simple Azure Container Apps deployment, built to run through GitHub Actions from day one.  
The repo currently targets a single `dev` environment with a prepared (but idle) `prod` configuration so that new stages can be introduced in controlled, reviewable increments.

## What gets deployed
- Azure Resource Group (`*-rg`)
- Log Analytics Workspace (`*-law`)
- Container Apps Environment linked to the workspace (`*-cae`)
- Hello World Container App (`*-hello-world-app`) with external ingress

The Terraform state is stored remotely in Azure Blob Storage, and GitHub Actions authenticates to Azure via OIDC (no long-lived secrets).

## CI/CD flow
| Event | Action | Details |
| --- | --- | --- |
| Pull request targeting `main` | `terraform plan` | Runs with `environments/dev.tfvars`, posts the plan output back to the PR as a comment for review. |
| Merge to `main` | `terraform apply` | Applies the `dev` configuration automatically after PR approval and merge. |

- All Azure credentials (`AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`) are stored as **GitHub Environment secrets** in the `dev` environment.
- Concurrency is enforced so only one Terraform run executes at a time.
- `prod` tfvars/environment exist but have no active CI jobs yet; they will be enabled when prod automation is required.

## Repository layout
```
.
├── backend/
│   └── dev.hcl               # Remote state backend config (prod placeholder exists for future)
├── environments/
│   ├── dev.tfvars            # Dev inputs (region, naming, container image, cpu/memory)
│   └── prod.tfvars           # Prod inputs ready for future stages
├── main.tf                   # Core resources (RG, LAW, CAE, Container App)
├── locals.tf / variables.tf  # Shared naming + input declarations
├── outputs.tf                # Container App FQDN
├── versions.tf               # Terraform + provider constraints
└── .github/workflows/terraform.yml
```

## Prerequisites
1. **Azure resources**: A storage account + container for Terraform state, and contributor permissions for the GitHub OIDC service principal (see `backend/dev.hcl` for names).
2. **GitHub configuration**:
   - Repo environments: `dev` (active) and `prod` (placeholder).
   - Environment secrets: `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`.
3. **Tooling**: Terraform ≥ 1.6 locally if you plan to run commands before pushing.

## Local development (optional)
These commands mirror the CI job and are useful when iterating before opening a PR.

```bash
terraform init -backend-config=backend/dev.hcl
terraform plan -var-file=environments/dev.tfvars -out=dev.tfplan
terraform apply dev.tfplan
```

Use the `prod.tfvars` file later when you are ready to validate prod settings locally (CI for prod is intentionally deferred).

## Contribution workflow
1. Branch from `main` (`feature/<description>`).
2. Make focused, stage-scoped changes.
3. Run local formatting/validation as needed (avoid grabbing the shared state lock unless necessary).
4. Push and open a PR with an enterprise-ready description (context, changes, testing). Allow the GitHub Actions plan to finish and review the comment it posts.
5. After approval, merge the PR and verify the merge-triggered apply succeeds before beginning the next stage.

## Future enhancements
- Add prod backend config + workflows gated by approvals.
- Break out modules once the solution grows (e.g., monitoring, networking, app modules).
- Add diagnostics alerts and advanced container configuration (revisions, secrets, autoscaling) as follow-up stages.
