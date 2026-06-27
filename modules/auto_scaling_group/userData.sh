#!/bin/bash

# Update system
dnf update -y

# Install Apache
dnf install -y httpd

# Install CloudWatch Agent
dnf install -y amazon-cloudwatch-agent

# Install SSM Agent
dnf install -y amazon-ssm-agent

# Start and enable Apache
systemctl enable httpd
systemctl start httpd

# Start and enable SSM Agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# Create test page
cat <<EOF >/var/www/html/index.html
<!DOCTYPE html>
<html>
  <head>
    <title>3-Tier App</title>
  </head>
  <body>
    <h1>EGYPT 1-1 IRAN</h1>
    <h1>EGYPT 1-1 IRAN</h1>
    <h1>EGYPT 1-1 IRAN</h1>
    <h1>EGYPT 1-1 IRAN</h1>
    <h1>EGYPT 1-1 IRAN</h1>
    <h1>EGYPT 1-1 IRAN</h1>
    <h1>EGYPT 1-1 IRAN</h1>
    <p>Hostname: $(hostname)</p>
  </body>
</html>
EOF

# CloudWatch Agent Configuration
cat <<EOF >/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "metrics": {
    "namespace": "CWAgent",
    "append_dimensions": {
      "AutoScalingGroupName": "${aws:AutoScalingGroupName}"
    },
    "metrics_collected": {
      "mem": {
        "measurement": [
          "mem_used_percent"
        ]
      },
      "disk": {
        "measurement": [
          "used_percent"
        ],
        "resources": [
          "/"
        ]
      }
    }
  }
}
EOF

# Start CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
	-a fetch-config \
	-m ec2 \
	-c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
	-s

# Enable CloudWatch Agent
systemctl enable amazon-cloudwatch-agent
