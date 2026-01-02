# Day 10: AWS S3 and Static Website Hosting

## 📚 Learning Objectives
- Master AWS S3 (Simple Storage Service) fundamentals
- Understand S3 storage classes and pricing models
- Configure S3 buckets for static website hosting
- Implement S3 security and access controls
- Deploy real-world static websites on S3
- Configure custom domains and CloudFront integration

## 🎯 Topics Covered

### 1. AWS S3 Overview
- What is Amazon S3?
- S3 vs traditional file systems
- Key concepts: Buckets, Objects, Keys
- S3 global infrastructure and regions

### 2. S3 Storage Classes
- **Standard** - Frequently accessed data
- **Standard-IA** - Infrequently accessed data
- **One Zone-IA** - Lower cost for infrequent access
- **Glacier Instant Retrieval** - Archive with instant access
- **Glacier Flexible Retrieval** - Archive with retrieval times
- **Glacier Deep Archive** - Lowest cost archive
- **Intelligent Tiering** - Automatic cost optimization

### 3. S3 Security and Access Control
- Bucket policies and IAM roles
- Access Control Lists (ACLs)
- S3 Block Public Access
- Encryption at rest and in transit
- Versioning and MFA delete

### 4. Static Website Hosting
- S3 website hosting capabilities
- Index and error documents
- Custom domain configuration
- HTTPS with CloudFront
- Performance optimization

## 🏗️ Architecture Overview

```
Internet Users
    ↓
Route 53 (DNS)
    ↓
CloudFront (CDN)
    ↓
S3 Bucket (Static Website)
    ↓
Website Files (HTML, CSS, JS, Images)
```

## 🛠️ Practical Lab: S3 Static Website Hosting

### Prerequisites
- AWS Free Tier account
- Domain name (optional, for custom domain)
- Basic HTML/CSS knowledge
- AWS CLI configured

### Lab Architecture
```
S3 Bucket: my-portfolio-website-2024
├── index.html (Homepage)
├── error.html (404 page)
├── css/
│   └── style.css
├── js/
│   └── script.js
├── images/
│   └── profile.jpg
└── assets/
    └── resume.pdf
```

## 🚀 Hands-on Exercise

### Step 1: Create S3 Bucket for Website

1. **Create Bucket via Console**
   - Go to S3 Console
   - Click "Create bucket"
   - Bucket name: `your-name-portfolio-2024` (must be globally unique)
   - Region: `us-east-1`
   - Uncheck "Block all public access"
   - Acknowledge public access warning

2. **Create Bucket via CLI**
   ```bash
   # Create bucket
   aws s3 mb s3://your-name-portfolio-2024 --region us-east-1
   
   # Configure public access
   aws s3api put-public-access-block \
     --bucket your-name-portfolio-2024 \
     --public-access-block-configuration \
     "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"
   ```

### Step 2: Enable Static Website Hosting

1. **Via Console**
   - Select bucket → Properties
   - Scroll to "Static website hosting"
   - Enable static website hosting
   - Index document: `index.html`
   - Error document: `error.html`
   - Save changes

2. **Via CLI**
   ```bash
   aws s3 website s3://your-name-portfolio-2024 \
     --index-document index.html \
     --error-document error.html
   ```

### Step 3: Create Website Files

1. **Create index.html**
   ```html
   <!DOCTYPE html>
   <html lang="en">
   <head>
       <meta charset="UTF-8">
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <title>My Portfolio - AWS S3 Hosted</title>
       <link rel="stylesheet" href="css/style.css">
   </head>
   <body>
       <header>
           <nav>
               <div class="logo">My Portfolio</div>
               <ul>
                   <li><a href="#home">Home</a></li>
                   <li><a href="#about">About</a></li>
                   <li><a href="#projects">Projects</a></li>
                   <li><a href="#contact">Contact</a></li>
               </ul>
           </nav>
       </header>

       <main>
           <section id="home" class="hero">
               <div class="hero-content">
                   <h1>Welcome to My Portfolio</h1>
                   <p>Hosted on AWS S3 - Day 10 Lab</p>
                   <img src="images/profile.jpg" alt="Profile" class="profile-img">
                   <a href="assets/resume.pdf" class="btn" target="_blank">Download Resume</a>
               </div>
           </section>

           <section id="about" class="about">
               <h2>About Me</h2>
               <p>AWS DevOps Engineer learning cloud technologies through hands-on practice.</p>
               <div class="skills">
                   <h3>Skills:</h3>
                   <ul>
                       <li>AWS Services (EC2, S3, EBS, VPC)</li>
                       <li>Linux Administration</li>
                       <li>DevOps Tools</li>
                       <li>Infrastructure as Code</li>
                   </ul>
               </div>
           </section>

           <section id="projects" class="projects">
               <h2>Projects</h2>
               <div class="project-grid">
                   <div class="project-card">
                       <h3>Static Website on S3</h3>
                       <p>Deployed this portfolio website using AWS S3 static hosting</p>
                       <span class="tech">AWS S3, HTML, CSS</span>
                   </div>
                   <div class="project-card">
                       <h3>EBS Volume Management</h3>
                       <p>Automated EBS snapshot creation and management</p>
                       <span class="tech">AWS EBS, Bash Scripting</span>
                   </div>
               </div>
           </section>

           <section id="contact" class="contact">
               <h2>Contact Me</h2>
               <p>Email: your.email@example.com</p>
               <p>LinkedIn: linkedin.com/in/yourprofile</p>
               <p>GitHub: github.com/yourusername</p>
           </section>
       </main>

       <footer>
           <p>&copy; 2024 My Portfolio. Hosted on AWS S3. Day 10 - AWS DevOps Batch 4</p>
       </footer>

       <script src="js/script.js"></script>
   </body>
   </html>
   ```

