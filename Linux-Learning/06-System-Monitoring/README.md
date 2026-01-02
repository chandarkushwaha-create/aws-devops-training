# 06 - System Monitoring

## 📊 System Performance Overview

### uptime (System Load)
```bash
# Show system uptime and load average
uptime

# Continuous monitoring
watch -n 1 uptime

# Load average interpretation:
# - Values represent 1, 5, and 15-minute averages
# - Values equal to CPU cores = 100% utilization
# - Values > CPU cores = overloaded system
# - Values < CPU cores = underutilized system
```

### vmstat (Virtual Memory Statistics)
```bash
# Show current statistics
vmstat

# Continuous monitoring (every 2 seconds)
vmstat 2

# Show statistics 5 times with 2-second intervals
vmstat 2 5

# Show memory statistics in MB
vmstat -S M

# Show disk statistics
vmstat -d

# Show partition statistics
vmstat -p /dev/sda1
```

### iostat (I/O Statistics)
```bash
# Install sysstat package
sudo apt install sysstat  # Ubuntu/Debian
sudo yum install sysstat  # CentOS/RHEL

# Show I/O statistics
iostat

# Continuous monitoring
iostat 2

# Show extended statistics
iostat -x

# Show statistics for specific device
iostat -x /dev/sda

# Show CPU and I/O statistics
iostat -c -d

# Human readable format
iostat -h
```

## 💾 Memory Monitoring

### free (Memory Usage)
```bash
# Show memory usage
free

# Human readable format
free -h

# Show in MB
free -m

# Show in GB
free -g

# Continuous monitoring
free -h -s 2

# Show total line
free -h -t

# Wide format
free -w
```

### /proc/meminfo (Detailed Memory Info)
```bash
# Show detailed memory information
cat /proc/meminfo

# Show specific memory metrics
grep -E "(MemTotal|MemFree|MemAvailable|Buffers|Cached)" /proc/meminfo

# Calculate memory usage percentage
awk '/MemTotal/ {total=$2} /MemAvailable/ {available=$2} END {used=total-available; print "Memory Usage: " used/total*100 "%"}' /proc/meminfo
```

### ps (Memory Usage by Process)
```bash
# Show processes sorted by memory usage
ps aux --sort=-%mem | head -10

# Show memory usage in MB
ps aux --no-headers | awk '{print $6/1024 " MB\t" $11}' | sort -n

# Show total memory usage by command
ps aux --no-headers | awk '{mem[$11] += $6} END {for (cmd in mem) print mem[cmd]/1024 " MB\t" cmd}' | sort -n
```

## 💿 Disk Monitoring

### df (Disk Space Usage)
```bash
# Show disk usage
df

# Human readable format
df -h

# Show inode usage
df -i

# Show specific filesystem type
df -t ext4

# Exclude specific filesystem type
df -x tmpfs

# Show filesystem type
df -T

# Show only local filesystems
df -l
```

### du (Directory Usage)
```bash
# Show directory size
du /path/to/directory

# Human readable format
du -h /path/to/directory

# Show total size only
du -sh /path/to/directory

# Show sizes of subdirectories
du -h --max-depth=1 /path/to/directory

# Sort by size
du -h /path/to/directory | sort -hr

# Show largest directories
du -h / 2>/dev/null | sort -hr | head -20

# Exclude certain directories
du -h --exclude="*.tmp" /path/to/directory
```

### lsblk (List Block Devices)
```bash
# Show block devices
lsblk

# Show filesystem information
lsblk -f

# Show device permissions
lsblk -m

# Show device topology
lsblk -t

# Show specific device
lsblk /dev/sda
```

### fdisk (Disk Partitions)
```bash
# List all partitions
sudo fdisk -l

# Show specific disk partitions
sudo fdisk -l /dev/sda

# Show partition sizes in sectors
sudo fdisk -s /dev/sda1
```

## 🌡️ System Temperature and Hardware

### sensors (Hardware Sensors)
```bash
# Install lm-sensors
sudo apt install lm-sensors  # Ubuntu/Debian
sudo yum install lm_sensors  # CentOS/RHEL

# Detect sensors
sudo sensors-detect

# Show sensor readings
sensors

# Show specific sensor
sensors coretemp-isa-0000

# Continuous monitoring
watch -n 2 sensors
```

