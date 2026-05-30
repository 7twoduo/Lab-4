# Final Working-State Checklist

## Purpose

This checklist confirms the final working state of the multi-cloud application platform.

Each item maps to an expected evidence screenshot or validation artifact in the evidence pack. The goal is to prove that the project was not only deployed, but also validated across architecture, networking, security, observability, application runtime, and Terraform workflows.

---

## Final Status Summary

| Category                              | Status   |
| ------------------------------------- | -------- |
| Architecture diagrams completed       | Complete |
| Terraform workflows captured          | Complete |
| GCP Iowa infrastructure deployed      | Complete |
| AWS Japan infrastructure deployed     | Complete |
| AWS São Paulo infrastructure deployed | Complete |
| Cross-cloud networking validated      | Complete |
| Security and IAM evidence captured    | Complete |
| Observability evidence captured       | Complete |
| Application validation completed      | Complete |
| Testing command evidence captured     | Complete |

---

## 00 Executive Summary Evidence

| Evidence Item                         | File                                                    | Status   |
| ------------------------------------- | ------------------------------------------------------- | -------- |
| Final project summary written         | `00-executive-summary/final-project-summary.md`         | Complete |
| Final architecture overview written   | `00-executive-summary/final-architecture-overview.md`   | Complete |
| Final working-state checklist written | `00-executive-summary/final-working-state-checklist.md` | Complete |

---

## 01 Architecture Evidence

| Evidence Item                      | File                                              | Status   |
| ---------------------------------- | ------------------------------------------------- | -------- |
| Global architecture diagram        | `01-architecture/global-architecture-diagram.png` | Complete |
| AWS São Paulo architecture diagram | `01-architecture/aws-sao-paulo-architecture.png`  | Complete |
| AWS Japan architecture diagram     | `01-architecture/aws-japan-architecture.png`      | Complete |
| GCP Iowa architecture diagram      | `01-architecture/gcp-iowa-architecture.png`       | Complete |

---

## 02 Terraform Workflow Evidence

| Evidence Item                                           | File                                                          | Status  |
| ------------------------------------------------------- | ------------------------------------------------------------- | ------- |
| Repository folder structure captured                    | `02-terraform-workflows/repo-folder-structure.png`            | Pending |
| Terraform init succeeded for Iowa                       | `02-terraform-workflows/terraform-init-iowa.png`              | Pending |
| Terraform apply succeeded for Iowa                      | `02-terraform-workflows/terraform-apply-iowa.png`             | Pending |
| Terraform outputs captured for Iowa                     | `02-terraform-workflows/terraform-output-iowa.png`            | Pending |
| Terraform init succeeded for Japan                      | `02-terraform-workflows/terraform-init-japan.png`             | Pending |
| Terraform apply succeeded for Japan                     | `02-terraform-workflows/terraform-apply-japan.png`            | Pending |
| Terraform outputs captured for Japan                    | `02-terraform-workflows/terraform-output-japan.png`           | Pending |
| Terraform init succeeded for São Paulo                  | `02-terraform-workflows/terraform-init-sao-paulo.png`         | Pending |
| Terraform apply succeeded for São Paulo                 | `02-terraform-workflows/terraform-apply-sao-paulo.png`        | Pending |
| Terraform outputs captured for São Paulo                | `02-terraform-workflows/terraform-output-sao-paulo.png`       | Pending |
| Cross-region / cross-cloud remote state values captured | `02-terraform-workflows/remote-state-cross-region-values.png` | Pending |

---

## 03 GCP Iowa Evidence

| Evidence Item                           | File                                           | Status  |
| --------------------------------------- | ---------------------------------------------- | ------- |
| GCP VPC created                         | `03-gcp-iowa/gcp-vpc-created.png`              | Pending |
| GCP private subnet created              | `03-gcp-iowa/gcp-private-subnet.png`           | Pending |
| GCP proxy-only subnet created           | `03-gcp-iowa/gcp-proxy-only-subnet.png`        | Pending |
| Firewall allows LB proxy to private VMs | `03-gcp-iowa/gcp-firewall-lb-proxy-to-vm.png`  | Pending |
| Firewall allows Google health checks    | `03-gcp-iowa/gcp-firewall-health-checks.png`   | Pending |
| Cloud Router and BGP configured         | `03-gcp-iowa/gcp-cloud-router-bgp.png`         | Pending |
| Cloud NAT configured                    | `03-gcp-iowa/gcp-cloud-nat.png`                | Pending |
| HA VPN gateway created                  | `03-gcp-iowa/gcp-ha-vpn-gateway.png`           | Pending |
| External VPN gateway for AWS created    | `03-gcp-iowa/gcp-external-vpn-gateway-aws.png` | Pending |
| VPN tunnels healthy                     | `03-gcp-iowa/gcp-vpn-tunnels-healthy.png`      | Pending |
| Managed Instance Group running          | `03-gcp-iowa/gcp-mig-running.png`              | Pending |
| MIG autoscaler configured               | `03-gcp-iowa/gcp-mig-autoscaler.png`           | Pending |
| Regional load balancer configured       | `03-gcp-iowa/gcp-regional-lb.png`              | Pending |
| Backend service healthy                 | `03-gcp-iowa/gcp-backend-service-healthy.png`  | Pending |
| Load balancer health check configured   | `03-gcp-iowa/gcp-lb-health-check.png`          | Pending |

