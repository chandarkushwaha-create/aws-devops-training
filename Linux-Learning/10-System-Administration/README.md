# 10 - System Administration

## 🔧 System Services Management

### systemctl (SystemD Service Control)
```bash
# Service status
systemctl status service_name
systemctl is-active service_name
systemctl is-enabled service_name

# Start/stop services
sudo systemctl start service_name
sudo systemctl stop service_name
sudo systemctl restart service_name
sudo systemctl reload service_name

# Enable/disable services (auto-start)
sudo systemctl enable service_name
sudo systemctl disable service_name

# List all services
systemctl list-units --type=service
systemctl list-units --type=service --state=active
systemctl list-units --type=service --state=failed

# Show service dependencies
systemctl list-dependencies service_name

# Edit service configuration
sudo systemctl edit service_name

# Reload systemd configuration
sudo systemctl daemon-reload

# System targets (runlevels)
systemctl get-default
sudo systemctl set-default multi-user.target
systemctl list-units --type=target

# System control
sudo systemctl reboot
sudo systemctl poweroff
sudo systemctl suspend
sudo systemctl hibernate
```

### service (Legacy Service Control)
```bash
# Service status
service service_name status

# Start/stop services
sudo service service_name start
sudo service service_name stop
sudo service service_name restart
sudo service service_name reload

# List all services
service --status-all

# Enable/disable services (varies by distribution)
sudo chkconfig service_name on   # CentOS/RHEL
sudo chkconfig service_name off
sudo update-rc.d service_name enable   # Debian/Ubuntu
sudo update-rc.d service_name disable
```

## 📅 Task Scheduling

### cron (Scheduled Tasks)
```bash
# Edit user crontab
crontab -e

# List user crontab
crontab -l

# Remove user crontab
crontab -r

# Edit root crontab
sudo crontab -e

# Edit system-wide crontab
sudo nano /etc/crontab

# Crontab format: minute hour day month weekday command
# Examples:
0 2 * * *     /path/to/script.sh           # Daily at 2 AM
30 14 * * 1   /path/to/script.sh           # Every Monday at 2:30 PM
0 */6 * * *   /path/to/script.sh           # Every 6 hours
*/15 * * * *  /path/to/script.sh           # Every 15 minutes
0 0 1 * *     /path/to/script.sh           # First day of every month

# Special strings:
@reboot       /path/to/script.sh           # At startup
@yearly       /path/to/script.sh           # Once a year
@monthly      /path/to/script.sh           # Once a month
@weekly       /path/to/script.sh           # Once a week
@daily        /path/to/script.sh           # Once a day
@hourly       /path/to/script.sh           # Once an hour

# System cron directories
ls /etc/cron.d/        # Additional cron files
ls /etc/cron.daily/    # Daily scripts
ls /etc/cron.weekly/   # Weekly scripts
ls /etc/cron.monthly/  # Monthly scripts
ls /etc/cron.hourly/   # Hourly scripts

# Check cron logs
grep CRON /var/log/syslog
tail -f /var/log/cron
```

### at (One-time Tasks)
```bash
# Schedule one-time task
at 14:30
at> /path/to/script.sh
at> Ctrl+D

# Schedule with different time formats
at now + 5 minutes
at 2:30 PM tomorrow
at midnight
at noon next Friday

# List scheduled jobs
atq

# Remove scheduled job
atrm job_number

# Show job details
at -c job_number

# Allow/deny users
sudo nano /etc/at.allow
sudo nano /etc/at.deny
```

## 🗂️ Log Management

### Log Files Locations
```bash
# System logs
/var/log/syslog         # General system messages
/var/log/messages       # General system messages (CentOS/RHEL)
/var/log/auth.log       # Authentication logs
/var/log/secure         # Authentication logs (CentOS/RHEL)
/var/log/kern.log       # Kernel messages
/var/log/dmesg          # Boot messages
/var/log/boot.log       # Boot process logs

# Service logs
/var/log/apache2/       # Apache web server
/var/log/nginx/         # Nginx web server
/var/log/mysql/         # MySQL database
/var/log/postgresql/    # PostgreSQL database

# Application logs
/var/log/cron           # Cron job logs
/var/log/mail.log       # Mail server logs
/var/log/daemon.log     # System daemon logs
```

