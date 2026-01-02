# Day 10: AWS S3 Static Website Hosting - Practical Lab Guide

## 🎯 Lab Objectives
- Create and configure S3 buckets for static website hosting
- Deploy a complete portfolio website on S3
- Configure custom domains and HTTPS with CloudFront
- Implement S3 security best practices
- Automate deployment with scripts
- Monitor website performance and costs

## ⏱️ Estimated Time: 2.5 hours

## 🛠️ Lab Setup

### Prerequisites Checklist
- [ ] AWS Free Tier account with valid payment method
- [ ] AWS CLI installed and configured
- [ ] Basic HTML/CSS/JavaScript knowledge
- [ ] Text editor or IDE
- [ ] Domain name (optional, for custom domain setup)

### Lab Environment
```
Region: us-east-1 (N. Virginia)
Storage Class: Standard
Website Type: Static Portfolio
CDN: CloudFront (optional)
```

## 📋 Lab Steps

### Phase 1: S3 Bucket Creation and Configuration

#### Step 1.1: Create S3 Bucket
```bash
# Set variables
BUCKET_NAME="your-name-portfolio-$(date +%Y%m%d)"
AWS_REGION="us-east-1"

echo "Bucket Name: $BUCKET_NAME"

# Create bucket
aws s3 mb s3://$BUCKET_NAME --region $AWS_REGION

# Verify bucket creation
aws s3 ls | grep $BUCKET_NAME
```

#### Step 1.2: Configure Public Access Settings
```bash
# Disable block public access (required for website hosting)
aws s3api put-public-access-block \
    --bucket $BUCKET_NAME \
    --public-access-block-configuration \
    "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"

# Verify settings
aws s3api get-public-access-block --bucket $BUCKET_NAME
```

#### Step 1.3: Enable Static Website Hosting
```bash
# Enable website hosting
aws s3 website s3://$BUCKET_NAME \
    --index-document index.html \
    --error-document error.html

# Verify website configuration
aws s3api get-bucket-website --bucket $BUCKET_NAME
```

#### Step 1.4: Set Bucket Policy for Public Read Access
```bash
# Create bucket policy file
cat > bucket-policy.json << 'EOF'
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::BUCKET_NAME_PLACEHOLDER/*"
        }
    ]
}
EOF

# Replace placeholder with actual bucket name
sed -i "s/BUCKET_NAME_PLACEHOLDER/$BUCKET_NAME/g" bucket-policy.json

# Apply bucket policy
aws s3api put-bucket-policy \
    --bucket $BUCKET_NAME \
    --policy file://bucket-policy.json

# Verify policy
aws s3api get-bucket-policy --bucket $BUCKET_NAME
```

### Phase 2: Website Development and Upload

#### Step 2.1: Prepare Website Files
```bash
# Create directory structure
mkdir -p portfolio-website/{css,js,images,assets}
cd portfolio-website

# Copy provided files or create your own
# Files should include:
# - index.html (main page)
# - error.html (404 page)
# - css/style.css (stylesheet)
# - js/script.js (JavaScript)
# - images/ (profile picture, etc.)
# - assets/ (resume PDF, etc.)
```

#### Step 2.2: Customize Website Content
```bash
# Edit index.html with your information
nano index.html

# Update the following sections:
# - Personal name and title
# - About section with your background
# - Skills relevant to your experience
# - Projects you've completed
# - Contact information

# Customize CSS if needed
nano css/style.css
```

#### Step 2.3: Upload Files to S3
```bash
# Upload all files
aws s3 sync . s3://$BUCKET_NAME/ --delete

# Set proper content types for better performance
aws s3 cp s3://$BUCKET_NAME/ s3://$BUCKET_NAME/ \
    --recursive \
    --metadata-directive REPLACE \
    --content-type "text/html" \
    --exclude "*" \
    --include "*.html"

aws s3 cp s3://$BUCKET_NAME/ s3://$BUCKET_NAME/ \
    --recursive \
    --metadata-directive REPLACE \
    --content-type "text/css" \
    --exclude "*" \
    --include "*.css"

aws s3 cp s3://$BUCKET_NAME/ s3://$BUCKET_NAME/ \
    --recursive \
    --metadata-directive REPLACE \
    --content-type "application/javascript" \
    --exclude "*" \
    --include "*.js"

# Verify upload
aws s3 ls s3://$BUCKET_NAME/ --recursive
```

