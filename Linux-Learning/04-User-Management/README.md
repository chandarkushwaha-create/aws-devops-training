# 04 - User Management

## 👤 User Account Management

### useradd (Add User)
```bash
# Basic user creation
sudo useradd username

# Create user with home directory
sudo useradd -m username

# Create user with specific shell
sudo useradd -s /bin/bash username

# Create user with specific home directory
sudo useradd -d /custom/home/path username

# Create user with specific UID
sudo useradd -u 1500 username

# Create user with specific group
sudo useradd -g groupname username

# Create user with multiple groups
sudo useradd -G group1,group2,group3 username

# Create system user (no home directory)
sudo useradd -r systemuser

# Create user with expiration date
sudo useradd -e 2024-12-31 username

# Create user with comment
sudo useradd -c "Full Name" username

# Complete user creation example
sudo useradd -m -s /bin/bash -c "John Doe" -G sudo,developers john
```

### usermod (Modify User)
```bash
# Change user's shell
sudo usermod -s /bin/zsh username

# Change user's home directory
sudo usermod -d /new/home/path username

# Move home directory
sudo usermod -d /new/home/path -m username

# Change user's UID
sudo usermod -u 1600 username

# Change user's primary group
sudo usermod -g newgroup username

# Add user to additional groups
sudo usermod -a -G group1,group2 username

# Replace user's groups
sudo usermod -G group1,group2 username

# Lock user account
sudo usermod -L username

# Unlock user account
sudo usermod -U username

# Set account expiration
sudo usermod -e 2024-12-31 username

# Change user's comment
sudo usermod -c "New Full Name" username
```

### userdel (Delete User)
```bash
# Delete user (keep home directory)
sudo userdel username

# Delete user and home directory
sudo userdel -r username

# Force delete user (even if logged in)
sudo userdel -f username

# Delete user and all files owned by user
sudo userdel -r username
sudo find / -user username -delete 2>/dev/null
```

## 🔑 Password Management

### passwd (Change Password)
```bash
# Change your own password
passwd

# Change another user's password (as root)
sudo passwd username

# Force password change on next login
sudo passwd -e username

# Lock user account
sudo passwd -l username

# Unlock user account
sudo passwd -u username

# Delete user's password (passwordless login)
sudo passwd -d username

# Show password status
sudo passwd -S username

# Set password expiration
sudo passwd -x 90 username    # Expire in 90 days
sudo passwd -n 7 username     # Minimum 7 days between changes
sudo passwd -w 7 username     # Warning 7 days before expiration
```

### chage (Change Age Information)
```bash
# Show password aging information
sudo chage -l username

# Set password expiration date
sudo chage -E 2024-12-31 username

# Set maximum password age (days)
sudo chage -M 90 username

# Set minimum password age (days)
sudo chage -m 7 username

# Set warning period (days)
sudo chage -W 7 username

# Force password change on next login
sudo chage -d 0 username

# Set inactive period after password expiration
sudo chage -I 30 username

# Interactive mode
sudo chage username
```

## 👥 Group Management

### groupadd (Add Group)
```bash
# Create new group
sudo groupadd groupname

# Create group with specific GID
sudo groupadd -g 2000 groupname

# Create system group
sudo groupadd -r systemgroup
```

### groupmod (Modify Group)
```bash
# Change group name
sudo groupmod -n newname oldname

# Change group GID
sudo groupmod -g 2500 groupname
```

### groupdel (Delete Group)
```bash
# Delete group
sudo groupdel groupname

# Note: Cannot delete if it's a user's primary group
```

### gpasswd (Group Password and Administration)
```bash
# Add user to group
sudo gpasswd -a username groupname

# Remove user from group
sudo gpasswd -d username groupname

# Set group administrators
sudo gpasswd -A admin1,admin2 groupname

# Set group members
sudo gpasswd -M user1,user2,user3 groupname

# Remove all members from group
sudo gpasswd -M "" groupname
```