### journalctl (SystemD Logs)
```bash
# View all logs
journalctl

# Follow logs in real-time
journalctl -f

# Show logs for specific service
journalctl -u service_name
journalctl -u apache2.service

# Show logs since specific time
journalctl --since "2024-01-01 10:00:00"
journalctl --since yesterday
journalctl --since "1 hour ago"

# Show logs until specific time
journalctl --until "2024-01-01 12:00:00"

# Show logs with specific priority
journalctl -p err       # Error level and above
journalctl -p warning   # Warning level and above
journalctl -p info      # Info level and above

# Show kernel messages
journalctl -k

# Show boot messages
journalctl -b           # Current boot
journalctl -b -1        # Previous boot

# Show logs in reverse order
journalctl -r

# Show logs with line numbers
journalctl -n 50        # Last 50 lines

# Show logs in JSON format
journalctl -o json

# Show disk usage
journalctl --disk-usage

# Clean old logs
sudo journalctl --vacuum-time=30d    # Keep 30 days
sudo journalctl --vacuum-size=100M   # Keep 100MB
sudo journalctl --vacuum-files=5     # Keep 5 files

# Configure log retention
sudo nano /etc/systemd/journald.conf
# SystemMaxUse=100M
# SystemMaxFileSize=10M
# SystemMaxFiles=10
```

### logrotate (Log Rotation)
```bash
# Main configuration
cat /etc/logrotate.conf

# Service-specific configurations
ls /etc/logrotate.d/

# Test configuration
sudo logrotate -d /etc/logrotate.conf

# Force rotation
sudo logrotate -f /etc/logrotate.conf

# Check status
cat /var/lib/logrotate/status

# Example configuration (/etc/logrotate.d/myapp):
/var/log/myapp/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 644 myapp myapp
    postrotate
        systemctl reload myapp
    endscript
}

# Configuration options:
# daily/weekly/monthly - rotation frequency
# rotate N - keep N old files
# compress - compress old files
# delaycompress - compress on next rotation
# missingok - don't error if log missing
# notifempty - don't rotate empty files
# create mode owner group - create new log file
# postrotate/endscript - commands after rotation
```

## 🔐 System Security

### User Account Security
```bash
# Password policies
sudo nano /etc/login.defs
# PASS_MAX_DAYS 90
# PASS_MIN_DAYS 1
# PASS_WARN_AGE 7

# Account lockout
sudo nano /etc/pam.d/common-auth
# auth required pam_tally2.so deny=3 unlock_time=600

# Check locked accounts
sudo pam_tally2 --user username

# Unlock account
sudo pam_tally2 --user username --reset

# Force password change
sudo chage -d 0 username

# Set password expiry
sudo chage -M 90 username

# Check password status
sudo chage -l username
```

### SSH Security
```bash
# SSH configuration
sudo nano /etc/ssh/sshd_config

# Key security settings:
Port 2222                    # Change default port
PermitRootLogin no          # Disable root login
PasswordAuthentication no   # Use key-based auth only
MaxAuthTries 3              # Limit auth attempts
ClientAliveInterval 300     # Keep-alive interval
ClientAliveCountMax 2       # Max keep-alive messages

# Restart SSH service
sudo systemctl restart sshd

# Generate SSH keys
ssh-keygen -t rsa -b 4096
ssh-keygen -t ed25519

# Copy public key to server
ssh-copy-id user@server

# SSH agent for key management
eval $(ssh-agent)
ssh-add ~/.ssh/id_rsa

# SSH config file
nano ~/.ssh/config
# Host myserver
#     HostName 192.168.1.100
#     User myuser
#     Port 2222
#     IdentityFile ~/.ssh/id_rsa
```

### Firewall Management
```bash
# UFW (Uncomplicated Firewall)
sudo ufw enable
sudo ufw status verbose
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow from 192.168.1.0/24
sudo ufw deny 23
sudo ufw delete allow 80

# iptables (Advanced)
sudo iptables -L
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -P INPUT DROP

# Save iptables rules
sudo iptables-save > /etc/iptables/rules.v4
sudo ip6tables-save > /etc/iptables/rules.v6

# Fail2ban (Intrusion prevention)
sudo apt install fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Fail2ban configuration
sudo nano /etc/fail2ban/jail.local
# [DEFAULT]
# bantime = 3600
# findtime = 600
# maxretry = 3
# 
# [sshd]
# enabled = true
# port = ssh
# logpath = /var/log/auth.log

sudo fail2ban-client status
sudo fail2ban-client status sshd
```

## 💾 Backup and Recovery

