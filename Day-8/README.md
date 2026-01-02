# Day 8: AWS EBS Volumes and Snapshots

## 📚 Learning Objectives
- Understand AWS EBS (Elastic Block Store) volumes
- Learn different EBS volume types and their use cases
- Master EBS snapshot creation and management
- Implement practical volume attachment and snapshot operations
- Understand backup and disaster recovery strategies

## 🎯 Topics Covered

### 1. AWS EBS (Elastic Block Store) Overview
- What is EBS?
- EBS vs Instance Store
- EBS volume lifecycle
- Availability and durability

### 2. EBS Volume Types
- **gp3** (General Purpose SSD) - Latest generation
- **gp2** (General Purpose SSD) - Previous generation
- **io2/io1** (Provisioned IOPS SSD) - High performance
- **st1** (Throughput Optimized HDD) - Big data workloads
- **sc1** (Cold HDD) - Infrequent access

### 3. EBS Snapshots
- What are snapshots?
- Incremental backup mechanism
- Cross-region snapshot copying
- Snapshot lifecycle management
- Cost optimization strategies

## 🛠️ Practical Lab: EBS Volume and Snapshot Management

### Prerequisites
- AWS Free Tier account
- Basic understanding of EC2 instances
- AWS CLI configured (optional)

### Lab Architecture
```
EC2 Instance (t2.micro)
    ↓
EBS Volume (8GB gp3)
    ↓
Snapshot Creation
    ↓
Volume from Snapshot
    ↓
Attach to New Instance
```

## 🚀 Hands-on Exercise

### Step 1: Launch EC2 Instance with Additional EBS Volume

1. **Navigate to EC2 Dashboard**
   - Go to AWS Console → EC2
   - Click "Launch Instance"

2. **Configure Instance**
   ```
   Name: day8-ebs-demo
   AMI: Amazon Linux 2023
   Instance Type: t2.micro
   Key Pair: Create new or use existing
   ```

3. **Configure Storage**
   - Root volume: 8 GB gp3
   - Add additional volume: 10 GB gp3
   - Tag: Name = "day8-data-volume"

### Step 2: Connect and Prepare the Volume

1. **SSH into Instance**
   ```bash
   ssh -i your-key.pem ec2-user@your-instance-ip
   ```

2. **List Available Disks**
   ```bash
   lsblk
   sudo fdisk -l
   ```

3. **Format and Mount the Volume**
   ```bash
   # Format the volume (assuming /dev/xvdf)
   sudo mkfs -t ext4 /dev/xvdf
   
   # Create mount point
   sudo mkdir /data
   
   # Mount the volume
   sudo mount /dev/xvdf /data
   
   # Verify mount
   df -h
   ```

4. **Create Test Data**
   ```bash
   # Create some test files
   sudo touch /data/test-file-1.txt
   sudo touch /data/test-file-2.txt
   echo "Day 8 EBS Demo Data" | sudo tee /data/demo-data.txt
   
   # List files
   ls -la /data/
   ```

### Step 3: Create EBS Snapshot

1. **Via AWS Console**
   - Go to EC2 → Volumes
   - Select your data volume
   - Actions → Create Snapshot
   - Description: "Day8-EBS-Demo-Snapshot"
   - Tags: Name = "day8-snapshot"

2. **Via AWS CLI** (Optional)
   ```bash
   # Get volume ID
   aws ec2 describe-volumes --filters "Name=tag:Name,Values=day8-data-volume"
   
   # Create snapshot
   aws ec2 create-snapshot \
     --volume-id vol-xxxxxxxxx \
     --description "Day8-EBS-Demo-Snapshot" \
     --tag-specifications 'ResourceType=snapshot,Tags=[{Key=Name,Value=day8-snapshot}]'
   ```

### Step 4: Monitor Snapshot Progress

1. **Check Snapshot Status**
   - EC2 → Snapshots
   - Monitor progress (pending → completed)

2. **Via CLI**
   ```bash
   aws ec2 describe-snapshots --snapshot-ids snap-xxxxxxxxx
   ```

### Step 5: Create Volume from Snapshot

1. **Create New Volume**
   - EC2 → Snapshots
   - Select your snapshot
   - Actions → Create Volume from Snapshot
   - Size: 10 GB (or larger)
   - Volume Type: gp3
   - Availability Zone: Same as your instance

### Step 6: Attach New Volume to Instance

1. **Attach Volume**
   - EC2 → Volumes
   - Select new volume
   - Actions → Attach Volume
   - Instance: Select your instance
   - Device: /dev/sdg