### lscpu (CPU Information)
```bash
# Show CPU information
lscpu

# Show CPU architecture
lscpu | grep Architecture

# Show number of CPUs
lscpu | grep "CPU(s):"

# Show CPU frequency
lscpu | grep MHz
```

### lshw (Hardware Information)
```bash
# Install lshw
sudo apt install lshw  # Ubuntu/Debian
sudo yum install lshw  # CentOS/RHEL

# Show all hardware information
sudo lshw

# Show short format
sudo lshw -short

# Show specific hardware class
sudo lshw -class memory
sudo lshw -class processor
sudo lshw -class disk

# Output in HTML format
sudo lshw -html > hardware.html
```

## 📈 Performance Monitoring Tools

### sar (System Activity Reporter)
```bash
# Show CPU usage
sar -u

# Show memory usage
sar -r

# Show I/O statistics
sar -b

# Show network statistics
sar -n DEV

# Show load average
sar -q

# Historical data (from specific time)
sar -u -s 10:00:00 -e 12:00:00

# Save data to file
sar -u -o /tmp/sar.data 2 10

# Read data from file
sar -u -f /tmp/sar.data
```

### dstat (Versatile System Statistics)
```bash
# Install dstat
sudo apt install dstat  # Ubuntu/Debian
sudo yum install dstat  # CentOS/RHEL

# Show default statistics
dstat

# Show CPU, memory, disk, network
dstat -cdnm

# Show top CPU and memory processes
dstat --top-cpu --top-mem

# Show disk I/O for specific disk
dstat -d -D sda

# Output to CSV file
dstat --output /tmp/dstat.csv
```

### nmon (System Monitor)
```bash
# Install nmon
sudo apt install nmon  # Ubuntu/Debian
sudo yum install nmon  # CentOS/RHEL

# Start nmon
nmon

# nmon interactive keys:
# c: CPU usage
# m: Memory usage
# d: Disk I/O
# n: Network I/O
# t: Top processes
# q: Quit

# Record data to file
nmon -f -s 10 -c 360  # Every 10 seconds for 1 hour
```

## 📊 Log File Monitoring

### tail (Monitor Log Files)
```bash
# Follow log file
tail -f /var/log/syslog

# Follow multiple log files
tail -f /var/log/syslog /var/log/auth.log

# Follow with line numbers
tail -n +1 -f /var/log/syslog

# Follow and highlight patterns
tail -f /var/log/syslog | grep --color=always ERROR
```

### journalctl (SystemD Logs)
```bash
# Show all logs
journalctl

# Show logs for specific service
journalctl -u service_name

# Follow logs in real-time
journalctl -f

# Show logs since specific time
journalctl --since "2024-01-01 10:00:00"
journalctl --since yesterday
journalctl --since "1 hour ago"

# Show logs with specific priority
journalctl -p err

# Show kernel messages
journalctl -k

# Show logs in JSON format
journalctl -o json

# Show disk usage of logs
journalctl --disk-usage

# Clean old logs
sudo journalctl --vacuum-time=30d
sudo journalctl --vacuum-size=100M
```

### logrotate (Log Rotation)
```bash
# Check logrotate configuration
cat /etc/logrotate.conf

# Show logrotate status
cat /var/lib/logrotate/status

# Test logrotate configuration
sudo logrotate -d /etc/logrotate.conf

# Force log rotation
sudo logrotate -f /etc/logrotate.conf

# Example logrotate configuration:
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
```

## 🔍 Process and Resource Analysis

### pmap (Process Memory Map)
```bash
# Show memory map of process
pmap PID

# Show extended information
pmap -x PID

# Show device information
pmap -d PID

# Show memory usage summary
pmap -X PID
```

### pidstat (Process Statistics)
```bash
# Show CPU usage by process
pidstat

# Show I/O statistics by process
pidstat -d

# Show memory statistics by process
pidstat -r

# Show statistics for specific process
pidstat -p PID

# Continuous monitoring
pidstat 2 5

# Show command line
pidstat -l
```

### iotop (I/O Monitor)
```bash
# Install iotop
sudo apt install iotop  # Ubuntu/Debian
sudo yum install iotop  # CentOS/RHEL

# Start iotop
sudo iotop

# iotop options:
# -o: Show only processes with I/O activity
# -a: Show accumulated I/O
# -d: Delay between updates
# -p: Monitor specific PID

# Monitor specific process
sudo iotop -p PID

# Show accumulated I/O
sudo iotop -a
```

