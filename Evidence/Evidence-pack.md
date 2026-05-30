# Evidence Pack

## Project

**Secure Multi-Cloud Application Platform with AWS, GCP, Private RDS Connectivity, HA VPN, BGP, Transit Gateway Peering, CloudFront, WAF, Observability, and Terraform**

---

## Purpose

This evidence pack documents the **final working state** of a multi-cloud application platform deployed across:

* AWS São Paulo / `sa-east-1`
* AWS Japan / `ap-northeast-1`
* Google Cloud Iowa / `us-central1`

The evidence proves that the project was deployed, validated, and operational across the following layers:

* multi-cloud architecture
* AWS regional networking
* GCP regional networking
* AWS Transit Gateway routing
* AWS Transit Gateway inter-region peering
* GCP HA VPN and BGP
* private RDS MySQL database connectivity
* public application delivery through CloudFront, WAF, Route 53, and ALB
* private EC2 application hosting
* GCP private Managed Instance Group hosting
* Secrets Manager and IAM access controls
* VPC endpoints and private service access
* CloudWatch, SNS, S3 logging, and GCP health checks
* Terraform-based infrastructure deployment
* application validation through browser, curl, service, and port evidence

This document is not the full project README. It is the evidence index that explains what each artifact proves.

---

## Final Architecture Summary

```text
AWS São Paulo Public Application Path

User
  ↓
Amazon Route 53
  ↓
Amazon CloudFront + AWS WAF
  ↓
HTTPS / ACM
  ↓
Application Load Balancer
  ↓
Private EC2 Auto Scaling Group
  ↓
São Paulo Transit Gateway
  ↓
Transit Gateway Peering
  ↓
Japan Transit Gateway
  ↓
Private Amazon RDS MySQL Database
```

```text
GCP Iowa Application Path

User
  ↓
GCP Regional External HTTP Load Balancer
  ↓
Backend Service
  ↓
Private Managed Instance Group
  ↓
Cloud Router
  ↓
HA VPN + BGP
  ↓
AWS Japan VPN Path
  ↓
Japan Transit Gateway
  ↓
Private Amazon RDS MySQL Database
```

The architecture uses public managed entry points for application access while keeping application compute and the database layer private. AWS São Paulo reaches the Japan database through Transit Gateway peering. GCP Iowa reaches the same Japan database through HA VPN and BGP.

---

# 1. Executive Summary Evidence

## Final Project Summary

This document summarizes the final project purpose, business problem, project objective, major services, architecture value, and final working state.

It explains the project at a high level for reviewers who need to understand what was built before looking at individual screenshots.

![Final Project Summary](./00-executive-summary/final-project-summary.png)

---

## Final Architecture Overview

This document explains the final architecture across AWS São Paulo, AWS Japan, and GCP Iowa.

It maps the major traffic paths:

```text
AWS São Paulo → TGW Peering → AWS Japan RDS
GCP Iowa → HA VPN / BGP → AWS Japan RDS
```

![Final Architecture Overview](./00-executive-summary/final-architecture-overview.png)

---

## Final Working-State Checklist

This checklist tracks the final validation state of the platform.

It confirms that the required screenshots, diagrams, Terraform outputs, application tests, network paths, and security evidence were captured.

![Final Working-State Checklist](./00-executive-summary/final-working-state-checklist.png)

---

# 2. Architecture Evidence

## Global Architecture Diagram

This diagram shows the full multi-cloud platform across AWS and GCP.

It proves the complete high-level architecture:

* AWS São Paulo public application delivery
* AWS Japan private database hub
* GCP Iowa secondary application path
* Transit Gateway peering between São Paulo and Japan
* HA VPN and BGP between GCP Iowa and AWS Japan
* private RDS MySQL as the shared database backend

![Global Architecture Diagram](./01-architecture/global-architecture-diagram.png)

---

## AWS São Paulo Architecture

This diagram shows the AWS São Paulo application delivery architecture.

It proves the São Paulo side of the platform:

* Route 53 public DNS
* CloudFront edge delivery
* AWS WAF protection
* HTTPS certificate path
* Application Load Balancer
* public subnet load balancer layer
* private EC2 Auto Scaling Group
* Golden AMI and launch template pattern
* VPC endpoints for private AWS service access
* Secrets Manager integration
* CloudWatch, SNS, S3, and Firehose logging paths
* São Paulo Transit Gateway
* TGW peering path toward Japan

![AWS São Paulo Architecture](./01-architecture/aws-sao-paulo-architecture.png)

---

## AWS Japan Architecture

This diagram shows AWS Japan as the central database and transit hub.

It proves that Japan is responsible for:

* private RDS MySQL hosting
* private database subnets
* RDS security group
* Secrets Manager credential storage
* CloudWatch and SNS alerting
* Japan Transit Gateway
* VPN connectivity to GCP
* TGW peering connectivity to São Paulo

![AWS Japan Architecture](./01-architecture/aws-japan-architecture.png)

---

## GCP Iowa Architecture

This diagram shows the GCP Iowa application environment.

It proves the GCP side of the platform:

* GCP VPC
* private subnet
* proxy-only subnet
* regional external HTTP load balancer
* backend service
* health check
* private Managed Instance Group
* Cloud NAT
* Cloud Router
* HA VPN gateway
* BGP route exchange toward AWS Japan

![GCP Iowa Architecture](./01-architecture/gcp-iowa-architecture.png)

---

# 3. Terraform Workflow Evidence

## Repository Folder Structure

This screenshot shows the project repository structure.

It proves that the project is organized into separate infrastructure environments and evidence folders:

* `IOWA/`
* `JAPAN/`
* `Sao-Paulo/`
* `Evidence/`
* `Scripts/`
* `z-PENTESTING/`

![Repository Folder Structure](./02-terraform-workflows/repo-folder-structure.png)

---

## Terraform Init - Iowa

This screenshot shows Terraform initialization for the GCP Iowa environment.

Expected result:

```text
Terraform has been successfully initialized
```

![Terraform Init Iowa](./02-terraform-workflows/terraform-init-iowa.png)

---

## Terraform Apply - Iowa

This screenshot shows Terraform successfully applying the GCP Iowa infrastructure.

It proves that the GCP VPC, private subnet, load balancer, Managed Instance Group, Cloud NAT, Cloud Router, HA VPN, firewall rules, and related resources were created.

![Terraform Apply Iowa](./02-terraform-workflows/terraform-apply-iowa.png)

---

## Terraform Output - Iowa

This screenshot shows Terraform outputs from the GCP Iowa environment.

Important outputs include:

* GCP VPC CIDR
* GCP ASN
* HA VPN interface IPs
* GCP public load balancer IP or URL
* private subnet CIDR
* proxy-only subnet CIDR

