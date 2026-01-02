# Day 2: AWS Account Security and Core Compute (EC2)

Today, we will focus on two critical areas: securing your AWS environment using best practices and diving deep into the foundational AWS compute service, Amazon EC2.

---

## Part 1: AWS Account Setup & Best Practices

Properly securing your AWS account is the first and most important step in your cloud journey. We will cover the essential practices to protect your resources and manage costs effectively.

### Creating a Secure AWS Account
When you first create an AWS account, you begin with a single sign-in identity that has complete access to all AWS services and resources in the account. This identity is called the AWS account **root user**. It is a best practice to secure the root user and use it only for tasks that require root access.

#### Steps to Create an AWS Free Tier Account
The AWS Free Tier enables you to gain free, hands-on experience with the AWS platform, products, and services.

1.  **Visit the AWS Free Tier Page:** Open your web browser and navigate to the [AWS Free Tier page](https://aws.amazon.com/free/).
2.  **Create an Account:** Click on the "Create a Free Account" button.
3.  **Root User Information:** Enter your email address and choose an AWS account name. Click "Verify email address". You will receive a verification code in your email.
4.  **Verify Email:** Enter the verification code you received to proceed.
5.  **Create Password:** Create a strong password for your root user.
6.  **Contact Information:** Fill in your contact information. Choose whether this is for business or personal use.
7.  **Billing Information:** Provide valid credit/debit card information. This is for identity verification and for charges that exceed the Free Tier limits. You won't be charged unless your usage exceeds the free tier.
8.  **Identity Verification:** Confirm your identity via a code sent to your phone number (either text message or voice call).
9.  **Choose a Support Plan:** Select a support plan. The "Basic support - Free" plan is recommended to start.
10. **Complete Sign-up:** Finalize the creation process. It may take a few minutes for your account to be fully activated.

### Multi-Factor Authentication (MFA)
MFA is a simple best practice that adds an extra layer of protection on top of your user name and password. With MFA enabled, when a user signs in to the AWS Console, they will be prompted for their user name and password (the first factor—what they know), as well as for an authentication code from their AWS MFA device (the second factor—what they have). **It is critical to enable MFA on your root user immediately after creating your account.**

### Billing Alerts and Cost Management
To avoid unexpected charges, it's crucial to monitor your estimated AWS charges and create billing alerts. You can use **Amazon CloudWatch** to create alarms that notify you when your account billing exceeds a threshold you define. **AWS Budgets** allows you to set custom budgets to track your cost and usage.

### AWS Organizations and Account Structure
AWS Organizations helps you centrally govern your environment as you grow and scale your workloads on AWS. You can create a multi-account structure, group accounts into Organizational Units (OUs), and apply policies for governance. This is essential for separating development, testing, and production environments.

### AWS Well-Architected Framework
The Well-Architected Framework helps you understand the pros and cons of decisions you make while building systems on AWS. By using the Framework, you will learn architectural best practices for designing and operating reliable, secure, efficient, and cost-effective systems in the cloud. It is based on five pillars:
- **Operational Excellence**: Running and monitoring systems
- **Security**: Protecting information and systems  
- **Reliability**: Ensuring system recovery and availability
- **Performance Efficiency**: Using resources efficiently
- **Cost Optimization**: Avoiding unnecessary costs

## 🎯 Key Takeaways

1. **Root Account Security** is critical - enable MFA immediately
2. **EC2 Instance Types** should match workload requirements
3. **Security Groups** provide instance-level firewall protection
4. **AMIs** enable consistent instance deployments
5. **Billing Alerts** prevent unexpected charges

---

## Part 2: AWS EC2 & Compute Services

Amazon Elastic Compute Cloud (EC2) is a web service that provides secure, resizable compute capacity in the cloud. It is designed to make web-scale cloud computing easier for developers.

### EC2 Fundamentals
EC2 provides virtual computing environments, known as **instances**. You can choose from various instance types with different CPU, memory, storage, and networking capacities.

### EC2 Instance Types and Families
AWS provides a wide variety of instance types optimized to fit different use cases.
- **General Purpose (e.g., T-family, M-family):** A balance of compute, memory, and networking. Good for web servers and development environments.
- **Compute Optimized (e.g., C-family):** Ideal for compute-intensive applications like high-performance web servers, scientific modeling, and batch processing.
- **Memory Optimized (e.g., R-family, X-family):** Designed for memory-intensive workloads, such as high-performance databases and real-time big data analytics.

### AMIs and Instance Lifecycle
An **Amazon Machine Image (AMI)** is a pre-configured template for your instances, which includes the operating system and other software. An EC2 instance transitions through different states from the moment you launch it until its termination (e.g., `pending`, `running`, `stopping`, `terminated`).

### Security Groups and Key Pairs
- **Security Groups:** Act as a virtual firewall for your instance to control inbound and outbound traffic. They are **stateful**, meaning if you allow inbound traffic, the outbound return traffic is automatically allowed.
- **Key Pairs:** Used to prove your identity when connecting to an EC2 instance. For Linux AMIs, the private key allows you to securely SSH into your instance.

### Instance Metadata Service (IMDSv2)
This service provides data about your instance that you can use to configure or manage the running instance. IMDSv2 is a more secure, session-oriented method that adds defense in depth against unauthorized metadata access.

### EC2 Placement Groups
A placement group is a logical grouping of instances within a single Availability Zone.
- **Cluster:** Packs instances close together for low-latency networking.
- **Spread:** Spreads instances across distinct underlying hardware to reduce correlated failures.
- **Partition:** Spreads instances across logical partitions, ensuring that instances in one partition do not share hardware with instances in other partitions.

---

## Useful Resources

### AWS Documentation
- [Securing your AWS account root user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user.html)
- [Enabling a virtual MFA device](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html)
- [Creating a billing alarm to monitor your estimated AWS charges](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/monitor_estimated_charges_with_cloudwatch.html)
- [What is AWS Organizations?](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [What is Amazon EC2?](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html)
- [Amazon EC2 Instance Types](https://aws.amazon.com/ec2/instance-types/)
- [Amazon EC2 Security Groups for Linux Instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security-groups.html)

## 🎤 Interview Questions & Answers

### Fresher Level Questions

**Q1: What is AWS EC2?**
**A:** Amazon Elastic Compute Cloud (EC2) is a web service that provides secure, resizable compute capacity in the cloud. It allows you to launch virtual servers (instances) with different configurations.

**Q2: What is the difference between stopping and terminating an EC2 instance?**
**A:** 
- **Stop**: Instance is shut down but EBS volumes remain, can be restarted
- **Terminate**: Instance is permanently deleted along with instance store volumes

**Q3: What is an AMI?**
**A:** Amazon Machine Image (AMI) is a pre-configured template containing the OS, application server, and applications needed to launch an EC2 instance.

**Q4: What are Security Groups?**
**A:** Security Groups act as virtual firewalls for EC2 instances, controlling inbound and outbound traffic. They are stateful - if you allow inbound traffic, outbound response is automatically allowed.

**Q5: Why is MFA important for AWS accounts?**
**A:** Multi-Factor Authentication adds an extra security layer requiring both password and authentication code from a device, significantly reducing the risk of unauthorized access.

### Intermediate Level Questions

**Q6: Explain different EC2 instance families and their use cases.**
**A:** 
- **General Purpose (T, M)**: Balanced compute, memory, networking - web servers, development
- **Compute Optimized (C)**: High-performance processors - scientific computing, gaming
- **Memory Optimized (R, X)**: Fast performance for memory-intensive workloads - databases, analytics
- **Storage Optimized (I, D)**: High sequential read/write - distributed file systems
- **Accelerated Computing (P, G)**: Hardware accelerators - machine learning, HPC

**Q7: What is the difference between Security Groups and NACLs?**
**A:** 
- **Security Groups**: Instance-level, stateful, allow rules only, evaluate all rules
- **NACLs**: Subnet-level, stateless, allow and deny rules, process rules in order

**Q8: What are EC2 Placement Groups?**
**A:** 
- **Cluster**: Low-latency networking in single AZ
- **Spread**: Instances on distinct hardware, max 7 per AZ
- **Partition**: Instances in logical partitions, isolated from other partitions

**Q9: What is Instance Metadata Service (IMDS)?**
**A:** Service providing data about running instances accessible from within the instance. IMDSv2 is more secure, requiring session tokens for access.

**Q10: How do you secure an AWS root account?**
**A:** 
- Enable MFA on root account
- Create strong password
- Don't use root for daily tasks
- Create IAM users for regular operations
- Enable CloudTrail for audit logging
- Set up billing alerts

### Other Useful Sites
- [AWS Ramp-Up Guide: Core Services](https://aws.amazon.com/training/ramp-up-guides/core-services/)
- [EC2 Instance Comparison by Vantage](https://instances.vantage.sh/) (A helpful tool for comparing instance types and pricing)

