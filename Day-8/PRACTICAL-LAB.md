# Day 8: EBS Volumes and Snapshots - Practical Lab Guide

## 🎯 Lab Objectives
- Create and attach EBS volumes to EC2 instances
- Format, mount, and use EBS volumes
- Create and manage EBS snapshots
- Restore data from snapshots
- Implement automation scripts

## ⏱️ Estimated Time: 2 hours

## 🛠️ Lab Setup

### Prerequisites Checklist
- [ ] AWS Free Tier account with valid payment method
- [ ] AWS CLI installed and configured
- [ ] SSH client (PuTTY for Windows, Terminal for Mac/Linux)
- [ ] Basic Linux command knowledge

### Lab Environment
```
Region: us-east-1 (N. Virginia)
Instance Type: t2.micro (Free Tier eligible)
AMI: Amazon Linux 2023
Storage: Root (8GB) + Additional EBS (10GB)
```

## 📋 Lab Steps

### Phase 1: EC2 Instance with EBS Volume

#### Step 1.1: Launch EC2 Instance
```bash
# Using AWS CLI (Optional - can use Console)
aws ec2 run-instances \
    --image-id ami-0abcdef1234567890 \
    --count 1 \
    --instance-type t2.micro \
    --key-name your-key-pair \
    --security-group-ids sg-xxxxxxxxx \
    --subnet-id subnet-xxxxxxxxx \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=day8-ebs-lab}]'
```

#### Step 1.2: Create Additional EBS Volume
```bash
# Create 10GB gp3 volume
aws ec2 create-volume \
    --size 10 \
    --volume-type gp3 \
    --availability-zone us-east-1a \
    --tag-specifications 'ResourceType=volume,Tags=[{Key=Name,Value=day8-data-volume}]'

# Note the VolumeId from output
```

#### Step 1.3: Attach Volume to Instance
```bash
# Attach volume to instance
aws ec2 attach-volume \
    --volume-id vol-xxxxxxxxx \
    --instance-id i-xxxxxxxxx \
    --device /dev/sdf
```

### Phase 2: Volume Configuration

#### Step 2.1: Connect to Instance
```bash
# SSH connection
ssh -i your-key.pem ec2-user@your-instance-public-ip

# Verify connection
whoami
pwd
```

#### Step 2.2: Identify and Prepare Volume
```bash
# List all block devices
lsblk

# Check disk information
sudo fdisk -l

# Expected output should show /dev/xvdf (10GB)
```

#### Step 2.3: Format and Mount Volume
```bash
# Check if volume has filesystem
sudo file -s /dev/xvdf

# Format with ext4 filesystem
sudo mkfs -t ext4 /dev/xvdf

# Create mount point
sudo mkdir /data

# Mount the volume
sudo mount /dev/xvdf /data

# Verify mount
df -h
mount | grep xvdf
```

#### Step 2.4: Configure Persistent Mounting
```bash
# Get UUID of the volume
sudo blkid /dev/xvdf

# Add to fstab for persistent mounting
echo "UUID=your-uuid-here /data ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab

# Test fstab entry
sudo umount /data
sudo mount -a
df -h
```

### Phase 3: Create Test Data

#### Step 3.1: Create Directory Structure
```bash
# Create test directories
sudo mkdir -p /data/{logs,backups,temp,app-data}

# Set permissions
sudo chown -R ec2-user:ec2-user /data
chmod 755 /data
```

#### Step 3.2: Generate Test Files
```bash
# Create various test files
echo "Day 8 EBS Lab - $(date)" > /data/lab-info.txt
echo "Student: Your Name" >> /data/lab-info.txt
echo "Batch: AWS DevOps Batch 4" >> /data/lab-info.txt

# Create log files
for i in {1..5}; do
    echo "Log entry $i - $(date)" >> /data/logs/app-$i.log
done

# Create a larger file for testing
dd if=/dev/zero of=/data/test-large-file.dat bs=1M count=50

# Create application data
mkdir -p /data/app-data/config
echo "database_host=localhost" > /data/app-data/config/app.conf
echo "database_port=3306" >> /data/app-data/config/app.conf
echo "debug=true" >> /data/app-data/config/app.conf

# List created files
find /data -type f -exec ls -lh {} \;
```

### Phase 4: Create EBS Snapshot