### Phase 3: Website Testing and Validation

#### Step 3.1: Get Website URL and Test
```bash
# Get website endpoint URL
WEBSITE_URL="http://$BUCKET_NAME.s3-website-$AWS_REGION.amazonaws.com"
echo "Website URL: $WEBSITE_URL"

# Test website accessibility
curl -I $WEBSITE_URL

# Open in browser (if available)
# For Windows: start $WEBSITE_URL
# For macOS: open $WEBSITE_URL
# For Linux: xdg-open $WEBSITE_URL
```

#### Step 3.2: Test Website Functionality
```bash
# Test main page
curl -s $WEBSITE_URL | grep -i "portfolio"

# Test 404 error page
curl -I $WEBSITE_URL/nonexistent-page

# Test CSS loading
curl -I $WEBSITE_URL/css/style.css

# Test JavaScript loading
curl -I $WEBSITE_URL/js/script.js

# Test assets
curl -I $WEBSITE_URL/assets/sample-resume.pdf
```

#### Step 3.3: Performance Testing
```bash
# Test page load time
time curl -s $WEBSITE_URL > /dev/null

# Test from different locations (using online tools)
# - GTmetrix: https://gtmetrix.com/
# - PageSpeed Insights: https://pagespeed.web.dev/
# - WebPageTest: https://www.webpagetest.org/
```

### Phase 4: Advanced Configuration (Optional)

#### Step 4.1: Custom Domain Setup with Route 53
```bash
# Create hosted zone (if you have a domain)
DOMAIN_NAME="yourdomain.com"

aws route53 create-hosted-zone \
    --name $DOMAIN_NAME \
    --caller-reference $(date +%s)

# Get hosted zone ID
HOSTED_ZONE_ID=$(aws route53 list-hosted-zones \
    --query "HostedZones[?Name=='$DOMAIN_NAME.'].Id" \
    --output text | cut -d'/' -f3)

echo "Hosted Zone ID: $HOSTED_ZONE_ID"
```

#### Step 4.2: Create CNAME Record for www subdomain
```bash
# Create DNS record file
cat > dns-record.json << EOF
{
    "Changes": [
        {
            "Action": "CREATE",
            "ResourceRecordSet": {
                "Name": "www.$DOMAIN_NAME",
                "Type": "CNAME",
                "TTL": 300,
                "ResourceRecords": [
                    {
                        "Value": "$BUCKET_NAME.s3-website-$AWS_REGION.amazonaws.com"
                    }
                ]
            }
        }
    ]
}
EOF

# Apply DNS record
aws route53 change-resource-record-sets \
    --hosted-zone-id $HOSTED_ZONE_ID \
    --change-batch file://dns-record.json
```

#### Step 4.3: CloudFront Distribution for HTTPS
```bash
# Create CloudFront distribution configuration
cat > cloudfront-config.json << 'EOF'
{
    "CallerReference": "s3-website-cloudfront-2024",
    "Origins": {
        "Quantity": 1,
        "Items": [
            {
                "Id": "S3-Website-Origin",
                "DomainName": "BUCKET_NAME_PLACEHOLDER.s3-website-us-east-1.amazonaws.com",
                "CustomOriginConfig": {
                    "HTTPPort": 80,
                    "HTTPSPort": 443,
                    "OriginProtocolPolicy": "http-only"
                }
            }
        ]
    },
    "DefaultCacheBehavior": {
        "TargetOriginId": "S3-Website-Origin",
        "ViewerProtocolPolicy": "redirect-to-https",
        "MinTTL": 0,
        "DefaultTTL": 86400,
        "MaxTTL": 31536000,
        "ForwardedValues": {
            "QueryString": false,
            "Cookies": {
                "Forward": "none"
            }
        },
        "Compress": true
    },
    "Comment": "S3 Static Website CloudFront Distribution",
    "Enabled": true,
    "PriceClass": "PriceClass_100"
}
EOF

# Replace placeholder
sed -i "s/BUCKET_NAME_PLACEHOLDER/$BUCKET_NAME/g" cloudfront-config.json

# Create distribution
aws cloudfront create-distribution \
    --distribution-config file://cloudfront-config.json
```

### Phase 5: Monitoring and Analytics

