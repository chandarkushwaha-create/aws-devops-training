# 05 - Process Management

## 🔄 Process Basics

### Understanding Processes
- **Process**: Running instance of a program
- **PID**: Process ID (unique identifier)
- **PPID**: Parent Process ID
- **Process States**: Running, Sleeping, Stopped, Zombie

### Process Types
- **Foreground**: Interactive processes
- **Background**: Non-interactive processes
- **Daemon**: System service processes
- **Zombie**: Terminated but not cleaned up

## 📊 Process Monitoring Commands

### ps (Process Status)
```bash
# Show processes for current user
ps

# Show all processes
ps aux

# Show processes in tree format
ps auxf

# Show processes for specific user
ps -u username

# Show processes by command name
ps -C command_name

# Custom format output
ps -eo pid,ppid,cmd,pcpu,pmem

# Show threads
ps -eLf

# Show process hierarchy
ps -ejH

# Real-time process monitoring
ps aux --sort=-%cpu | head -10
```

### top (Real-time Process Monitor)
```bash
# Start top
top

# Top navigation keys:
# q: Quit
# k: Kill process (enter PID)
# r: Renice process
# P: Sort by CPU usage
# M: Sort by memory usage
# T: Sort by time
# u: Show specific user processes
# 1: Show individual CPU cores
# h: Help

# Run top with specific options
top -u username     # Show specific user
top -p PID         # Monitor specific process
top -d 2           # Update every 2 seconds
```

### htop (Enhanced Process Monitor)
```bash
# Install htop
sudo apt install htop  # Ubuntu/Debian
sudo yum install htop  # CentOS/RHEL

# Start htop
htop

# htop features:
# F1: Help
# F2: Setup
# F3: Search
# F4: Filter
# F5: Tree view
# F6: Sort by
# F9: Kill process
# F10: Quit
```

### pstree (Process Tree)
```bash
# Show process tree
pstree

# Show PIDs
pstree -p

# Show specific user's processes
pstree username

# Show process arguments
pstree -a

# Highlight specific process
pstree -H PID
```

## 🎮 Process Control

### Job Control
```bash
# Run command in background
command &

# List active jobs
jobs

# Bring job to foreground
fg %1

# Send job to background
bg %1

# Kill job
kill %1

# Suspend current process
Ctrl+Z

# Resume suspended process
fg
bg
```

### Process Signals
```bash
# Common signals:
# SIGTERM (15): Graceful termination
# SIGKILL (9): Force kill
# SIGSTOP (19): Stop process
# SIGCONT (18): Continue process
# SIGHUP (1): Hangup (reload config)

# Send signal to process
kill -SIGNAL PID
kill -15 1234      # SIGTERM
kill -9 1234       # SIGKILL
kill -HUP 1234     # SIGHUP

# Kill by process name
killall process_name
killall -9 process_name

# Kill processes matching pattern
pkill pattern
pkill -f "full command line"

# Interactive process killer
kill -9 $(ps aux | grep process_name | grep -v grep | awk '{print $2}')
```

### nohup (No Hangup)
```bash
# Run command immune to hangups
nohup command &

# Output goes to nohup.out by default
nohup command > output.log 2>&1 &

# Check nohup processes
ps aux | grep -v grep | grep nohup
```

## ⚙️ System Services Management

### systemctl (SystemD Service Control)
```bash
# Start service
sudo systemctl start service_name

# Stop service
sudo systemctl stop service_name

# Restart service
sudo systemctl restart service_name

# Reload service configuration
sudo systemctl reload service_name

# Enable service (start at boot)
sudo systemctl enable service_name

# Disable service
sudo systemctl disable service_name

# Check service status
systemctl status service_name

# List all services
systemctl list-units --type=service

# List enabled services
systemctl list-unit-files --type=service --state=enabled

# List failed services
systemctl --failed

# Show service dependencies
systemctl list-dependencies service_name

# Mask service (prevent starting)
sudo systemctl mask service_name

# Unmask service
sudo systemctl unmask service_name
```

### service (SysV Service Control)
```bash
# Start service
sudo service service_name start

# Stop service
sudo service service_name stop

# Restart service
sudo service service_name restart

# Check service status
sudo service service_name status

# List all services
service --status-all
```

## 📅 Process Scheduling

### cron (Scheduled Tasks)
```bash
# Edit user's crontab
crontab -e

# List user's crontab
crontab -l

# Remove user's crontab
crontab -r

# Edit another user's crontab (as root)
sudo crontab -e -u username

# Crontab format:
# * * * * * command
# | | | | |
# | | | | +-- Day of week (0-7, Sunday=0 or 7)
# | | | +---- Month (1-12)
# | | +------ Day of month (1-31)
# | +-------- Hour (0-23)
# +---------- Minute (0-59)

# Examples:
# Run every minute
* * * * * /path/to/script.sh

# Run at 2:30 AM daily
30 2 * * * /path/to/backup.sh

# Run every Monday at 9 AM
0 9 * * 1 /path/to/weekly_task.sh

# Run on 1st of every month
0 0 1 * * /path/to/monthly_task.sh

# Run every 5 minutes
*/5 * * * * /path/to/frequent_task.sh
```

### at (One-time Scheduled Tasks)
```bash
# Schedule command for specific time
at 14:30
at> /path/to/script.sh
at> Ctrl+D

# Schedule for specific date and time
at 2:30 PM tomorrow
at 9:00 AM next Monday
at now + 1 hour
at now + 30 minutes

# List scheduled jobs
atq

# Remove scheduled job
atrm job_number

# View job details
at -c job_number
```