## 📋 User and Group Information

### id (User and Group IDs)
```bash
# Show current user's ID information
id

# Show specific user's ID information
id username

# Show only user ID
id -u username

# Show only group ID
id -g username

# Show all group IDs
id -G username

# Show names instead of numbers
id -un username  # Username
id -gn username  # Primary group name
id -Gn username  # All group names
```

### who/w (Logged in Users)
```bash
# Show who is logged in
who

# Show detailed information
w

# Show only usernames
who -q

# Show login time
who -u

# Show system boot time
who -b

# Show current runlevel
who -r
```

### last (Login History)
```bash
# Show login history
last

# Show specific user's login history
last username

# Show last n entries
last -n 10

# Show logins since specific date
last -s yesterday

# Show failed login attempts
lastb
```

### users (Currently Logged Users)
```bash
# Show currently logged in users
users

# Count logged in users
users | wc -w
```

## 🏠 Home Directory Management

### mkhomedir_helper (Create Home Directory)
```bash
# Create home directory for existing user
sudo mkhomedir_helper username

# Set proper permissions
sudo chmod 755 /home/username
sudo chown username:username /home/username
```

### Skeleton Directory (/etc/skel)
```bash
# View skeleton directory contents
ls -la /etc/skel/

# Add files to skeleton (affects new users)
sudo cp .bashrc_custom /etc/skel/

# Manually copy skeleton to existing user
sudo cp -r /etc/skel/. /home/username/
sudo chown -R username:username /home/username/
```

## 🔐 Sudo Configuration

### visudo (Edit Sudo Configuration)
```bash
# Edit sudoers file safely
sudo visudo

# Common sudoers entries:
# Allow user to run all commands
username ALL=(ALL:ALL) ALL

# Allow user to run commands without password
username ALL=(ALL) NOPASSWD: ALL

# Allow group to run all commands
%groupname ALL=(ALL:ALL) ALL

# Allow user to run specific commands
username ALL=(ALL) /usr/bin/systemctl, /usr/bin/service

# Allow user to run commands as specific user
username ALL=(otheruser) ALL
```

### sudo Usage
```bash
# Run command as root
sudo command

# Run command as specific user
sudo -u username command

# Switch to root shell
sudo -i
sudo su -

# Run command with environment preserved
sudo -E command

# List sudo privileges
sudo -l

# Validate sudo credentials
sudo -v

# Clear sudo credentials
sudo -k
```

## 📁 User Configuration Files

### /etc/passwd (User Database)
```bash
# View user database
cat /etc/passwd

# Format: username:password:UID:GID:comment:home:shell
# Example: john:x:1000:1000:John Doe:/home/john:/bin/bash

# Search for specific user
grep username /etc/passwd

# Show only usernames
cut -d: -f1 /etc/passwd

# Show users with specific shell
grep "/bin/bash" /etc/passwd
```

### /etc/shadow (Password Database)
```bash
# View password database (root only)
sudo cat /etc/shadow

# Format: username:encrypted_password:last_change:min:max:warn:inactive:expire:reserved

# Check password status
sudo grep username /etc/shadow
```

### /etc/group (Group Database)
```bash
# View group database
cat /etc/group

# Format: groupname:password:GID:members
# Example: developers:x:1001:john,jane,mike

# Show groups for user
groups username

# Show all groups
cut -d: -f1 /etc/group
```

### /etc/gshadow (Group Shadow)
```bash
# View group shadow file (root only)
sudo cat /etc/gshadow

# Format: groupname:encrypted_password:administrators:members
```

## 🎯 Practical User Management Scenarios