#### Step 5.1: Enable S3 Access Logging
```bash
# Create logging bucket
LOGGING_BUCKET="$BUCKET_NAME-access-logs"
aws s3 mb s3://$LOGGING_BUCKET

# Create logging configuration
cat > logging-config.json << EOF
{
    "LoggingEnabled": {
        "TargetBucket": "$LOGGING_BUCKET",
        "TargetPrefix": "access-logs/"
    }
}
EOF

# Enable access logging
aws s3api put-bucket-logging \
    --bucket $BUCKET_NAME \
    --bucket-logging-status file://logging-config.json
```

#### Step 5.2: Set up CloudWatch Monitoring
```bash
# Enable request metrics
aws s3api put-bucket-metrics-configuration \
    --bucket $BUCKET_NAME \
    --id "EntireBucket" \
    --metrics-configuration Id="EntireBucket",Filter={}

# Create CloudWatch dashboard (optional)
cat > dashboard-config.json << EOF
{
    "widgets": [
        {
            "type": "metric",
            "properties": {
                "metrics": [
                    ["AWS/S3", "BucketSizeBytes", "BucketName", "$BUCKET_NAME", "StorageType", "StandardStorage"],
                    [".", "NumberOfObjects", ".", ".", ".", "AllStorageTypes"]
                ],
                "period": 86400,
                "stat": "Average",
                "region": "$AWS_REGION",
                "title": "S3 Bucket Metrics"
            }
        }
    ]
}
EOF

aws cloudwatch put-dashboard \
    --dashboard-name "S3-Website-Dashboard" \
    --dashboard-body file://dashboard-config.json
```

### Phase 6: Automation and CI/CD

#### Step 6.1: Use Deployment Script
```bash
# Make deployment script executable
chmod +x ../scripts/deploy-website.sh

# Deploy using script
../scripts/deploy-website.sh -b $BUCKET_NAME deploy

# Test automated deployment
echo "<!-- Updated: $(date) -->" >> index.html
../scripts/deploy-website.sh -b $BUCKET_NAME deploy
```

#### Step 6.2: GitHub Actions Workflow (Optional)
```yaml
# Create .github/workflows/deploy.yml
name: Deploy to S3

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1
    
    - name: Deploy to S3
      run: |
        aws s3 sync ./website-files s3://${{ secrets.S3_BUCKET_NAME }} --delete
```

### Phase 7: Security and Best Practices

#### Step 7.1: Implement Security Headers
```bash
# Add security headers via CloudFront (if using)
# Or implement via Lambda@Edge for advanced security
```

#### Step 7.2: Enable Versioning (Optional)
```bash
# Enable versioning for backup purposes
aws s3api put-bucket-versioning \
    --bucket $BUCKET_NAME \
    --versioning-configuration Status=Enabled

# Verify versioning
aws s3api get-bucket-versioning --bucket $BUCKET_NAME
```

#### Step 7.3: Set up Lifecycle Policies
```bash
# Create lifecycle policy for cost optimization
cat > lifecycle-policy.json << 'EOF'
{
    "Rules": [
        {
            "ID": "DeleteOldVersions",
            "Status": "Enabled",
            "Filter": {},
            "NoncurrentVersionExpiration": {
                "NoncurrentDays": 30
            }
        }
    ]
}
EOF

aws s3api put-bucket-lifecycle-configuration \
    --bucket $BUCKET_NAME \
    --lifecycle-configuration file://lifecycle-policy.json
```

### Phase 8: Testing and Validation

#### Step 8.1: Comprehensive Testing Checklist
```bash
# Test all pages and functionality
echo "Testing website functionality..."

# Test main page
curl -f $WEBSITE_URL || echo "Main page failed"

# Test 404 page
curl -f $WEBSITE_URL/nonexistent || echo "404 page test completed"

# Test CSS
curl -f $WEBSITE_URL/css/style.css || echo "CSS failed"

# Test JavaScript
curl -f $WEBSITE_URL/js/script.js || echo "JavaScript failed"

# Test assets
curl -f $WEBSITE_URL/assets/sample-resume.pdf || echo "PDF failed"

echo "Testing completed!"
```

#### Step 8.2: Performance Validation
```bash
# Check page size
PAGE_SIZE=$(curl -s $WEBSITE_URL | wc -c)
echo "Page size: $PAGE_SIZE bytes"

# Check load time
LOAD_TIME=$(curl -o /dev/null -s -w '%{time_total}' $WEBSITE_URL)
echo "Load time: $LOAD_TIME seconds"

# Validate HTML (if html5validator is installed)
# html5validator --root website-files/
```