2. **Create error.html**
   ```html
   <!DOCTYPE html>
   <html lang="en">
   <head>
       <meta charset="UTF-8">
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <title>Page Not Found - My Portfolio</title>
       <link rel="stylesheet" href="css/style.css">
   </head>
   <body>
       <div class="error-page">
           <h1>404 - Page Not Found</h1>
           <p>The page you're looking for doesn't exist.</p>
           <a href="index.html" class="btn">Go Home</a>
       </div>
   </body>
   </html>
   ```

3. **Create css/style.css**
   ```css
   * {
       margin: 0;
       padding: 0;
       box-sizing: border-box;
   }

   body {
       font-family: 'Arial', sans-serif;
       line-height: 1.6;
       color: #333;
   }

   header {
       background: #2c3e50;
       color: white;
       padding: 1rem 0;
       position: fixed;
       width: 100%;
       top: 0;
       z-index: 1000;
   }

   nav {
       display: flex;
       justify-content: space-between;
       align-items: center;
       max-width: 1200px;
       margin: 0 auto;
       padding: 0 2rem;
   }

   .logo {
       font-size: 1.5rem;
       font-weight: bold;
   }

   nav ul {
       display: flex;
       list-style: none;
   }

   nav ul li {
       margin-left: 2rem;
   }

   nav ul li a {
       color: white;
       text-decoration: none;
       transition: color 0.3s;
   }

   nav ul li a:hover {
       color: #3498db;
   }

   main {
       margin-top: 80px;
   }

   .hero {
       background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
       color: white;
       text-align: center;
       padding: 4rem 2rem;
   }

   .hero-content h1 {
       font-size: 3rem;
       margin-bottom: 1rem;
   }

   .hero-content p {
       font-size: 1.2rem;
       margin-bottom: 2rem;
   }

   .profile-img {
       width: 200px;
       height: 200px;
       border-radius: 50%;
       margin: 2rem 0;
       border: 5px solid white;
   }

   .btn {
       display: inline-block;
       background: #3498db;
       color: white;
       padding: 12px 30px;
       text-decoration: none;
       border-radius: 5px;
       transition: background 0.3s;
   }

   .btn:hover {
       background: #2980b9;
   }

   section {
       padding: 4rem 2rem;
       max-width: 1200px;
       margin: 0 auto;
   }

   .about, .projects, .contact {
       text-align: center;
   }

   .about h2, .projects h2, .contact h2 {
       font-size: 2.5rem;
       margin-bottom: 2rem;
       color: #2c3e50;
   }

   .skills {
       margin-top: 2rem;
   }

   .skills ul {
       list-style: none;
       display: flex;
       justify-content: center;
       flex-wrap: wrap;
       gap: 1rem;
   }

   .skills li {
       background: #ecf0f1;
       padding: 0.5rem 1rem;
       border-radius: 20px;
       color: #2c3e50;
   }

   .project-grid {
       display: grid;
       grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
       gap: 2rem;
       margin-top: 2rem;
   }

   .project-card {
       background: white;
       padding: 2rem;
       border-radius: 10px;
       box-shadow: 0 5px 15px rgba(0,0,0,0.1);
       transition: transform 0.3s;
   }

   .project-card:hover {
       transform: translateY(-5px);
   }

   .project-card h3 {
       color: #2c3e50;
       margin-bottom: 1rem;
   }

   .tech {
       display: inline-block;
       background: #3498db;
       color: white;
       padding: 0.3rem 0.8rem;
       border-radius: 15px;
       font-size: 0.8rem;
       margin-top: 1rem;
   }

   footer {
       background: #2c3e50;
       color: white;
       text-align: center;
       padding: 2rem;
   }

   .error-page {
       text-align: center;
       padding: 4rem 2rem;
       min-height: 100vh;
       display: flex;
       flex-direction: column;
       justify-content: center;
   }

   .error-page h1 {
       font-size: 4rem;
       color: #e74c3c;
       margin-bottom: 1rem;
   }

   @media (max-width: 768px) {
       nav {
           flex-direction: column;
           gap: 1rem;
       }

       nav ul {
           flex-direction: column;
           gap: 1rem;
       }

       .hero-content h1 {
           font-size: 2rem;
       }

       .profile-img {
           width: 150px;
           height: 150px;
       }
   }
   ```

