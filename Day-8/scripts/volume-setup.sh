#!/bin/bash

# EBS Volume Setup Script
# Day 8 - AWS DevOps Batch 4
# Author: Neeraj Kumar

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_error "Please run this script as root or with sudo"
        exit 1
    fi
}

# Detect new volumes
detect_volumes() {
    log_step "Detecting available volumes..."
    
    # List all block devices
    lsblk
    echo ""
    
    # Find unmounted volumes
    AVAILABLE_VOLUMES=$(lsblk -rno NAME,MOUNTPOINT | awk '$2=="" {print "/dev/"$1}' | grep -E 'xvd[f-z]|nvme[1-9]')
    
    if [ -z "$AVAILABLE_VOLUMES" ]; then
        log_warn "No unmounted volumes found"
        return 1
    fi
    
    log_info "Available unmounted volumes:"
    echo "$AVAILABLE_VOLUMES"
    echo ""
}

# Format volume
format_volume() {
    local device=$1
    local filesystem=${2:-ext4}
    
    log_step "Formatting $device with $filesystem filesystem..."
    
    # Check if device exists
    if [ ! -b "$device" ]; then
        log_error "Device $device does not exist"
        return 1
    fi
    
    # Check if device is already formatted
    if file -s "$device" | grep -q filesystem; then
        log_warn "Device $device appears to be already formatted"
        read -p "Do you want to reformat? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Skipping format of $device"
            return 0
        fi
    fi
    
    # Format the device
    case $filesystem in
        ext4)
            mkfs.ext4 -F "$device"
            ;;
        xfs)
            mkfs.xfs -f "$device"
            ;;
        *)
            log_error "Unsupported filesystem: $filesystem"
            return 1
            ;;
    esac
    
    log_info "Successfully formatted $device with $filesystem"
}

# Mount volume
mount_volume() {
    local device=$1
    local mount_point=$2
    local filesystem=${3:-ext4}
    
    log_step "Mounting $device to $mount_point..."
    
    # Create mount point if it doesn't exist
    if [ ! -d "$mount_point" ]; then
        mkdir -p "$mount_point"
        log_info "Created mount point: $mount_point"
    fi
    
    # Mount the device
    mount "$device" "$mount_point"
    
    # Verify mount
    if mountpoint -q "$mount_point"; then
        log_info "Successfully mounted $device to $mount_point"
        
        # Show disk usage
        df -h "$mount_point"
        
        # Set permissions
        chmod 755 "$mount_point"
        
        # Add to fstab for persistent mounting
        local uuid=$(blkid -s UUID -o value "$device")
        local fstab_entry="UUID=$uuid $mount_point $filesystem defaults,nofail 0 2"
        
        if ! grep -q "$uuid" /etc/fstab; then
            echo "$fstab_entry" >> /etc/fstab
            log_info "Added entry to /etc/fstab for persistent mounting"
        else
            log_warn "Entry already exists in /etc/fstab"
        fi
    else
        log_error "Failed to mount $device"
        return 1
    fi
}

# Create test data
create_test_data() {
    local mount_point=$1
    
    log_step "Creating test data in $mount_point..."
    
    # Create test directory
    mkdir -p "$mount_point/test-data"
    
    # Create test files
    echo "Day 8 EBS Volume Demo" > "$mount_point/test-data/demo.txt"
    echo "Created on: $(date)" > "$mount_point/test-data/timestamp.txt"
    
    # Create a larger test file
    dd if=/dev/zero of="$mount_point/test-data/large-file.dat" bs=1M count=10 2>/dev/null
    
    # Create directory structure
    mkdir -p "$mount_point/test-data/logs"
    mkdir -p "$mount_point/test-data/backups"
    mkdir -p "$mount_point/test-data/temp"
    
    # Set ownership
    chown -R ec2-user:ec2-user "$mount_point/test-data" 2>/dev/null || true
    
    log_info "Test data created successfully"
    ls -la "$mount_point/test-data/"
}