#### Step 4.1: Create Snapshot via Console
1. Go to AWS Console → EC2 → Volumes
2. Select your data volume (day8-data-volume)
3. Actions → Create Snapshot
4. Description: "Day8-Lab-Snapshot-$(date +%Y%m%d)"
5. Add tags: Name = "day8-lab-snapshot"

#### Step 4.2: Create Snapshot via CLI
```bash
# Get volume ID
VOLUME_ID=$(aws ec2 describe-volumes \
    --filters "Name=tag:Name,Values=day8-data-volume" \
    --query 'Volumes[0].VolumeId' \
    --output text)

echo "Volume ID: $VOLUME_ID"

# Create snapshot
SNAPSHOT_ID=$(aws ec2 create-snapshot \
    --volume-id $VOLUME_ID \
    --description "Day8-Lab-Snapshot-$(date +%Y%m%d-%H%M)" \
    --tag-specifications 'ResourceType=snapshot,Tags=[{Key=Name,Value=day8-lab-snapshot}]' \
    --query 'SnapshotId' \
    --output text)

echo "Snapshot ID: $SNAPSHOT_ID"
```

#### Step 4.3: Monitor Snapshot Progress
```bash
# Check snapshot status
aws ec2 describe-snapshots \
    --snapshot-ids $SNAPSHOT_ID \
    --query 'Snapshots[0].[State,Progress]' \
    --output table

# Monitor until completed (script)
while true; do
    STATUS=$(aws ec2 describe-snapshots \
        --snapshot-ids $SNAPSHOT_ID \
        --query 'Snapshots[0].State' \
        --output text)
    
    PROGRESS=$(aws ec2 describe-snapshots \
        --snapshot-ids $SNAPSHOT_ID \
        --query 'Snapshots[0].Progress' \
        --output text)
    
    echo "Status: $STATUS, Progress: $PROGRESS"
    
    if [ "$STATUS" = "completed" ]; then
        echo "Snapshot completed!"
        break
    fi
    
    sleep 30
done
```

### Phase 5: Test Data Recovery

#### Step 5.1: Simulate Data Loss
```bash
# Create backup of current data list
ls -la /data > /tmp/original-data-list.txt

# Simulate accidental deletion
sudo rm -rf /data/logs/*
sudo rm /data/test-large-file.dat

# Verify data loss
ls -la /data
echo "Data lost! Need to restore from snapshot."
```

#### Step 5.2: Create Volume from Snapshot
```bash
# Create new volume from snapshot
NEW_VOLUME_ID=$(aws ec2 create-volume \
    --snapshot-id $SNAPSHOT_ID \
    --availability-zone us-east-1a \
    --volume-type gp3 \
    --tag-specifications 'ResourceType=volume,Tags=[{Key=Name,Value=day8-restored-volume}]' \
    --query 'VolumeId' \
    --output text)

echo "New Volume ID: $NEW_VOLUME_ID"

# Wait for volume to be available
aws ec2 wait volume-available --volume-ids $NEW_VOLUME_ID
echo "Volume is ready!"
```

#### Step 5.3: Attach and Mount Restored Volume
```bash
# Attach new volume
aws ec2 attach-volume \
    --volume-id $NEW_VOLUME_ID \
    --instance-id $(curl -s http://169.254.169.254/latest/meta-data/instance-id) \
    --device /dev/sdg

# Wait for attachment
sleep 10

# Create mount point for restored data
sudo mkdir /restored-data

# Mount restored volume (no formatting needed)
sudo mount /dev/xvdg /restored-data

# Verify data restoration
ls -la /restored-data
diff /tmp/original-data-list.txt <(ls -la /restored-data)
```

#### Step 5.4: Restore Lost Data
```bash
# Copy restored data back to original location
sudo cp -r /restored-data/logs/* /data/logs/
sudo cp /restored-data/test-large-file.dat /data/

# Verify restoration
ls -la /data/logs/
ls -lh /data/test-large-file.dat

echo "Data successfully restored from snapshot!"
```

### Phase 6: Automation and Best Practices

#### Step 6.1: Use Automation Scripts
```bash
# Download and use the automation scripts
cd /home/ec2-user

# Make scripts executable
chmod +x /path/to/scripts/snapshot-automation.sh
chmod +x /path/to/scripts/volume-setup.sh

# Test snapshot automation
sudo ./snapshot-automation.sh -v $VOLUME_ID -r us-east-1
```