4. **Create js/script.js**
   ```javascript
   // Smooth scrolling for navigation links
   document.querySelectorAll('a[href^="#"]').forEach(anchor => {
       anchor.addEventListener('click', function (e) {
           e.preventDefault();
           const target = document.querySelector(this.getAttribute('href'));
           if (target) {
               target.scrollIntoView({
                   behavior: 'smooth',
                   block: 'start'
               });
           }
       });
   });

   // Add active class to navigation based on scroll position
   window.addEventListener('scroll', () => {
       const sections = document.querySelectorAll('section');
       const navLinks = document.querySelectorAll('nav a[href^="#"]');
       
       let current = '';
       sections.forEach(section => {
           const sectionTop = section.offsetTop;
           const sectionHeight = section.clientHeight;
           if (scrollY >= (sectionTop - 200)) {
               current = section.getAttribute('id');
           }
       });

       navLinks.forEach(link => {
           link.classList.remove('active');
           if (link.getAttribute('href') === `#${current}`) {
               link.classList.add('active');
           }
       });
   });

   // Add loading animation
   window.addEventListener('load', () => {
       document.body.style.opacity = '0';
       document.body.style.transition = 'opacity 0.5s';
       setTimeout(() => {
           document.body.style.opacity = '1';
       }, 100);
   });

   // Console message for developers
   console.log('🚀 Portfolio website hosted on AWS S3!');
   console.log('📚 Day 10 - AWS DevOps Batch 4');
   console.log('👨‍💻 Instructor: Neeraj Kumar');
   ```

### Step 4: Upload Files to S3

1. **Create Directory Structure**
   ```bash
   mkdir -p website-files/{css,js,images,assets}
   
   # Save the HTML, CSS, JS files in respective directories
   # Add a profile image to images/ folder
   # Add a sample resume PDF to assets/ folder
   ```

2. **Upload via AWS CLI**
   ```bash
   # Upload all files
   aws s3 sync website-files/ s3://your-name-portfolio-2024/
   
   # Set public read permissions
   aws s3api put-object-acl \
     --bucket your-name-portfolio-2024 \
     --key index.html \
     --acl public-read
   
   # Set permissions for all files
   aws s3api put-bucket-acl \
     --bucket your-name-portfolio-2024 \
     --acl public-read
   ```

3. **Upload via Console**
   - Go to S3 bucket
   - Click "Upload"
   - Add files and folders
   - Set permissions to public read

### Step 5: Configure Bucket Policy

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::your-name-portfolio-2024/*"
        }
    ]
}
```

Apply via CLI:
```bash
# Create policy file
cat > bucket-policy.json << 'EOF'
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::your-name-portfolio-2024/*"
        }
    ]
}
EOF

# Apply policy
aws s3api put-bucket-policy \
  --bucket your-name-portfolio-2024 \
  --policy file://bucket-policy.json
```

### Step 6: Test Website

1. **Get Website URL**
   ```bash
   # Get website endpoint
   aws s3api get-bucket-website \
     --bucket your-name-portfolio-2024
   
   # URL format: http://bucket-name.s3-website-region.amazonaws.com
   ```

2. **Test Website**
   - Open: `http://your-name-portfolio-2024.s3-website-us-east-1.amazonaws.com`
   - Test navigation links
   - Test 404 error page: add `/nonexistent` to URL
   - Test mobile responsiveness

## 🌐 Advanced Configuration

### Custom Domain with Route 53

1. **Create Hosted Zone**
   ```bash
   aws route53 create-hosted-zone \
     --name yourdomain.com \
     --caller-reference $(date +%s)
   ```

2. **Create CNAME Record**
   ```bash
   # Point www.yourdomain.com to S3 endpoint
   aws route53 change-resource-record-sets \
     --hosted-zone-id Z123456789 \
     --change-batch file://dns-record.json
   ```

### CloudFront Distribution for HTTPS

1. **Create Distribution**
   ```bash
   aws cloudfront create-distribution \
     --distribution-config file://cloudfront-config.json
   ```