### System Backup Strategies
```bash
# Full system backup with tar
sudo tar -czf /backup/system-$(date +%Y%m%d).tar.gz \
    --exclude=/proc \
    --exclude=/sys \
    --exclude=/dev \
    --exclude=/tmp \
    --exclude=/backup \
    /

# Incremental backup
sudo tar -czf /backup/incremental-$(date +%Y%m%d).tar.gz \
    --newer-mtime="2024-01-01" /home /etc /var

# Database backup
mysqldump -u root -p database_name > backup.sql
pg_dump database_name > backup.sql

# Rsync backup
rsync -avz --delete /source/ /destination/
rsync -avz --delete /home/ user@backup-server:/backups/home/

# Automated backup script
#!/bin/bash
# backup.sh
BACKUP_DIR="/backup"
DATE=$(date +%Y%m%d_%H%M%S)
SOURCE_DIRS="/home /etc /var/www"

for dir in $SOURCE_DIRS; do
    tar -czf "$BACKUP_DIR/$(basename $dir)-$DATE.tar.gz" "$dir"
done

# Clean old backups (keep 7 days)
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
```

### System Recovery
```bash
# Boot from rescue mode
# Add 'single' or 'rescue' to kernel parameters

# Reset root password
mount -o remount,rw /
passwd root
mount -o remount,ro /

# Repair filesystem
fsck /dev/sda1
fsck -y /dev/sda1  # Auto-repair

# Restore from backup
tar -xzf backup.tar.gz -C /

# GRUB recovery
sudo grub-install /dev/sda
sudo update-grub

# System restore points (LVM snapshots)
sudo lvcreate -L 1G -s -n root-snapshot /dev/vg0/root
sudo lvremove /dev/vg0/root-snapshot
```

## 📊 System Monitoring and Performance

### Performance Monitoring
```bash
# System load and uptime
uptime
w

# CPU usage
top
htop
iostat
sar -u 1 5

# Memory usage
free -h
vmstat 1 5
sar -r 1 5

# Disk usage and I/O
df -h
du -sh /*
iotop
sar -d 1 5

# Network monitoring
netstat -i
ss -tuln
iftop
nethogs

# Process monitoring
ps aux
pstree
lsof
```

### System Health Scripts
```bash
#!/bin/bash
# system_health.sh

echo "=== System Health Report - $(date) ==="
echo

# System uptime
echo "System Uptime:"
uptime
echo

# CPU load
echo "CPU Load Average:"
cat /proc/loadavg
echo

# Memory usage
echo "Memory Usage:"
free -h
echo

# Disk usage
echo "Disk Usage:"
df -h | grep -E '^/dev/'
echo

# Top processes by CPU
echo "Top 5 CPU Processes:"
ps aux --sort=-%cpu | head -6
echo

# Top processes by memory
echo "Top 5 Memory Processes:"
ps aux --sort=-%mem | head -6
echo

# Network connections
echo "Network Connections:"
ss -tuln | wc -l
echo

# Failed login attempts
echo "Failed Login Attempts (last 24h):"
grep "Failed password" /var/log/auth.log | grep "$(date '+%b %d')" | wc -l
echo

# System temperature (if available)
if command -v sensors &> /dev/null; then
    echo "System Temperature:"
    sensors | grep -E "(Core|temp)"
fi
```

## 🔄 System Updates and Maintenance

### Package Updates
```bash
# Ubuntu/Debian
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean

# CentOS/RHEL
sudo yum update -y
sudo yum autoremove -y
sudo yum clean all

# Security updates only
sudo apt upgrade -s | grep -i security
sudo yum --security update

# Automatic updates
sudo dpkg-reconfigure -plow unattended-upgrades  # Ubuntu
sudo nano /etc/yum.conf  # CentOS (yum-cron)
```

### System Maintenance Tasks
```bash
# Clean temporary files
sudo find /tmp -type f -atime +7 -delete
sudo find /var/tmp -type f -atime +30 -delete

# Clean log files
sudo find /var/log -name "*.log" -size +100M -exec truncate -s 0 {} \;

# Update locate database
sudo updatedb

# Update man pages
sudo mandb

# Check filesystem
sudo fsck -n /dev/sda1

# Defragment (ext4)
sudo e4defrag /

# Clean package cache
sudo apt clean
sudo yum clean all

# Update GRUB
sudo update-grub

# Rebuild initramfs
sudo update-initramfs -u
```

## 🎯 Automation Scripts

