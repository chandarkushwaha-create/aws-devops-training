#!/bin/bash

# AWS EBS Snapshot Automation Script
# Day 8 - AWS DevOps Batch 4
# Author: Neeraj Kumar

set -e

# Configuration
VOLUME_ID=""
INSTANCE_ID=""
RETENTION_DAYS=7
AWS_REGION="us-east-1"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if AWS CLI is installed
check_aws_cli() {
    if ! command -v aws &> /dev/null; then
        log_error "AWS CLI is not installed. Please install it first."
        exit 1
    fi
    log_info "AWS CLI found"
}

# Get volume ID from instance
get_volume_id() {
    if [ -z "$VOLUME_ID" ] && [ -n "$INSTANCE_ID" ]; then
        log_info "Getting volume ID from instance: $INSTANCE_ID"
        VOLUME_ID=$(aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[0].Instances[0].BlockDeviceMappings[1].Ebs.VolumeId' \
            --output text \
            --region $AWS_REGION)
        
        if [ "$VOLUME_ID" = "None" ] || [ -z "$VOLUME_ID" ]; then
            log_error "Could not find additional volume for instance $INSTANCE_ID"
            exit 1
        fi
        log_info "Found volume: $VOLUME_ID"
    fi
}

# Create snapshot
create_snapshot() {
    local description="Automated snapshot - $(date +%Y-%m-%d_%H-%M-%S)"
    
    log_info "Creating snapshot for volume: $VOLUME_ID"
    
    SNAPSHOT_ID=$(aws ec2 create-snapshot \
        --volume-id $VOLUME_ID \
        --description "$description" \
        --query 'SnapshotId' \
        --output text \
        --region $AWS_REGION)
    
    if [ $? -eq 0 ]; then
        log_info "Snapshot created successfully: $SNAPSHOT_ID"
        
        # Tag the snapshot
        aws ec2 create-tags \
            --resources $SNAPSHOT_ID \
            --tags Key=Name,Value="auto-snapshot-$(date +%Y%m%d)" \
                   Key=CreatedBy,Value="automation-script" \
                   Key=VolumeId,Value="$VOLUME_ID" \
            --region $AWS_REGION
        
        log_info "Snapshot tagged successfully"
    else
        log_error "Failed to create snapshot"
        exit 1
    fi
}

# Monitor snapshot progress
monitor_snapshot() {
    log_info "Monitoring snapshot progress..."
    
    while true; do
        STATUS=$(aws ec2 describe-snapshots \
            --snapshot-ids $SNAPSHOT_ID \
            --query 'Snapshots[0].State' \
            --output text \
            --region $AWS_REGION)
        
        PROGRESS=$(aws ec2 describe-snapshots \
            --snapshot-ids $SNAPSHOT_ID \
            --query 'Snapshots[0].Progress' \
            --output text \
            --region $AWS_REGION)
        
        if [ "$STATUS" = "completed" ]; then
            log_info "Snapshot completed successfully (100%)"
            break
        elif [ "$STATUS" = "error" ]; then
            log_error "Snapshot failed"
            exit 1
        else
            log_info "Snapshot in progress: $PROGRESS"
            sleep 30
        fi
    done
}

# Cleanup old snapshots
cleanup_old_snapshots() {
    log_info "Cleaning up snapshots older than $RETENTION_DAYS days"
    
    # Calculate date threshold
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        THRESHOLD_DATE=$(date -v-${RETENTION_DAYS}d +%Y-%m-%d)
    else
        # Linux
        THRESHOLD_DATE=$(date -d "$RETENTION_DAYS days ago" +%Y-%m-%d)
    fi
    
    # Find old snapshots
    OLD_SNAPSHOTS=$(aws ec2 describe-snapshots \
        --owner-ids self \
        --filters "Name=tag:CreatedBy,Values=automation-script" \
                  "Name=tag:VolumeId,Values=$VOLUME_ID" \
        --query "Snapshots[?StartTime<='$THRESHOLD_DATE'].SnapshotId" \
        --output text \
        --region $AWS_REGION)
    
    if [ -n "$OLD_SNAPSHOTS" ] && [ "$OLD_SNAPSHOTS" != "None" ]; then
        for snapshot in $OLD_SNAPSHOTS; do
            log_warn "Deleting old snapshot: $snapshot"
            aws ec2 delete-snapshot \
                --snapshot-id $snapshot \
                --region $AWS_REGION
        done
    else
        log_info "No old snapshots found for cleanup"
    fi
}

# Main function
main() {
    log_info "Starting EBS Snapshot Automation"
    log_info "Region: $AWS_REGION"
    log_info "Retention: $RETENTION_DAYS days"
    
    check_aws_cli
    get_volume_id
    create_snapshot
    monitor_snapshot
    cleanup_old_snapshots
    
    log_info "Snapshot automation completed successfully"
    log_info "Snapshot ID: $SNAPSHOT_ID"
}

# Usage function
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -v, --volume-id VOLUME_ID     EBS Volume ID to snapshot"
    echo "  -i, --instance-id INSTANCE_ID EC2 Instance ID (to get volume)"
    echo "  -r, --region REGION           AWS Region (default: us-east-1)"
    echo "  -d, --retention-days DAYS     Retention period (default: 7)"
    echo "  -h, --help                    Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -v vol-1234567890abcdef0"
    echo "  $0 -i i-1234567890abcdef0 -r us-west-2 -d 14"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--volume-id)
            VOLUME_ID="$2"
            shift 2
            ;;
        -i|--instance-id)
            INSTANCE_ID="$2"
            shift 2
            ;;
        -r|--region)
            AWS_REGION="$2"
            shift 2
            ;;
        -d|--retention-days)
            RETENTION_DAYS="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Validate inputs
if [ -z "$VOLUME_ID" ] && [ -z "$INSTANCE_ID" ]; then
    log_error "Either volume ID or instance ID must be provided"
    usage
    exit 1
fi

# Run main function
main