2. **CloudFront Configuration**
   ```json
   {
       "CallerReference": "s3-website-2024",
       "Origins": {
           "Quantity": 1,
           "Items": [
               {
                   "Id": "S3-Website",
                   "DomainName": "your-name-portfolio-2024.s3-website-us-east-1.amazonaws.com",
                   "CustomOriginConfig": {
                       "HTTPPort": 80,
                       "HTTPSPort": 443,
                       "OriginProtocolPolicy": "http-only"
                   }
               }
           ]
       },
       "DefaultCacheBehavior": {
           "TargetOriginId": "S3-Website",
           "ViewerProtocolPolicy": "redirect-to-https",
           "MinTTL": 0,
           "ForwardedValues": {
               "QueryString": false,
               "Cookies": {"Forward": "none"}
           }
       },
       "Comment": "S3 Static Website Distribution",
       "Enabled": true
   }
   ```

## 📊 Monitoring and Analytics

### CloudWatch Metrics
```bash
# Get bucket size metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/S3 \
  --metric-name BucketSizeBytes \
  --dimensions Name=BucketName,Value=your-name-portfolio-2024 \
  --start-time 2024-01-01T00:00:00Z \
  --end-time 2024-12-31T23:59:59Z \
  --period 86400 \
  --statistics Average
```

### S3 Access Logging
```bash
# Enable access logging
aws s3api put-bucket-logging \
  --bucket your-name-portfolio-2024 \
  --bucket-logging-status file://logging-config.json
```

## 🔧 Automation Scripts

### Deployment Script
```bash
#!/bin/bash
# deploy-website.sh

BUCKET_NAME="your-name-portfolio-2024"
WEBSITE_DIR="./website-files"

echo "🚀 Deploying website to S3..."

# Sync files
aws s3 sync $WEBSITE_DIR s3://$BUCKET_NAME --delete

# Invalidate CloudFront cache (if using CloudFront)
if [ ! -z "$CLOUDFRONT_DISTRIBUTION_ID" ]; then
    aws cloudfront create-invalidation \
      --distribution-id $CLOUDFRONT_DISTRIBUTION_ID \
      --paths "/*"
fi

echo "✅ Deployment completed!"
echo "🌐 Website URL: http://$BUCKET_NAME.s3-website-us-east-1.amazonaws.com"
```

## 🎯 Key Takeaways

1. **S3 Static Hosting** is cost-effective for static websites
2. **Global Accessibility** through S3's distributed infrastructure
3. **Scalability** handles traffic spikes automatically
4. **Security** through bucket policies and IAM
5. **Performance** enhanced with CloudFront CDN
6. **Cost Optimization** through storage classes

## 🧪 Practice Exercises

### Exercise 1: Multi-Environment Setup
- Create dev, staging, and prod buckets
- Implement automated deployment pipeline
- Configure different access policies

### Exercise 2: E-commerce Static Site
- Build product catalog website
- Implement search functionality with JavaScript
- Add shopping cart (localStorage)

### Exercise 3: Blog Website
- Create blog structure with multiple pages
- Implement RSS feed
- Add comment system integration

## 🔍 Troubleshooting

### Common Issues
1. **403 Forbidden**: Check bucket policy and public access settings
2. **404 Not Found**: Verify index document configuration
3. **Mixed Content**: Use HTTPS with CloudFront
4. **Slow Loading**: Optimize images and enable compression

### Useful Commands
```bash
# Check bucket policy
aws s3api get-bucket-policy --bucket your-bucket-name

# List bucket contents
aws s3 ls s3://your-bucket-name --recursive

# Check website configuration
aws s3api get-bucket-website --bucket your-bucket-name

# Monitor access logs
aws s3 ls s3://your-logs-bucket/access-logs/
```

## 📚 Additional Resources

- [S3 Static Website Hosting Guide](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [Route 53 Developer Guide](https://docs.aws.amazon.com/route53/)
- [S3 Security Best Practices](https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html)

## 🏆 Lab Completion Checklist

- [ ] S3 bucket created with unique name
- [ ] Static website hosting enabled
- [ ] Website files uploaded successfully
- [ ] Bucket policy configured for public access
- [ ] Website accessible via S3 endpoint
- [ ] Error page working correctly
- [ ] Mobile responsiveness tested
- [ ] Performance optimized
- [ ] Security configurations verified
- [ ] Cleanup completed (optional)

---

**Next Day Preview**: Day 11 will cover AWS CloudFront CDN and advanced S3 features like lifecycle policies and cross-region replication.

**Instructor**: Neeraj Kumar  
**Date**: Day 10 - AWS DevOps Batch 4  
**Duration**: 3 hours (Theory: 1 hour, Practical: 2 hours)