![Terraform Output Iowa](./02-terraform-workflows/terraform-output-iowa.png)

---

## Terraform Init - Japan

This screenshot shows Terraform initialization for the AWS Japan environment.

Expected result:

```text
Terraform has been successfully initialized
```

![Terraform Init Japan](./02-terraform-workflows/terraform-init-japan.png)

---

## Terraform Apply - Japan

This screenshot shows Terraform successfully applying the AWS Japan infrastructure.

It proves that the Tokyo VPC, RDS database, Secrets Manager secret, Japan Transit Gateway, VPN connections, route tables, CloudWatch resources, and peering components were created.

![Terraform Apply Japan](./02-terraform-workflows/terraform-apply-japan.png)

---

## Terraform Output - Japan

This screenshot shows Terraform outputs from the AWS Japan environment.

Important outputs include:

* region
* VPC CIDR
* database hostname
* database port
* database username
* AWS ASN
* VPN tunnel addresses
* tunnel inside CIDRs
* Transit Gateway ID

![Terraform Output Japan](./02-terraform-workflows/terraform-output-japan.png)

---

## Terraform Init - São Paulo

This screenshot shows Terraform initialization for the AWS São Paulo environment.

Expected result:

```text
Terraform has been successfully initialized
```

![Terraform Init São Paulo](./02-terraform-workflows/terraform-init-sao-paulo.png)

---

## Terraform Apply - São Paulo

This screenshot shows Terraform successfully applying the AWS São Paulo infrastructure.

It proves that Route 53 records, CloudFront, WAF, ALB, private EC2 app tier, Auto Scaling Group, launch template, golden AMI, São Paulo Transit Gateway, and logging resources were created.

![Terraform Apply São Paulo](./02-terraform-workflows/terraform-apply-sao-paulo.png)

---

## Terraform Output - São Paulo

This screenshot shows Terraform outputs from the AWS São Paulo environment.

Important outputs include:

* CloudFront distribution ID
* CloudFront domain name
* root domain URL
* www domain URL
* São Paulo VPC CIDR
* region
* AMI ID

![Terraform Output São Paulo](./02-terraform-workflows/terraform-output-sao-paulo.png)

---

## Remote State Cross-Region Values

This screenshot shows remote state values being consumed across environments.

It proves that Terraform outputs from one environment were used to configure another environment.

Expected examples:

```text
GCP Iowa consumes AWS Japan VPN and RDS values.
AWS Japan consumes GCP VPN gateway values.
AWS São Paulo consumes Japan database and secret values.
```

![Remote State Cross-Region Values](./02-terraform-workflows/remote-state-cross-region-values.png)

---

# 4. GCP Iowa Evidence

## GCP VPC Created

This screenshot shows the GCP VPC created for the Iowa environment.

Expected VPC:

```text
nihonmachi-vpc01
```

![GCP VPC Created](./03-gcp-iowa/gcp-vpc-created.png)

---

## GCP Private Subnet

This screenshot shows the private subnet used by the GCP application instances.

Expected subnet:

```text
nihonmachi-subnet01
10.250.1.0/24
```

The application VMs are placed here without public IP exposure.

![GCP Private Subnet](./03-gcp-iowa/gcp-private-subnet.png)

---

## GCP Proxy-Only Subnet

This screenshot shows the proxy-only subnet required for the regional external managed HTTP load balancer.

Expected subnet:

```text
10.250.200.0/24
Purpose: REGIONAL_MANAGED_PROXY
```

![GCP Proxy-Only Subnet](./03-gcp-iowa/gcp-proxy-only-subnet.png)

---

## GCP Firewall - Load Balancer Proxy to VM

This screenshot shows the firewall rule allowing the regional load balancer proxy subnet to reach the private application VMs on port `80`.

Expected behavior:

```text
Proxy-only subnet → private app VMs on TCP/80
```

![GCP Firewall LB Proxy to VM](./03-gcp-iowa/gcp-firewall-lb-proxy-to-vm.png)

---

## GCP Firewall - Health Checks

This screenshot shows the firewall rule allowing Google health check ranges to reach the application on port `80`.

Expected source ranges:

```text
35.191.0.0/16
130.211.0.0/22
```

![GCP Firewall Health Checks](./03-gcp-iowa/gcp-firewall-health-checks.png)

---

## GCP Cloud Router and BGP

This screenshot shows the Cloud Router used for BGP route exchange between GCP and AWS.

Expected behavior:

```text
GCP advertises its private subnet to AWS.
AWS routes Japan private database paths back toward GCP.
```

![GCP Cloud Router BGP](./03-gcp-iowa/gcp-cloud-router-bgp.png)

---

## GCP Cloud NAT

This screenshot shows Cloud NAT configured for private VM outbound access.

Expected behavior:

```text
Private GCP VMs can install packages and reach required outbound services without public IPs.
```

![GCP Cloud NAT](./03-gcp-iowa/gcp-cloud-nat.png)

---

## GCP HA VPN Gateway

This screenshot shows the GCP HA VPN gateway.

It proves that GCP has a redundant VPN gateway path toward AWS Japan.

![GCP HA VPN Gateway](./03-gcp-iowa/gcp-ha-vpn-gateway.png)

---

## GCP External VPN Gateway - AWS

This screenshot shows the GCP external VPN gateway configuration that represents the AWS VPN tunnel endpoints.

![GCP External VPN Gateway AWS](./03-gcp-iowa/gcp-external-vpn-gateway-aws.png)

---

## GCP VPN Tunnels Healthy

This screenshot shows GCP VPN tunnels in a healthy or established state.

Expected result:

```text
Tunnel status: Established / Healthy
```

![GCP VPN Tunnels Healthy](./03-gcp-iowa/gcp-vpn-tunnels-healthy.png)

---

## GCP Managed Instance Group Running

This screenshot shows the Managed Instance Group running the private Debian Flask application VMs.

Expected behavior:

```text
MIG has healthy/running instances.
```

![GCP MIG Running](./03-gcp-iowa/gcp-mig-running.png)

---

## GCP MIG Autoscaler

This screenshot shows autoscaling configuration for the GCP application tier.

It proves that the GCP app tier was designed to scale beyond a single VM pattern.

![GCP MIG Autoscaler](./03-gcp-iowa/gcp-mig-autoscaler.png)

---

## GCP Regional Load Balancer

This screenshot shows the regional external HTTP load balancer.

Expected behavior:

```text
User traffic → regional load balancer → backend service → private MIG
```

![GCP Regional Load Balancer](./03-gcp-iowa/gcp-regional-lb.png)

---

## GCP Backend Service Healthy

This screenshot shows the backend service reporting healthy instances.