### Creating Development Team
```bash
# Create development group
sudo groupadd developers

# Create users and add to group
sudo useradd -m -s /bin/bash -G developers alice
sudo useradd -m -s /bin/bash -G developers bob
sudo useradd -m -s /bin/bash -G developers charlie

# Set passwords
sudo passwd alice
sudo passwd bob
sudo passwd charlie

# Create shared directory
sudo mkdir /opt/projects
sudo chgrp developers /opt/projects
sudo chmod 775 /opt/projects
sudo chmod g+s /opt/projects  # SGID for group inheritance
```

### Service Account Creation
```bash
# Create system user for service
sudo useradd -r -s /bin/false -d /opt/myapp myapp

# Create service directories
sudo mkdir -p /opt/myapp/{bin,config,logs}
sudo chown -R myapp:myapp /opt/myapp

# Set appropriate permissions
sudo chmod 755 /opt/myapp
sudo chmod 750 /opt/myapp/config
sudo chmod 755 /opt/myapp/logs
```

### Temporary User Account
```bash
# Create temporary user with expiration
sudo useradd -m -e $(date -d "+30 days" +%Y-%m-%d) tempuser
sudo passwd tempuser

# Set password to expire immediately (force change)
sudo chage -d 0 tempuser
```

### Bulk User Creation
```bash
#!/bin/bash
# Script to create multiple users

users=("user1" "user2" "user3" "user4")
group="newusers"

# Create group
sudo groupadd $group

# Create users
for user in "${users[@]}"; do
    sudo useradd -m -s /bin/bash -G $group $user
    echo "Created user: $user"
    
    # Generate random password
    password=$(openssl rand -base64 12)
    echo "$user:$password" | sudo chpasswd
    echo "Password for $user: $password"
done
```

## 🔍 User Monitoring and Auditing

### Active User Monitoring
```bash
# Show currently logged in users
who -u

# Show user activity
w

# Show login history
last -n 20

# Show failed login attempts
sudo lastb -n 10

# Monitor user logins in real-time
sudo tail -f /var/log/auth.log | grep "session opened"
```

### User Account Auditing
```bash
# Find users with UID 0 (root privileges)
awk -F: '$3 == 0 {print $1}' /etc/passwd

# Find users with empty passwords
sudo awk -F: '$2 == "" {print $1}' /etc/shadow

# Find users with no home directory
awk -F: '{print $1, $6}' /etc/passwd | while read user home; do
    [ ! -d "$home" ] && echo "No home: $user"
done

# Find inactive users (no recent login)
lastlog | awk '$2 == "**Never" {print $1}'

# Check password expiration
sudo chage -l username
```

## 🎤 Interview Questions

**Q1: What's the difference between `useradd` and `adduser`?**
**A:** `useradd` is the low-level utility that creates users with minimal setup. `adduser` is a higher-level script that provides interactive user creation with home directory, password setup, etc.

**Q2: How do you add a user to the sudo group?**
**A:** Use `sudo usermod -a -G sudo username` or `sudo gpasswd -a username sudo`.

**Q3: What's the difference between `/etc/passwd` and `/etc/shadow`?**
**A:** `/etc/passwd` contains user account information (readable by all), while `/etc/shadow` contains encrypted passwords and password aging info (readable by root only).

**Q4: How do you create a system user?**
**A:** Use `sudo useradd -r username`. System users typically have UID < 1000, no home directory, and shell set to `/bin/false`.

**Q5: How do you force a user to change password on next login?**
**A:** Use `sudo chage -d 0 username` or `sudo passwd -e username`.

## 🎯 Key Takeaways

1. **User Creation**: Use `useradd` with appropriate options for different user types
2. **Password Management**: Implement strong password policies with `passwd` and `chage`
3. **Group Management**: Organize users into groups for easier permission management
4. **Sudo Configuration**: Use `visudo` to safely configure sudo access
5. **System Files**: Understand `/etc/passwd`, `/etc/shadow`, `/etc/group`
6. **Security**: Regular auditing of user accounts and permissions
7. **Automation**: Script bulk user operations for efficiency

---

**Next**: [05 - Process Management](../05-Process-Management/) - Managing processes and system services