2. **Mount the Restored Volume**
   ```bash
   # Check new disk
   lsblk
   
   # Create mount point
   sudo mkdir /restored-data
   
   # Mount (no formatting needed - data preserved)
   sudo mount /dev/xvdg /restored-data
   
   # Verify data restoration
   ls -la /restored-data/
   cat /restored-data/demo-data.txt
   ```

## 📊 Monitoring and Management

### Volume Performance Monitoring
```bash
# Check disk usage
df -h

# Monitor I/O statistics
iostat -x 1

# Check volume performance metrics in CloudWatch
```

### Snapshot Management Best Practices
- **Automated Snapshots**: Use AWS Backup or Lambda
- **Retention Policy**: Delete old snapshots
- **Cross-Region Backup**: Copy critical snapshots
- **Tagging Strategy**: Consistent naming and tagging

## 🔧 Advanced Operations

### Resize EBS Volume
```bash
# Modify volume size (AWS Console or CLI)
aws ec2 modify-volume --volume-id vol-xxxxxxxxx --size 20

# Extend filesystem
sudo resize2fs /dev/xvdf
```

### Snapshot Automation Script
```bash
#!/bin/bash
# snapshot-automation.sh

VOLUME_ID="vol-xxxxxxxxx"
DESCRIPTION="Automated snapshot $(date +%Y-%m-%d_%H-%M-%S)"

# Create snapshot
SNAPSHOT_ID=$(aws ec2 create-snapshot \
  --volume-id $VOLUME_ID \
  --description "$DESCRIPTION" \
  --query 'SnapshotId' \
  --output text)

echo "Created snapshot: $SNAPSHOT_ID"

# Tag snapshot
aws ec2 create-tags \
  --resources $SNAPSHOT_ID \
  --tags Key=Name,Value="auto-snapshot-$(date +%Y%m%d)"
```

## 🎯 Key Takeaways

1. **EBS Volumes** provide persistent, high-performance block storage
2. **Snapshots** enable point-in-time backups and disaster recovery
3. **Volume Types** should be chosen based on performance requirements
4. **Automation** is crucial for consistent backup strategies
5. **Cost Optimization** through proper snapshot lifecycle management

## 🧪 Practice Exercises

### Exercise 1: Multi-Volume Setup
- Create EC2 instance with 3 EBS volumes
- Configure RAID 0 for performance
- Create snapshots of all volumes

### Exercise 2: Cross-Region Backup
- Create snapshot in us-east-1
- Copy snapshot to us-west-2
- Restore volume in different region

### Exercise 3: Automated Backup
- Create Lambda function for automated snapshots
- Schedule using CloudWatch Events
- Implement retention policy

## 🔍 Troubleshooting

### Common Issues
1. **Volume not visible**: Check attachment and device mapping
2. **Mount fails**: Verify filesystem and permissions
3. **Snapshot slow**: Large volumes take time for first snapshot
4. **Cross-AZ attachment**: Volumes must be in same AZ as instance

### Useful Commands
```bash
# Check volume attachment
lsblk
sudo fdisk -l

# Check filesystem
sudo file -s /dev/xvdf

# Force filesystem check
sudo fsck /dev/xvdf

# Check mount points
mount | grep /dev/xvdf
```

## 📚 Additional Resources

- [AWS EBS Documentation](https://docs.aws.amazon.com/ebs/)
- [EBS Volume Types Comparison](https://aws.amazon.com/ebs/volume-types/)
- [Snapshot Best Practices](https://docs.aws.amazon.com/ebs/latest/userguide/ebs-snapshots.html)
- [AWS Backup Service](https://aws.amazon.com/backup/)

## 🏆 Lab Completion Checklist

- [ ] EC2 instance launched with additional EBS volume
- [ ] Volume formatted and mounted successfully
- [ ] Test data created on volume
- [ ] EBS snapshot created and completed
- [ ] New volume created from snapshot
- [ ] Volume attached to instance and data verified
- [ ] Performance monitoring configured
- [ ] Cleanup completed (terminate instances, delete volumes/snapshots)

---

**Next Day Preview**: Day 9 will cover AWS S3 (Simple Storage Service) - Object storage, buckets, and lifecycle policies.

**Instructor**: Neeraj Kumar  
**Date**: Day 8 - AWS DevOps Batch 4  
**Duration**: 2 hours (Theory: 0.3 hour, Practical: 1.3 hours)