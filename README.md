# Terraform AWS 3-Tier Architecture

A production-style, highly available 3-tier infrastructure on AWS, built with Terraform and organized into reusable modules following IaC best practices.

---

## Architecture

```
         Internet
             │
             ▼
 Application Load Balancer  (Public Subnets)
             │
             ▼
  Auto Scaling Group / EC2  (Private Subnets)
             │
             ▼
      PostgreSQL RDS         (Private DB Subnets)
```

---

## Stack

| Layer          | Technology                                    |
| -------------- | --------------------------------------------- |
| IaC            | Terraform                                     |
| Compute        | EC2, Auto Scaling Group, Launch Template      |
| Networking     | VPC, Subnets, IGW, NAT Gateway, VPC Endpoints |
| Load Balancing | Application Load Balancer                     |
| Database       | RDS PostgreSQL (Multi-AZ)                     |
| Security       | IAM, Security Groups                          |
| Monitoring     | CloudWatch Agent, Dashboard, Alarms           |
| Notifications  | SNS (email alerts)                            |
| Web Server     | Apache HTTP Server (via User Data)            |

---

## Project Structure

```
.
├── environments/
│   ├── dev/
│   └── prod/
├── modules/
│   ├── alb/
│   ├── auto_scaling_group/
│   ├── cloudwatch/
│   ├── iam/
│   ├── rds/
│   ├── security_groups/
│   ├── sns/
│   ├── vpc/
│   └── vpc_endpoints/
├── scripts/
│   └── userData.sh
└── README.md
```

---

## Security Highlights

- Least privilege IAM role for EC2
- Separate security groups per tier (ALB → App → DB)
- EC2 instances in private subnets (no public IPs)
- RDS in isolated DB subnets
- VPC Endpoints for SSM, SSMMessages, EC2Messages, and S3 (no traffic over public internet)
- SSM Session Manager access instead of open SSH

---

## Monitoring & Alerts

- CloudWatch Agent collects CPU, memory, and disk metrics
- CloudWatch Dashboard with ALB, EC2, and RDS metrics
- CloudWatch Alarm triggers at EC2 CPU > 70%
- SNS email notifications for alarms and ASG lifecycle events (launch, terminate, errors)

---

## Deployment

```bash
cd /environment/dev
terraform init -backend-init=backend.hcl
terraform plan
terraform apply
terraform destroy
```
