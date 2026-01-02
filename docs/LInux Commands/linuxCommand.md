# Linux Commands Reference for AWS DevOps Engineers

## 📋 Table of Contents

- [Navigation and Files](#-navigation-and-files)
- [File Editing and Parsing](#-file-editing-and-parsing)
- [Permissions and Ownership](#-permissions-and-ownership)
- [Processes and Services](#-processes-and-services)
- [Networking and DNS](#-networking-and-dns)
- [Firewall and Security](#-firewall-and-security)
- [Package Management](#-package-management)
- [Archive and Transfer](#-archive-and-transfer)
- [Disks and Filesystems](#-disks-and-filesystems)
- [Users and Sudo](#-users-and-sudo)
- [Logs and Diagnostics](#-logs-and-diagnostics)
- [Shell and Automation](#-shell-and-automation)
- [Web Stack Management](#-web-stack-management)
- [Docker and Kubernetes](#-docker-and-kubernetes)
- [AWS-Specific Commands](#-aws-specific-commands)

---

## 📁 Navigation and Files

### Basic Navigation
```bash
ls -la                    # List files with details
cd                        # Change directory
pwd                       # Print working directory
tree                      # Display directory tree
find /path -name "*"      # Find files by name
du -sh *                  # Disk usage summary
df -h                     # Disk space usage
```

### File Operations
```bash
cat file                  # Display file content
tac file                  # Display file content in reverse
less file                 # View file with pagination
head -n 10 file           # Show first 10 lines
tail -f file              # Follow file in real-time
wc -l file                # Count lines in file
stat file                 # File status information
touch file                # Create empty file or update timestamp
```

### File Management
```bash
cp -r source dest         # Copy directory recursively
mv oldname newname        # Move/rename file
rm -rf directory          # Remove directory and contents
mkdir -p /path/to/dir     # Create directory with parents
```

---

## ✏️ File Editing and Parsing

### Text Editors
```bash
vim file                  # Edit file with Vim
nano file                 # Edit file with Nano
```

### Text Processing
```bash
grep -R "pattern" /etc -n # Search recursively with line numbers
sed -i 's/old/new/g' file # Replace text in file
awk '{print $1}' file     # Print first column
cut -d: -f1 file          # Cut first field delimited by :
```

---

## 🔐 Permissions and Ownership

### File Permissions
```bash
chmod 644 file            # Set read/write for owner, read for group/others
chmod +x script.sh        # Make file executable
chown -R user:group /path # Change ownership recursively
umask                     # Show current umask
umask 022                 # Set umask for new files
```

---

## ⚙️ Processes and Services

### Process Management
```bash
ps aux | grep process     # Find running processes
top                       # Interactive process viewer
htop                      # Enhanced process viewer
kill -9 PID               # Force kill process
killall process_name      # Kill all processes by name
```

### Service Management
```bash
systemctl status nginx    # Check service status
systemctl start nginx     # Start service
systemctl stop nginx      # Stop service
systemctl restart nginx   # Restart service
systemctl enable nginx    # Enable service at boot
systemctl disable nginx   # Disable service at boot
journalctl -u nginx -f    # Follow service logs
journalctl -xe            # Show recent system logs
```

---

## 🌐 Networking and DNS

### Network Configuration
```bash
ip a                      # Show IP addresses
ip r                      # Show routing table
ss -tulpen                # Show listening ports
netstat -tulpn            # Show network connections (if installed)
```

### Network Testing
```bash
curl -I http://localhost  # HTTP HEAD request
telnet host 80            # Test TCP connection
nc -zv host 80            # Test port connectivity
ping host                 # Test connectivity
traceroute host           # Trace network path
```

### DNS Resolution
```bash
dig domain +short         # DNS lookup
nslookup domain           # Interactive DNS lookup
host domain               # Simple DNS lookup
```

---

## 🔥 Firewall and Security

### Firewall Management
```bash
# UFW (Ubuntu)
ufw status                # Show firewall status
ufw allow 80              # Allow port 80
ufw deny 22               # Deny port 22

# firewalld (RHEL/CentOS)
firewall-cmd --list-all   # Show all rules
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --reload
```

### SELinux
```bash
getenforce                # Show SELinux status
setenforce 0              # Disable SELinux temporarily
semanage port -l          # List SELinux ports
ausearch -m AVC -ts recent # Search SELinux denials
```

---

## 📦 Package Management

### Amazon Linux/RHEL/CentOS
```bash
sudo yum update -y        # Update all packages
sudo yum install nginx -y # Install package
sudo yum remove nginx     # Remove package
sudo yum list installed   # List installed packages
sudo yum search nginx     # Search for packages
```

### Ubuntu/Debian
```bash
sudo apt update           # Update package list
sudo apt upgrade -y       # Upgrade packages
sudo apt install nginx -y # Install package
sudo apt remove nginx     # Remove package
sudo apt list --installed # List installed packages
```

### SUSE
```bash
sudo zypper refresh       # Refresh repositories
sudo zypper install nginx # Install package
sudo zypper remove nginx  # Remove package
sudo zypper search nginx  # Search for packages
```

---

## 📦 Archive and Transfer

### Compression and Archives
```bash
tar -czf archive.tar.gz /path    # Create compressed archive
tar -xzf archive.tar.gz          # Extract compressed archive
unzip file.zip                   # Extract ZIP file
zip -r archive.zip /path         # Create ZIP archive
```

### File Transfer
```bash
rsync -avz src/ dest/            # Sync directories
scp file user@host:/path         # Copy file via SSH
sftp user@host                   # Interactive SFTP
ssh -i key.pem ec2-user@IP       # SSH with key file
```

---

## 💾 Disks and Filesystems

### Disk Information
```bash
lsblk                           # List block devices
blkid                           # Show block device UUIDs
fdisk -l                        # List disk partitions
df -h                           # Show disk usage
du -sh *                        # Show directory sizes
```

### Mounting and Filesystems
```bash
mount                           # Show mounted filesystems
mount /dev/xvdf /mnt            # Mount device
umount /mnt                     # Unmount filesystem
growpart /dev/xvda 1            # Grow partition
resize2fs /dev/xvda1            # Resize ext filesystem
xfs_growfs /mnt                 # Resize XFS filesystem
```

### Swap Management
```bash
swapon -s                       # Show swap usage
swapon /dev/xvdf                # Enable swap
swapoff -a                      # Disable all swap
```

---

## 👥 Users and Sudo

### User Management
```bash
adduser username                # Add new user
usermod -aG wheel username      # Add user to wheel group
id username                     # Show user info
whoami                         # Show current user
getent passwd username          # Show user details
```

### Sudo Configuration
```bash
visudo                         # Edit sudoers file
sudo -l                        # List sudo privileges
sudo -u username command       # Run command as user
```

---

## 📊 Logs and Diagnostics

### System Logs
```bash
tail -f /var/log/messages      # Follow system messages
tail -f /var/log/syslog        # Follow system log
dmesg -T                       # Show kernel messages
last                           # Show login history
uptime                         # Show system uptime
```

### System Information
```bash
date                           # Show current date/time
env                            # Show environment variables
which command                  # Show command location
whereis command                # Show command locations
free -h                        # Show memory usage
```

---

## 🐚 Shell and Automation

### Script Execution
```bash
bash script.sh                 # Execute bash script
chmod +x script.sh             # Make script executable
./script.sh                    # Execute current directory script
```

### Scheduling
```bash
crontab -e                     # Edit crontab
crontab -l                     # List crontab entries
at now + 5 min -f script.sh    # Schedule job
atq                            # List scheduled jobs
```

### Environment
```bash
export VAR=value               # Set environment variable
echo $VAR                      # Display variable
source ~/.bashrc               # Reload bash configuration
```

---

## 🌐 Web Stack Management

### Web Server Management
```bash
nginx -t                       # Test nginx configuration
apachectl -t                   # Test Apache configuration
systemctl reload nginx         # Reload nginx configuration
systemctl reload httpd         # Reload Apache configuration
```

### Web Testing
```bash
curl -v http://localhost/health # Test web endpoint
curl --resolve domain:80:IP http://domain # Test with custom DNS
openssl s_client -connect host:443 -servername host # Test SSL
```

---

## 🐳 Docker and Kubernetes

### Docker Commands
```bash
docker ps                      # List running containers
docker ps -a                   # List all containers
docker logs -f container       # Follow container logs
docker exec -it container sh   # Execute shell in container
docker images                  # List images
docker build -t image .        # Build image
docker run -d -p 80:80 image   # Run container
```

### Kubernetes Commands
```bash
kubectl get pods -A            # List all pods
kubectl get services -A        # List all services
kubectl logs -f pod -n ns      # Follow pod logs
kubectl describe svc name -n ns # Describe service
kubectl apply -f file.yaml     # Apply configuration
kubectl delete -f file.yaml    # Delete resources
kubectl port-forward svc/name 8080:80 # Port forward
```

---

## ☁️ AWS-Specific Commands

### AWS CLI
```bash
aws configure                  # Configure AWS CLI
aws s3 ls                      # List S3 buckets
aws ec2 describe-instances     # List EC2 instances
aws sts get-caller-identity    # Show current identity
```

### EC2 Metadata
```bash
curl http://169.254.169.254/latest/meta-data/           # Get instance metadata
curl http://169.254.169.254/latest/meta-data/instance-id # Get instance ID
curl http://169.254.169.254/latest/meta-data/public-ipv4 # Get public IP
```

### AWS Tools
```bash
aws-iam-authenticator token -i cluster-name              # Get EKS token
aws eks update-kubeconfig --name cluster-name --region region # Update kubeconfig
```

---

## 🎯 Quick Reference

### Most Used Commands
```bash
# File operations
ls -la | grep pattern         # Find files matching pattern
find . -name "*.log" -exec rm {} \;  # Remove all .log files
tar -czf backup.tar.gz /important/dir  # Create backup

# Process management
ps aux | grep nginx           # Find nginx processes
kill $(pgrep nginx)           # Kill all nginx processes

# Network troubleshooting
netstat -tulpn | grep :80     # Check what's using port 80
curl -I http://localhost      # Test web server
ping -c 4 google.com          # Test connectivity

# System monitoring
top -p $(pgrep nginx)         # Monitor nginx processes
df -h | grep -E '^/dev'       # Show disk usage
free -h                       # Show memory usage
```

---

## 📚 Additional Resources

- [Linux Command Library](https://linuxcommandlibrary.com/)
- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/)
- [AWS CLI User Guide](https://docs.aws.amazon.com/cli/latest/userguide/)
- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

---

**💡 Pro Tips:**
- Use `man command` to get detailed help for any command
- Use `command --help` for quick help
- Use `history | grep pattern` to find previously used commands
- Use `Ctrl+R` for reverse search in bash history
- Use `Tab` for command completion

**Last Updated:** January 2025  
**Version:** 1.0  
**Author:** Neeraj Kumar