### batch (Run When System Load is Low)
```bash
# Schedule batch job
batch
at> /path/to/cpu_intensive_task.sh
at> Ctrl+D

# Set load average threshold
batch -q b  # Use queue 'b'
```

## 🔍 Process Analysis

### lsof (List Open Files)
```bash
# List all open files
lsof

# List files opened by specific process
lsof -p PID

# List files opened by specific user
lsof -u username

# List processes using specific file
lsof /path/to/file

# List processes using specific directory
lsof +D /path/to/directory

# List network connections
lsof -i

# List specific port usage
lsof -i :80
lsof -i :22

# List TCP connections
lsof -i tcp

# List UDP connections
lsof -i udp
```

### strace (System Call Trace)
```bash
# Trace system calls of running process
strace -p PID

# Trace system calls of new process
strace command

# Trace specific system calls
strace -e open,read,write command

# Save trace to file
strace -o trace.log command

# Show time stamps
strace -t command

# Count system calls
strace -c command
```

### pgrep/pkill (Process Grep/Kill)
```bash
# Find processes by name
pgrep process_name

# Find processes by full command line
pgrep -f "full command"

# Find processes by user
pgrep -u username

# Show process names with PIDs
pgrep -l process_name

# Kill processes by name
pkill process_name

# Kill processes by user
pkill -u username

# Kill processes with signal
pkill -9 process_name
```

## 🚀 Process Performance

### nice/renice (Process Priority)
```bash
# Run command with specific priority
nice -n 10 command        # Lower priority
nice -n -5 command        # Higher priority

# Change priority of running process
renice 10 PID             # Lower priority
renice -5 PID             # Higher priority

# Change priority by process name
renice 10 -p $(pgrep process_name)

# Change priority by user
renice 10 -u username

# Priority ranges: -20 (highest) to 19 (lowest)
# Default priority: 0
```

### ionice (I/O Priority)
```bash
# Set I/O priority for command
ionice -c 3 command       # Idle class
ionice -c 2 -n 4 command  # Best effort, priority 4

# Change I/O priority of running process
ionice -c 1 -n 2 -p PID   # Real-time, priority 2

# I/O Classes:
# 0: None (inherit from CPU priority)
# 1: Real-time (highest priority)
# 2: Best-effort (normal priority)
# 3: Idle (lowest priority)
```

## 🔧 Advanced Process Management

### Process Limits (ulimit)
```bash
# Show all limits
ulimit -a

# Show specific limits
ulimit -n    # File descriptors
ulimit -u    # Max processes
ulimit -m    # Memory
ulimit -f    # File size

# Set limits
ulimit -n 2048    # Set max file descriptors
ulimit -u 1000    # Set max processes

# Set limits in /etc/security/limits.conf
# username soft nofile 2048
# username hard nofile 4096
```

### Process Monitoring Scripts
```bash
#!/bin/bash
# Monitor high CPU processes

while true; do
    echo "=== $(date) ==="
    ps aux --sort=-%cpu | head -6
    echo
    sleep 5
done
```

```bash
#!/bin/bash
# Kill processes using too much memory

THRESHOLD=80  # 80% memory usage

ps aux --no-headers | awk '{print $2, $4, $11}' | while read pid mem cmd; do
    if (( $(echo "$mem > $THRESHOLD" | bc -l) )); then
        echo "Killing $cmd (PID: $pid, MEM: $mem%)"
        kill -15 $pid
    fi
done
```

## 🎯 Practical Process Management Scenarios

### Web Server Management
```bash
# Check Apache/Nginx processes
ps aux | grep -E "(apache|nginx|httpd)"

# Restart web server
sudo systemctl restart apache2
sudo systemctl restart nginx

# Monitor web server logs
tail -f /var/log/apache2/access.log
tail -f /var/log/nginx/access.log

# Check web server status
systemctl status apache2
systemctl status nginx
```

### Database Process Management
```bash
# Check MySQL processes
ps aux | grep mysql

# Monitor MySQL connections
mysqladmin processlist

# Restart MySQL
sudo systemctl restart mysql

# Check MySQL status
systemctl status mysql
```

### Application Deployment
```bash
# Deploy application with nohup
nohup java -jar application.jar > app.log 2>&1 &

# Check application process
ps aux | grep java

# Monitor application logs
tail -f app.log

# Gracefully stop application
pkill -15 java
```

## 🎤 Interview Questions

**Q1: What's the difference between kill and killall?**
**A:** `kill` terminates processes by PID, while `killall` terminates processes by name. `kill` is more precise, `killall` can affect multiple processes.

**Q2: What does the load average represent?**
**A:** Load average represents the average system load over 1, 5, and 15 minutes. Values above the number of CPU cores indicate system overload.

**Q3: How do you run a process that continues after logout?**
**A:** Use `nohup command &` or run the process in a screen/tmux session.

**Q4: What's the difference between SIGTERM and SIGKILL?**
**A:** SIGTERM (15) allows graceful shutdown with cleanup, while SIGKILL (9) immediately terminates the process without cleanup.

**Q5: How do you find which process is using a specific port?**
**A:** Use `lsof -i :port_number` or `netstat -tulpn | grep port_number`.

## 🎯 Key Takeaways

1. **Process Monitoring**: Use `ps`, `top`, `htop` for process visibility
2. **Process Control**: Master job control and signal handling
3. **Service Management**: Use `systemctl` for modern service management
4. **Scheduling**: Implement `cron` for recurring tasks, `at` for one-time tasks
5. **Performance**: Use `nice`/`renice` for process prioritization
6. **Troubleshooting**: Use `lsof`, `strace` for process analysis
7. **Automation**: Script common process management tasks

---

**Next**: [06 - System Monitoring](../06-System-Monitoring/) - Monitoring system performance and resources