# 03 - File Permissions

## 🔐 Understanding Linux Permissions

### Permission Types
Linux has three types of permissions for three categories of users:

**Permission Types:**
- **r (read)**: View file contents or list directory contents
- **w (write)**: Modify file contents or create/delete files in directory
- **x (execute)**: Execute file or access directory

**User Categories:**
- **u (user/owner)**: The file owner
- **g (group)**: Users in the file's group
- **o (others)**: All other users

### Permission Representation

#### Symbolic Notation
```bash
# Example: -rwxr-xr--
# Position 1: File type (- = file, d = directory, l = link)
# Positions 2-4: Owner permissions (rwx)
# Positions 5-7: Group permissions (r-x)
# Positions 8-10: Other permissions (r--)

ls -l filename.txt
# Output: -rw-r--r-- 1 user group 1024 Jan 1 12:00 filename.txt
```

#### Numeric (Octal) Notation
```bash
# Each permission has a numeric value:
# r (read) = 4
# w (write) = 2
# x (execute) = 1

# Common permission combinations:
# 7 = rwx (4+2+1)
# 6 = rw- (4+2+0)
# 5 = r-x (4+0+1)
# 4 = r-- (4+0+0)
# 0 = --- (0+0+0)

# Examples:
# 755 = rwxr-xr-x (owner: rwx, group: r-x, others: r-x)
# 644 = rw-r--r-- (owner: rw-, group: r--, others: r--)
# 600 = rw------- (owner: rw-, group: ---, others: ---)
```

## 🔧 Permission Management Commands

### chmod (Change Mode/Permissions)

#### Symbolic Mode
```bash
# Add permissions
chmod u+x filename.txt      # Add execute for owner
chmod g+w filename.txt      # Add write for group
chmod o+r filename.txt      # Add read for others
chmod a+x filename.txt      # Add execute for all

# Remove permissions
chmod u-x filename.txt      # Remove execute from owner
chmod g-w filename.txt      # Remove write from group
chmod o-r filename.txt      # Remove read from others

# Set exact permissions
chmod u=rwx filename.txt    # Set owner to rwx
chmod g=r filename.txt      # Set group to r only
chmod o= filename.txt       # Remove all permissions for others

# Multiple changes
chmod u+x,g-w,o=r filename.txt

# Recursive changes
chmod -R 755 directory/
```

#### Numeric Mode
```bash
# Set permissions using octal notation
chmod 755 filename.txt      # rwxr-xr-x
chmod 644 filename.txt      # rw-r--r--
chmod 600 filename.txt      # rw-------
chmod 777 filename.txt      # rwxrwxrwx (dangerous!)

# Recursive numeric permissions
chmod -R 755 directory/

# Common permission patterns
chmod 755 script.sh         # Executable script
chmod 644 document.txt      # Regular file
chmod 600 private.key       # Private key file
chmod 700 ~/.ssh/           # SSH directory
```

### chown (Change Owner)
```bash
# Change owner only
chown newowner filename.txt

# Change owner and group
chown newowner:newgroup filename.txt

# Change group only (using colon)
chown :newgroup filename.txt

# Recursive ownership change
chown -R user:group directory/

# Change ownership using numeric IDs
chown 1000:1000 filename.txt

# Preserve root ownership for system files
sudo chown root:root /etc/important.conf
```

### chgrp (Change Group)
```bash
# Change group ownership
chgrp newgroup filename.txt

# Recursive group change
chgrp -R newgroup directory/

# Change to user's primary group
chgrp $(id -gn) filename.txt
```

## 🔒 Special Permissions

### SUID (Set User ID)
```bash
# Set SUID bit (4000)
chmod u+s filename
chmod 4755 filename

# Example: passwd command
ls -l /usr/bin/passwd
# Output: -rwsr-xr-x (note the 's' in owner execute position)

# Remove SUID
chmod u-s filename
```

### SGID (Set Group ID)
```bash
# Set SGID on file (2000)
chmod g+s filename
chmod 2755 filename

# Set SGID on directory (files inherit group)
chmod g+s directory/
chmod 2755 directory/

# Remove SGID
chmod g-s filename
```

### Sticky Bit
```bash
# Set sticky bit (1000)
chmod +t directory/
chmod 1755 directory/

# Example: /tmp directory
ls -ld /tmp
# Output: drwxrwxrwt (note the 't' at the end)

# Remove sticky bit
chmod -t directory/
```

### Combined Special Permissions
```bash
# Set multiple special permissions
chmod 6755 filename    # SUID + SGID
chmod 7755 directory/  # SUID + SGID + Sticky bit

# Check special permissions
ls -l filename
# s = SUID/SGID set and execute permission present
# S = SUID/SGID set but no execute permission
# t = Sticky bit set and execute permission present
# T = Sticky bit set but no execute permission
```

## 🛡️ Access Control Lists (ACL)

### getfacl (Get File ACL)
```bash
# View ACL information
getfacl filename.txt

# View ACL for directory
getfacl directory/

# View default ACL
getfacl -d directory/
```

