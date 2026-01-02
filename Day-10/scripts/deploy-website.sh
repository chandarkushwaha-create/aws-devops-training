#!/bin/bash

# AWS S3 Website Deployment Script
# Day 10 - AWS DevOps Batch 4
# Author: Neeraj Kumar

set -e

# Configuration
BUCKET_NAME=""
WEBSITE_DIR="./website-files"
AWS_REGION="us-east-1"
CLOUDFRONT_DISTRIBUTION_ID=""

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

# Check if AWS CLI is installed
check_aws_cli() {
    if ! command -v aws &> /dev/null; then
        log_error "AWS CLI is not installed. Please install it first."
        exit 1
    fi
    log_info "AWS CLI found"
}

# Check if bucket exists
check_bucket_exists() {
    if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
        log_info "Bucket $BUCKET_NAME exists"
        return 0
    else
        log_warn "Bucket $BUCKET_NAME does not exist"
        return 1
    fi
}

# Create S3 bucket
create_bucket() {
    log_step "Creating S3 bucket: $BUCKET_NAME"
    
    if [ "$AWS_REGION" = "us-east-1" ]; then
        aws s3 mb "s3://$BUCKET_NAME"
    else
        aws s3 mb "s3://$BUCKET_NAME" --region "$AWS_REGION"
    fi
    
    log_info "Bucket created successfully"
}

# Configure bucket for static website hosting
configure_website_hosting() {
    log_step "Configuring static website hosting"
    
    aws s3 website "s3://$BUCKET_NAME" \
        --index-document index.html \
        --error-document error.html
    
    log_info "Website hosting configured"
}