## 🌐 Network Monitoring

### netstat (Network Statistics)
```bash
# Show all connections
netstat -a

# Show listening ports
netstat -l

# Show TCP connections
netstat -t

# Show UDP connections
netstat -u

# Show process names
netstat -p

# Show numerical addresses
netstat -n

# Combined options
netstat -tulpn

# Show routing table
netstat -r

# Show interface statistics
netstat -i
```

### ss (Socket Statistics)
```bash
# Show all sockets
ss -a

# Show listening sockets
ss -l

# Show TCP sockets
ss -t

# Show UDP sockets
ss -u

# Show process information
ss -p

# Show numerical addresses
ss -n

# Combined options
ss -tulpn

# Show sockets for specific port
ss -tulpn | grep :80

# Show socket memory usage
ss -m
```

### iftop (Network Interface Monitor)
```bash
# Install iftop
sudo apt install iftop  # Ubuntu/Debian
sudo yum install iftop  # CentOS/RHEL

# Monitor default interface
sudo iftop

# Monitor specific interface
sudo iftop -i eth0

# Show port numbers
sudo iftop -P

# Show bandwidth in bytes
sudo iftop -B
```

## 🎯 Monitoring Scripts and Automation

### System Health Check Script
```bash
#!/bin/bash
# system_health.sh

echo "=== System Health Check - $(date) ==="
echo

# CPU Load
echo "CPU Load Average:"
uptime | awk '{print $10, $11, $12}'
echo

# Memory Usage
echo "Memory Usage:"
free -h | grep -E "(Mem|Swap)"
echo

# Disk Usage
echo "Disk Usage:"
df -h | grep -vE '^Filesystem|tmpfs|cdrom'
echo

# Top CPU Processes
echo "Top 5 CPU Processes:"
ps aux --sort=-%cpu | head -6
echo

# Top Memory Processes
echo "Top 5 Memory Processes:"
ps aux --sort=-%mem | head -6
echo

# Network Connections
echo "Active Network Connections:"
ss -tulpn | wc -l
echo "connections"
```

### Alert Script for High Resource Usage
```bash
#!/bin/bash
# resource_alert.sh

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90

# Check CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo "ALERT: High CPU usage: $CPU_USAGE%"
fi

# Check memory usage
MEM_USAGE=$(free | grep Mem | awk '{printf("%.1f", $3/$2 * 100.0)}')
if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
    echo "ALERT: High memory usage: $MEM_USAGE%"
fi

# Check disk usage
df -h | awk 'NR>1 {gsub(/%/,"",$5); if($5 > '$DISK_THRESHOLD') print "ALERT: High disk usage on " $6 ": " $5"%"}'
```

## 🎤 Interview Questions

**Q1: What does a load average of 2.0 mean on a 4-core system?**
**A:** Load average of 2.0 on a 4-core system means the system is 50% utilized. The system can handle twice as much load before becoming fully utilized.

**Q2: How do you find which process is consuming the most memory?**
**A:** Use `ps aux --sort=-%mem | head -10` or `top` and press 'M' to sort by memory usage.

**Q3: What's the difference between buffers and cache in memory usage?**
**A:** Buffers are used for block device I/O operations, while cache stores frequently accessed file contents. Both can be freed if applications need more memory.

**Q4: How do you monitor disk I/O in real-time?**
**A:** Use `iostat -x 1` for continuous I/O statistics or `iotop` for per-process I/O monitoring.

**Q5: What command shows network connections and the processes using them?**
**A:** Use `netstat -tulpn` or `ss -tulpn` to show network connections with process information.

## 🎯 Key Takeaways

1. **System Overview**: Use `uptime`, `vmstat`, `iostat` for system performance overview
2. **Memory Monitoring**: Monitor with `free`, `/proc/meminfo`, and process memory usage
3. **Disk Monitoring**: Use `df`, `du`, `iostat` for disk space and I/O monitoring
4. **Process Analysis**: Use `top`, `htop`, `ps` for process monitoring
5. **Log Monitoring**: Use `tail`, `journalctl` for log file analysis
6. **Network Monitoring**: Use `netstat`, `ss`, `iftop` for network analysis
7. **Automation**: Create scripts for automated monitoring and alerting

---

**Next**: [07 - Networking](../07-Networking/) - Network configuration and troubleshooting