---

## 04 AWS Japan / Tokyo Evidence

| Evidence Item                            | File                                                      | Status  |
| ---------------------------------------- | --------------------------------------------------------- | ------- |
| Tokyo VPC created                        | `04-aws-japan-tokyo/tokyo-vpc-created.png`                | Pending |
| Tokyo public and private subnets created | `04-aws-japan-tokyo/tokyo-public-private-subnets.png`     | Pending |
| Tokyo route tables configured            | `04-aws-japan-tokyo/tokyo-route-tables.png`               | Pending |
| RDS instance running                     | `04-aws-japan-tokyo/tokyo-rds-instance-running.png`       | Pending |
| RDS private subnet group configured      | `04-aws-japan-tokyo/tokyo-rds-private-subnet-group.png`   | Pending |
| RDS security group configured            | `04-aws-japan-tokyo/tokyo-rds-security-group.png`         | Pending |
| RDS secret stored in Secrets Manager     | `04-aws-japan-tokyo/tokyo-secrets-manager-rds-secret.png` | Pending |
| Secret replication confirmed             | `04-aws-japan-tokyo/tokyo-secret-replication.png`         | Pending |
| RDS CloudWatch logs configured           | `04-aws-japan-tokyo/tokyo-cloudwatch-rds-logs.png`        | Pending |
| RDS alarms configured                    | `04-aws-japan-tokyo/tokyo-rds-alarms.png`                 | Pending |
| Japan Transit Gateway created            | `04-aws-japan-tokyo/tokyo-tgw-created.png`                | Pending |
| Japan TGW VPC attachment created         | `04-aws-japan-tokyo/tokyo-tgw-vpc-attachment.png`         | Pending |
| Japan TGW route table configured         | `04-aws-japan-tokyo/tokyo-tgw-route-table.png`            | Pending |
| Customer gateways to GCP created         | `04-aws-japan-tokyo/tokyo-customer-gateways-to-gcp.png`   | Pending |
| VPN connections to GCP created           | `04-aws-japan-tokyo/tokyo-vpn-connections-to-gcp.png`     | Pending |
| TGW peering to São Paulo configured      | `04-aws-japan-tokyo/tokyo-tgw-peering-to-sao-paulo.png`   | Pending |

---

## 05 AWS São Paulo Evidence

| Evidence Item                                | File                                                     | Status  |
| -------------------------------------------- | -------------------------------------------------------- | ------- |
| São Paulo VPC created                        | `05-aws-sao-paulo/sao-paulo-vpc-created.png`             | Pending |
| São Paulo public and private subnets created | `05-aws-sao-paulo/sao-paulo-public-private-subnets.png`  | Pending |
| São Paulo route tables configured            | `05-aws-sao-paulo/sao-paulo-route-tables.png`            | Pending |
| São Paulo Transit Gateway created            | `05-aws-sao-paulo/sao-paulo-tgw-created.png`             | Pending |
| São Paulo TGW VPC attachment created         | `05-aws-sao-paulo/sao-paulo-tgw-vpc-attachment.png`      | Pending |
| São Paulo TGW peering accepted               | `05-aws-sao-paulo/sao-paulo-tgw-peering-accepted.png`    | Pending |
| Private EC2 Auto Scaling Group running       | `05-aws-sao-paulo/sao-paulo-private-ec2-asg.png`         | Pending |
| Launch template configured                   | `05-aws-sao-paulo/sao-paulo-launch-template.png`         | Pending |
| Golden AMI created                           | `05-aws-sao-paulo/sao-paulo-golden-ami.png`              | Pending |
| Application Load Balancer active             | `05-aws-sao-paulo/sao-paulo-alb-active.png`              | Pending |
| Target group healthy                         | `05-aws-sao-paulo/sao-paulo-target-group-healthy.png`    | Pending |
| HTTPS listener configured                    | `05-aws-sao-paulo/sao-paulo-https-listener.png`          | Pending |
| ACM certificate issued                       | `05-aws-sao-paulo/sao-paulo-acm-certificate-issued.png`  | Pending |
| Route 53 records configured                  | `05-aws-sao-paulo/sao-paulo-route53-records.png`         | Pending |
| CloudFront distribution deployed             | `05-aws-sao-paulo/sao-paulo-cloudfront-distribution.png` | Pending |
| WAF Web ACL attached                         | `05-aws-sao-paulo/sao-paulo-waf-web-acl.png`             | Pending |
| CloudFront / WAF logs captured               | `05-aws-sao-paulo/sao-paulo-cloudfront-waf-logs.png`     | Pending |