# Show volume information
show_volume_info() {
    log_step "Volume Information Summary"
    
    echo "=== Disk Usage ==="
    df -h
    echo ""
    
    echo "=== Block Devices ==="
    lsblk
    echo ""
    
    echo "=== Mount Points ==="
    mount | grep -E 'xvd|nvme'
    echo ""
    
    echo "=== /etc/fstab entries ==="
    grep -E 'xvd|nvme|UUID' /etc/fstab || echo "No EBS entries found"
}

# Interactive setup
interactive_setup() {
    log_info "Starting interactive EBS volume setup"
    
    # Detect volumes
    if ! detect_volumes; then
        log_error "No volumes available for setup"
        exit 1
    fi
    
    # Select volume
    echo "Available volumes:"
    select device in $AVAILABLE_VOLUMES "Exit"; do
        case $device in
            "Exit")
                log_info "Exiting..."
                exit 0
                ;;
            *)
                if [ -n "$device" ]; then
                    break
                else
                    log_error "Invalid selection"
                fi
                ;;
        esac
    done
    
    # Select filesystem
    echo "Select filesystem type:"
    select fs in "ext4" "xfs"; do
        case $fs in
            ext4|xfs)
                filesystem=$fs
                break
                ;;
            *)
                log_error "Invalid selection"
                ;;
        esac
    done
    
    # Get mount point
    read -p "Enter mount point (default: /data): " mount_point
    mount_point=${mount_point:-/data}
    
    # Confirm setup
    echo ""
    log_info "Setup Summary:"
    echo "  Device: $device"
    echo "  Filesystem: $filesystem"
    echo "  Mount Point: $mount_point"
    echo ""
    
    read -p "Proceed with setup? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Setup cancelled"
        exit 0
    fi
    
    # Perform setup
    format_volume "$device" "$filesystem"
    mount_volume "$device" "$mount_point" "$filesystem"
    create_test_data "$mount_point"
    show_volume_info
    
    log_info "EBS volume setup completed successfully!"
}

# Automated setup
automated_setup() {
    local device=$1
    local mount_point=${2:-/data}
    local filesystem=${3:-ext4}
    
    log_info "Starting automated EBS volume setup"
    log_info "Device: $device, Mount: $mount_point, FS: $filesystem"
    
    format_volume "$device" "$filesystem"
    mount_volume "$device" "$mount_point" "$filesystem"
    create_test_data "$mount_point"
    show_volume_info
    
    log_info "Automated EBS volume setup completed!"
}

# Usage function
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -d, --device DEVICE           Block device to setup (e.g., /dev/xvdf)"
    echo "  -m, --mount-point PATH        Mount point (default: /data)"
    echo "  -f, --filesystem TYPE         Filesystem type: ext4|xfs (default: ext4)"
    echo "  -i, --interactive             Interactive mode"
    echo "  -h, --help                    Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -i                         # Interactive mode"
    echo "  $0 -d /dev/xvdf               # Automated with defaults"
    echo "  $0 -d /dev/xvdf -m /app-data -f xfs"
}

# Main function
main() {
    local device=""
    local mount_point="/data"
    local filesystem="ext4"
    local interactive=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--device)
                device="$2"
                shift 2
                ;;
            -m|--mount-point)
                mount_point="$2"
                shift 2
                ;;
            -f|--filesystem)
                filesystem="$2"
                shift 2
                ;;
            -i|--interactive)
                interactive=true
                shift
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
    
    # Check root privileges
    check_root
    
    # Run appropriate mode
    if [ "$interactive" = true ]; then
        interactive_setup
    elif [ -n "$device" ]; then
        automated_setup "$device" "$mount_point" "$filesystem"
    else
        log_error "Either specify device or use interactive mode"
        usage
        exit 1
    fi
}

# Run main function with all arguments
main "$@"