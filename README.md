# 🌐 Armageddon: Secure Multi-Cloud Application Platform with Private Database Connectivity

<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Inter&weight=700&size=24&pause=1200&color=58A6FF&center=true&vCenter=true&width=1100&lines=AWS+Tokyo+%2B+AWS+S%C3%A3o+Paulo+%2B+GCP+Iowa;Private+RDS+Connectivity+Across+Clouds;Terraform+%2B+HA+VPN+%2B+BGP+%2B+Transit+Gateway+%2B+CloudFront+%2B+WAF" alt="Typing SVG" />
</p>

<p align="center">
  A production-inspired multi-cloud infrastructure project that proves private application-to-database connectivity across AWS and GCP using Terraform, Transit Gateway, HA VPN, BGP, private routing, load balancing, security controls, observability, and evidence-driven validation.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/AWS-Multi--Region-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white" />
  <img src="https://img.shields.io/badge/GCP-Private%20Compute-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white" />
  <img src="https://img.shields.io/badge/Terraform-IaC-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" />
  <img src="https://img.shields.io/badge/Linux-Server%20Ops-FCC624?style=for-the-badge&logo=linux&logoColor=black" />
  <img src="https://img.shields.io/badge/Bash-Automation-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/CloudFront-Edge%20Security-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white" />
  <img src="https://img.shields.io/badge/Route%2053-DNS-FF9900?style=for-the-badge&logo=amazonroute53&logoColor=white" />
  <img src="https://img.shields.io/badge/AWS%20WAF-Web%20Protection-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white" />
  <img src="https://img.shields.io/badge/RDS%20MySQL-Private%20Database-527FFF?style=for-the-badge&logo=amazonrds&logoColor=white" />
  <img src="https://img.shields.io/badge/Secrets%20Manager-Credentials-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Transit%20Gateway-Core%20Routing-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white" />
  <img src="https://img.shields.io/badge/HA%20VPN-Cross--Cloud-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white" />
  <img src="https://img.shields.io/badge/BGP-Dynamic%20Routing-0052CC?style=for-the-badge" />
  <img src="https://img.shields.io/badge/CloudWatch-Observability-FF4F00?style=for-the-badge&logo=amazoncloudwatch&logoColor=white" />
  <img src="https://img.shields.io/badge/Pentesting-Red%20Packet-red?style=for-the-badge" />
</p>

---

## 📋 Table of Contents

