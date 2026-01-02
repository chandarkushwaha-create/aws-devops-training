# Day 9: AWS IAM (Identity and Access Management) & Interview Preparation

## 📚 Learning Objectives
- Master AWS IAM core concepts and components
- Understand authentication vs authorization
- Implement IAM policies, roles, and groups
- Practice hands-on IAM configurations
- Prepare for AWS interview questions

## 🎯 What is AWS IAM?

AWS Identity and Access Management (IAM) is a web service that helps you securely control access to AWS resources. IAM controls **who** is authenticated (signed in) and **who** is authorized (has permissions) to use resources.

### Core Components:
- **Users**: Individual people or services
- **Groups**: Collection of users
- **Roles**: Set of permissions for AWS services
- **Policies**: Documents defining permissions

## 🔐 IAM Core Concepts

### Authentication vs Authorization
```
Authentication (Who are you?)
├── Username/Password
├── Access Keys
├── MFA (Multi-Factor Authentication)
└── Temporary Security Credentials

Authorization (What can you do?)
├── Policies (JSON documents)
├── Permissions
├── Resource-based policies
└── Identity-based policies
```

### IAM Components Deep Dive

#### 1. IAM Users
- Represents a person or service
- Has permanent long-term credentials
- Can have console and/or programmatic access

#### 2. IAM Groups
- Collection of users
- Easier permission management
- Users inherit group permissions

#### 3. IAM Roles
- Temporary credentials
- Can be assumed by users, services, or applications
- Cross-account access capability

#### 4. IAM Policies
- JSON documents defining permissions
- Attached to users, groups, or roles
- Effect: Allow or Deny

## 🛠️ Hands-on Lab: IAM Implementation

### Lab Overview
1. Create IAM users and groups
2. Attach policies to groups
3. Create custom policies
4. Implement IAM roles
5. Test permissions and access

### Step 1: Create IAM Groups

```bash
# Navigate to IAM Console
AWS Console → IAM → Groups → Create Group

# Create Groups:
1. Developers
2. Administrators  
3. ReadOnlyUsers
```

### Step 2: Create IAM Users

```json
// Create users via console or CLI
Users to create:
- john-developer
- sarah-admin
- mike-readonly
```

**Via AWS CLI:**
```bash
# Create users
aws iam create-user --user-name john-developer
aws iam create-user --user-name sarah-admin
aws iam create-user --user-name mike-readonly

# Create login profiles
aws iam create-login-profile \
  --user-name john-developer \
  --password TempPassword123! \
  --password-reset-required
```

### Step 3: Attach Policies to Groups

```bash
# Attach AWS managed policies
Developers Group:
- AmazonEC2FullAccess
- AmazonS3FullAccess

Administrators Group:
- AdministratorAccess

ReadOnlyUsers Group:
- ReadOnlyAccess
```

### Step 4: Create Custom Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::my-dev-bucket/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::my-dev-bucket"
    }
  ]
}
```

### Step 5: Create IAM Role

```json
// Trust Policy for EC2 Role
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

**Create Role Steps:**
1. IAM → Roles → Create Role
2. Select EC2 service
3. Attach policies (e.g., AmazonS3ReadOnlyAccess)
4. Name: EC2-S3-ReadOnly-Role

### Step 6: Test Permissions

```bash
# Test user permissions
aws sts get-caller-identity
aws s3 ls  # Should work for developers
aws ec2 describe-instances  # Test EC2 access
```

## 🎯 IAM Best Practices

### Security Best Practices
1. **Principle of Least Privilege**: Grant minimum required permissions
2. **Use Groups**: Don't attach policies directly to users
3. **Enable MFA**: Multi-factor authentication for sensitive operations
4. **Rotate Credentials**: Regular access key rotation
5. **Use Roles**: For applications and cross-account access
6. **Monitor Activity**: CloudTrail for audit logging

### Policy Best Practices
```json
// Good Policy Example
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::specific-bucket/*",
      "Condition": {
        "StringEquals": {
          "s3:ExistingObjectTag/Environment": "Development"
        }
      }
    }
  ]
}
```

## 🎤 AWS Interview Questions & Answers

### Basic Level Questions

**Q1: What is AWS IAM?**
**A:** AWS IAM is a service that manages access to AWS resources. It controls authentication (who can sign in) and authorization (what they can do). IAM includes users, groups, roles, and policies to manage permissions securely.

**Q2: Difference between IAM Users and IAM Roles?**
**A:** 
- **Users**: Permanent identities with long-term credentials (access keys/passwords)
- **Roles**: Temporary identities that can be assumed, no permanent credentials
- **Use Cases**: Users for people, Roles for applications/services

**Q3: What are IAM Policies?**
**A:** JSON documents that define permissions. They specify what actions are allowed or denied on which resources. Policies can be attached to users, groups, or roles.

### Intermediate Level Questions

**Q4: Explain IAM Policy Structure**
**A:**
```json
{
  "Version": "2012-10-17",        // Policy language version
  "Statement": [                  // Array of permission statements
    {
      "Effect": "Allow|Deny",     // Permission type
      "Action": "service:action", // What actions
      "Resource": "arn:aws:...",  // Which resources
      "Condition": {...}          // When (optional)
    }
  ]
}
```

