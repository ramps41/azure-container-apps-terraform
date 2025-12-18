# Azure Container Apps - Terraform (dev + prod)

## Local usage

### Dev
terraform init -backend-config=backend/dev.hcl
terraform plan -var-file=environments/dev.tfvars -out=dev.tfplan
terraform apply dev.tfplan

### Prod
terraform init -backend-config=backend/prod.hcl
terraform plan -var-file=environments/prod.tfvars -out=prod.tfplan
terraform apply prod.tfplan