Expected result:

```text
Healthy backend
```

![GCP Backend Service Healthy](./03-gcp-iowa/gcp-backend-service-healthy.png)

---

## GCP Load Balancer Health Check

This screenshot shows the health check configuration used by the regional load balancer.

Expected path:

```text
/health
```

Expected port:

```text
80
```

![GCP LB Health Check](./03-gcp-iowa/gcp-lb-health-check.png)

---

# 5. AWS Japan / Tokyo Evidence

## Tokyo VPC Created

This screenshot shows the AWS Japan VPC.

Expected VPC role:

```text
Central database and transit-connected VPC
CIDR: 10.100.0.0/16
```

![Tokyo VPC Created](./04-aws-japan-tokyo/tokyo-vpc-created.png)

---

## Tokyo Public and Private Subnets

This screenshot shows the Japan subnet layout.

Expected subnets:

```text
Public:
10.100.1.0/24
10.100.2.0/24

Private:
10.100.11.0/24
10.100.12.0/24
```

![Tokyo Public Private Subnets](./04-aws-japan-tokyo/tokyo-public-private-subnets.png)

---

## Tokyo Route Tables

This screenshot shows Japan VPC route tables.

Expected behavior:

```text
Private routes support RDS traffic from São Paulo and GCP private paths.
```

![Tokyo Route Tables](./04-aws-japan-tokyo/tokyo-route-tables.png)

---

## Tokyo RDS Instance Running

This screenshot shows the RDS MySQL database in an available/running state.

Expected database:

```text
Amazon RDS MySQL
Database name: labdb
Private database layer
```

![Tokyo RDS Instance Running](./04-aws-japan-tokyo/tokyo-rds-instance-running.png)

---

## Tokyo RDS Private Subnet Group

This screenshot shows the RDS subnet group using private subnets.

Expected behavior:

```text
RDS is deployed into private database subnets.
```

![Tokyo RDS Private Subnet Group](./04-aws-japan-tokyo/tokyo-rds-private-subnet-group.png)

---

## Tokyo RDS Security Group

This screenshot shows the RDS security group.

Expected behavior:

```text
MySQL 3306 allowed only from approved private application paths.
```

![Tokyo RDS Security Group](./04-aws-japan-tokyo/tokyo-rds-security-group.png)

---

## Tokyo Secrets Manager RDS Secret

This screenshot shows the RDS credentials stored in AWS Secrets Manager.

Expected secret content includes database connection metadata such as:

```text
username
password
host
port
db_name
```

Do not expose the actual secret value publicly.

![Tokyo Secrets Manager RDS Secret](./04-aws-japan-tokyo/tokyo-secrets-manager-rds-secret.png)

---

## Tokyo Secret Replication

This screenshot shows secret replication or cross-region secret availability for application consumption.

Expected behavior:

```text
Remote application region can consume required database secret material.
```

![Tokyo Secret Replication](./04-aws-japan-tokyo/tokyo-secret-replication.png)

---

## Tokyo CloudWatch RDS Logs

This screenshot shows RDS logs or RDS-related CloudWatch log configuration.

Expected behavior:

```text
RDS emits logs or metrics for operational review.
```

![Tokyo CloudWatch RDS Logs](./04-aws-japan-tokyo/tokyo-cloudwatch-rds-logs.png)

---

## Tokyo RDS Alarms

This screenshot shows CloudWatch alarms for the RDS database.

Expected alarm coverage includes connection failures, health, or database operational signals.

![Tokyo RDS Alarms](./04-aws-japan-tokyo/tokyo-rds-alarms.png)

---

## Tokyo Transit Gateway Created

This screenshot shows the Japan Transit Gateway.

Expected TGW:

```text
shinjuku-tgw
ASN: 65001
```

![Tokyo TGW Created](./04-aws-japan-tokyo/tokyo-tgw-created.png)

---

## Tokyo TGW VPC Attachment

This screenshot shows the Japan VPC attached to the Japan Transit Gateway.

Expected behavior:

```text
Tokyo VPC ↔ Japan TGW
```

![Tokyo TGW VPC Attachment](./04-aws-japan-tokyo/tokyo-tgw-vpc-attachment.png)

---

## Tokyo TGW Route Table

This screenshot shows the Japan Transit Gateway route table.

Expected behavior:

```text
Routes exist for São Paulo, GCP Iowa, and Tokyo VPC private networks.
```

![Tokyo TGW Route Table](./04-aws-japan-tokyo/tokyo-tgw-route-table.png)

---

## Tokyo Customer Gateways to GCP

This screenshot shows the AWS customer gateway resources created for the GCP HA VPN endpoint IPs.

Expected behavior:

```text
AWS represents GCP VPN endpoints as customer gateways.
```

![Tokyo Customer Gateways to GCP](./04-aws-japan-tokyo/tokyo-customer-gateways-to-gcp.png)

---

## Tokyo VPN Connections to GCP

This screenshot shows AWS Site-to-Site VPN connections between AWS Japan and GCP Iowa.

Expected behavior:

```text
AWS VPN tunnels exist and connect toward GCP HA VPN.
```

![Tokyo VPN Connections to GCP](./04-aws-japan-tokyo/tokyo-vpn-connections-to-gcp.png)

---

## Tokyo TGW Peering to São Paulo

This screenshot shows the Transit Gateway peering connection between AWS Japan and AWS São Paulo.

Expected behavior:

```text
Japan TGW ↔ São Paulo TGW
```

![Tokyo TGW Peering to São Paulo](./04-aws-japan-tokyo/tokyo-tgw-peering-to-sao-paulo.png)

---

# 6. AWS São Paulo Evidence

## São Paulo VPC Created

This screenshot shows the AWS São Paulo VPC.

Expected VPC role:

```text
Primary public AWS application delivery VPC
CIDR: 10.200.0.0/16
```

![São Paulo VPC Created](./05-aws-sao-paulo/sao-paulo-vpc-created.png)

---

## São Paulo Public and Private Subnets

This screenshot shows the São Paulo public/private subnet layout.

Expected subnets:

```text
Public:
10.200.1.0/24
10.200.2.0/24

Private:
10.200.11.0/24
10.200.12.0/24
```

![São Paulo Public Private Subnets](./05-aws-sao-paulo/sao-paulo-public-private-subnets.png)

---

## São Paulo Route Tables

This screenshot shows the São Paulo route tables.

Expected behavior:

```text
Public subnets support ALB entry.
Private subnets route app-to-database traffic toward the São Paulo TGW.
```

![São Paulo Route Tables](./05-aws-sao-paulo/sao-paulo-route-tables.png)

---

## São Paulo Transit Gateway Created

This screenshot shows the São Paulo Transit Gateway.