* [📌 Project Objective](#-project-objective)
* [🧠 Problem Statement](#-problem-statement)
* [🏗️ Architecture](#️-architecture)
* [📊 Architecture Diagrams](#-architecture-diagrams)
* [🖥️ Project Overview](#️-project-overview)
* [🎥 Demo Videos](#-demo-videos)
* [🧰 Technology Stack](#-technology-stack)
* [☁️ Cloud Services Used](#️-cloud-services-used)
* [📁 Project Structure](#-project-structure)
* [🚀 Quick Start](#-quick-start)
* [⚙️ Implementation Summary](#️-implementation-summary)
* [🔐 Security Architecture](#-security-architecture)
* [🌐 Network Architecture](#-network-architecture)
* [🗄️ Database Architecture](#️-database-architecture)
* [🧪 Validation and Testing](#-validation-and-testing)
* [🛡️ Pentesting and Security Assessment](#️-pentesting-and-security-assessment)
* [📊 Observability](#-observability)
* [🔁 CI/CD Pipeline Simulation](#-cicd-pipeline-simulation)
* [🏢 Enterprise Architecture Mapping](#-enterprise-architecture-mapping)
* [⚖️ Scaling Considerations](#️-scaling-considerations)
* [🧩 Multi-Service Expansion](#-multi-service-expansion)
* [📸 Evidence Pack](#-evidence-pack)
* [🧹 Teardown](#-teardown)
* [🧠 Lessons Learned](#-lessons-learned)
* [🧪 Troubleshooting Highlights](#-troubleshooting-highlights)
* [📚 References](#-references)
* [👥 Author](#-author)

---

## 📌 Project Objective

The objective of this project was to build and validate a secure, multi-cloud application platform across AWS and Google Cloud Platform.

This project proves that separate application environments can operate across multiple regions and cloud providers while privately connecting back to a centralized AWS RDS MySQL database.

The final architecture demonstrates:

* AWS Tokyo as the central private database and transit hub
* AWS São Paulo as a regional application environment
* GCP Iowa as a separate cloud application environment
* Private cross-cloud database connectivity
* AWS Transit Gateway routing
* Inter-region Transit Gateway peering
* GCP HA VPN connectivity into AWS
* BGP route exchange
* Private subnet compute
* Public load-balanced application entry points
* CloudFront, WAF, Route 53, and HTTPS exposure
* Terraform-driven infrastructure deployment
* Evidence-based validation and security assessment

---

## 🧠 Problem Statement

Modern enterprise systems rarely live inside one simple network boundary.

Organizations often need to connect:

* Applications across regions
* Workloads across cloud providers
* Private databases to remote compute environments
* Public entry points to private application tiers
* Security controls to infrastructure deployed through code
* Operational evidence to engineering decisions

The difficult part is not simply creating cloud resources.

The difficult part is proving that the architecture works end-to-end.

```text
Public User
→ Secure Edge
→ Regional Load Balancer
→ Private Compute
→ Private Routing
→ Cross-Cloud Network Path
→ Private Database
→ Observability and Evidence
```

This project was built to solve that challenge in a hands-on, production-inspired way.

---

## 🏗️ Architecture

At a high level, this platform is built around three major environments.

| Environment | Cloud | Region | Purpose |
|---|---|---|---|
| Tokyo / Japan | AWS | `ap-northeast-1` | Central database, Transit Gateway hub, VPN termination |
| São Paulo / Brazil | AWS | `sa-east-1` | Public-facing regional application stack |
| Iowa / United States | GCP | `us-central1` | Cross-cloud application stack connected through HA VPN and BGP |

The database authority lives in AWS Tokyo.

Application workloads in AWS São Paulo and GCP Iowa connect back to Tokyo over private network paths.

---

## 📊 Architecture Diagrams

### Global Architecture

![Global Architecture](./Evidence/01-architecture/global-architecture-diagram.png)

### AWS Japan / Tokyo Architecture

![AWS Japan Architecture](./Evidence/01-architecture/aws-japan-architecture.png)

### AWS São Paulo Architecture

![AWS São Paulo Architecture](./Evidence/01-architecture/aws-sao-paulo-architecture.png)

### GCP Iowa Architecture

![GCP Iowa Architecture](./Evidence/01-architecture/gcp-iowa-architecture.png)

---

## 🖥️ Project Overview

This project deploys a stateful web application architecture where application servers can create, read, and validate data stored in a private RDS MySQL database.

This project is more than a web application. It is a complete infrastructure engineering build that combines cloud networking, application hosting, secure database access, private routing, multi-cloud connectivity, Terraform state handoff, edge protection, application validation, observability, evidence generation, and controlled security testing.

The application layer validates that the infrastructure is not theoretical. It proves the network path by writing and reading data through the private database connection.

---

## 🎥 Demo Videos

This section provides visual proof of the deployed multi-cloud architecture in action.  
The recordings demonstrate live application connectivity across cloud providers, regions, and private network paths, validating that the AWS, GCP, and Japan database components were successfully integrated.

### AWS São Paulo to Japan

This demo validates connectivity from the AWS São Paulo application layer to the Japan-hosted database environment.  
It confirms that the application can reach the backend database over the intended cloud network path and that the cross-region AWS architecture is functioning correctly.

https://github.com/user-attachments/assets/2ea12e3b-d528-4f82-ae48-b46c005f5ae9

### GCP Iowa to Japan

This demo validates connectivity from the GCP Iowa application layer to the Japan-hosted database environment.  
It confirms that the GCP workload can communicate with the AWS-hosted database over the configured hybrid cloud path, proving the multi-cloud routing and private connectivity design.

https://github.com/user-attachments/assets/d70e02f6-f842-4fad-92d9-9ec6975027d4


## 🧰 Technology Stack

| Layer | Technology |
|---|---|
| Infrastructure as Code | Terraform |
| Cloud Provider 1 | AWS |
| Cloud Provider 2 | Google Cloud Platform |
| AWS Regions | Tokyo / `ap-northeast-1`, São Paulo / `sa-east-1` |
| GCP Region | Iowa / `us-central1` |
| Compute | EC2, Auto Scaling Group, GCP Managed Instance Group |
| Application | Python Flask |
| Database | Amazon RDS MySQL |
| Networking | VPC, Subnets, Route Tables, Transit Gateway, HA VPN, BGP |
| Edge | CloudFront, Route 53, ACM, Application Load Balancer |
| Security | IAM, Security Groups, WAF, Secrets Manager, SSM |
| Observability | CloudWatch, Alarms, Logs, GCP Health Checks |
| Testing | curl, systemctl, ss, traceroute, security assessment scripts |
| Security Assessment | Custom red-packet pentesting workflow |

---

## ☁️ Cloud Services Used

| Service | Purpose |
|---|---|
| AWS VPC | Isolated AWS networking for Tokyo and São Paulo |
| AWS Subnets | Public and private subnet segmentation |
| AWS Route Tables | Private and public routing control |
| AWS Transit Gateway | Central routing hub for AWS and cross-cloud paths |
| TGW Peering | Inter-region routing between Tokyo and São Paulo |
| AWS Site-to-Site VPN | VPN termination between AWS and GCP |
| Amazon RDS MySQL | Private relational database |
| AWS Secrets Manager | Database credential storage and retrieval |
| AWS IAM | Least-privilege service access |
| AWS EC2 | Application compute |
| AWS Auto Scaling Group | São Paulo application scaling |
| AWS Application Load Balancer | Regional HTTP/HTTPS application entry point |
| Amazon CloudFront | Global edge distribution |
| AWS WAF | Web-layer protection |
| Route 53 | Public DNS routing |
| ACM | TLS certificate management |
| CloudWatch | Logs, metrics, alarms, and dashboards |
| GCP VPC | Isolated GCP network |
| GCP Subnets | Private compute and proxy-only subnet design |
| GCP Managed Instance Group | Regional application compute |
| GCP Regional Load Balancer | Public entry point into private GCP app instances |
| GCP Cloud Router | BGP route exchange |
| GCP HA VPN | Cross-cloud encrypted connectivity |
| GCP Cloud NAT | Outbound internet access for private instances |

---

## 📁 Project Structure

```text
LAB-4/
├── README.md
├── .gitignore
│
├── Evidence/
│   ├── Evidence-pack.md
│   ├── 00-executive-summary/
│   ├── 01-architecture/
│   ├── 02-terraform-workflows/
│   ├── 03-gcp-iowa/
│   ├── 04-aws-japan-tokyo/
│   ├── 05-aws-sao-paulo/
│   ├── 06-cross-cloud-networking/
│   ├── 07-security-iam-secrets/
│   ├── 08-observability/
│   ├── 09-application-validation/
│   └── 10-testing-commands/
│
├── IOWA/
│   ├── Terraform configuration for GCP Iowa
│   ├── VPC, subnets, firewall rules, Cloud NAT
│   ├── Cloud Router, HA VPN, BGP
│   ├── Regional load balancer
│   ├── Managed instance group
│   └── Startup script for the GCP application workload
│
├── JAPAN/
│   ├── Terraform configuration for AWS Tokyo
│   ├── VPC, public and private subnets
│   ├── RDS MySQL database
│   ├── Secrets Manager
│   ├── Transit Gateway
│   ├── AWS VPN connections to GCP
│   └── TGW peering to São Paulo
│
├── Sao-Paulo/
│   ├── Terraform configuration for AWS São Paulo
│   ├── VPC, public and private subnets
│   ├── EC2 application infrastructure
│   ├── Auto Scaling Group
│   ├── Application Load Balancer
│   ├── CloudFront
│   ├── Route 53
│   ├── WAF
│   └── TGW peering back to Tokyo
│
├── Scripts/
│   ├── gojo_banner_pack/
│   ├── 1-build_everything.sh
│   ├── a-change_secret_id.sh
│   ├── b-build_states.sh
│   ├── c-build_tgw_vpn.sh
│   ├── lala.sh
│   └── z-destroy_everything.sh
│
└── z-PENTESTING/
    ├── red-packet/
    │   ├── 03_findings/
    │   ├── 04_artifacts/
    │   ├── 05_final_report/
    │   ├── 00_rules_of_engagement.md
    │   ├── 01_target_map.md
    │   ├── 02_activity_log.csv
    │   └── README.md
    │
    ├── red-packet-package/
    │   ├── manifest_*.sha256
    │   ├── package_summary_*.md
    │   ├── red-packet-*.tar.gz
    │   └── secret_pattern_check_*.txt
    │
    ├── report-builder/
    │   ├── inputs/
    │   │   ├── iowa/
    │   │   ├── saopaulo/
    │   │   └── tokyo/
    │   ├── outputs/
    │   │   ├── consolidated_security_report.md
    │   │   ├── extracted_findings.json
    │   │   └── run_summary.md
    │   └── build_report.py
    │
    ├── GITHUB_EVIDENCE_INDEX.md
    ├── INTERVIEW_DEFENSE_GUIDE.md
    ├── PORTFOLIO_SECURITY_SUMMARY.md
    ├── step0-complete_test.sh
    ├── step2_collect_targets.sh
    ├── step3_recon_baseline.sh
    ├── step4_web_baseline.sh
    ├── step5_iac_cloud_posture.sh
    ├── step6_generate_web_findings.sh
    ├── step7_local_llama_report_builder.sh
    ├── step8_finalize_handoff.sh
    ├── step9_package_red_packets.sh
    ├── step10_create_github_docs.sh
    └── step11_final_qa.sh
```

---

## 🚀 Quick Start

This project is designed to build the full multi-cloud environment through the automation scripts in the `Scripts/` folder.

Before running the build, update the required values inside all three infrastructure folders:

```text
JAPAN/
IOWA/
Sao-Paulo/
```
### 1. Update Required Values

Before running Terraform, update the project-specific variables inside each environment folder.

You must have the following ready:

* A valid email address for SNS notifications
* A valid GCP project ID
* A registered domain name that you control
* Access to update DNS records for that domain

The domain is required because the Sao-Paulo environment uses Route 53, CloudFront, DNS records, and HTTPS routing.

---

#### JAPAN

Update the email value used for notifications.

Go to:

```text
JAPAN/2-var.tf
```

Look for the email variable around line 78:

```hcl
sns_email = "your-email@example.com"
```

Replace it with your own email address:

```hcl
sns_email = "your-real-email@example.com"
```

---

#### Sao-Paulo

Update the email value used for notifications.

Go to:

```text
Sao-Paulo/2-var.tf
```

Look for the email variable around line 82:

```hcl
sns_email = "your-email@example.com"
```

Replace it with your own email address:

```hcl
sns_email = "your-real-email@example.com"
```

Next, update the domain value.

In the same file:

```text
Sao-Paulo/2-var.tf
```

Look for the domain variable around line 98.

Example:

```hcl
root_domain_name = "your-domain.com"
```

Replace it with your own domain:

```hcl
root_domain_name = "example.com"
```

This must be a real domain that you own or control. You will need access to its DNS settings so the project can create or validate the required records.

---

#### IOWA

Update the GCP project ID.

Go to:

```text
IOWA/2-var.tf
```

Look for the GCP project variable:

```hcl
gcp_project_id = "your-gcp-project-id"
```

Replace it with your own GCP project ID:

```hcl
gcp_project_id = "my-real-gcp-project-id"
```

Update the email value and any project-specific domain or notification settings.

Replace the default email values with your own email address.

### 2. Authenticate to AWS and GCP

This project requires both AWS CLI authentication and GCP CLI authentication before deployment.

#### AWS CLI Login

Make sure your AWS CLI is authenticated and pointed at the correct account.

```bash
aws sts get-caller-identity
```

If this fails, configure your AWS credentials first.

```bash
aws configure
```

Or use your preferred AWS SSO/profile workflow.

```bash
aws sso login --profile your-profile-name
```

#### GCP CLI Login

Authenticate to Google Cloud.

```bash
gcloud auth login
```

Set your active GCP project.

```bash
gcloud config set project YOUR_GCP_PROJECT_ID
```

Authenticate Application Default Credentials.

```bash
gcloud auth application-default login
```

Verify the active project.

```bash
gcloud config get-value project
```

### 3. Build the Entire Environment

After the required values are updated and both cloud CLIs are authenticated, move into the `Scripts/` folder.

```bash
cd Scripts
```

Make the scripts executable.

```bash
chmod +x *.sh
```

Run the full build script.

```bash
./1-build_everything.sh
```

This script is intended to build the full environment across:

```text
JAPAN
IOWA
Sao-Paulo
```

The build process creates the infrastructure dependencies in sequence and connects the multi-cloud networking paths together.

### 4. If the Build Fails

This project is complex. If something fails, read the error carefully, fix the issue, and run the build script again.

Common failure areas include:

* Missing AWS credentials
* Missing GCP Application Default Credentials
* Wrong GCP project ID
* Unconfirmed SNS email subscription
* Domain or certificate validation issues
* Terraform dependency timing
* VPN or Transit Gateway dependency order
* Cloud provider quota limits
* Local script permissions

This is a real infrastructure build, not a toy deployment. If something breaks, debug it like an engineer.

Useful commands:

```bash
terraform validate
terraform plan
terraform apply
```

Then rerun:

```bash
./1-build_everything.sh
```

Good luck. You will need developer-level patience if the cloud providers decide to fight back.

### 5. Important Control File Warning

Be very careful when modifying the `4-control.tf` files.

These files control major build and destroy dependencies across the project. They affect when Terraform enables or disables specific workflow stages such as:

* Remote state dependency loading
* Transit Gateway peering
* VPN creation
* Route creation
* Cross-cloud dependency wiring
* Destroy ordering

Changing these files without understanding the dependency flow can break the build or destroy process.

Do not randomly flip values inside `4-control.tf`.

---

## ⚙️ Implementation Summary

The project was built in separate infrastructure domains and then connected through private networking.

### 1. AWS Tokyo Foundation

Tokyo acts as the central database and routing authority.

Implemented components:

* AWS VPC
* Public and private subnets
* Internet gateway
* Route tables
* Security groups
* RDS MySQL database
* Secrets Manager secret
* Transit Gateway
* VPN connections for GCP
* TGW peering toward São Paulo

### 2. GCP Iowa Application Environment

Iowa acts as the GCP application environment.

Implemented components:

* GCP VPC
* Private subnet
* Proxy-only subnet
* Firewall rules
* Cloud NAT
* Cloud Router
* HA VPN gateway
* BGP sessions
* Regional external load balancer
* Managed instance group
* Startup script-based Flask application

### 3. AWS São Paulo Application Environment

São Paulo acts as the AWS regional application environment.

Implemented components:

* AWS VPC
* Public and private subnets
* Route tables
* EC2 application layer
* Auto Scaling Group
* Application Load Balancer
* ACM certificate
* Route 53 records
* CloudFront distribution
* WAF Web ACL
* Transit Gateway
* TGW peering back to Tokyo

### 4. Cross-Cloud Private Database Connectivity

The final system validates private database access across two paths.

```text
GCP Iowa Application
→ GCP HA VPN
→ AWS Tokyo VPN Connection
→ Tokyo Transit Gateway
→ Private RDS MySQL
```

```text
AWS São Paulo Application
→ São Paulo Transit Gateway
→ TGW Peering
→ Tokyo Transit Gateway
→ Private RDS MySQL
```

---

## 🔐 Security Architecture

Security was designed across multiple layers.

| Layer | Control |
|---|---|
| Network | Public/private subnet separation |
| Routing | TGW route tables, private routes, VPN/BGP exchange |
| Edge | CloudFront, ALB, HTTPS, Route 53 |
| Web Protection | AWS WAF |
| Identity | IAM roles for EC2 and service access |
| Secrets | AWS Secrets Manager |
| Database | Private RDS endpoint and restricted security group path |
| Administration | SSM-based private instance access pattern |
| Logging | CloudWatch logs and security evidence artifacts |
| Validation | Pentesting workflow and red-packet evidence bundle |

The design avoids placing the database directly on the public internet. Application traffic reaches the database through private network paths and controlled routing.

---

## 🌐 Network Architecture

This project is heavily network-driven.

Core network design:

```text
AWS Tokyo VPC:       10.100.0.0/16
AWS São Paulo VPC:   10.200.0.0/16
GCP Iowa VPC:        10.250.0.0/16
```

Network paths:

| Path | Method | Purpose |
|---|---|---|
| GCP Iowa to AWS Tokyo | HA VPN + BGP | Cross-cloud private app-to-database path |
| AWS São Paulo to AWS Tokyo | TGW Peering | Inter-region private app-to-database path |
| Public user to São Paulo app | CloudFront / Route 53 / ALB | Public application access |
| Public user to GCP app | GCP Regional Load Balancer | Public application access |
| Private app to RDS | Private route tables and security groups | Database access |

This architecture demonstrates real enterprise networking patterns, including segmentation, private routing, encrypted tunnels, and centralized data services.

---

## 🗄️ Database Architecture

The database layer is hosted in AWS Tokyo using Amazon RDS MySQL.

Design characteristics:

* Private RDS endpoint
* Database deployed away from public application entry points
* Application-to-database access over private routing
* Credentials managed through AWS Secrets Manager
* Database used as the shared state layer for application validation
* Connectivity tested from both AWS São Paulo and GCP Iowa application environments

The database is the proof point of the entire architecture. If remote applications can successfully write to and read from the private RDS instance, then the network, IAM, routing, and application configuration are working together.

---

## 🧪 Validation and Testing

Validation was performed across infrastructure, network, application, and security layers.

### Application Validation

Evidence captured:

* GCP application homepage
* GCP health check
* GCP database initialization
* GCP note creation
* GCP note listing
* São Paulo application homepage
* São Paulo database initialization
* São Paulo note creation
* São Paulo note listing
* Shared RDS data proof

### System Validation

Evidence captured:

* `systemctl status` for application service
* `ss` port validation for port `80`
* Local curl tests
* Load balancer curl tests
* Traceroute/private path checks
* Backend health checks
* Target group health checks

### Network Validation

Evidence captured:

* AWS VPN tunnel status
* GCP VPN tunnel status
* BGP route exchange
* TGW route propagation
* TGW peering path
* Private RDS reachability from separate compute environments

---

## 🛡️ Pentesting and Security Assessment

This project includes a dedicated security assessment section under:

```text
z-PENTESTING/
```

The pentesting workflow was designed as a controlled, evidence-based assessment process for the deployed multi-cloud platform.

The main pentesting components include:

| Component | Purpose |
|---|---|
| `red-packet/` | Main assessment evidence workspace |
| `00_rules_of_engagement.md` | Defines authorized testing boundaries |
| `01_target_map.md` | Documents approved targets |
| `02_activity_log.csv` | Tracks testing activity |
| `03_findings/` | Stores discovered findings |
| `04_artifacts/` | Stores recon, cloud, web, and IaC artifacts |
| `05_final_report/` | Stores final security reports and handoff documents |
| `red-packet-package/` | Stores packaged evidence bundles, manifests, and secret checks |
| `report-builder/` | Builds consolidated security reporting from collected inputs |
| `step0` through `step11` scripts | Automates assessment, collection, packaging, and QA workflow |

The security workflow was built as a formal evidence chain.

At a high level, the pentesting process covers:

* Rules of engagement
* Target mapping
* Activity logging
* Baseline reconnaissance
* Web baseline checks
* IaC and cloud posture review
* Finding generation
* Local report building
* Final handoff creation
* GitHub documentation generation
* Final QA before publishing

The independent pentesting README documents this folder in depth. This main README only summarizes the pentesting capability so the primary project remains focused on the full multi-cloud architecture.

### Publishing Safety Warning

Before publishing the pentesting artifacts, review and sanitize:

```text
z-PENTESTING/red-packet-package/secret_pattern_check_*.txt
```

Do not publish:

* Real passwords
* Database credentials
* VPN pre-shared keys
* Private keys
* Access tokens
* Full Terraform state
* Unredacted cloud account identifiers
* Sensitive infrastructure metadata
* Real PHI or regulated data

---

## 📊 Observability

The project includes operational visibility across AWS and GCP.

Observability evidence includes:

* AWS CloudWatch dashboard
* ALB request metrics
* ALB 5XX alarm
* Auto Scaling Group health alarm
* RDS connection alarm
* SNS notification topic
* GCP health check status
* GCP MIG autohealing status
* Load balancer backend health

The observability layer proves the system is not only deployed, but monitorable.

---

## 🔁 CI/CD Pipeline Simulation

Although this project was built primarily through direct Terraform workflows, the structure supports CI/CD expansion.

A production pipeline could follow this pattern:

```text
Git Push
→ Terraform fmt
→ Terraform validate
→ Terraform plan
→ Security scan
→ Manual approval
→ Terraform apply
→ Health checks
→ Evidence capture
→ Security assessment packaging
```

Recommended future CI/CD integrations:

* GitHub Actions
* GitLab CI
* Terraform plan artifacts
* Manual approval gates
* Checkov or tfsec IaC scanning
* Secret scanning
* OIDC-based cloud authentication
* Automated evidence generation after successful deployment

---

## 🏢 Enterprise Architecture Mapping

This project maps directly to enterprise cloud architecture patterns.

| Enterprise Pattern | Project Implementation |
|---|---|
| Multi-cloud connectivity | AWS + GCP connected through HA VPN and BGP |
| Centralized data services | RDS MySQL hosted privately in AWS Tokyo |
| Regional application hosting | AWS São Paulo and GCP Iowa app environments |
| Private network routing | TGW, TGW peering, VPN, BGP, private route tables |
| Edge security | CloudFront, WAF, HTTPS, Route 53 |
| Infrastructure as Code | Terraform-based deployment |
| Secrets management | AWS Secrets Manager |
| Operational monitoring | CloudWatch, alarms, health checks |
| Security validation | Red-packet pentesting workflow |
| Evidence-based engineering | Dedicated Evidence folder and final validation screenshots |

---

## ⚖️ Scaling Considerations

The architecture can scale in several ways.

### Compute Scaling

* AWS São Paulo can scale through Auto Scaling Groups.
* GCP Iowa can scale through Managed Instance Groups.
* Load balancers distribute traffic to healthy targets.

### Network Scaling

* AWS Transit Gateway supports additional VPC attachments.
* GCP Cloud Router can exchange additional routes.
* More regions can be connected through TGW peering or additional VPNs.

### Application Scaling

The Flask application can evolve into:

* Containerized workloads
* ECS/Fargate services
* GKE workloads
* API Gateway-backed services
* Microservice-based architecture

### Database Scaling

Future database improvements could include:

* RDS Multi-AZ
* Read replicas
* Automated backups
* Performance Insights
* Tighter security group scoping
* Migration to Aurora MySQL for higher availability

---

## 🧩 Multi-Service Expansion

This project can expand into a larger enterprise-grade platform.

Possible future improvements:

* ECS or EKS application layer
* GKE service mesh integration
* Private API Gateway
* Centralized SIEM pipeline
* GuardDuty and Security Hub integration
* AWS Network Firewall
* Cloud Armor for GCP
* Automated remediation Lambdas
* Cross-region disaster recovery
* Blue/green deployment pipeline
* Full compliance mapping against CIS, NIST, or SOC 2 controls

---

## 📸 Evidence Pack

The project includes a dedicated evidence pack under:

```text
Evidence/
```

The evidence pack documents:

* Final architecture
* Terraform workflow proof
* GCP Iowa deployment proof
* AWS Tokyo deployment proof
* AWS São Paulo deployment proof
* Cross-cloud networking proof
* Security and IAM proof
* Observability proof
* Application validation proof
* Testing command proof

Main evidence file:

```text
Evidence/Evidence-pack.md
```

The evidence pack is designed to prove that the project reached a final working state.

---

## 🧹 Teardown

To destroy the full environment, use the destroy automation script.

From the project root, move into the `Scripts/` folder:

```bash
cd Scripts
```

Run the teardown script:

```bash
./z-destroy_everything.sh
```

This is the recommended way to bring the project down.

The destroy script is designed to handle the dependency order across:

```text
IOWA
Sao-Paulo
JAPAN
```

Because this project uses cross-cloud networking, VPNs, Transit Gateway peering, remote state dependencies, and regional infrastructure, manual teardown can easily fail if resources are destroyed in the wrong order.

After teardown, verify that expensive resources are removed:

* RDS instances
* NAT gateways
* Load balancers
* CloudFront distributions
* VPN connections
* Transit Gateways
* Elastic IPs
* GCP forwarding rules
* GCP VPN gateways
* GCP Cloud NAT routers
* CloudWatch log groups

Be especially careful modifying the `4-control.tf` files before teardown, because those files control build and destroy dependencies.

---

## 🧠 Lessons Learned

This project forced multiple advanced cloud engineering concepts to work together.

Key lessons:

* Multi-cloud networking requires disciplined routing and CIDR planning.
* BGP connectivity is only useful when route advertisements and return paths are correct.
* Private database access depends on routing, DNS, security groups, and application configuration all working together.
* Terraform remote state can solve cross-environment dependency problems, but it must be handled carefully.
* Load balancer health checks often fail because of simple mismatches: wrong port, wrong path, firewall restrictions, or service bind address.
* Secrets must be handled carefully because generated evidence can accidentally capture sensitive values.
* Evidence matters. Screenshots, command outputs, diagrams, and structured reports turn a project from “I built it” into “I can prove it works.”

---

## 🧪 Troubleshooting Highlights

Major troubleshooting areas included:

| Issue | Root Cause Category | Resolution |
|---|---|---|
| GCP health check failures | Firewall, backend service, app port, or health path mismatch | Validated service status, port binding, firewall rules, and load balancer config |
| RDS connectivity failures | Security group or private route path issue | Corrected database access path |
| Startup script failures | Template variable or runtime dependency issue | Validated rendered startup script and systemd service |
| TGW route issues | Missing peering route or route table association | Corrected TGW routing |
| VPN/BGP issues | ASN, tunnel, or route exchange mismatch | Validated tunnel status and route propagation |
| Secret exposure risk | Collected artifacts included credential-like values | Reviewed secret pattern checks and sanitized before publishing |

---

## 📚 References

* AWS Transit Gateway Documentation
* AWS Site-to-Site VPN Documentation
* AWS VPC Documentation
* AWS RDS Documentation
* AWS Secrets Manager Documentation
* AWS CloudFront Documentation
* AWS WAF Documentation
* Google Cloud HA VPN Documentation
* Google Cloud Router Documentation
* Google Cloud Load Balancing Documentation
* Terraform AWS Provider Documentation
* Terraform Google Provider Documentation

---

## 👥 Author

**Gavin Fogwe**  
Cloud Security / AWS Infrastructure Engineer

---

## Final Statement

This project represents a complete multi-cloud infrastructure build with real routing, real application validation, real private database connectivity, real security controls, and real evidence.

It demonstrates the ability to design, deploy, troubleshoot, validate, document, and assess a complex cloud platform across AWS and GCP.