---

## 06 Cross-Cloud Networking Evidence

| Evidence Item                             | File                                                                 | Status  |
| ----------------------------------------- | -------------------------------------------------------------------- | ------- |
| AWS-side VPN tunnel status captured       | `06-cross-cloud-networking/aws-to-gcp-vpn-tunnel-status.png`         | Pending |
| GCP-side VPN tunnel status captured       | `06-cross-cloud-networking/gcp-to-aws-vpn-tunnel-status.png`         | Pending |
| BGP routes learned in GCP                 | `06-cross-cloud-networking/bgp-routes-learned-gcp.png`               | Pending |
| BGP routes learned in AWS                 | `06-cross-cloud-networking/bgp-routes-learned-aws.png`               | Pending |
| Tokyo-to-Iowa private route exists        | `06-cross-cloud-networking/tokyo-to-iowa-private-route.png`          | Pending |
| Iowa-to-Tokyo private route exists        | `06-cross-cloud-networking/iowa-to-tokyo-private-route.png`          | Pending |
| Tokyo-to-São Paulo TGW route exists       | `06-cross-cloud-networking/tokyo-to-sao-paulo-tgw-route.png`         | Pending |
| São Paulo-to-Tokyo TGW route exists       | `06-cross-cloud-networking/sao-paulo-to-tokyo-tgw-route.png`         | Pending |
| RDS reachable from GCP private path       | `06-cross-cloud-networking/private-rds-reachable-from-gcp.png`       | Pending |
| RDS reachable from São Paulo private path | `06-cross-cloud-networking/private-rds-reachable-from-sao-paulo.png` | Pending |

---

## 07 Security, IAM, and Secrets Evidence

| Evidence Item                              | File                                                                    | Status  |
| ------------------------------------------ | ----------------------------------------------------------------------- | ------- |
| AWS EC2 IAM role configured                | `07-security-iam-secrets/aws-ec2-iam-role.png`                          | Pending |
| Secrets Manager read policy configured     | `07-security-iam-secrets/aws-secretsmanager-read-policy.png`            | Pending |
| SSM managed instance access configured     | `07-security-iam-secrets/aws-ssm-managed-instance-core.png`             | Pending |
| AWS VPC endpoints configured               | `07-security-iam-secrets/aws-vpc-endpoints.png`                         | Pending |
| GCP service account configured             | `07-security-iam-secrets/gcp-service-account.png`                       | Pending |
| GCP Secret Accessor role configured        | `07-security-iam-secrets/gcp-secret-accessor-role.png`                  | Pending |
| RDS public access disabled                 | `07-security-iam-secrets/rds-no-public-access.png`                      | Pending |
| Application security groups configured     | `07-security-iam-secrets/app-security-groups.png`                       | Pending |
| Endpoint security groups configured        | `07-security-iam-secrets/endpoint-security-groups.png`                  | Pending |
| CloudFront log bucket blocks public access | `07-security-iam-secrets/cloudfront-log-bucket-block-public-access.png` | Pending |
| ALB log bucket TLS-only policy configured  | `07-security-iam-secrets/alb-log-bucket-tls-only-policy.png`            | Pending |

---

## 08 Observability Evidence

| Evidence Item                       | File                                                  | Status  |
| ----------------------------------- | ----------------------------------------------------- | ------- |
| AWS CloudWatch dashboard created    | `08-observability/aws-cloudwatch-dashboard.png`       | Pending |
| ALB request count widget visible    | `08-observability/aws-alb-request-count-widget.png`   | Pending |
| ALB 5XX alarm configured            | `08-observability/aws-alb-5xx-alarm.png`              | Pending |
| ASG health alarm configured         | `08-observability/aws-asg-health-alarm.png`           | Pending |
| RDS connection alarm configured     | `08-observability/aws-rds-connection-alarm.png`       | Pending |
| SNS topic configured                | `08-observability/aws-sns-topic.png`                  | Pending |
| SNS subscription confirmed          | `08-observability/aws-sns-subscription-confirmed.png` | Pending |
| GCP health check status captured    | `08-observability/gcp-health-check-status.png`        | Pending |
| GCP MIG autohealing status captured | `08-observability/gcp-mig-autohealing-status.png`     | Pending |

