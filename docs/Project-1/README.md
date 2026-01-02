# Project 1: Production-Level VPC with Auto Scaling and Load Balancer

## 📋 Project Overview

This project demonstrates creating a production-ready VPC with servers in private subnets, Auto Scaling, Application Load Balancer, and NAT Gateways for high availability and security.

## 🏗️ Architecture Diagram

```
                    Internet
                        |
                Internet Gateway
                        |
        ┌───────────────┼───────────────┐
        │               │               │
   Public Subnet    Public Subnet   Application
   (AZ-1a)          (AZ-1b)         Load Balancer
   │                │               │
   NAT Gateway      NAT Gateway     │
   │                │               │
   ├────────────────┼───────────────┤
   │                │               │
   Private Subnet   Private Subnet  │
   (AZ-1a)          (AZ-1b)         │
   │                │               │
   EC2 Instances    EC2 Instances   │
   (Auto Scaling Group) ────────────┘
```

## 🎯 Project Objectives

- Deploy highly available, scalable web application
- Implement security best practices with private subnets
- Configure auto scaling for dynamic capacity management
- Set up load balancing for traffic distribution
- Enable internet access through NAT Gateways
- Implement S3 access via VPC Gateway Endpoint

## 🛠️ Step 1: Create the VPC

### 1.1 VPC Creation
```bash
# Navigate to VPC Console
AWS Console → VPC → Create VPC

# Configuration:
Resources to create: VPC and more
Name tag auto-generation: Production-VPC
IPv4 CIDR block: 10.0.0.0/16
Number of Availability Zones: 2
Number of public subnets: 2
Number of private subnets: 2
NAT gateways: 1 per AZ
VPC endpoints: S3 Gateway
```

### 1.2 Route Tables

#### Public Subnet Route Table
| Destination | Target | Purpose |
|-------------|--------|---------|
| 10.0.0.0/16 | local | VPC internal traffic |
| 0.0.0.0/0 | igw-id | Internet access |

#### Private Subnet Route Tables
| Destination | Target | Purpose |
|-------------|--------|---------|
| 10.0.0.0/16 | local | VPC internal traffic |
| 0.0.0.0/0 | nat-gateway-id | Internet via NAT |
| s3-prefix-list | s3-gateway-id | S3 access |

## 🛡️ Step 2: Security Groups

### 2.1 Application Load Balancer Security Group
```bash
# ALB-SG Configuration:
Inbound Rules:
- HTTP (80) from 0.0.0.0/0
- HTTPS (443) from 0.0.0.0/0

Outbound Rules:
- HTTP (80) to Web-Server-SG
- HTTPS (443) to Web-Server-SG
```

### 2.2 Web Server Security Group
```bash
# Web-Server-SG Configuration:
Inbound Rules:
- HTTP (80) from ALB-SG
- HTTPS (443) from ALB-SG

Outbound Rules:
- All Traffic to 0.0.0.0/0
```

## 🖥️ Step 3: Deploy Application

### 3.1 Create Launch Template
```bash
# EC2 Console → Launch Templates → Create Launch Template
Name: Production-Web-Server-Template
AMI: Amazon Linux 2023
Instance type: t3.micro
Security groups: Web-Server-SG
```

### 3.2 User Data Script
```bash
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head><title>Production Web Server</title></head>
<body>
    <h1>Production Web Application</h1>
    <p>Server: $(hostname)</p>
    <p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
    <p>AZ: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
</body>
</html>
EOF

echo "OK" > /var/www/html/health.html
```

### 3.3 Create Application Load Balancer
```bash
# EC2 Console → Load Balancers → Create Load Balancer
Type: Application Load Balancer
Name: Production-ALB
Scheme: Internet-facing
VPC: Production-VPC
Subnets: Both public subnets
Security groups: ALB-SG
```

### 3.4 Create Target Group
```bash
# Target Group Configuration:
Name: Production-Web-Servers-TG
Protocol: HTTP, Port: 80
Health check path: /health.html
```

### 3.5 Create Auto Scaling Group
```bash
# EC2 Console → Auto Scaling Groups → Create
Name: Production-Web-ASG
Launch template: Production-Web-Server-Template
Subnets: Both private subnets
Target groups: Production-Web-Servers-TG

Group Size:
- Desired: 2
- Minimum: 1
- Maximum: 6

Scaling Policy:
- Target tracking
- CPU Utilization: 70%
```

## 🧪 Step 4: Test Configuration

### 4.1 Basic Connectivity Test
```bash
# Test Load Balancer
curl http://<ALB-DNS-Name>
# Should return HTML page with server details
```

### 4.2 Auto Scaling Test
```bash
# Generate load
for i in {1..1000}; do curl http://<ALB-DNS-Name> & done

# Monitor scaling activity in Auto Scaling Groups console
```

### 4.3 High Availability Test
```bash
# Terminate one instance manually
# Verify Auto Scaling launches replacement
# Confirm no service interruption
```

### 4.4 NAT Gateway Test
```bash
# SSH to instance via Session Manager
ping google.com
curl http://checkip.amazonaws.com
aws s3 ls  # Test S3 via VPC endpoint
```

## 📊 Monitoring

### CloudWatch Metrics
- ALB Request Count and Response Time
- EC2 CPU Utilization
- Auto Scaling Group metrics
- NAT Gateway data transfer

### VPC Flow Logs
```bash
# Enable Flow Logs
VPC Console → Production-VPC → Actions → Create Flow Log
Destination: CloudWatch Logs
Log group: /aws/vpc/production-flowlogs
```

## 🧹 Step 5: Clean Up

### Cleanup Order
1. **Auto Scaling Group**: Set capacity to 0, then delete
2. **Load Balancer**: Delete ALB and target groups
3. **Launch Template**: Delete template
4. **VPC**: Delete VPC (auto-deletes associated resources)

```bash
# Auto Scaling Group
ASG → Edit → Desired/Min capacity: 0 → Wait → Delete

# Load Balancer
Load Balancers → Production-ALB → Delete
Target Groups → Production-Web-Servers-TG → Delete

# Launch Template
Launch Templates → Production-Web-Server-Template → Delete

# VPC
VPC Console → Production-VPC → Delete VPC
```

## 🔍 Troubleshooting

### Common Issues
1. **No traffic to instances**: Check security groups and target group health
2. **No internet access**: Verify NAT Gateway and route tables
3. **Auto Scaling not working**: Check CloudWatch metrics and scaling policies

## 💰 Cost Considerations

- **NAT Gateways**: ~$45/month per gateway
- **Application Load Balancer**: ~$16/month + usage
- **EC2 Instances**: Variable based on type and count

## 📚 Learning Outcomes

- Production VPC architecture design
- High availability implementation
- Auto Scaling and Load Balancing
- Security best practices
- Monitoring and troubleshooting

---

**Duration**: 4-6 hours  
**Difficulty**: Intermediate  
**Cost**: $10-20 for testing