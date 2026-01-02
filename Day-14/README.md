# Day 14: VPC Implementation - Complete Hands-on Lab

## 📚 Learning Objectives
- Create a complete VPC from scratch
- Implement public and private subnets
- Configure Internet Gateway and NAT Gateway
- Set up route tables and security groups
- Deploy EC2 instances to test connectivity
- Understand VPC networking in practice

## 🏗️ VPC Architecture Overview

```
Internet
    |
Internet Gateway
    |
VPC (10.0.0.0/16)
    |
    ├── Public Subnet (10.0.1.0/24)
    │   ├── Route Table (Public)
    │   ├── EC2 Instance (Web Server)
    │   └── NAT Gateway
    │
    └── Private Subnet (10.0.2.0/24)
        ├── Route Table (Private)
        └── EC2 Instance (Database Server)
```

## 🛠️ Step-by-Step VPC Creation

### Step 1: Create VPC
```bash
# Navigate to VPC Console
AWS Console → Services → VPC → Your VPCs → Create VPC

# VPC Configuration:
Name tag: MyCustomVPC
IPv4 CIDR block: 10.0.0.0/16
IPv6 CIDR block: No IPv6 CIDR block
Tenancy: Default
```

### Step 2: Create Internet Gateway
```bash
# Create Internet Gateway
VPC Console → Internet Gateways → Create Internet Gateway

# Configuration:
Name tag: MyCustomVPC-IGW

# Attach to VPC
Actions → Attach to VPC → Select MyCustomVPC
```

### Step 3: Create Public Subnet
```bash
# Create Public Subnet
VPC Console → Subnets → Create Subnet

# Configuration:
VPC ID: MyCustomVPC
Subnet name: Public-Subnet
Availability Zone: us-east-1a
IPv4 CIDR block: 10.0.1.0/24
```

### Step 4: Create Private Subnet
```bash
# Create Private Subnet
VPC Console → Subnets → Create Subnet

# Configuration:
VPC ID: MyCustomVPC
Subnet name: Private-Subnet
Availability Zone: us-east-1b
IPv4 CIDR block: 10.0.2.0/24
```

### Step 5: Create Route Tables

#### Public Route Table
```bash
# Create Public Route Table
VPC Console → Route Tables → Create Route Table

# Configuration:
Name: Public-RT
VPC: MyCustomVPC

# Add Routes:
Destination: 0.0.0.0/0
Target: Internet Gateway (MyCustomVPC-IGW)

# Associate with Public Subnet:
Subnet Associations → Edit → Select Public-Subnet
```

#### Private Route Table
```bash
# Create Private Route Table
VPC Console → Route Tables → Create Route Table

# Configuration:
Name: Private-RT
VPC: MyCustomVPC

# Associate with Private Subnet:
Subnet Associations → Edit → Select Private-Subnet
```

### Step 6: Create NAT Gateway
```bash
# Create NAT Gateway
VPC Console → NAT Gateways → Create NAT Gateway

# Configuration:
Name: MyCustomVPC-NAT
Subnet: Public-Subnet
Connectivity type: Public
Elastic IP allocation ID: Create new EIP

# Update Private Route Table:
Route Tables → Private-RT → Routes → Edit Routes
Add Route: 0.0.0.0/0 → NAT Gateway (MyCustomVPC-NAT)
```

### Step 7: Create Security Groups

#### Web Server Security Group
```bash
# Create Web Server SG
VPC Console → Security Groups → Create Security Group

# Configuration:
Security group name: WebServer-SG
Description: Security group for web servers
VPC: MyCustomVPC

# Inbound Rules:
Type: HTTP, Protocol: TCP, Port: 80, Source: 0.0.0.0/0
Type: HTTPS, Protocol: TCP, Port: 443, Source: 0.0.0.0/0
Type: SSH, Protocol: TCP, Port: 22, Source: Your IP

# Outbound Rules:
Type: All Traffic, Protocol: All, Port: All, Destination: 0.0.0.0/0
```

#### Database Security Group
```bash
# Create Database SG
VPC Console → Security Groups → Create Security Group

# Configuration:
Security group name: Database-SG
Description: Security group for database servers
VPC: MyCustomVPC

# Inbound Rules:
Type: MySQL/Aurora, Protocol: TCP, Port: 3306, Source: WebServer-SG
Type: SSH, Protocol: TCP, Port: 22, Source: WebServer-SG

# Outbound Rules:
Type: All Traffic, Protocol: All, Port: All, Destination: 0.0.0.0/0
```

## 🖥️ EC2 Instance Deployment

### Step 8: Launch Public EC2 Instance (Web Server)
```bash
# Launch Instance
EC2 Console → Launch Instance

# Configuration:
Name: WebServer-Public
AMI: Amazon Linux 2023
Instance Type: t2.micro
Key Pair: Create new or select existing

# Network Settings:
VPC: MyCustomVPC
Subnet: Public-Subnet
Auto-assign Public IP: Enable
Security Group: WebServer-SG

# User Data Script:
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Web Server in Public Subnet</h1>" > /var/www/html/index.html
echo "<p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>" >> /var/www/html/index.html
echo "<p>Public IP: $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)</p>" >> /var/www/html/index.html
```

### Step 9: Launch Private EC2 Instance (Database Server)
```bash
# Launch Instance
EC2 Console → Launch Instance

# Configuration:
Name: DatabaseServer-Private
AMI: Amazon Linux 2023
Instance Type: t2.micro
Key Pair: Same as web server

# Network Settings:
VPC: MyCustomVPC
Subnet: Private-Subnet
Auto-assign Public IP: Disable
Security Group: Database-SG

# User Data Script:
#!/bin/bash
yum update -y
yum install -y mysql-server
systemctl start mysqld
systemctl enable mysqld
```

