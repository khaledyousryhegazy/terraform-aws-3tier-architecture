# Terraform AWS 3-Tier Architecture

## Overview

This project provisions a production-style highly available 3-tier architecture on AWS using Terraform.

The infrastructure is modular, reusable, and follows Infrastructure as Code (IaC) best practices.

## Note: Production environments should use AWS Certificate Manager (ACM) with Route53 to enable HTTPS.

## Architecture

```
                Internet
                    │
                    ▼
        Application Load Balancer
                    │
                    ▼
        Auto Scaling Group (EC2)
                    │
                    ▼
            PostgreSQL RDS
```

---

## Technologies

- Terraform
- AWS
- VPC
- EC2
- Auto Scaling Group
- Launch Template
- Application Load Balancer
- RDS PostgreSQL
- IAM
- Security Groups
- CloudWatch
- SNS
- Apache HTTP Server

---

## Project Structure

```
.
├── assets/
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
│   ├── vpc/
│   └── vpc_endpoints/
├── scripts/
│   └── userData.sh
└── README.md
```

---

## Infrastructure Components

### Networking

- Custom VPC
- Public and Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- VPC Endpoints

---

### Security

- Separate Security Groups for:
  - Application Load Balancer
  - EC2 Instances
  - PostgreSQL RDS

- Least privilege IAM Role for EC2

---

### Compute

- Launch Template
- Auto Scaling Group
- Apache installed automatically using User Data
- CloudWatch Agent installed automatically
- EC2 instances deployed in private subnets

---

### Load Balancer

- Application Load Balancer
- HTTP Listener
- Target Group
- Health Checks
- Automatic registration of Auto Scaling instances

---

### Database

- PostgreSQL RDS
- Private DB Subnet Group
- Storage Encryption
- Enhanced Monitoring
- Performance Insights
- Automated Backups
- Deletion Protection
- Multi-AZ deployment

---

### Monitoring

CloudWatch Agent collects:

- CPU Utilization
- Memory Usage
- Disk Usage

CloudWatch Dashboard includes:

- EC2 CPU Utilization
- EC2 Memory Usage
- EC2 Disk Usage
- ALB Request Count
- RDS CPU Utilization
- RDS Free Storage

CloudWatch Alarm:

- EC2 CPU Utilization > 70%

---

### Notifications

Amazon SNS sends email notifications for:

- CloudWatch Alarms
- Auto Scaling Launch Events
- Auto Scaling Termination Events
- Auto Scaling Errors

---

## User Data

Each EC2 instance automatically:

- Updates the operating system
- Installs Apache HTTP Server
- Installs Amazon CloudWatch Agent
- Creates a sample web page
- Starts required services
- Enables services on boot

---

## High Availability

- Multi-AZ VPC Design
- Application Load Balancer
- Auto Scaling Group
- Multi-AZ PostgreSQL Database

---

## Terraform Modules

- VPC
- Security Groups
- IAM
- Auto Scaling Group
- Application Load Balancer
- RDS PostgreSQL
- CloudWatch
- SNS

---

## Deployment

```bash
terraform init

terraform plan

terraform apply
```

---

## Future Improvements (for Production)

- HTTPS using AWS Certificate Manager (ACM)
- Route 53 DNS
- AWS WAF
- GitHub Actions CI/CD
- AWS Secrets Manager for database credentials
- KMS Customer Managed Keys
