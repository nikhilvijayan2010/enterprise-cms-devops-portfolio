# 🏗️ Enterprise CMS Deployment on Azure (Umbraco + DevOps)

This repository showcases a real-world example of deploying a content management platform (CMS) built with Umbraco, using modern DevOps practices and Microsoft Azure infrastructure. All sensitive information has been sanitized for public sharing.

---

## 🔍 Overview

This project demonstrates the end-to-end deployment of a CMS platform for a mid-sized enterprise, hosted on Azure App Service Environment (ASE). The solution uses **Infrastructure as Code (Terraform)**, **CI/CD pipelines (Azure DevOps)**, and includes robust security, observability, and rollback mechanisms.

---

## 📁 Project Structure

enterprise-cms-devops-portfolio/
├── terraform/ # Terraform modules (sanitized)
├── pipelines/ # Azure DevOps YAML pipeline definitions
├── documentation/ # Architecture diagram & Word/PDF documentation
└── README.md



---

## ⚙️ Technologies Used

| Category           | Tools & Services                                |
|--------------------|--------------------------------------------------|
| IaC                | Terraform                                        |
| CI/CD              | Azure DevOps (YAML Pipelines)                   |
| Web Hosting        | Azure App Services (ASE)                        |
| Networking         | Azure Front Door + Web Application Firewall     |
| Monitoring         | Azure Monitor, Application Insights             |
| Security           | Azure Key Vault, RBAC, NSG, WAF, Advanced Tools |
| Code Quality       | SonarQube                                        |
| Backup & Recovery  | Azure Blob Storage (Cool Tier), VM snapshots    |

---

## 🚀 CI/CD Pipeline Highlights

- **YAML-based Pipelines** using shared templates
- **Development Deployments** triggered from `Development` branch
- **Production Deployments** gated and approved from `main` branch
- **Slot-based releases** enable zero-downtime deployments
- **SonarQube** and **Azure Advanced Security Tools** integrated in CI for quality and vulnerability scans
- Secrets managed through **App Service Configuration** and **Key Vault**

---

## 🏗️ Infrastructure Overview (Terraform)

Provisioned via Terraform modules:

- Azure Resource Groups
- Azure App Services (ASE)
- Azure Front Door + WAF
- Azure SQL and VM-based SQL Server
- Azure Storage Accounts
- DNS Zones, App Insights, and more

Terraform state stored in a secured backend.

---

## 🔐 Security Practices

- No secrets or credentials in source control
- All services deployed within a private VNet (no public IP exposure)
- App Services restricted via NSG to internal traffic only
- WAF rules block malicious traffic using OWASP rules and custom filters
- Alerts for IP flooding and blocked requests routed to email and Teams

---

## 🧠 Monitoring & Observability

- **Application Insights** tracks HTTP failures, SQL dependencies, and exceptions
- **Azure Monitor** provides dashboards and real-time alerts
- **Custom alerts** for WAF hits, deployment errors, and app crashes

---

## 💾 Backup Strategy

- Weekly database backups to `cmsstorageprod` Azure Blob Storage
- Only the **last 3 backups** retained at a time
- **Older 2 backups** moved to **Cool Tier** to save on storage cost
- Backups taken from VM-hosted SQL Server via scheduled tasks

---

## 🌐 Architecture Diagram

![Architecture Diagram](./documentation/architecture-diagram.png)

---

## 🔁 Rollback & DR Strategy

- **Slot-based deployment** enables quick rollback via swap reversal
- Azure-native VM & SQL snapshots configured
- Geo-redundant storage used for backup resilience
- RTO/RPO goals tracked per environment

---

## ✅ Key Accomplishments

- Automated deployment pipeline with zero-downtime production releases
- Full infrastructure provisioning via Terraform
- Enhanced security with WAF, NSG, Key Vault, and scanning tools
- Cost optimization through Cool-tier blob backups
- Full observability with alerts integrated into Teams and email

---

## 📄 Documentation

- 📘 [Download Word Document](./documentation/Enterprise_CMS_Deployment_Documentation.docx)
- 📊 [Architecture Diagram (PNG)](./documentation/architecture-diagram.png)

> ⚠️ This is a sanitized version of a real-world deployment project. All proprietary and client-specific data has been removed or anonymized.

---

## 📬 Contact

Want to know how I can help your business deploy secure, scalable systems in the cloud?

📧 Email me at: `jamiu.ejiwumi@gmail.com`  
🔗 [LinkedIn](https://www.linkedin.com/in/your-profile)  
🌐 Portfolio: `https://yourportfolio.com`

---