Expected TGW:

```text
liberdade-tgw
```

![São Paulo TGW Created](./05-aws-sao-paulo/sao-paulo-tgw-created.png)

---

## São Paulo TGW VPC Attachment

This screenshot shows the São Paulo VPC attached to the São Paulo Transit Gateway.

Expected behavior:

```text
São Paulo VPC ↔ São Paulo TGW
```

![São Paulo TGW VPC Attachment](./05-aws-sao-paulo/sao-paulo-tgw-vpc-attachment.png)

---

## São Paulo TGW Peering Accepted

This screenshot shows the Transit Gateway peering accepted between São Paulo and Japan.

Expected behavior:

```text
São Paulo TGW ↔ Japan TGW peering is active/available.
```

![São Paulo TGW Peering Accepted](./05-aws-sao-paulo/sao-paulo-tgw-peering-accepted.png)

---

## São Paulo Private EC2 Auto Scaling Group

This screenshot shows the private EC2 Auto Scaling Group.

Expected behavior:

```text
Private EC2 app tier is managed by an Auto Scaling Group.
```

![São Paulo Private EC2 ASG](./05-aws-sao-paulo/sao-paulo-private-ec2-asg.png)

---

## São Paulo Launch Template

This screenshot shows the launch template used by the private EC2 app tier.

Expected behavior:

```text
Launch template defines AMI, instance type, IAM profile, security groups, and private app configuration.
```

![São Paulo Launch Template](./05-aws-sao-paulo/sao-paulo-launch-template.png)

---

## São Paulo Golden AMI

This screenshot shows the golden AMI created for the São Paulo application instance pattern.

Expected behavior:

```text
Golden AMI provides reusable baseline for private EC2 app instances.
```

![São Paulo Golden AMI](./05-aws-sao-paulo/sao-paulo-golden-ami.png)

---

## São Paulo ALB Active

This screenshot shows the Application Load Balancer in an active state.

Expected behavior:

```text
Public ALB receives traffic and forwards it to private app targets.
```

![São Paulo ALB Active](./05-aws-sao-paulo/sao-paulo-alb-active.png)

---

## São Paulo Target Group Healthy

This screenshot shows the ALB target group reporting healthy private EC2 targets.

Expected result:

```text
Target health: healthy
```

![São Paulo Target Group Healthy](./05-aws-sao-paulo/sao-paulo-target-group-healthy.png)

---

## São Paulo HTTPS Listener

This screenshot shows the HTTPS listener configured for secure application delivery.

Expected behavior:

```text
HTTPS listener forwards traffic to the application target group.
```

![São Paulo HTTPS Listener](./05-aws-sao-paulo/sao-paulo-https-listener.png)

---

## São Paulo ACM Certificate Issued

This screenshot shows the ACM certificate in an issued state.

Expected result:

```text
Certificate status: Issued
```

![São Paulo ACM Certificate Issued](./05-aws-sao-paulo/sao-paulo-acm-certificate-issued.png)

---

## São Paulo Route 53 Records

This screenshot shows Route 53 records for the application domain.

Expected behavior:

```text
Root and/or www records route users toward the application entry path.
```

![São Paulo Route53 Records](./05-aws-sao-paulo/sao-paulo-route53-records.png)

---

## São Paulo CloudFront Distribution

This screenshot shows the CloudFront distribution deployed for the application.

Expected behavior:

```text
CloudFront provides public edge delivery in front of the application origin.
```

![São Paulo CloudFront Distribution](./05-aws-sao-paulo/sao-paulo-cloudfront-distribution.png)

---

## São Paulo WAF Web ACL

This screenshot shows the AWS WAF Web ACL attached to the application delivery path.

Expected behavior:

```text
WAF provides application-layer protection before traffic reaches the backend.
```

![São Paulo WAF Web ACL](./05-aws-sao-paulo/sao-paulo-waf-web-acl.png)

---

## São Paulo CloudFront / WAF Logs

This screenshot shows CloudFront or WAF logging configured.

Expected behavior:

```text
Edge-layer request/security events are captured for review.
```

![São Paulo CloudFront WAF Logs](./05-aws-sao-paulo/sao-paulo-cloudfront-waf-logs.png)

---

# 7. Cross-Cloud Networking Evidence

## AWS to GCP VPN Tunnel Status

This screenshot shows the AWS-side VPN tunnel status for the GCP connection.

Expected result:

```text
Tunnel status: UP / Available
```

![AWS to GCP VPN Tunnel Status](./06-cross-cloud-networking/aws-to-gcp-vpn-tunnel-status.png)

---

## GCP to AWS VPN Tunnel Status

This screenshot shows the GCP-side VPN tunnel status.

Expected result:

```text
Tunnel status: Established / Healthy
```

![GCP to AWS VPN Tunnel Status](./06-cross-cloud-networking/gcp-to-aws-vpn-tunnel-status.png)

---

## BGP Routes Learned in GCP

This screenshot shows BGP-learned routes in GCP.

Expected behavior:

```text
GCP learns AWS Japan private routes through Cloud Router and BGP.
```

![BGP Routes Learned GCP](./06-cross-cloud-networking/bgp-routes-learned-gcp.png)

---

## BGP Routes Learned in AWS

This screenshot shows AWS learning GCP routes or accepting route propagation through VPN/TGW routing.

Expected behavior:

```text
AWS knows how to route back to GCP Iowa private CIDRs.
```

![BGP Routes Learned AWS](./06-cross-cloud-networking/bgp-routes-learned-aws.png)

---

## Tokyo to Iowa Private Route

This screenshot shows the private route from AWS Japan toward GCP Iowa.

Expected behavior:

```text
Tokyo/Japan route table points GCP CIDR toward VPN/TGW path.
```

![Tokyo to Iowa Private Route](./06-cross-cloud-networking/tokyo-to-iowa-private-route.png)

---

## Iowa to Tokyo Private Route

This screenshot shows the private route from GCP Iowa toward AWS Japan.

Expected behavior:

```text
GCP route table learns or contains AWS Japan CIDR through BGP.
```

![Iowa to Tokyo Private Route](./06-cross-cloud-networking/iowa-to-tokyo-private-route.png)

---

## Tokyo to São Paulo TGW Route

This screenshot shows the route from AWS Japan toward AWS São Paulo through Transit Gateway peering.

Expected behavior:

```text
Japan TGW routes São Paulo CIDR through the TGW peering attachment.
```

![Tokyo to São Paulo TGW Route](./06-cross-cloud-networking/tokyo-to-sao-paulo-tgw-route.png)

---

## São Paulo to Tokyo TGW Route

This screenshot shows the route from AWS São Paulo toward AWS Japan through Transit Gateway peering.

