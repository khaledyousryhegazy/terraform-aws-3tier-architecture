## TODO Order

1.  ~~VPC~~
2.  ~~Security Groups~~
3.  ~~S3 Endpoint~~
4.  ~~IAM~~
5.  ~~Launch Template~~
6.  ~~Auto Scaling Group~~
7.  ~~ALB
8.  ~~RDS
9.  ~~CloudWatch
10. ~~Backend State
11. ~~README
12. ~~Checking & Testing (if can add more advantages)

## last stage outputs:

- output "vpc_id"
- output "public_subnets"
- output "private_subnets"
- output "database_subnets"
- output "autoscaling_group_name"
- output "alb_dns_name"
- output "rds_endpoint"

## Architecture

- VPC
- Public / Private / DB Subnets
- NAT Gateway
- S3 VPC Endpoint
- Application Load Balancer
- Auto Scaling Group
- RDS MySQL Multi-AZ
- Security Groups (Internet -> VPC -> ALB -> APP -> DB)
- Terraform Modules
- Remote State Backend
