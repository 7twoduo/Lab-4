# Final Architecture Overview

## Purpose

This document summarizes the final architecture of the multi-cloud application platform.

It is intended to support the executive evidence section by explaining the major architecture decisions, traffic paths, trust boundaries, and operational design without becoming a full project README.

---

## Architecture Scope

The platform spans three primary environments:

| Environment   | Cloud        | Region           | Function                                               |
| ------------- | ------------ | ---------------- | ------------------------------------------------------ |
| AWS São Paulo | AWS          | `sa-east-1`      | Public application delivery and private EC2 app tier   |
| AWS Japan     | AWS          | `ap-northeast-1` | Centralized private RDS MySQL database and transit hub |
| GCP Iowa      | Google Cloud | `us-central1`    | Secondary application workload and hybrid cloud path   |

---

## Architecture Diagram References

| File                                                 | Description                                                        |
| ---------------------------------------------------- | ------------------------------------------------------------------ |
| `../01-architecture/global-architecture-diagram.png` | Full multi-cloud platform overview                                 |
| `../01-architecture/aws-sao-paulo-architecture.png`  | AWS São Paulo public application delivery path                     |
| `../01-architecture/aws-japan-architecture.png`      | AWS Japan private database and network hub                         |
| `../01-architecture/gcp-iowa-architecture.png`       | GCP Iowa regional load balancer, private app tier, and HA VPN path |

---

## Global Architecture Summary

```text
Users
  ↓
Route 53
  ↓
CloudFront + AWS WAF
  ↓
AWS São Paulo ALB
  ↓
Private EC2 Auto Scaling Group
  ↓
São Paulo Transit Gateway
  ↓
Transit Gateway Peering
  ↓
Japan Transit Gateway
  ↓
Private Amazon RDS MySQL

GCP Users
  ↓
GCP Regional External HTTP Load Balancer
  ↓
Private Managed Instance Group
  ↓
Cloud Router + HA VPN + BGP
  ↓
AWS Japan VPN Path
  ↓
Japan Transit Gateway
  ↓
Private Amazon RDS MySQL
```

---

## AWS São Paulo Architecture

AWS São Paulo acts as the primary public application delivery region.

### Main Components

| Component                 | Role                                                              |
| ------------------------- | ----------------------------------------------------------------- |
| Route 53                  | DNS entry point for the public domain                             |
| CloudFront                | CDN and edge entry layer                                          |
| AWS WAF                   | Layer 7 filtering and protection in front of the application path |
| ACM                       | TLS certificate support for HTTPS                                 |
| Application Load Balancer | Public entry into the São Paulo application VPC                   |
| Public Subnets            | Host public load balancer entry points                            |
| Private Subnets           | Host private EC2 application instances                            |
| EC2 Auto Scaling Group    | Runs the Flask Notes application on private instances             |
| Launch Template           | Defines EC2 instance configuration                                |
| Golden AMI                | Provides reusable application image baseline                      |
| Secrets Manager           | Stores or provides access to database credentials                 |
| VPC Endpoints             | Allow private instances to reach AWS services privately           |
| CloudWatch                | Collects metrics and supports alarms                              |
| SNS                       | Sends operational notifications                                   |
| S3 / Firehose             | Stores delivery and access logs                                   |
| São Paulo Transit Gateway | Routes private application traffic toward Japan                   |
| TGW Peering               | Connects São Paulo TGW to Japan TGW                               |

### São Paulo Request Flow

```text
User
  ↓
Route 53
  ↓
CloudFront + WAF
  ↓
HTTPS / ACM
  ↓
Application Load Balancer
  ↓
Private EC2 Auto Scaling Group
  ↓
São Paulo Transit Gateway
  ↓
TGW Peering
  ↓
Japan Transit Gateway
  ↓
Private RDS MySQL
```

### Design Intent

The São Paulo region is designed to demonstrate production-style AWS application delivery:

* public traffic terminates at managed AWS edge and load balancing services
* compute runs privately behind the ALB
* database traffic does not use the public internet
* private EC2 instances can access required AWS services through controlled paths
* monitoring and logging support operational review

---

## AWS Japan Architecture

AWS Japan acts as the centralized private database and network hub.

### Main Components

| Component              | Role                                                                  |
| ---------------------- | --------------------------------------------------------------------- |
| Tokyo / Star VPC       | Database and transit-connected VPC                                    |
| Public Subnets         | Present for VPC completeness and routing structure                    |
| Private Subnets        | Host the RDS database subnet group                                    |
| RDS MySQL              | Central database layer for both application environments              |
| RDS Security Group     | Controls MySQL access on port `3306`                                  |
| Secrets Manager        | Stores database credentials and supports cross-region/app consumption |
| CloudWatch Logs        | Captures RDS and infrastructure metrics/logs                          |
| CloudWatch Alarms      | Detects operational issues                                            |
| SNS                    | Sends notifications to the developer                                  |
| Japan Transit Gateway  | Central private routing hub                                           |
| AWS Site-to-Site VPN   | Terminates the private GCP-to-AWS VPN path                            |
| TGW Peering Attachment | Connects Japan TGW to São Paulo TGW                                   |

### Japan Private Data Flow

```text
São Paulo TGW
  ↓
TGW Peering
  ↓
Japan TGW
  ↓
Tokyo VPC private route table
  ↓
RDS Security Group
  ↓
Private RDS MySQL
```

```text
GCP HA VPN
  ↓
AWS Site-to-Site VPN
  ↓
Japan TGW
  ↓
Tokyo VPC private route table
  ↓
RDS Security Group
  ↓
Private RDS MySQL
```

### Design Intent

