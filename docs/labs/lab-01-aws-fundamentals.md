# Lab 01: AWS Fundamentals & Account Setup

## 🎯 Learning Objectives
By the end of this lab, you will be able to:
- Create and configure an AWS account
- Navigate the AWS Management Console
- Set up billing alerts and budgets
- Install and configure AWS CLI
- Understand AWS global infrastructure
- Implement basic security best practices

## ⏱️ Duration
- **Estimated Time:** 2-3 hours
- **Difficulty Level:** Beginner

## 📋 Prerequisites
- Valid email address
- Credit card for AWS account verification
- Computer with internet access
- Basic understanding of cloud computing concepts

## 🛠️ Tools Required
- Web browser (Chrome, Firefox, Safari, or Edge)
- AWS CLI (will be installed during the lab)
- Text editor (VS Code, Notepad++, or similar)

## 📚 Lab Overview

### **Part 1: AWS Account Creation**
### **Part 2: AWS Console Navigation**
### **Part 3: Billing & Cost Management**
### **Part 4: AWS CLI Setup**
### **Part 5: Security Best Practices**

---

## 🚀 Part 1: AWS Account Creation

### **Step 1: Create AWS Account**

1. **Navigate to AWS**
   - Open your web browser
   - Go to [https://aws.amazon.com](https://aws.amazon.com)
   - Click "Create an AWS Account"

2. **Account Information**
   - Enter your email address
   - Choose a password (follow AWS password requirements)
   - Provide a unique AWS account name

3. **Contact Information**
   - Select account type (Personal or Business)
   - Fill in your contact information:
     - Full name
     - Phone number
     - Country/Region
     - Address

4. **Payment Information**
   - Enter credit card details
   - AWS will charge $1 for verification (refunded)
   - Provide billing address

5. **Identity Verification**
   - Choose verification method (SMS or Voice)
   - Enter the verification code received

6. **Support Plan Selection**
   - Choose "Free" support plan for now
   - You can upgrade later if needed

### **Step 2: Account Verification**

1. **Check Email**
   - Look for AWS welcome email
   - Click the verification link
   - Sign in to your new AWS account

2. **Complete Account Setup**
   - Set up your account alias (optional)
   - Review and accept the AWS Customer Agreement

---

## 🖥️ Part 2: AWS Console Navigation

### **Step 1: Explore AWS Console**

1. **Sign in to AWS Console**
   - Go to [https://console.aws.amazon.com](https://console.aws.amazon.com)
   - Sign in with your credentials

2. **Console Overview**
   - Notice the search bar at the top
   - Explore the service categories on the left
   - Check the region selector in the top-right

3. **Service Categories**
   - **Compute:** EC2, Lambda, ECS
   - **Storage:** S3, EBS, EFS
   - **Database:** RDS, DynamoDB, ElastiCache
   - **Networking:** VPC, Route 53, CloudFront
   - **Security:** IAM, KMS, WAF
   - **Management:** CloudWatch, CloudTrail, Config

### **Step 2: Region Selection**

1. **Understand AWS Regions**
   - Click the region selector (top-right)
   - Notice the different regions available
   - Select a region close to your location
   - **Recommended:** us-east-1 (N. Virginia) for learning

2. **Region Characteristics**
   - Each region is independent
   - Services and pricing may vary by region
   - Data residency requirements

### **Step 3: Service Navigation**

1. **Search for Services**
   - Use the search bar to find "EC2"
   - Click on EC2 service
   - Explore the EC2 dashboard

2. **Service Dashboard**
   - Notice the service overview
   - Check the left navigation menu
   - Explore different sections

---

## 💰 Part 3: Billing & Cost Management

### **Step 1: Access Billing Dashboard**

1. **Navigate to Billing**
   - Click on your account name (top-right)
   - Select "Billing & Cost Management"
   - Or search for "Billing" in the console

2. **Billing Dashboard Overview**
   - Current month charges
   - Cost breakdown by service
   - Budget alerts status

### **Step 2: Set Up Billing Alerts**

1. **Create Budget**
   - Click "Budgets" in the left menu
   - Click "Create budget"
   - Choose "Cost budget"

2. **Configure Budget**
   - **Budget name:** "Monthly Budget Alert"
   - **Budget amount:** $10 (for learning)
   - **Budget period:** Monthly
   - **Start month:** Current month

3. **Set Up Alerts**
   - **Alert 1:** 80% of budget ($8)
   - **Alert 2:** 100% of budget ($10)
   - **Alert 3:** 120% of budget ($12)
   - **Email addresses:** Your email address

### **Step 3: Cost Explorer**

1. **Access Cost Explorer**
   - Click "Cost Explorer" in the left menu
   - Click "Launch Cost Explorer"

2. **View Cost Data**
   - Select date range (last 7 days)
   - Group by service
   - Analyze cost breakdown

---

## 🔧 Part 4: AWS CLI Setup

### **Step 1: Install AWS CLI**

#### **For Windows:**
```bash
# Download AWS CLI MSI installer
# Visit: https://awscli.amazonaws.com/AWSCLIV2.msi
# Run the installer and follow the prompts
```

#### **For macOS:**
```bash
# Using Homebrew
brew install awscli

# Or download the official installer
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

#### **For Linux:**
```bash
# Download and install
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### **Step 2: Configure AWS CLI**

1. **Run Configuration**
   ```bash
   aws configure
   ```

2. **Enter Credentials**
   - **AWS Access Key ID:** [You'll create this next]
   - **AWS Secret Access Key:** [You'll create this next]
   - **Default region name:** us-east-1
   - **Default output format:** json

### **Step 3: Create IAM User for CLI**

1. **Navigate to IAM**
   - Search for "IAM" in the console
   - Click on IAM service

2. **Create User**
   - Click "Users" in the left menu
   - Click "Create user"
   - **User name:** cli-user
   - **Access type:** Programmatic access

3. **Set Permissions**
   - Click "Attach existing policies directly"
   - Search for "AdministratorAccess"
   - Select the policy (for learning purposes)

4. **Create Access Keys**
   - Complete user creation
   - Download the CSV file with credentials
   - **Important:** Keep this file secure!

5. **Configure CLI with New Credentials**
   ```bash
   aws configure
   # Enter the Access Key ID and Secret Access Key from the CSV file
   ```

### **Step 4: Test AWS CLI**

1. **List S3 Buckets**
   ```bash
   aws s3 ls
   ```

2. **List EC2 Instances**
   ```bash
   aws ec2 describe-instances
   ```

3. **Check Your Identity**
   ```bash
   aws sts get-caller-identity
   ```

---

## 🔒 Part 5: Security Best Practices

### **Step 1: Enable Multi-Factor Authentication (MFA)**

1. **Access IAM Console**
   - Go to IAM service
   - Click on your root user account

2. **Enable MFA**
   - Click "Security credentials" tab
   - Click "Enable MFA"
   - Choose "Virtual MFA device"
   - Follow the setup instructions

### **Step 2: Create IAM Users**

1. **Create Admin User**
   - Go to IAM → Users
   - Click "Create user"
   - **User name:** admin-user
   - **Access type:** Both console and programmatic

2. **Set Console Password**
   - Choose "Custom password"
   - Set a strong password
   - Require password reset

3. **Attach Policies**
   - Attach "AdministratorAccess" policy
   - Complete user creation

### **Step 3: Set Up IAM Groups**

1. **Create Groups**
   - Go to IAM → Groups
   - Click "Create group"
   - **Group name:** Administrators
   - Attach "AdministratorAccess" policy

2. **Add Users to Groups**
   - Go back to Users
   - Select your admin user
   - Add to Administrators group

### **Step 4: Configure Password Policy**

1. **Set Password Requirements**
   - Go to IAM → Account settings
   - Click "Edit" for password policy
   - Configure:
     - Minimum password length: 12
     - Require uppercase letters: Yes
     - Require lowercase letters: Yes
     - Require numbers: Yes
     - Require symbols: Yes
     - Password expiration: 90 days

---

## 📝 Lab Exercises

### **Exercise 1: Service Exploration**
1. Navigate to 5 different AWS services
2. Take screenshots of each service dashboard
3. Note down the key features of each service

### **Exercise 2: CLI Commands**
1. List all available AWS services using CLI
2. Get information about your AWS account
3. List all IAM users in your account

### **Exercise 3: Cost Analysis**
1. Set up a budget for $5
2. Create alerts at 50%, 80%, and 100%
3. Analyze your current month's spending

### **Exercise 4: Security Setup**
1. Create an IAM user for yourself
2. Enable MFA for the new user
3. Create a custom policy with minimal permissions

---

## 🧪 Lab Validation

### **Checklist for Completion**
- [ ] AWS account created and verified
- [ ] Billing alerts configured
- [ ] AWS CLI installed and configured
- [ ] IAM user created with MFA
- [ ] Password policy configured
- [ ] All exercises completed

### **Validation Commands**
```bash
# Test AWS CLI access
aws sts get-caller-identity

# List IAM users
aws iam list-users

# Check S3 buckets
aws s3 ls

# Verify region
aws configure get region
```

---

## 🚨 Important Notes

### **Cost Management**
- Always monitor your AWS spending
- Set up billing alerts immediately
- Use AWS Free Tier when possible
- Terminate resources when not in use

### **Security Best Practices**
- Never share your AWS credentials
- Use IAM users instead of root account
- Enable MFA for all users
- Follow the principle of least privilege

### **Free Tier Limits**
- 12 months free tier available
- Monitor usage to avoid charges
- Some services have perpetual free tier

---

## 📚 Additional Resources

### **Documentation**
- [AWS Getting Started Guide](https://aws.amazon.com/getting-started/)
- [AWS CLI User Guide](https://docs.aws.amazon.com/cli/latest/userguide/)
- [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)

### **Videos**
- [AWS Console Overview](https://www.youtube.com/watch?v=8tLJ7YXwq5g)
- [AWS CLI Setup](https://www.youtube.com/watch?v=KngM5bfpttA)

### **Practice**
- [AWS Cloud Practitioner Essentials](https://aws.amazon.com/training/awsacademy/)
- [AWS Free Tier](https://aws.amazon.com/free/)

---

## 🆘 Troubleshooting

### **Common Issues**

1. **CLI Configuration Error**
   ```bash
   # Reconfigure AWS CLI
   aws configure
   ```

2. **Permission Denied**
   - Check IAM user permissions
   - Verify access keys are correct
   - Ensure user has necessary policies

3. **Billing Alerts Not Working**
   - Check email spam folder
   - Verify email address is correct
   - Wait 24 hours for first alert

4. **MFA Setup Issues**
   - Use a different MFA app
   - Ensure time synchronization
   - Try hardware MFA device

### **Support Resources**
- AWS Support Center
- AWS Documentation
- AWS Forums
- AWS Training

---

**Next Lab:** [Lab 02: Identity & Access Management (IAM)](./lab-02-iam.md)