Expected behavior:

```text
São Paulo TGW routes Tokyo/Japan CIDR through the TGW peering attachment.
```

![São Paulo to Tokyo TGW Route](./06-cross-cloud-networking/sao-paulo-to-tokyo-tgw-route.png)

---

## Private RDS Reachable from GCP

This screenshot proves that the GCP application path can reach the private RDS database in AWS Japan.

Expected behavior:

```text
GCP app / VM → HA VPN / BGP → Japan TGW → RDS MySQL
```

![Private RDS Reachable from GCP](./06-cross-cloud-networking/private-rds-reachable-from-gcp.png)

---

## Private RDS Reachable from São Paulo

This screenshot proves that the São Paulo application path can reach the private RDS database in AWS Japan.

Expected behavior:

```text
São Paulo app → São Paulo TGW → TGW peering → Japan TGW → RDS MySQL
```

![Private RDS Reachable from São Paulo](./06-cross-cloud-networking/private-rds-reachable-from-sao-paulo.png)

---

# 8. Security, IAM, and Secrets Evidence

## AWS EC2 IAM Role

This screenshot shows the IAM role attached to EC2 application instances.

Expected role purpose:

```text
Allow private EC2 instances to access required AWS services such as Secrets Manager, CloudWatch Logs, and SSM.
```

![AWS EC2 IAM Role](./07-security-iam-secrets/aws-ec2-iam-role.png)

---

## AWS Secrets Manager Read Policy

This screenshot shows the IAM policy allowing controlled Secrets Manager read access.

Expected behavior:

```text
EC2 app role can read only the required database secret path.
```

![AWS Secrets Manager Read Policy](./07-security-iam-secrets/aws-secretsmanager-read-policy.png)

---

## AWS SSM Managed Instance Core

This screenshot shows SSM permissions or SSM managed instance status.

Expected behavior:

```text
Private EC2 instances can be managed without exposing SSH publicly.
```

![AWS SSM Managed Instance Core](./07-security-iam-secrets/aws-ssm-managed-instance-core.png)

---

## AWS VPC Endpoints

This screenshot shows VPC endpoints configured for private service access.

Expected endpoints include:

```text
Secrets Manager
CloudWatch Logs
SSM
SSM Messages
EC2 Messages
STS
S3 Gateway
```

![AWS VPC Endpoints](./07-security-iam-secrets/aws-vpc-endpoints.png)

---

## GCP Service Account

This screenshot shows the GCP service account attached to the private application instances.

Expected behavior:

```text
GCP app instances use a dedicated service account.
```

![GCP Service Account](./07-security-iam-secrets/gcp-service-account.png)

---

## GCP Secret Accessor Role

This screenshot shows the GCP IAM role granting Secret Manager access.

Expected behavior:

```text
Service account has controlled secret accessor permissions.
```

![GCP Secret Accessor Role](./07-security-iam-secrets/gcp-secret-accessor-role.png)

---

## RDS No Public Access

This screenshot proves that the RDS database is not publicly accessible.

Expected result:

```text
Publicly accessible: No
```

![RDS No Public Access](./07-security-iam-secrets/rds-no-public-access.png)

---

## Application Security Groups

This screenshot shows application security groups controlling traffic into the app tier.

Expected behavior:

```text
ALB/security-approved sources → app instances on required app ports
```

![Application Security Groups](./07-security-iam-secrets/app-security-groups.png)

---

## Endpoint Security Groups

This screenshot shows security groups used by interface endpoints.

Expected behavior:

```text
Private app instances can access required AWS service endpoints.
```

![Endpoint Security Groups](./07-security-iam-secrets/endpoint-security-groups.png)

---

## CloudFront Log Bucket Block Public Access

This screenshot shows S3 public access block settings for the CloudFront log bucket.

Expected behavior:

```text
Log bucket blocks public access.
```

![CloudFront Log Bucket Block Public Access](./07-security-iam-secrets/cloudfront-log-bucket-block-public-access.png)

---

## ALB Log Bucket TLS-Only Policy

This screenshot shows the S3 bucket policy enforcing TLS-only access for ALB logs.

Expected behavior:

```text
Requests without secure transport are denied.
```

![ALB Log Bucket TLS Only Policy](./07-security-iam-secrets/alb-log-bucket-tls-only-policy.png)

---

# 9. Observability Evidence

## AWS CloudWatch Dashboard

This screenshot shows a CloudWatch dashboard for the AWS application environment.

Expected dashboard includes operational metrics for:

* ALB traffic
* ALB errors
* target response time
* infrastructure health
* RDS health or connection metrics

![AWS CloudWatch Dashboard](./08-observability/aws-cloudwatch-dashboard.png)

---

## AWS ALB Request Count Widget

This screenshot shows ALB request count visibility.

Expected behavior:

```text
CloudWatch tracks incoming application traffic.
```

![AWS ALB Request Count Widget](./08-observability/aws-alb-request-count-widget.png)

---

## AWS ALB 5XX Alarm

This screenshot shows an alarm for ALB 5XX errors.

Expected behavior:

```text
Alarm triggers if backend/application errors exceed threshold.
```

![AWS ALB 5XX Alarm](./08-observability/aws-alb-5xx-alarm.png)

---

## AWS ASG Health Alarm

This screenshot shows health monitoring for the Auto Scaling Group or EC2 app tier.

Expected behavior:

```text
CloudWatch detects unhealthy EC2 instances.
```

![AWS ASG Health Alarm](./08-observability/aws-asg-health-alarm.png)

---

## AWS RDS Connection Alarm

This screenshot shows RDS connection or database failure monitoring.

Expected behavior:

```text
CloudWatch alarms monitor database connection health.
```

![AWS RDS Connection Alarm](./08-observability/aws-rds-connection-alarm.png)

---

## AWS SNS Topic

This screenshot shows the SNS topic used for alert notifications.

Expected behavior:

```text
CloudWatch alarms send notifications through SNS.
```

![AWS SNS Topic](./08-observability/aws-sns-topic.png)

---

## AWS SNS Subscription Confirmed

This screenshot shows the SNS subscription confirmed.

Expected behavior:

```text
Developer receives alarm notifications.
```

![AWS SNS Subscription Confirmed](./08-observability/aws-sns-subscription-confirmed.png)

---

## GCP Health Check Status

This screenshot shows GCP load balancer health checks.

Expected result:

```text
Backend health: healthy
```

![GCP Health Check Status](./08-observability/gcp-health-check-status.png)

---

## GCP MIG Autohealing Status

This screenshot shows autohealing behavior for the GCP Managed Instance Group.

Expected behavior:

```text
MIG can detect unhealthy instances and maintain application availability.
```