#### Step 6.2: Performance Testing
```bash
# Test write performance
sudo dd if=/dev/zero of=/data/performance-test.dat bs=1M count=100 oflag=direct

# Test read performance
sudo dd if=/data/performance-test.dat of=/dev/null bs=1M iflag=direct

# Monitor I/O statistics
iostat -x 1 5
```

### Phase 7: Cleanup and Cost Management

#### Step 7.1: Document Resources
```bash
# List all resources created
echo "=== EC2 Instances ==="
aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=day8-ebs-lab" \
    --query 'Reservations[].Instances[].[InstanceId,State.Name]' \
    --output table

echo "=== EBS Volumes ==="
aws ec2 describe-volumes \
    --filters "Name=tag:Name,Values=day8-*" \
    --query 'Volumes[].[VolumeId,State,Size,VolumeType]' \
    --output table

echo "=== Snapshots ==="
aws ec2 describe-snapshots \
    --owner-ids self \
    --filters "Name=tag:Name,Values=day8-*" \
    --query 'Snapshots[].[SnapshotId,State,Progress,StartTime]' \
    --output table
```

#### Step 7.2: Cleanup Resources (Important!)
```bash
# Unmount volumes
sudo umount /data
sudo umount /restored-data

# Detach volumes
aws ec2 detach-volume --volume-id $VOLUME_ID
aws ec2 detach-volume --volume-id $NEW_VOLUME_ID

# Wait for detachment
aws ec2 wait volume-available --volume-ids $VOLUME_ID $NEW_VOLUME_ID

# Delete volumes
aws ec2 delete-volume --volume-id $VOLUME_ID
aws ec2 delete-volume --volume-id $NEW_VOLUME_ID

# Delete snapshots
aws ec2 delete-snapshot --snapshot-id $SNAPSHOT_ID

# Terminate instance
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
aws ec2 terminate-instances --instance-ids $INSTANCE_ID
```

## 🧪 Advanced Exercises

### Exercise 1: Multi-Volume RAID Setup
```bash
# Create two 5GB volumes
# Configure RAID 0 for performance
sudo mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/xvdf /dev/xvdg
sudo mkfs.ext4 /dev/md0
sudo mount /dev/md0 /raid-data
```

### Exercise 2: Cross-Region Snapshot Copy
```bash
# Copy snapshot to different region
aws ec2 copy-snapshot \
    --source-region us-east-1 \
    --source-snapshot-id $SNAPSHOT_ID \
    --destination-region us-west-2 \
    --description "Cross-region backup"
```

### Exercise 3: Automated Backup with Retention
```bash
# Create Lambda function for automated snapshots
# Set up CloudWatch Events for scheduling
# Implement retention policy
```

## ✅ Lab Validation Checklist

- [ ] EC2 instance launched successfully
- [ ] EBS volume created and attached
- [ ] Volume formatted and mounted with persistent configuration
- [ ] Test data created and verified
- [ ] Snapshot created and completed
- [ ] Data recovery tested successfully
- [ ] Performance testing completed
- [ ] Automation scripts tested
- [ ] All resources documented
- [ ] Cleanup completed to avoid charges

## 🎓 Key Learning Outcomes

1. **EBS Volume Management**: Created, attached, and configured EBS volumes
2. **Filesystem Operations**: Formatted, mounted, and configured persistent mounting
3. **Snapshot Operations**: Created snapshots and restored data
4. **Data Recovery**: Successfully recovered from simulated data loss
5. **Automation**: Implemented scripts for routine operations
6. **Cost Management**: Properly cleaned up resources

## 📊 Lab Report Template

```
Student Name: _______________
Date: _______________
Lab Duration: _______________

Resources Created:
- Instance ID: _______________
- Volume IDs: _______________
- Snapshot IDs: _______________

Key Commands Used:
1. Volume Creation: _______________
2. Snapshot Creation: _______________
3. Data Recovery: _______________

Challenges Faced:
_______________

Solutions Applied:
_______________

Cost Incurred: $_______________
```

## 🔗 Additional Resources

- [AWS EBS User Guide](https://docs.aws.amazon.com/ebs/latest/userguide/)
- [EBS Performance Documentation](https://docs.aws.amazon.com/ebs/latest/userguide/ebs-performance.html)
- [AWS CLI EBS Commands](https://docs.aws.amazon.com/cli/latest/reference/ec2/)

---

**Lab Instructor**: Neeraj Kumar  
**Contact**: For questions, create an issue in the repository  
**Next Lab**: Day 9 - AWS S3 Object Storage