**Q5: What is Cross-Account Access?**
**A:** Allows users from one AWS account to access resources in another account using IAM roles. The target account creates a role with trust policy allowing the source account to assume it.

**Q6: Difference between Resource-based and Identity-based Policies?**
**A:**
- **Identity-based**: Attached to users/groups/roles, defines what they can do
- **Resource-based**: Attached to resources (S3 buckets), defines who can access them

### Advanced Level Questions

**Q7: How does IAM Policy Evaluation work?**
**A:** AWS follows this logic:
1. **Default Deny**: All requests denied by default
2. **Explicit Deny**: Any explicit deny overrides everything
3. **Explicit Allow**: Must have explicit allow to proceed
4. **Policy Types**: Identity-based, resource-based, SCPs, ACLs evaluated together

**Q8: What is IAM Policy Simulator?**
**A:** A tool to test and troubleshoot IAM policies. It simulates API calls to see if they would be allowed or denied based on current policies, helping debug permission issues.

**Q9: Explain STS (Security Token Service)**
**A:** STS provides temporary security credentials for IAM roles. It's used for:
- Cross-account access
- Federation with external identity providers
- Applications running on EC2 instances
- Temporary access for users

### Scenario-Based Questions

**Q10: How would you provide S3 access to an EC2 instance?**
**A:**
1. Create IAM role with S3 permissions
2. Attach role to EC2 instance
3. Application uses instance metadata to get temporary credentials
4. No need to store access keys on instance

**Q11: A user can't access S3 bucket despite having S3FullAccess policy. Why?**
**A:** Possible reasons:
- Explicit deny in another policy
- Bucket policy denying access
- S3 Block Public Access settings
- Resource-based policy conflicts
- SCP (Service Control Policy) restrictions

**Q12: How to implement least privilege for a developer?**
**A:**
1. Start with no permissions
2. Add specific permissions as needed
3. Use groups for common permissions
4. Regular access reviews
5. Use conditions in policies
6. Monitor with CloudTrail

## 🔧 Practical IAM Scenarios

### Scenario 1: Multi-Environment Access
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::dev-bucket/*",
        "arn:aws:s3:::dev-bucket"
      ],
      "Condition": {
        "StringEquals": {
          "aws:RequestedRegion": "us-east-1"
        }
      }
    }
  ]
}
```

### Scenario 2: Time-based Access
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*",
      "Condition": {
        "DateGreaterThan": {
          "aws:CurrentTime": "2024-01-01T00:00:00Z"
        },
        "DateLessThan": {
          "aws:CurrentTime": "2024-12-31T23:59:59Z"
        }
      }
    }
  ]
}
```

### Scenario 3: IP-based Restrictions
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "NotIpAddress": {
          "aws:SourceIp": [
            "203.0.113.0/24",
            "198.51.100.0/24"
          ]
        }
      }
    }
  ]
}
```

## 🎯 Common IAM Troubleshooting

### Permission Denied Issues
```bash
# Check current identity
aws sts get-caller-identity

# Simulate policy
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::123456789012:user/testuser \
  --action-names s3:GetObject \
  --resource-arns arn:aws:s3:::test-bucket/test.txt
```

### Access Key Management
```bash
# List access keys
aws iam list-access-keys --user-name username

# Create new access key
aws iam create-access-key --user-name username

# Delete access key
aws iam delete-access-key --user-name username --access-key-id AKIAIOSFODNN7EXAMPLE
```

## 📊 IAM Monitoring and Compliance

### CloudTrail Integration
- Log all IAM API calls
- Monitor policy changes
- Track access patterns
- Compliance reporting

### Access Analyzer
- Identifies resources shared with external entities
- Validates policies against security best practices
- Generates findings for review

## 🏆 Lab Completion Checklist

- [ ] Created IAM users, groups, and roles
- [ ] Attached appropriate policies
- [ ] Tested permissions and access
- [ ] Implemented custom policies
- [ ] Configured MFA for users
- [ ] Tested cross-account access scenario
- [ ] Reviewed CloudTrail logs
- [ ] Practiced troubleshooting scenarios

## 📚 Additional Resources

- [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [IAM Policy Reference](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html)
- [AWS Security Blog](https://aws.amazon.com/blogs/security/)
- [IAM Policy Simulator](https://policysim.aws.amazon.com/)

## 🎯 Key Takeaways

1. **IAM is Global**: Not region-specific
2. **Root Account**: Avoid using for daily tasks
3. **Policies**: JSON documents defining permissions
4. **Roles**: Preferred for applications and services
5. **Least Privilege**: Grant minimum required permissions
6. **MFA**: Essential for sensitive operations
7. **Monitoring**: Use CloudTrail and Access Analyzer

---

**Next Day Preview**: Day 10 will cover AWS S3 (Simple Storage Service) - Object storage, bucket policies, and lifecycle management.

**Instructor**: Neeraj Kumar  
**Date**: Day 9 - AWS DevOps Batch 4  
**Duration**: 2 hours (Theory: 1 hours, Practical: 1 hours)

## 🎉 Congratulations!

You've mastered AWS IAM fundamentals and are now prepared for IAM-related interview questions. Understanding IAM is crucial for AWS security and is frequently tested in interviews and certifications!