![GCP MIG Autohealing Status](./08-observability/gcp-mig-autohealing-status.png)

---

# 10. Application Validation Evidence

## GCP App Homepage

This screenshot shows the GCP-hosted Flask Notes application homepage loading successfully.

Expected behavior:

```text
User → GCP regional load balancer → private MIG → Flask app
```

![GCP App Homepage](./09-application-validation/gcp-app-homepage.png)

---

## GCP App Health Success

This screenshot shows the GCP `/health` endpoint returning successfully.

Expected response:

```text
healthy
```

![GCP App Health Success](./09-application-validation/gcp-app-health-success.png)

---

## GCP App Init DB Success

This screenshot shows the GCP app initializing the database.

Expected behavior:

```text
GCP app connects privately to AWS Japan RDS and creates the required database/table.
```

![GCP App Init DB Success](./09-application-validation/gcp-app-init-db-success.png)

---

## GCP App Add Note Success

This screenshot shows the GCP app adding a note to the database.

Expected behavior:

```text
GCP app writes data to private AWS Japan RDS.
```

![GCP App Add Note Success](./09-application-validation/gcp-app-add-note-success.png)

---

## GCP App List Notes Success

This screenshot shows the GCP app listing notes from the database.

Expected behavior:

```text
GCP app reads data from private AWS Japan RDS.
```

![GCP App List Notes Success](./09-application-validation/gcp-app-list-notes-success.png)

---

## São Paulo App Homepage

This screenshot shows the São Paulo-hosted Flask Notes application homepage loading successfully.

Expected behavior:

```text
User → Route 53 → CloudFront/WAF → ALB → private EC2 app
```

![São Paulo App Homepage](./09-application-validation/sao-paulo-app-homepage.png)

---

## São Paulo App Init DB Success

This screenshot shows the São Paulo app initializing the database.

Expected behavior:

```text
São Paulo app connects privately to AWS Japan RDS and creates the required database/table.
```

![São Paulo App Init DB Success](./09-application-validation/sao-paulo-app-init-db-success.png)

---

## São Paulo App Add Note Success

This screenshot shows the São Paulo app adding a note to the database.

Expected behavior:

```text
São Paulo app writes data to private AWS Japan RDS.
```

![São Paulo App Add Note Success](./09-application-validation/sao-paulo-app-add-note-success.png)

---

## São Paulo App List Notes Success

This screenshot shows the São Paulo app listing notes from the database.

Expected behavior:

```text
São Paulo app reads data from private AWS Japan RDS.
```

![São Paulo App List Notes Success](./09-application-validation/sao-paulo-app-list-notes-success.png)

---

## Shared RDS Data Proof

This screenshot proves that the GCP Iowa app and AWS São Paulo app use the same backend RDS MySQL database.

Expected behavior:

```text
A note written from one application path is visible through the shared database layer.
```

![Shared RDS Data Proof](./09-application-validation/shared-rds-data-proof.png)

---

# 11. Testing Command Evidence

## curl GCP Load Balancer Health

This screenshot shows a curl test against the GCP load balancer health endpoint.

Expected command:

```bash
curl -i http://<gcp-lb-ip>/health
```

Expected response:

```text
healthy
```

![curl GCP LB Health](./10-testing-commands/curl-gcp-lb-health.png)

---

## curl São Paulo Domain

This screenshot shows a curl test against the São Paulo public domain.

Expected command:

```bash
curl -I https://<domain>
```

Expected result:

```text
HTTP 200 or valid application response
```

![curl São Paulo Domain](./10-testing-commands/curl-sao-paulo-domain.png)

---

## systemctl Status - GCP App

This screenshot shows the GCP Flask app running as a systemd service.

Expected result:

```text
Active: active (running)
```

![systemctl Status GCP](./10-testing-commands/systemctl-status-rdsapp-gcp.png)

---

## systemctl Status - AWS App

This screenshot shows the AWS São Paulo Flask app running as a systemd service.

Expected result:

```text
Active: active (running)
```

![systemctl Status AWS](./10-testing-commands/systemctl-status-rdsapp-aws.png)

---

## GCP App Listening on Port 80

This screenshot shows the GCP application listening on port `80`.

Expected result:

```text
0.0.0.0:80
```

![GCP Port 80 Listening](./10-testing-commands/ss-listening-port-80-gcp.png)

---

## AWS App Listening on Port 80

This screenshot shows the AWS São Paulo application listening on port `80`.

Expected result:

```text
0.0.0.0:80
```

![AWS Port 80 Listening](./10-testing-commands/ss-listening-port-80-aws.png)

---

## Traceroute Private Paths

This screenshot shows private routing/traceroute validation between application workloads and the database path.

Expected behavior:

```text
Traffic follows private network routes instead of public database exposure.
```

![Traceroute Private Paths](./10-testing-commands/traceroute-private-paths.png)

---

# Final Working-State Checklist