Japan is the data authority for the project.

The goal is to keep the database private while allowing controlled application access from both AWS São Paulo and GCP Iowa through private routed paths.

---

## GCP Iowa Architecture

GCP Iowa acts as the secondary cloud application environment.

### Main Components

| Component                            | Role                                                        |
| ------------------------------------ | ----------------------------------------------------------- |
| GCP VPC                              | Isolated Google Cloud network                               |
| Private Subnet                       | Hosts private application VM instances                      |
| Proxy-Only Subnet                    | Required for regional external managed HTTP load balancing  |
| Regional External HTTP Load Balancer | Public entry point for GCP application path                 |
| Backend Service                      | Routes LB traffic to the managed instance group             |
| Health Check                         | Validates application availability through `/health`        |
| Managed Instance Group               | Runs the Debian Flask Notes application                     |
| Cloud NAT                            | Allows private instances outbound access without public IPs |
| Cloud Router                         | Exchanges routes using BGP                                  |
| HA VPN Gateway                       | Connects GCP Iowa to AWS Japan                              |
| BGP                                  | Advertises private routes between GCP and AWS               |

### GCP Request Flow

```text
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
Private RDS MySQL
```

### Design Intent

GCP Iowa proves that a non-AWS application environment can still participate in the same private database architecture by using Cloud Router, HA VPN, and BGP.

---

## Network Architecture

The design includes two major private connectivity patterns.

### 1. AWS Inter-Region Connectivity

```text
AWS São Paulo
  ↓
São Paulo Transit Gateway
  ↓
TGW Peering
  ↓
Japan Transit Gateway
  ↓
Private RDS MySQL
```

This demonstrates private cross-region AWS routing using Transit Gateway peering.

### 2. GCP-to-AWS Connectivity

```text
GCP Iowa
  ↓
Cloud Router
  ↓
HA VPN / BGP
  ↓
AWS Site-to-Site VPN
  ↓
Japan Transit Gateway
  ↓
Private RDS MySQL
```

This demonstrates hybrid cloud networking through VPN and dynamic route exchange.

---

## Security Architecture

| Layer          | Security Design                                                                       |
| -------------- | ------------------------------------------------------------------------------------- |
| Public Edge    | Route 53, CloudFront, WAF, and HTTPS reduce direct exposure to backend infrastructure |
| Load Balancing | ALB routes public traffic only to approved private application targets                |
| Compute        | Application workloads run in private subnets                                          |
| Database       | RDS is private and accessed only through controlled network paths                     |
| Secrets        | Database credentials are stored or consumed through controlled secret mechanisms      |
| IAM            | EC2 and GCP service accounts receive only the permissions needed for their roles      |
| Network Access | TGW, VPN, route tables, firewall rules, and security groups define allowed paths      |
| Admin Access   | SSM-style private management is used instead of relying on broad public SSH exposure  |
| Logging        | CloudWatch, S3, Firehose, SNS, and GCP health checks provide operational visibility   |

---

## Observability Architecture

| Service               | Purpose                                                              |
| --------------------- | -------------------------------------------------------------------- |
| CloudWatch Dashboard  | Tracks ALB request volume, errors, and response timing               |
| CloudWatch Alarms     | Detects ALB 5XX, RDS connection issues, and unhealthy infrastructure |
| SNS                   | Sends notifications to the developer                                 |
| S3 Log Buckets        | Stores access and delivery logs                                      |
| Kinesis Data Firehose | Delivers log streams to S3                                           |
| GCP Health Checks     | Validates MIG backend health                                         |
| systemd               | Confirms application service runtime on EC2 and GCP VMs              |
| curl / browser checks | Confirms application availability through public endpoints           |

---

## Application Architecture

The application is a Flask Notes app deployed in both AWS São Paulo and GCP Iowa.

### Shared Application Behavior

| Route / Function | Purpose                                              |
| ---------------- | ---------------------------------------------------- |
| `/`              | Loads the Notes application page                     |
| `/health`        | Returns a lightweight health response                |
| `/init`          | Initializes the database and creates the notes table |
| `/add`           | Adds a new note to the database                      |
| `/list`          | Reads notes from the database                        |

### Application Validation Goal

The key proof is not only that the web page loads.

The key proof is that both cloud application paths can perform database operations against the same private RDS MySQL backend.

---

## Architecture Decision Summary

| Decision                            | Reason                                                                                 |
| ----------------------------------- | -------------------------------------------------------------------------------------- |
| Use Japan as the database hub       | Centralizes the private data layer and simplifies proof of shared backend connectivity |
| Use São Paulo for AWS app delivery  | Demonstrates public AWS delivery with CloudFront, WAF, ALB, private EC2, and TGW       |
| Use GCP Iowa for secondary app path | Demonstrates multi-cloud integration through HA VPN and BGP                            |
| Use Transit Gateway peering         | Provides private AWS inter-region connectivity                                         |
| Use HA VPN and BGP                  | Provides dynamic cross-cloud routing between GCP and AWS                               |
| Keep compute private                | Reduces direct public exposure of application servers                                  |
| Use RDS MySQL                       | Provides managed database backend for application proof                                |
| Use Terraform                       | Makes the infrastructure repeatable and reviewable                                     |
| Use evidence screenshots            | Proves the build reached a real working state                                          |

---

## Final Architecture Statement

The final architecture demonstrates a working multi-cloud application platform where AWS and GCP application workloads connect to a centralized private database in AWS Japan.

The design combines edge delivery, private compute, cross-region AWS routing, GCP-to-AWS VPN connectivity, controlled secret access, monitoring, and Terraform-based deployment into one validated platform.