### System Maintenance Script
```bash
#!/bin/bash
# maintenance.sh

LOG_FILE="/var/log/maintenance.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

log_message() {
    echo "[$DATE] $1" | tee -a $LOG_FILE
}

log_message "Starting system maintenance"

# Update packages
log_message "Updating packages"
if command -v apt &> /dev/null; then
    apt update && apt upgrade -y
    apt autoremove -y
    apt autoclean
elif command -v yum &> /dev/null; then
    yum update -y
    yum autoremove -y
    yum clean all
fi

# Clean temporary files
log_message "Cleaning temporary files"
find /tmp -type f -atime +7 -delete 2>/dev/null
find /var/tmp -type f -atime +30 -delete 2>/dev/null

# Rotate logs
log_message "Rotating logs"
logrotate -f /etc/logrotate.conf

# Update databases
log_message "Updating system databases"
updatedb
mandb

# Check disk space
log_message "Checking disk space"
df -h | awk '$5 > 80 {print "Warning: " $1 " is " $5 " full"}'

log_message "System maintenance completed"
```

### Monitoring Script
```bash
#!/bin/bash
# monitor.sh

THRESHOLD_CPU=80
THRESHOLD_MEM=80
THRESHOLD_DISK=90
EMAIL="admin@example.com"

# Check CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
if (( $(echo "$CPU_USAGE > $THRESHOLD_CPU" | bc -l) )); then
    echo "High CPU usage: $CPU_USAGE%" | mail -s "CPU Alert" $EMAIL
fi

# Check memory usage
MEM_USAGE=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100.0)}')
if [ $MEM_USAGE -gt $THRESHOLD_MEM ]; then
    echo "High memory usage: $MEM_USAGE%" | mail -s "Memory Alert" $EMAIL
fi

# Check disk usage
df -h | awk '{if($5 > 90) print $1 " is " $5 " full"}' | while read line; do
    echo "High disk usage: $line" | mail -s "Disk Alert" $EMAIL
done
```

## 📚 Interview Questions & Answers

### Fresher Level (1-10)

**Q1: What is systemctl and how is it different from service command?**
A: systemctl is the modern SystemD service manager, while service is the legacy SysV init command. systemctl provides more features like dependency management, parallel startup, and better logging. Example: `systemctl start apache2` vs `service apache2 start`.

**Q2: How do you schedule a task to run daily at 2 AM?**
A: Use crontab: `crontab -e` then add `0 2 * * * /path/to/script.sh`. The format is minute(0) hour(2) day(*) month(*) weekday(*) command.

**Q3: Where are system logs typically stored in Linux?**
A: Main logs are in /var/log/: syslog (general), auth.log (authentication), kern.log (kernel), messages (CentOS/RHEL). SystemD systems also use journalctl for centralized logging.

**Q4: How do you check which services are running on your system?**
A: Use `systemctl list-units --type=service --state=active` for SystemD or `service --status-all` for SysV. Also `ps aux` shows all running processes.

**Q5: What is the purpose of logrotate?**
A: logrotate manages log files by rotating, compressing, and deleting old logs to prevent disk space issues. Configuration is in /etc/logrotate.conf and /etc/logrotate.d/.

### Intermediate Level (6-15)

**Q6: How do you secure SSH access on a Linux server?**
A: Change default port, disable root login, use key-based authentication, limit max auth tries, configure fail2ban, and use strong ciphers. Edit /etc/ssh/sshd_config and restart sshd service.

**Q7: Explain the difference between cron and at commands.**
A: cron schedules recurring tasks using crontab entries, while at schedules one-time tasks. cron runs continuously, at executes once at specified time. Use cron for regular backups, at for temporary tasks.

**Q8: How do you monitor system performance in Linux?**
A: Use tools like top/htop (processes), iostat (I/O), vmstat (memory), sar (historical data), netstat/ss (network), and df/du (disk usage). Create monitoring scripts for automated alerts.

**Q9: What are the steps to recover a system with forgotten root password?**
A: Boot into single-user mode, remount root filesystem as read-write (`mount -o remount,rw /`), change password (`passwd root`), remount as read-only, and reboot normally.

**Q10: How do you implement automated system backups?**
A: Create backup scripts using tar/rsync, schedule with cron, implement rotation policy, test restore procedures, and monitor backup success. Store backups on separate systems or cloud storage.

## 🔑 Key Takeaways

- **Automation**: Automate routine tasks with scripts and cron jobs
- **Monitoring**: Implement comprehensive system monitoring and alerting
- **Security**: Follow security best practices for services, users, and network access
- **Backup Strategy**: Regular backups with tested restore procedures are essential
- **Documentation**: Keep detailed logs and documentation of system changes
- **Proactive Maintenance**: Regular updates and maintenance prevent major issues