## 🧪 Testing Connectivity

### Test 1: Public Instance Internet Access
```bash
# SSH to Public Instance
ssh -i your-key.pem ec2-user@<public-ip>

# Test internet connectivity
ping google.com
curl http://google.com

# Check web server
curl localhost
```

### Test 2: Private Instance Internet Access
```bash
# SSH to Private Instance (through Public Instance)
ssh -i your-key.pem ec2-user@<public-ip>
ssh -i your-key.pem ec2-user@<private-ip>

# Test internet connectivity from private instance
ping google.com
curl http://google.com
```

### Test 3: Inter-Subnet Communication
```bash
# From Public Instance
ping <private-instance-ip>

# From Private Instance
ping <public-instance-ip>
```

### Test 4: Web Server Access
```bash
# Access web server from internet
curl http://<public-instance-ip>
```

## 🔧 Troubleshooting Common Issues

### Issue 1: Public Instance No Internet Access
```bash
# Check List:
1. Internet Gateway attached to VPC? ✓
2. Public subnet route table has 0.0.0.0/0 → IGW? ✓
3. Instance has public IP assigned? ✓
4. Security group allows outbound traffic? ✓
```

### Issue 2: Private Instance No Internet Access
```bash
# Check List:
1. NAT Gateway in public subnet? ✓
2. NAT Gateway has Elastic IP? ✓
3. Private route table has 0.0.0.0/0 → NAT? ✓
4. Security group allows outbound traffic? ✓
```

## 📚 Interview Questions & Answers

### Fresher Level (1-10)

**Q1: What is the difference between public and private subnets?**
A: Public subnets have a route to Internet Gateway (0.0.0.0/0 → IGW) allowing direct internet access. Private subnets don't have direct internet routes and use NAT Gateway for outbound internet access only.

**Q2: Why do we need NAT Gateway in private subnets?**
A: NAT Gateway allows private subnet instances to access internet for updates, patches, and external API calls while preventing inbound internet connections, maintaining security.

**Q3: What is the purpose of Internet Gateway?**
A: Internet Gateway enables bidirectional internet communication for VPC. It allows public subnet instances to send/receive traffic to/from internet and provides public IP translation.

**Q4: How many IP addresses are available in a /24 subnet?**
A: A /24 subnet has 256 total IP addresses, but AWS reserves 5 IPs (.0, .1, .2, .3, .255), leaving 251 usable IP addresses for instances.

**Q5: What happens if you don't associate a subnet with a route table?**
A: The subnet automatically associates with the main route table of the VPC. It's best practice to create custom route tables for better control and security.

### Intermediate Level (6-15)

**Q6: Explain the traffic flow from a private instance to internet.**
A: Private Instance → Private Route Table → NAT Gateway (in public subnet) → Public Route Table → Internet Gateway → Internet. Return traffic follows the reverse path.

**Q7: What's the difference between NAT Gateway and NAT Instance?**
A: NAT Gateway is AWS-managed, highly available, auto-scaling service with better performance. NAT Instance is self-managed EC2 instance, cheaper but requires manual management.

**Q8: How do you troubleshoot connectivity issues in VPC?**
A: Check route tables, security groups, NACLs, instance status, VPC Flow Logs. Use systematic approach: routing → security → instance level.

**Q9: Can you have multiple Internet Gateways in one VPC?**
A: No, each VPC can have only one Internet Gateway attached at a time. However, you can detach and attach different IGWs.

**Q10: How do you secure database servers in private subnets?**
A: Use security groups allowing only application tier access, implement database-level authentication, encrypt data, and enable monitoring/logging.

**Q11: What are the limitations of NAT Gateway?**
A: NAT Gateway has bandwidth limits (up to 45 Gbps), costs money, single AZ deployment, and cannot be used as bastion host.

**Q12: How do you implement high availability for NAT Gateway?**
A: Deploy NAT Gateways in multiple AZs, create separate route tables for each private subnet pointing to NAT Gateway in same AZ.

**Q13: What are VPC Endpoints and when to use them?**
A: VPC Endpoints provide private connectivity to AWS services without internet. Use for S3, DynamoDB access from private subnets to avoid NAT Gateway costs.

**Q14: How do you optimize costs for NAT Gateway?**
A: Use single NAT Gateway for multiple private subnets, consider NAT Instance for low traffic, use VPC Endpoints for AWS services.

**Q15: Explain VPC Flow Logs and their use cases.**
A: VPC Flow Logs capture IP traffic information for VPC, subnets, or network interfaces. Used for security analysis, troubleshooting, and compliance monitoring

## 🔑 Key Takeaways

- **VPC Design**: Plan CIDR blocks carefully for future growth and avoid overlaps
- **Security Layers**: Use security groups, NACLs, and proper subnet design
- **High Availability**: Deploy resources across multiple AZs
- **Cost Management**: Monitor NAT Gateway usage and consider alternatives
- **Troubleshooting**: Understand traffic flow and use systematic approach

## 🚀 Next Steps

- Day 15: Advanced VPC Features (VPC Endpoints, Peering, Transit Gateway)
- Implement multi-AZ deployment
- Explore VPC security best practices

---

**Hands-on Completed:** ✅ VPC Creation, Subnets, Gateways, EC2 Deployment, Connectivity Testing  
**Duration:** 2 hours  
**Difficulty:** Intermediate