### setfacl (Set File ACL)
```bash
# Grant user specific permissions
setfacl -m u:username:rwx filename.txt

# Grant group specific permissions
setfacl -m g:groupname:rx filename.txt

# Set permissions for other users
setfacl -m o:r filename.txt

# Remove ACL entry
setfacl -x u:username filename.txt

# Remove all ACL entries
setfacl -b filename.txt

# Set default ACL for directory
setfacl -d -m u:username:rwx directory/

# Recursive ACL setting
setfacl -R -m u:username:rx directory/

# Copy ACL from one file to another
getfacl file1.txt | setfacl --set-file=- file2.txt
```

## 🔍 Permission Analysis Commands

### ls (List with Permissions)
```bash
# Detailed listing with permissions
ls -l

# Show numeric permissions
ls -l | awk '{print $1, $9}'

# Show only directories with permissions
ls -ld */

# Show hidden files with permissions
ls -la

# Sort by permissions
ls -l | sort -k1
```

### stat (Detailed File Information)
```bash
# Show detailed file statistics
stat filename.txt

# Show permissions in octal format
stat -c "%a %n" filename.txt

# Show owner and group
stat -c "%U %G %n" filename.txt

# Custom format
stat -c "File: %n, Permissions: %a, Owner: %U:%G" filename.txt
```

### find (Find by Permissions)
```bash
# Find files with specific permissions
find /path -perm 755

# Find files with at least these permissions
find /path -perm -644

# Find files with any of these permissions
find /path -perm /u+w

# Find SUID files
find /path -perm -4000

# Find SGID files
find /path -perm -2000

# Find sticky bit files
find /path -perm -1000

# Find world-writable files
find /path -perm -002

# Find files owned by specific user
find /path -user username

# Find files owned by specific group
find /path -group groupname
```

## 🎯 Common Permission Scenarios

### Web Server Files
```bash
# Web content permissions
chmod 644 *.html *.css *.js     # Read-only for web files
chmod 755 cgi-bin/              # Executable directory
chmod 600 config.php            # Secure config files
chown -R www-data:www-data /var/www/html/
```

### SSH Key Permissions
```bash
# SSH directory and key permissions
chmod 700 ~/.ssh/               # SSH directory
chmod 600 ~/.ssh/id_rsa         # Private key
chmod 644 ~/.ssh/id_rsa.pub     # Public key
chmod 644 ~/.ssh/authorized_keys # Authorized keys
chmod 644 ~/.ssh/known_hosts    # Known hosts
```

### Script Permissions
```bash
# Make script executable
chmod +x script.sh

# Secure script permissions
chmod 750 script.sh             # Owner can execute, group can read
chmod 700 sensitive_script.sh   # Only owner can access
```

### Database Files
```bash
# Database file permissions
chmod 600 database.db           # Only owner can read/write
chown mysql:mysql /var/lib/mysql/
chmod 750 /var/lib/mysql/       # MySQL directory
```

### Log File Permissions
```bash
# Log file permissions
chmod 640 /var/log/application.log  # Owner rw, group r
chown app:adm /var/log/application.log
chmod 755 /var/log/                 # Log directory
```

## 🚨 Security Best Practices

### Principle of Least Privilege
```bash
# Give minimum required permissions
chmod 644 data.txt              # Read-only for most files
chmod 600 sensitive.txt         # Restrict to owner only
chmod 755 public_dir/           # Standard directory permissions
chmod 700 private_dir/          # Private directory
```

### Avoiding Common Mistakes
```bash
# NEVER do these (security risks):
chmod 777 filename              # World writable
chmod -R 777 directory/         # Recursive world writable
chown -R root:root /home/user/  # Wrong ownership

# Instead, use appropriate permissions:
chmod 644 filename              # Standard file
chmod 755 directory/            # Standard directory
chmod 600 private_file          # Private file
```

### Regular Security Audits
```bash
# Find world-writable files
find / -type f -perm -002 2>/dev/null

# Find SUID/SGID files
find / -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null

# Find files with no owner
find / -nouser -o -nogroup 2>/dev/null

# Check for unusual permissions
find /home -type f -perm 777 2>/dev/null
```

## 🎤 Interview Questions

**Q1: What does the permission 755 mean?**
**A:** 755 means owner has read/write/execute (7), group has read/execute (5), and others have read/execute (5). In symbolic notation: rwxr-xr-x.

**Q2: What's the difference between SUID and SGID?**
**A:** SUID runs executable with owner's privileges, SGID runs with group's privileges. For directories, SGID makes new files inherit the directory's group.

**Q3: How do you make a file readable by owner only?**
**A:** Use `chmod 600 filename` or `chmod u=rw,go= filename`.

**Q4: What is the sticky bit used for?**
**A:** Sticky bit on directories (like /tmp) allows only file owners to delete their own files, even if others have write permission to the directory.

**Q5: How do you find all SUID files on the system?**
**A:** Use `find / -type f -perm -4000 2>/dev/null`.

## 🎯 Key Takeaways

1. **Permission Basics**: Understand read, write, execute for user, group, others
2. **Numeric Notation**: Master octal permissions (755, 644, 600, etc.)
3. **Special Permissions**: Know SUID, SGID, and sticky bit usage
4. **Security**: Apply principle of least privilege
5. **ACLs**: Use for fine-grained permission control
6. **Common Patterns**: Learn standard permissions for different file types
7. **Auditing**: Regular permission audits for security

---

**Next**: [04 - User Management](../04-User-Management/) - Managing users and groups in Linux