# Set bucket policy for public access
set_bucket_policy() {
    log_step "Setting bucket policy for public access"
    
    # Create temporary policy file
    cat > /tmp/bucket-policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::$BUCKET_NAME/*"
        }
    ]
}
EOF

    # Apply bucket policy
    aws s3api put-bucket-policy \
        --bucket "$BUCKET_NAME" \
        --policy file:///tmp/bucket-policy.json
    
    # Remove temporary file
    rm /tmp/bucket-policy.json
    
    log_info "Bucket policy applied"
}

# Disable block public access
disable_block_public_access() {
    log_step "Disabling block public access"
    
    aws s3api put-public-access-block \
        --bucket "$BUCKET_NAME" \
        --public-access-block-configuration \
        "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"
    
    log_info "Block public access disabled"
}

# Upload website files
upload_files() {
    log_step "Uploading website files to S3"
    
    if [ ! -d "$WEBSITE_DIR" ]; then
        log_error "Website directory $WEBSITE_DIR not found"
        exit 1
    fi
    
    # Sync files with proper content types
    aws s3 sync "$WEBSITE_DIR" "s3://$BUCKET_NAME" \
        --delete \
        --exact-timestamps \
        --metadata-directive REPLACE
    
    # Set specific content types for better performance
    aws s3 cp "s3://$BUCKET_NAME" "s3://$BUCKET_NAME" \
        --recursive \
        --metadata-directive REPLACE \
        --content-type "text/html" \
        --exclude "*" \
        --include "*.html"
    
    aws s3 cp "s3://$BUCKET_NAME" "s3://$BUCKET_NAME" \
        --recursive \
        --metadata-directive REPLACE \
        --content-type "text/css" \
        --exclude "*" \
        --include "*.css"
    
    aws s3 cp "s3://$BUCKET_NAME" "s3://$BUCKET_NAME" \
        --recursive \
        --metadata-directive REPLACE \
        --content-type "application/javascript" \
        --exclude "*" \
        --include "*.js"
    
    log_info "Files uploaded successfully"
}

# Invalidate CloudFront cache
invalidate_cloudfront() {
    if [ -n "$CLOUDFRONT_DISTRIBUTION_ID" ]; then
        log_step "Invalidating CloudFront cache"
        
        aws cloudfront create-invalidation \
            --distribution-id "$CLOUDFRONT_DISTRIBUTION_ID" \
            --paths "/*"
        
        log_info "CloudFront invalidation created"
    else
        log_info "No CloudFront distribution ID provided, skipping cache invalidation"
    fi
}

# Get website URL
get_website_url() {
    local website_url="http://$BUCKET_NAME.s3-website-$AWS_REGION.amazonaws.com"
    log_info "Website URL: $website_url"
    echo "$website_url"
}

# Validate website
validate_website() {
    log_step "Validating website deployment"
    
    local website_url=$(get_website_url)
    
    # Test if website is accessible
    if curl -s --head "$website_url" | head -n 1 | grep -q "200 OK"; then
        log_info "Website is accessible and responding"
    else
        log_warn "Website might not be immediately accessible (DNS propagation)"
    fi
}

# Show deployment summary
show_summary() {
    log_step "Deployment Summary"
    
    echo "=================================="
    echo "Bucket Name: $BUCKET_NAME"
    echo "Region: $AWS_REGION"
    echo "Website URL: $(get_website_url)"
    echo "Files Uploaded: $(find $WEBSITE_DIR -type f | wc -l)"
    echo "Deployment Time: $(date)"
    echo "=================================="
}

# Main deployment function
deploy_website() {
    log_info "Starting website deployment to S3"
    
    check_aws_cli
    
    # Create bucket if it doesn't exist
    if ! check_bucket_exists; then
        create_bucket
        sleep 5  # Wait for bucket creation to propagate
    fi
    
    disable_block_public_access
    configure_website_hosting
    set_bucket_policy
    upload_files
    invalidate_cloudfront
    validate_website
    show_summary
    
    log_info "Website deployment completed successfully!"
}

# Cleanup function
cleanup_deployment() {
    log_step "Cleaning up deployment resources"
    
    read -p "Are you sure you want to delete the bucket and all its contents? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Delete all objects in bucket
        aws s3 rm "s3://$BUCKET_NAME" --recursive
        
        # Delete bucket
        aws s3 rb "s3://$BUCKET_NAME"
        
        log_info "Bucket and contents deleted successfully"
    else
        log_info "Cleanup cancelled"
    fi
}

# Usage function
usage() {
    echo "Usage: $0 [OPTIONS] COMMAND"
    echo ""
    echo "Commands:"
    echo "  deploy    Deploy website to S3"
    echo "  cleanup   Delete bucket and all contents"
    echo ""
    echo "Options:"
    echo "  -b, --bucket BUCKET_NAME      S3 bucket name (required)"
    echo "  -d, --directory DIRECTORY     Website files directory (default: ./website-files)"
    echo "  -r, --region REGION           AWS region (default: us-east-1)"
    echo "  -c, --cloudfront-id ID        CloudFront distribution ID (optional)"
    echo "  -h, --help                    Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -b my-portfolio-2024 deploy"
    echo "  $0 -b my-portfolio-2024 -r us-west-2 deploy"
    echo "  $0 -b my-portfolio-2024 -c E1234567890123 deploy"
    echo "  $0 -b my-portfolio-2024 cleanup"
}

# Parse command line arguments
COMMAND=""
while [[ $# -gt 0 ]]; do
    case $1 in
        -b|--bucket)
            BUCKET_NAME="$2"
            shift 2
            ;;
        -d|--directory)
            WEBSITE_DIR="$2"
            shift 2
            ;;
        -r|--region)
            AWS_REGION="$2"
            shift 2
            ;;
        -c|--cloudfront-id)
            CLOUDFRONT_DISTRIBUTION_ID="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        deploy|cleanup)
            COMMAND="$1"
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Validate inputs
if [ -z "$BUCKET_NAME" ]; then
    log_error "Bucket name is required"
    usage
    exit 1
fi

if [ -z "$COMMAND" ]; then
    log_error "Command is required (deploy or cleanup)"
    usage
    exit 1
fi

# Execute command
case $COMMAND in
    deploy)
        deploy_website
        ;;
    cleanup)
        cleanup_deployment
        ;;
    *)
        log_error "Invalid command: $COMMAND"
        usage
        exit 1
        ;;
esac