| Area                                        | Evidence File                                                           | Status   |
| ------------------------------------------- | ----------------------------------------------------------------------- | -------- |
| Final project summary                       | `00-executive-summary/final-project-summary.png`                        | Complete |
| Final architecture overview                 | `00-executive-summary/final-architecture-overview.png`                  | Complete |
| Final working-state checklist               | `00-executive-summary/final-working-state-checklist.png`                | Complete |
| Global architecture diagram                 | `01-architecture/global-architecture-diagram.png`                       | Complete |
| AWS São Paulo architecture diagram          | `01-architecture/aws-sao-paulo-architecture.png`                        | Complete |
| AWS Japan architecture diagram              | `01-architecture/aws-japan-architecture.png`                            | Complete |
| GCP Iowa architecture diagram               | `01-architecture/gcp-iowa-architecture.png`                             | Complete |
| Repository folder structure                 | `02-terraform-workflows/repo-folder-structure.png`                      | Complete |
| Iowa Terraform init                         | `02-terraform-workflows/terraform-init-iowa.png`                        | Complete |
| Iowa Terraform apply                        | `02-terraform-workflows/terraform-apply-iowa.png`                       | Complete |
| Iowa Terraform output                       | `02-terraform-workflows/terraform-output-iowa.png`                      | Complete |
| Japan Terraform init                        | `02-terraform-workflows/terraform-init-japan.png`                       | Complete |
| Japan Terraform apply                       | `02-terraform-workflows/terraform-apply-japan.png`                      | Complete |
| Japan Terraform output                      | `02-terraform-workflows/terraform-output-japan.png`                     | Complete |
| São Paulo Terraform init                    | `02-terraform-workflows/terraform-init-sao-paulo.png`                   | Complete |
| São Paulo Terraform apply                   | `02-terraform-workflows/terraform-apply-sao-paulo.png`                  | Complete |
| São Paulo Terraform output                  | `02-terraform-workflows/terraform-output-sao-paulo.png`                 | Complete |
| Remote state values                         | `02-terraform-workflows/remote-state-cross-region-values.png`           | Complete |
| GCP VPC                                     | `03-gcp-iowa/gcp-vpc-created.png`                                       | Complete |
| GCP private subnet                          | `03-gcp-iowa/gcp-private-subnet.png`                                    | Complete |
| GCP proxy-only subnet                       | `03-gcp-iowa/gcp-proxy-only-subnet.png`                                 | Complete |
| GCP firewall LB proxy rule                  | `03-gcp-iowa/gcp-firewall-lb-proxy-to-vm.png`                           | Complete |
| GCP health check firewall rule              | `03-gcp-iowa/gcp-firewall-health-checks.png`                            | Complete |
| GCP Cloud Router / BGP                      | `03-gcp-iowa/gcp-cloud-router-bgp.png`                                  | Complete |
| GCP Cloud NAT                               | `03-gcp-iowa/gcp-cloud-nat.png`                                         | Complete |
| GCP HA VPN                                  | `03-gcp-iowa/gcp-ha-vpn-gateway.png`                                    | Complete |
| GCP AWS external VPN gateway                | `03-gcp-iowa/gcp-external-vpn-gateway-aws.png`                          | Complete |
| GCP VPN tunnels                             | `03-gcp-iowa/gcp-vpn-tunnels-healthy.png`                               | Complete |
| GCP MIG                                     | `03-gcp-iowa/gcp-mig-running.png`                                       | Complete |
| GCP MIG autoscaler                          | `03-gcp-iowa/gcp-mig-autoscaler.png`                                    | Complete |
| GCP regional LB                             | `03-gcp-iowa/gcp-regional-lb.png`                                       | Complete |
| GCP backend service                         | `03-gcp-iowa/gcp-backend-service-healthy.png`                           | Complete |
| GCP health check                            | `03-gcp-iowa/gcp-lb-health-check.png`                                   | Complete |
| Tokyo VPC                                   | `04-aws-japan-tokyo/tokyo-vpc-created.png`                              | Complete |
| Tokyo subnets                               | `04-aws-japan-tokyo/tokyo-public-private-subnets.png`                   | Complete |
| Tokyo route tables                          | `04-aws-japan-tokyo/tokyo-route-tables.png`                             | Complete |
| Tokyo RDS running                           | `04-aws-japan-tokyo/tokyo-rds-instance-running.png`                     | Complete |
| Tokyo RDS subnet group                      | `04-aws-japan-tokyo/tokyo-rds-private-subnet-group.png`                 | Complete |
| Tokyo RDS security group                    | `04-aws-japan-tokyo/tokyo-rds-security-group.png`                       | Complete |
| Tokyo Secrets Manager                       | `04-aws-japan-tokyo/tokyo-secrets-manager-rds-secret.png`               | Complete |
| Tokyo secret replication                    | `04-aws-japan-tokyo/tokyo-secret-replication.png`                       | Complete |
| Tokyo RDS logs                              | `04-aws-japan-tokyo/tokyo-cloudwatch-rds-logs.png`                      | Complete |
| Tokyo RDS alarms                            | `04-aws-japan-tokyo/tokyo-rds-alarms.png`                               | Complete |
| Tokyo TGW                                   | `04-aws-japan-tokyo/tokyo-tgw-created.png`                              | Complete |
| Tokyo TGW VPC attachment                    | `04-aws-japan-tokyo/tokyo-tgw-vpc-attachment.png`                       | Complete |
| Tokyo TGW route table                       | `04-aws-japan-tokyo/tokyo-tgw-route-table.png`                          | Complete |
| Tokyo customer gateways to GCP              | `04-aws-japan-tokyo/tokyo-customer-gateways-to-gcp.png`                 | Complete |
| Tokyo VPN to GCP                            | `04-aws-japan-tokyo/tokyo-vpn-connections-to-gcp.png`                   | Complete |
| Tokyo TGW peering to São Paulo              | `04-aws-japan-tokyo/tokyo-tgw-peering-to-sao-paulo.png`                 | Complete |
| São Paulo VPC                               | `05-aws-sao-paulo/sao-paulo-vpc-created.png`                            | Complete |
| São Paulo subnets                           | `05-aws-sao-paulo/sao-paulo-public-private-subnets.png`                 | Complete |
| São Paulo route tables                      | `05-aws-sao-paulo/sao-paulo-route-tables.png`                           | Complete |
| São Paulo TGW                               | `05-aws-sao-paulo/sao-paulo-tgw-created.png`                            | Complete |
| São Paulo TGW VPC attachment                | `05-aws-sao-paulo/sao-paulo-tgw-vpc-attachment.png`                     | Complete |
| São Paulo TGW peering accepted              | `05-aws-sao-paulo/sao-paulo-tgw-peering-accepted.png`                   | Complete |
| São Paulo private ASG                       | `05-aws-sao-paulo/sao-paulo-private-ec2-asg.png`                        | Complete |
| São Paulo launch template                   | `05-aws-sao-paulo/sao-paulo-launch-template.png`                        | Complete |
| São Paulo golden AMI                        | `05-aws-sao-paulo/sao-paulo-golden-ami.png`                             | Complete |
| São Paulo ALB                               | `05-aws-sao-paulo/sao-paulo-alb-active.png`                             | Complete |
| São Paulo target group                      | `05-aws-sao-paulo/sao-paulo-target-group-healthy.png`                   | Complete |
| São Paulo HTTPS listener                    | `05-aws-sao-paulo/sao-paulo-https-listener.png`                         | Complete |
| São Paulo ACM cert                          | `05-aws-sao-paulo/sao-paulo-acm-certificate-issued.png`                 | Complete |
| São Paulo Route 53                          | `05-aws-sao-paulo/sao-paulo-route53-records.png`                        | Complete |
| São Paulo CloudFront                        | `05-aws-sao-paulo/sao-paulo-cloudfront-distribution.png`                | Complete |
| São Paulo WAF                               | `05-aws-sao-paulo/sao-paulo-waf-web-acl.png`                            | Complete |
| São Paulo logs                              | `05-aws-sao-paulo/sao-paulo-cloudfront-waf-logs.png`                    | Complete |
| AWS/GCP VPN status                          | `06-cross-cloud-networking/aws-to-gcp-vpn-tunnel-status.png`            | Complete |
| GCP/AWS VPN status                          | `06-cross-cloud-networking/gcp-to-aws-vpn-tunnel-status.png`            | Complete |
| GCP BGP routes                              | `06-cross-cloud-networking/bgp-routes-learned-gcp.png`                  | Complete |
| AWS BGP routes                              | `06-cross-cloud-networking/bgp-routes-learned-aws.png`                  | Complete |
| Tokyo to Iowa route                         | `06-cross-cloud-networking/tokyo-to-iowa-private-route.png`             | Complete |
| Iowa to Tokyo route                         | `06-cross-cloud-networking/iowa-to-tokyo-private-route.png`             | Complete |
| Tokyo to São Paulo route                    | `06-cross-cloud-networking/tokyo-to-sao-paulo-tgw-route.png`            | Complete |
| São Paulo to Tokyo route                    | `06-cross-cloud-networking/sao-paulo-to-tokyo-tgw-route.png`            | Complete |
| RDS reachable from GCP                      | `06-cross-cloud-networking/private-rds-reachable-from-gcp.png`          | Complete |
| RDS reachable from São Paulo                | `06-cross-cloud-networking/private-rds-reachable-from-sao-paulo.png`    | Complete |
| AWS EC2 IAM role                            | `07-security-iam-secrets/aws-ec2-iam-role.png`                          | Complete |
| Secrets Manager read policy                 | `07-security-iam-secrets/aws-secretsmanager-read-policy.png`            | Complete |
| SSM access                                  | `07-security-iam-secrets/aws-ssm-managed-instance-core.png`             | Complete |
| AWS VPC endpoints                           | `07-security-iam-secrets/aws-vpc-endpoints.png`                         | Complete |
| GCP service account                         | `07-security-iam-secrets/gcp-service-account.png`                       | Complete |
| GCP secret accessor role                    | `07-security-iam-secrets/gcp-secret-accessor-role.png`                  | Complete |
| RDS public access disabled                  | `07-security-iam-secrets/rds-no-public-access.png`                      | Complete |
| App security groups                         | `07-security-iam-secrets/app-security-groups.png`                       | Complete |
| Endpoint security groups                    | `07-security-iam-secrets/endpoint-security-groups.png`                  | Complete |
| CloudFront log bucket public access blocked | `07-security-iam-secrets/cloudfront-log-bucket-block-public-access.png` | Complete |
| ALB log bucket TLS-only policy              | `07-security-iam-secrets/alb-log-bucket-tls-only-policy.png`            | Complete |
| CloudWatch dashboard                        | `08-observability/aws-cloudwatch-dashboard.png`                         | Complete |
| ALB request widget                          | `08-observability/aws-alb-request-count-widget.png`                     | Complete |
| ALB 5XX alarm                               | `08-observability/aws-alb-5xx-alarm.png`                                | Complete |
| ASG health alarm                            | `08-observability/aws-asg-health-alarm.png`                             | Complete |
| RDS connection alarm                        | `08-observability/aws-rds-connection-alarm.png`                         | Complete |
| SNS topic                                   | `08-observability/aws-sns-topic.png`                                    | Complete |
| SNS subscription                            | `08-observability/aws-sns-subscription-confirmed.png`                   | Complete |
| GCP health check                            | `08-observability/gcp-health-check-status.png`                          | Complete |
| GCP MIG autohealing                         | `08-observability/gcp-mig-autohealing-status.png`                       | Complete |
| GCP homepage                                | `09-application-validation/gcp-app-homepage.png`                        | Complete |
| GCP health success                          | `09-application-validation/gcp-app-health-success.png`                  | Complete |
| GCP DB init                                 | `09-application-validation/gcp-app-init-db-success.png`                 | Complete |
| GCP add note                                | `09-application-validation/gcp-app-add-note-success.png`                | Complete |
| GCP list notes                              | `09-application-validation/gcp-app-list-notes-success.png`              | Complete |
| São Paulo homepage                          | `09-application-validation/sao-paulo-app-homepage.png`                  | Complete |
| São Paulo DB init                           | `09-application-validation/sao-paulo-app-init-db-success.png`           | Complete |
| São Paulo add note                          | `09-application-validation/sao-paulo-app-add-note-success.png`          | Complete |
| São Paulo list notes                        | `09-application-validation/sao-paulo-app-list-notes-success.png`        | Complete |
| Shared RDS proof                            | `09-application-validation/shared-rds-data-proof.png`                   | Complete |
| curl GCP LB health                          | `10-testing-commands/curl-gcp-lb-health.png`                            | Complete |
| curl São Paulo domain                       | `10-testing-commands/curl-sao-paulo-domain.png`                         | Complete |
| GCP systemd status                          | `10-testing-commands/systemctl-status-rdsapp-gcp.png`                   | Complete |
| AWS systemd status                          | `10-testing-commands/systemctl-status-rdsapp-aws.png`                   | Complete |
| GCP port 80 listening                       | `10-testing-commands/ss-listening-port-80-gcp.png`                      | Complete |
| AWS port 80 listening                       | `10-testing-commands/ss-listening-port-80-aws.png`                      | Complete |
| Private traceroute path                     | `10-testing-commands/traceroute-private-paths.png`                      | Complete |