### Phase 9: Cost Monitoring and Cleanup

#### Step 9.1: Monitor Costs
```bash
# Get current month's S3 costs
aws ce get-cost-and-usage \
    --time-period Start=2024-01-01,End=2024-01-31 \
    --granularity MONTHLY \
    --metrics BlendedCost \
    --group-by Type=DIMENSION,Key=SERVICE

# Check bucket size
aws s3api list-objects-v2 \
    --bucket $BUCKET_NAME \
    --query 'sum(Contents[].Size)' \
    --output text
```

#### Step 9.2: Cleanup Resources (Important!)
```bash
# List all resources created
echo "Resources to clean up:"
echo "1. S3 Bucket: $BUCKET_NAME"
echo "2. Logging Bucket: $LOGGING_BUCKET"
echo "3. CloudFront Distribution (if created)"
echo "4. Route 53 Hosted Zone (if created)"

# Cleanup script
read -p "Do you want to clean up all resources? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Delete bucket contents
    aws s3 rm s3://$BUCKET_NAME --recursive
    aws s3 rm s3://$LOGGING_BUCKET --recursive
    
    # Delete buckets
    aws s3 rb s3://$BUCKET_NAME
    aws s3 rb s3://$LOGGING_BUCKET
    
    echo "Cleanup completed!"
else
    echo "Cleanup skipped. Remember to delete resources to avoid charges!"
fi
```

## 🧪 Advanced Exercises

### Exercise 1: Multi-Environment Setup
```bash
# Create dev, staging, and prod environments
for env in dev staging prod; do
    BUCKET="$BUCKET_NAME-$env"
    aws s3 mb s3://$BUCKET
    # Configure each environment
done
```

### Exercise 2: Custom Error Pages
```bash
# Create custom error pages for different HTTP codes
# 403.html, 404.html, 500.html
# Configure S3 to serve appropriate error pages
```

### Exercise 3: A/B Testing Setup
```bash
# Create two versions of the website
# Use CloudFront behaviors to split traffic
# Monitor performance differences
```

## ✅ Lab Validation Checklist

- [ ] S3 bucket created with unique name
- [ ] Static website hosting enabled and configured
- [ ] Website files uploaded successfully
- [ ] Bucket policy allows public read access
- [ ] Website accessible via S3 endpoint URL
- [ ] All pages load correctly (home, 404 error)
- [ ] CSS and JavaScript files load properly
- [ ] Assets (images, PDFs) are accessible
- [ ] Mobile responsiveness tested
- [ ] Performance metrics recorded
- [ ] Security configurations verified
- [ ] Monitoring and logging enabled
- [ ] Deployment automation tested
- [ ] Cost monitoring configured
- [ ] Cleanup completed (if desired)

## 🎓 Key Learning Outcomes

1. **S3 Website Hosting**: Configured complete static website hosting
2. **Security Implementation**: Applied proper bucket policies and access controls
3. **Performance Optimization**: Implemented caching and compression
4. **Automation**: Created deployment scripts and CI/CD workflows
5. **Monitoring**: Set up logging and CloudWatch metrics
6. **Cost Management**: Implemented lifecycle policies and cost monitoring

## 📊 Lab Report Template

```
Student Name: _______________
Date: _______________
Lab Duration: _______________

Website Details:
- Bucket Name: _______________
- Website URL: _______________
- Total Files: _______________
- Total Size: _______________

Performance Metrics:
- Page Load Time: _______________
- Page Size: _______________
- Mobile Score: _______________

Security Configurations:
- Bucket Policy: ✓/✗
- Public Access: ✓/✗
- HTTPS (CloudFront): ✓/✗

Challenges Faced:
_______________

Solutions Applied:
_______________

Cost Estimate: $_______________
```

## 🔗 Additional Resources

- [S3 Static Website Hosting Guide](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [Route 53 Developer Guide](https://docs.aws.amazon.com/route53/)
- [AWS CLI S3 Commands](https://docs.aws.amazon.com/cli/latest/reference/s3/)
- [Web Performance Best Practices](https://web.dev/performance/)

---

**Lab Instructor**: Neeraj Kumar  
**Contact**: For questions, create an issue in the repository  
**Next Lab**: Day 11 - AWS CloudFront CDN and Advanced S3 Features