
#  Azure Blob Storage Automation using Terraform & GitHub Actions

This project automates provisioning of an **Azure Storage Account** and **Blob Container** using Terraform, configures **remote state** with Azure Blob Storage, and implements CI/CD via **GitHub Actions**.

---

##  Project Structure

```
.
├── main.tf                      # Terraform resources
├── provider.tf                  # Azure provider config
├── variables.tf                 # Input variable declarations
├── terraform.tfvars             # Default variable values
├── environments/
│   ├── dev.tfvars               # Dev-specific variables
│   ├── prod.tfvars              # Prod-specific variables
│   ├── uat.tfvars               # UAT-specific variables
│   └── backend.tf               # Remote state backend config
└── .github/
    └── workflows/
        └── deploy.yml           # GitHub Actions CI/CD pipeline
```

---

## What This Project Does

- Creates an **Azure Resource Group**
- Provisions an **Azure Storage Account**
- Creates a **Blob Container**
- Stores **Terraform state** in Azure Blob Storage
- Executes `terraform plan` and `apply` through GitHub Actions
- Runs **Infracost** to estimate infrastructure costs
- Requires **manual approval** for `terraform apply` via GitHub Environments

---

##  Generate Azure Credentials

Use the command below to generate your GitHub-compatible Service Principal credentials (JSON format):

```bash
az ad sp create-for-rbac \
  --name "ServicePrinciple-Prathyusha" \
  --role Contributor \
  --scopes /subscriptions/$(az account show --query id -o tsv) \
  --sdk-auth
```

This will output a JSON object like:

```json
{
  "clientId": "...",
  "clientSecret": "...",
  "subscriptionId": "...",
  "tenantId": "..."
}
```

Copy this entire JSON and save it in your GitHub repo as a secret called:

```
AZURE_CREDENTIALS
```

---

##  GitHub Secrets Required

Go to your repository:

> **Settings → Secrets and variables → Actions → New repository secret**

Add the following secrets:

| Secret Name             | Description                               |
|-------------------------|-------------------------------------------|
| `AZURE_CREDENTIALS`     | Entire JSON output from the SP command    |
| `INFRACOST_API_KEY`     | Your Infracost API key                    |

---

##  Remote State Configuration

The `environments/backend.tf` configures remote state storage:

| Property           | Value                 |
|--------------------|-----------------------|
| Storage Account    | `storage88998898`     |
| Blob Container     | `container5579`       |
| State File Name    | `terraform.tfstate`   |

GitHub Actions workflow will automatically ensure this backend is created before running `terraform init`.

---

##  GitHub Actions Workflow

On every push to `main`, this pipeline will:

1. Authenticate with Azure
2. Set environment variables (`ARM_CLIENT_ID`, etc.)
3. Ensure backend resources (storage account, container) exist
4. Run `terraform init`
5. Run `terraform plan` and save the plan
6. Generate Infracost cost report
7. Upload artifacts (plan + cost report)
8. Require **manual approval**
9. Apply the Terraform plan once approved

---

##  Add Collaborators & Approvals

1. **Go to GitHub → Settings → Collaborators and teams**
2. Add your team members (e.g. reviewers)
3. Go to **Environments → New environment**
   - Name it: `dev-approval`
   - Add required reviewers (collaborators)
   - Save

This ensures `terraform apply` only runs after approval.

---

##  How to Use

1. **Clone the repo**

```bash
git clone https://github.com/Pratyushaa94/Azure-BlobStorage.git
cd Azure-BlobStorage
```

2. **Create a feature branch (optional)**

```bash
git checkout -b feature/blob-cicd
```

3. **Push to GitHub**

```bash
git add .
git commit -m "Initial setup with Terraform and GitHub Actions"
git push -u origin feature/blob-cicd
```

4. **GitHub Actions** will now run:
   - Validate credentials
   - Create backend if needed
   - Run plan and cost estimate
   - Await manual approval
   - Apply the plan

---
