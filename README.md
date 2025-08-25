# Enterprise CMS DevOps on Azure — Scalable Secure Platform 🚀

[![Releases](https://img.shields.io/badge/Release-Download-blue?style=for-the-badge)](https://github.com/nikhilvijayan2010/enterprise-cms-devops-portfolio/releases)

[![Azure](https://img.shields.io/badge/Azure-Cloud-0089D6?style=for-the-badge&logo=microsoft-azure)](https://azure.microsoft.com)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?style=for-the-badge&logo=terraform)](https://www.terraform.io)
[![Azure DevOps](https://img.shields.io/badge/Azure%20DevOps-CI%2FCD-0078D4?style=for-the-badge&logo=azuredevops)](https://dev.azure.com)
[![Umbraco](https://img.shields.io/badge/Umbraco-CMS-FF6A00?style=for-the-badge&logo=umbraco)](https://umbraco.com)
[![SonarQube](https://img.shields.io/badge/SonarQube-Quality-1E9EAC?style=for-the-badge&logo=sonarqube)](https://www.sonarqube.org)

Topics: advanced, azure, azure-devops, ci-cd, database, frontdoor, security-tools, sonarqube, sql, sqlserver, storage, terraform, vnet, waf

Live artifacts and automation are available in the Releases area. The release asset must be downloaded and executed from the Releases page: https://github.com/nikhilvijayan2010/enterprise-cms-devops-portfolio/releases

---

![Azure Front Door diagram](https://raw.githubusercontent.com/microsoft/azure-pipelines-image-generation/main/images/azure-cloud.svg)

Table of contents
- Quick start
- What this repo contains
- Architecture overview
- Infra: Terraform layout
- CI/CD: Azure DevOps pipelines
- Deployment patterns
- Security and hardening
- Observability and telemetry
- Backup and cost optimization
- Database and storage strategy
- Quality gates and SonarQube
- Networking and Front Door/WAF design
- How to run the release artifact (mandatory)
- Folder structure
- Troubleshooting
- Contributing
- License
- Contact

Quick start
- Visit Releases and download the main release asset. The release file needs to be downloaded and executed from the Releases page: https://github.com/nikhilvijayan2010/enterprise-cms-devops-portfolio/releases
- Follow the steps in the release README inside the artifact.
- Use the provided Terraform to provision infra.
- Trigger the CI pipeline in Azure DevOps to build and deploy.

What this repo contains
This repository collects infrastructure and pipeline patterns used to deliver a production-ready Umbraco CMS deployment on Microsoft Azure. It shows how to:
- Provision infrastructure with Terraform.
- Build CI/CD pipelines with YAML in Azure DevOps.
- Implement gated approvals for pipeline promotion.
- Perform zero-downtime deployments using slot swap.
- Integrate Azure Front Door and WAF for global traffic and security.
- Add Application Insights for observability.
- Configure database and storage for Umbraco.
- Integrate SonarQube for code quality.
- Optimize backup costs and retention.

This repo contains reference modules, example YAML, and scripts. Use them as a template. Adapt them for your environment and compliance needs.

Architecture overview
This section describes the logical architecture.

High-level flow
- Users hit Azure Front Door.
- Front Door checks WAF rules.
- Traffic routes to App Service Environment (or App Service) slot.
- Application runs Umbraco CMS with SQL Server backend.
- Application Insights collects telemetry.
- Storage Account holds media and backups.
- Terraform controls all infra.
- Azure DevOps pipelines handle build, test, and release.
- SonarQube scans code and blocks merge on quality issues.

Components
- Azure Front Door: Global entry, health checks, route rules.
- Azure WAF (Front Door): OWASP rules and custom rules.
- App Service: Web hosting with deployment slots.
- Azure SQL / SQL Server: Managed DB with Geo-restore and point-in-time restore.
- Storage Account: BLOB for media and backup snapshots.
- Key Vault: Secrets and connection strings.
- Application Insights: Tracing, metrics, and alerts.
- Terraform: Modules for VNet, subnets, SQL, storage, app service, AAD, and Front Door.
- Azure DevOps: YAML pipelines, approvals, gated environments.
- SonarQube: Static analysis and code quality gates.

Design goals
- Scalable: Use App Service Autoscale and SQL DTUs/vCores scaling.
- Secure: Use Managed Identity, Key Vault, and Front Door WAF.
- Resilient: Use slot-based zero-downtime deployments and read replicas.
- Observable: Use App Insights and structured logs.
- Cost aware: Use lifecycle policies and backup tiering.

Infra: Terraform layout
This repo uses a modular Terraform layout. Modules isolate responsibilities. Example top-level structure:
- /terraform
  - /modules
    - /network
    - /sql
    - /appservice
    - /storage
    - /frontdoor
    - /keyvault
  - /environments
    - /dev
    - /staging
    - /prod
  - backend.tf
  - providers.tf
  - main.tf
  - variables.tf
  - outputs.tf

Sample provider configuration (short)
```hcl
provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatestorage"
    container_name       = "tfstate"
    key                  = "enterprise-cms.terraform.tfstate"
  }
}
```

Network module
- VNet with service endpoints.
- Subnets: app, db, infra, peering.
- Network Security Groups with minimal allowed ports.
- Private Endpoints for SQL and Key Vault.

SQL module
- Azure SQL managed instance or single database depending on requirement.
- Geo-replication optional.
- Automated backups configured; long term retention policy.
- VNet service endpoint or private endpoint.

App Service module
- App Service Plan with scale rules.
- App Service with deployment slots: staging and production.
- Managed Identity bound to Key Vault.
- Connection strings injected from Key Vault.

Front Door module
- Front Door with custom domains and TLS.
- WAF policy with OWASP rules and rate limiting.
- Backend pools with probe and session affinity.

Key Vault
- Secrets for connection strings, storage keys.
- Access policies for service principal and managed identity.
- Soft delete and purge protection on in-scope environments.

State and branching
- Use a shared state storage with locks.
- Keep env-specific state files.
- Use branches for PR review. Terraform runs in pipelines to plan and require approval to apply in prod.

CI/CD: Azure DevOps pipelines
This section shows pipeline patterns. Use YAML for pipeline-as-code. Use multi-stage pipelines with separate jobs for build, quality, infra, and deploy.

Pipeline layout
- azure-pipelines.yml — main pipeline.
- templates/
  - build.yml
  - test.yml
  - sonarqube.yml
  - terraform-plan.yml
  - terraform-apply.yml
  - deploy-webapp.yml

Key pipeline features
- Build job that restores, builds, and packages Umbraco site.
- SonarQube scan job that runs before merges.
- Unit tests and automated UI tests.
- Terraform plan in PRs.
- Terraform apply only after approvals in protected environments.
- Release stage that performs slot deployment and swaps.
- Approval gates in pre-prod and production stages.

Example YAML snippet for gated deploy
```yaml
stages:
- stage: Build
  jobs:
  - template: templates/build.yml

- stage: QA
  dependsOn: Build
  jobs:
  - template: templates/deploy-webapp.yml
    parameters:
      slot: staging

- stage: Prod
  dependsOn: QA
  condition: succeeded()
  approval:
    steps:
      - task: ManualValidation@0
        inputs:
          notifyUsers: 'devops_lead@company.com'
  jobs:
  - template: templates/deploy-webapp.yml
    parameters:
      slot: production
```

Slot-based zero-downtime deployments
- Deploy to staging slot.
- Warm the slot by hitting health endpoints.
- Run smoke tests against staging slot.
- If tests pass, swap staging into production.
- Use swap with auto-stabilization and slot settings to keep secrets intact.

Blue-green and Canary options
- Canary: route small percentage via Front Door to new slot.
- Blue-green: use complete separate slot and swap after validation.

Security and hardening
Follow security best practices in all layers.

Identity and secrets
- Use Managed Identity for App Service.
- Store secrets and connection strings in Key Vault.
- Rotate secrets with lifecycle policies.

Network control
- Place SQL behind private endpoint.
- Use service endpoints for Storage when possible.
- Deny inbound traffic except required ports.
- Use NSGs and Route Tables.

Front Door and WAF
- Use Front Door for TLS termination and global routing.
- Add WAF policy with OWASP top 10 rules enabled.
- Create custom rules for rate limits, API protection, and geo-blocking.

App Service hardening
- Enforce HTTPS only.
- Turn on Authentication if needed.
- Turn off FTP and other unused features.
- Restrict access to Kudu to allowed IP ranges.

SQL hardening
- Enforce TLS.
- Require Azure AD auth for admin and service accounts.
- Enable auditing and Threat Detection.

Compliance and logs
- Forward logs to Log Analytics workspace.
- Retain audit logs for required retention period.

Observability and telemetry
App Insights
- Use Application Insights for request, dependency, and exception telemetry.
- Use custom telemetry for key business flows.
- Track request rates, failures, latency.

Dashboards and Alerts
- Create dashboards for overall app health.
- Configure alerts on:
  - High error rate.
  - Slow page load.
  - CPU or memory limits.
  - SQL DTU or vCore thresholds.
- Route alerts to Teams, Slack, or PagerDuty.

Tracing and correlation
- Use operation id and trace id propagation.
- Correlate logs across front end, API, and DB.

Logging
- Use structured JSON logs.
- Send logs to Log Analytics and blob storage for archive.
- Keep sensitive data out of logs.

Backup and cost optimization
Backups
- Configure automated backups for SQL with required retention.
- Use Storage lifecycle management to tier old backups to cool/archive.
- Keep daily backups for short term and weekly/monthly for long term.

Cost controls
- Use reserved instances or savings plans where applicable.
- Use scale rules to reduce instances during low traffic.
- Use blob lifecycle to move old media to cool/archive tiers.
- Use Azure Advisor to find cost anomalies.

Optimize storage
- Use CDN for static media to reduce egress and compute load.
- Configure media deduplication policies if possible.

Database and storage strategy
SQL sizing
- Start with reasonable SKU and scale as load grows.
- Use read-replicas for read-heavy workloads.
- Monitor index usage and query patterns.

Schema and migrations
- Use migrations in CI pipeline.
- Run migrations against staging first.
- Use feature flags if migrations require downtime.

Storage for media
- Use Azure Blob Storage for media and backups.
- Use Shared Access Signatures (SAS) for limited access.
- Integrate Umbraco to store media in blob store.

Blob lifecycle
- Hot: recent assets.
- Cool: less frequent access.
- Archive: long-term retention.

Quality gates and SonarQube
SonarQube integration
- Run SonarQube scans during build.
- Fail build on critical or blocker issues.
- Use branch analysis for feature branches.

Rules and thresholds
- Define rules for security issues and code smells.
- Set coverage thresholds.
- Block merges when quality gates fail.

Pipeline snippet for SonarQube
```yaml
- stage: Quality
  jobs:
  - job: SonarQube
    steps:
    - task: SonarQubePrepare@4
      inputs:
        SonarQube: 'SonarQubeService'
        scannerMode: 'MSBuild'
    - task: DotNetCoreCLI@2
      inputs:
        command: 'build'
    - task: SonarQubeAnalyze@4
    - task: SonarQubePublish@4
      inputs:
        pollingTimeoutSec: '300'
```

Networking and Front Door/WAF design
Front Door setup
- Use Front Door Standard or Premium.
- Add backends in different regions if you need geo-redundancy.
- Set health probes for backends and route based on priority and weight.

Custom domains and TLS
- Validate domain ownership.
- Use managed certificates or bring your own.
- Set TLS minimum to 1.2+.

WAF rules
- Base on OWASP CRS.
- Add custom rules for known threats and API endpoints.
- Add rate-based rules and geo-block rules when needed.

Private endpoints and VNet integration
- Use Private Endpoint for SQL and Key Vault.
- Use service endpoints for storage.
- Use peering to connect VNet where tooling runs.

How to run the release artifact (mandatory)
This repository links to a Releases page. The release asset must be downloaded and executed.

Step-by-step
1. Open Releases: https://github.com/nikhilvijayan2010/enterprise-cms-devops-portfolio/releases
2. Download the latest asset, for example enterprise-cms-deploy.ps1 or infra-package.zip.
3. Inspect the release notes and the included README inside the artifact.
4. Verify signatures and checksums if included.
5. Run the deploy script on a machine with the required tools:
   - Azure CLI (az)
   - Terraform (v1.x)
   - PowerShell 7 or Bash depending on the script
6. Typical commands:
   - PowerShell:
     ```powershell
     .\enterprise-cms-deploy.ps1 -Environment prod -Confirm:$false
     ```
   - Bash:
     ```bash
     ./deploy.sh --env prod
     ```
6. The release script will:
   - Initialize Terraform state.
   - Plan and apply infra in the selected environment (requires approval for prod).
   - Upload app package to artifact storage.
   - Trigger Azure DevOps pipeline for build and deploy.
7. After deployment, validate endpoints and check Application Insights telemetry.

Release artifact contents (example)
- enterprise-cms-deploy.ps1 — orchestration script for Azure.
- infra/ — Terraform templates and modules.
- pipelines/ — Azure DevOps YAML templates.
- scripts/ — helper scripts for DB migrations and media sync.
- docs/ — runbook and architecture diagrams.

Safety
- Run scripts from a trusted machine.
- Use least privilege principals.
- Review the code before execution.

Folder structure
Example layout with detail
- /terraform
  - /modules
    - /appservice
      - main.tf
      - variables.tf
      - outputs.tf
    - /sql
    - /frontdoor
    - /network
  - /environments
    - dev
    - staging
    - prod
- /pipelines
  - azure-pipelines.yml
  - templates/
- /src
  - Umbraco solution
- /scripts
  - deploy.sh
  - enterprise-cms-deploy.ps1
  - db-migrate.ps1
- /docs
  - architecture.md
  - runbook.md
  - security.md
- /releases
  - release-manifest.json

Troubleshooting
Common issues and checks
- Terraform plan fails for provider version:
  - Check provider block and required provider versions.
  - Update local Terraform to match version constraints.
- App Service fails to start:
  - Check App Service logs in Log Stream and Kudu.
  - Verify env variables and Key Vault access.
- Slot swap fails:
  - Check app settings configured as slot setting.
  - Ensure no sticky connections block swap.
- DB connectivity fails:
  - Check private endpoint and firewall rules.
  - Verify connection string and managed identity access.
- High latency after deploy:
  - Check App Insights traces for slow dependencies.
  - Verify cold start and warming did not occur.

Debugging tips
- Use Azure CLI to fetch logs quickly:
  - az webapp log tail
  - az monitor metrics list
- Use Application Insights to trace issues end-to-end.
- Reproduce in staging with same config before impacting prod.

Operational runbook samples
- Rollback:
  - If swap caused issues, swap back to revert state.
  - In severe cases, restore DB from latest backup and restore blob content.
- Emergency patch:
  - Patch slot and swap after smoke tests.
  - Use traffic routing to shift load away from impacted region.

Testing strategy
- Unit tests in CI pipeline.
- Integration tests against staging slot.
- Smoke tests post-deploy.
- Load tests in a sandbox environment.

Scaling and performance
- App Service:
  - Use autoscale rules based on CPU, memory, or request count.
- SQL:
  - Use read replicas for read-heavy workloads.
  - Use elastic pools for multi-tenant cost savings.
- Caching:
  - Use Azure Cache for Redis for frequent reads and session storage.

Compliance and governance
- Tag resources with environment, owner, and cost center.
- Use Azure Policy to enforce required configuration.
- Audit access with Azure Monitor and activity logs.

Examples and snippets
Terraform module example for app service
```hcl
module "appservice" {
  source              = "../modules/appservice"
  name                = var.app_name
  resource_group_name = var.rg_name
  location            = var.location
  plan_sku            = "S1"
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = module.appinsights.instrumentation_key
    "KEYVAULT_URI"                   = module.keyvault.vault_uri
  }
  identity = {
    type = "SystemAssigned"
  }
}
```

Azure DevOps pipeline to swap slots
```yaml
- job: SwapSlots
  pool:
    vmImage: 'ubuntu-latest'
  steps:
  - task: AzureWebApp@1
    inputs:
      azureSubscription: 'AzureServiceConnection'
      appName: '$(appName)'
      action: 'Swap Slots'
      sourceSlot: 'staging'
      targetSlot: 'production'
```

DB migration script sample (PowerShell)
```powershell
param(
  [string]$ConnectionString,
  [string]$MigrationPackage
)

Write-Output "Running DB migrations..."
dotnet ef database update --connection "$ConnectionString"
Write-Output "Migrations applied"
```

Audit and compliance automation
- Automate policy assignment per subscription.
- Use scripted checks as pipeline gates.
- Export audit logs and keep them in a secure archive.

Contributing
How to contribute
- Fork the repo.
- Create a feature branch.
- Run tests locally.
- Create a pull request.
- A PR must include:
  - Description of change.
  - Terraform plan for infra changes.
  - Pipeline changes in YAML.
- All PRs run pipelines that include SonarQube and Terraform plan.
- Major infra changes require architecture review and approval.

Code of conduct
- Be respectful.
- Aim for clear, testable changes.
- Keep commits small and focused.

Branching and release model
- main: production-ready code.
- develop: integration.
- feature/*: for new features.
- Use semantic versioning for release artifacts.

License
This repository uses MIT License. See LICENSE file for full text.

Contact
- Repo owner: nikhilvijayan2010 on GitHub
- Issues: Use the GitHub Issues for bugs and feature requests.
- Pull requests: Use PRs as described in Contributing.

Additional resources and references
- Azure Docs: https://docs.microsoft.com/azure
- Terraform: https://www.terraform.io/docs
- Azure DevOps YAML schema: https://docs.microsoft.com/azure/devops/pipelines/yaml-schema
- Umbraco docs: https://our.umbraco.com/documentation
- SonarQube: https://www.sonarqube.org

Releases and artifacts
- The release artifact on the Releases page must be downloaded and executed. The link is: https://github.com/nikhilvijayan2010/enterprise-cms-devops-portfolio/releases
- The Releases page contains detailed release notes and the primary deploy script. Download the artifact and follow the included runbook for the environment you target.

Appendix A — Sample smoke test plan
- GET /health returns 200.
- GET / returns 200 and content-type text/html.
- Login test with test user.
- Media upload test to storage.
- DB write/read test.

Appendix B — Role and permission map
- DevOps Engineers: Terraform apply in non-prod, pipeline edits.
- Release Managers: Approve prod deploys.
- SRE: Monitor and respond to alerts.
- Developers: PRs, unit tests, and feature flags.

Appendix C — Useful CLI commands
- Terraform
  - terraform init
  - terraform plan -var-file=env.tfvars
  - terraform apply
- Azure
  - az login
  - az account set --subscription "SUB_ID"
  - az webapp log tail --name appName --resource-group rgName
- Azure DevOps
  - az pipelines run --name pipelineName

Images and visual assets
- Use the badges and images in the header for quick context.
- The repo includes ASCII and SVG diagrams in /docs.

This README aims to act as an operational and implementation guide. The release artifacts contain full automation and runnable scripts. Download the release and follow the included runbook to provision and operate the enterprise-grade Umbraco CMS deployment on Azure.