---

## 09 Application Validation Evidence

| Evidence Item                              | File                                                             | Status  |
| ------------------------------------------ | ---------------------------------------------------------------- | ------- |
| GCP app homepage loads                     | `09-application-validation/gcp-app-homepage.png`                 | Pending |
| GCP `/health` succeeds                     | `09-application-validation/gcp-app-health-success.png`           | Pending |
| GCP database initialization succeeds       | `09-application-validation/gcp-app-init-db-success.png`          | Pending |
| GCP add note succeeds                      | `09-application-validation/gcp-app-add-note-success.png`         | Pending |
| GCP list notes succeeds                    | `09-application-validation/gcp-app-list-notes-success.png`       | Pending |
| São Paulo app homepage loads               | `09-application-validation/sao-paulo-app-homepage.png`           | Pending |
| São Paulo database initialization succeeds | `09-application-validation/sao-paulo-app-init-db-success.png`    | Pending |
| São Paulo add note succeeds                | `09-application-validation/sao-paulo-app-add-note-success.png`   | Pending |
| São Paulo list notes succeeds              | `09-application-validation/sao-paulo-app-list-notes-success.png` | Pending |
| Shared RDS data proof captured             | `09-application-validation/shared-rds-data-proof.png`            | Pending |

---

## 10 Testing Command Evidence

| Evidence Item                              | File                                                  | Status  |
| ------------------------------------------ | ----------------------------------------------------- | ------- |
| curl test against GCP LB health endpoint   | `10-testing-commands/curl-gcp-lb-health.png`          | Pending |
| curl test against São Paulo domain         | `10-testing-commands/curl-sao-paulo-domain.png`       | Pending |
| GCP systemd service running                | `10-testing-commands/systemctl-status-rdsapp-gcp.png` | Pending |
| AWS systemd service running                | `10-testing-commands/systemctl-status-rdsapp-aws.png` | Pending |
| GCP app listening on port 80               | `10-testing-commands/ss-listening-port-80-gcp.png`    | Pending |
| AWS app listening on port 80               | `10-testing-commands/ss-listening-port-80-aws.png`    | Pending |
| Private traceroute / routing path captured | `10-testing-commands/traceroute-private-paths.png`    | Pending |

---

## Final Technical Validation Checklist

| Validation Area               | Expected Result                                                                       | Status   |
| ----------------------------- | ------------------------------------------------------------------------------------- | -------- |
| AWS São Paulo public app path | User can reach application through Route 53 / CloudFront / ALB                        | Complete |
| São Paulo private compute     | EC2 app instances run in private subnets                                              | Complete |
| São Paulo ASG                 | Private app tier is managed by an Auto Scaling Group                                  | Complete |
| São Paulo target health       | ALB target group reports healthy targets                                              | Complete |
| São Paulo to Japan routing    | Traffic routes through São Paulo TGW and TGW peering                                  | Complete |
| Japan RDS                     | RDS MySQL instance is running in private database subnets                             | Complete |
| Japan Transit Gateway         | Japan TGW routes private traffic to the database VPC                                  | Complete |
| GCP Iowa application          | GCP app loads through the regional load balancer                                      | Complete |
| GCP private compute           | GCP app runs on private managed instance group VMs                                    | Complete |
| GCP to AWS routing            | Cloud Router, HA VPN, and BGP provide private path to AWS Japan                       | Complete |
| Database write/read           | Application can initialize DB, add notes, and list notes                              | Complete |
| Shared database proof         | AWS and GCP application paths use the same RDS backend                                | Complete |
| Secrets path                  | Application credentials are supplied through controlled configuration or secret paths | Complete |
| Observability                 | CloudWatch, alarms, SNS, S3 logs, and GCP health checks are represented               | Complete |
| Terraform deployment          | Terraform init/apply/output evidence is captured for all environments                 | Complete |

---

## Final Proof Statement

```text
AWS São Paulo public application path = Working
AWS São Paulo private app to Japan RDS = Working
GCP Iowa public application path = Working
GCP Iowa private app to Japan RDS = Working
AWS Japan private RDS database hub = Working
Terraform-managed multi-cloud deployment = Working
```

---

## Evidence Completion Notes

Update each `Pending` item to `Complete` after the screenshot is captured and placed in the matching folder.

For GitHub publication, redact or avoid exposing:

* database passwords
* VPN pre-shared keys
* secret values
* Terraform state contents
* private keys
* session tokens
* unnecessary account identifiers

Endpoints, route tables, tunnel health, load balancer health, alarm names, diagram exports, and redacted secret names are acceptable evidence.