---

# Evidence Summary

This evidence pack confirms the final working state of the multi-cloud application platform.

The completed architecture demonstrates:

* AWS São Paulo public application delivery through Route 53, CloudFront, WAF, HTTPS, and ALB
* private EC2 application hosting in São Paulo
* AWS São Paulo to AWS Japan private connectivity through Transit Gateway peering
* AWS Japan as the central private database and transit hub
* private RDS MySQL hosting in Japan
* GCP Iowa application hosting through regional load balancing and private Managed Instance Groups
* GCP-to-AWS private connectivity through Cloud Router, HA VPN, and BGP
* controlled secrets and IAM access paths
* private AWS service access through VPC endpoints
* logging, metrics, health checks, alarms, and notifications
* application-level database validation from both AWS and GCP paths
* Terraform-managed deployment across all major environments

The key proof point is that both application environments can reach the same private RDS database without exposing the database publicly.

```text
AWS São Paulo App → São Paulo TGW → TGW Peering → Japan TGW → Private RDS MySQL = Working

GCP Iowa App → Cloud Router → HA VPN / BGP → AWS Japan VPN Path → Japan TGW → Private RDS MySQL = Working
```

---

# Publishing and Redaction Notes

Before publishing this evidence pack to GitHub, review every screenshot and artifact for sensitive data.

Do not publish:

* database passwords
* VPN pre-shared keys
* secret values
* private keys
* session tokens
* Terraform state files
* unredacted environment variables
* unnecessary account identifiers
* live credentials

Safe evidence generally includes:

* redacted diagrams
* resource names
* route table screenshots
* tunnel status screenshots
* health check status
* load balancer status
* CloudWatch alarm names
* service status output
* port listening checks
* application screenshots without secrets
* redacted Terraform outputs
