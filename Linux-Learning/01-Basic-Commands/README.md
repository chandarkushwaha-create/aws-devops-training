# 01 - Basic Linux Commands

## 📚 Navigation Commands

### pwd (Print Working Directory)
```bash
# Show current directory
pwd
# Output: /home/username

# Show physical path (resolve symlinks)
pwd -P
```

### ls (List Directory Contents)
```bash
# Basic listing
ls

# Detailed listing
ls -l

# Show hidden files
ls -a

# Human readable sizes
ls -lh

# Sort by modification time
ls -lt

# Reverse order
ls -lr

# Recursive listing
ls -R

# Combined options
ls -lah
```

### cd (Change Directory)
```bash
# Go to home directory
cd
cd ~

# Go to specific directory
cd /path/to/directory

# Go to parent directory
cd ..

# Go to previous directory
cd -

# Go to root directory
cd /
```

### tree (Directory Tree)
```bash
# Install tree (if not available)
sudo apt install tree  # Ubuntu/Debian
sudo yum install tree  # CentOS/RHEL

# Show directory tree
tree

# Limit depth
tree -L 2

# Show hidden files
tree -a

# Show only directories
tree -d
```

## 📁 Basic File Operations

### touch (Create Empty Files)
```bash
# Create single file
touch filename.txt

# Create multiple files
touch file1.txt file2.txt file3.txt

# Create files with timestamp
touch file_{1..5}.txt

# Update timestamp of existing file
touch existing_file.txt
```

### mkdir (Make Directory)
```bash
# Create single directory
mkdir dirname

# Create multiple directories
mkdir dir1 dir2 dir3

# Create nested directories
mkdir -p path/to/nested/directory

# Create with specific permissions
mkdir -m 755 dirname
```

### rmdir (Remove Empty Directory)
```bash
# Remove empty directory
rmdir dirname

# Remove nested empty directories
rmdir -p path/to/empty/directories
```

### rm (Remove Files and Directories)
```bash
# Remove file
rm filename.txt

# Remove multiple files
rm file1.txt file2.txt

# Remove with confirmation
rm -i filename.txt

# Force remove (no confirmation)
rm -f filename.txt

# Remove directory and contents
rm -r dirname

# Force remove directory
rm -rf dirname

# Remove files matching pattern
rm *.txt
```

## 👀 Viewing File Contents

### cat (Display File Contents)
```bash
# Display file content
cat filename.txt

# Display multiple files
cat file1.txt file2.txt

# Number lines
cat -n filename.txt

# Show non-printing characters
cat -A filename.txt

# Create file with content
cat > newfile.txt
# Type content, press Ctrl+D to save
```

### less (View File Page by Page)
```bash
# View file with pagination
less filename.txt

# Navigation in less:
# Space or f: Next page
# b: Previous page
# q: Quit
# /pattern: Search forward
# ?pattern: Search backward
# n: Next search result
# N: Previous search result
```

### more (View File Page by Page)
```bash
# View file with pagination
more filename.txt

# Navigation in more:
# Space: Next page
# Enter: Next line
# q: Quit
```

### head (Display First Lines)
```bash
# Show first 10 lines (default)
head filename.txt

# Show first n lines
head -n 5 filename.txt
head -5 filename.txt

# Show first n bytes
head -c 100 filename.txt
```

### tail (Display Last Lines)
```bash
# Show last 10 lines (default)
tail filename.txt

# Show last n lines
tail -n 5 filename.txt
tail -5 filename.txt

# Follow file changes (useful for logs)
tail -f filename.txt

# Follow with retry (if file doesn't exist)
tail -F filename.txt
```

## ℹ️ System Information Commands

### whoami (Current User)
```bash
# Show current username
whoami
```

### id (User and Group IDs)
```bash
# Show user and group IDs
id

# Show specific user's ID
id username

# Show only user ID
id -u

# Show only group ID
id -g
```

### uname (System Information)
```bash
# Show system information
uname

# Show all information
uname -a

# Show kernel name
uname -s

# Show kernel release
uname -r

# Show kernel version
uname -v

# Show machine hardware
uname -m

# Show operating system
uname -o
```

### hostname (System Hostname)
```bash
# Show hostname
hostname

# Show FQDN
hostname -f

# Show IP address
hostname -I
```

### date (Date and Time)
```bash
# Show current date and time
date

# Show in specific format
date "+%Y-%m-%d %H:%M:%S"

# Show UTC time
date -u

# Set date (requires root)
sudo date -s "2024-01-01 12:00:00"
```

### uptime (System Uptime)
```bash
# Show system uptime and load
uptime

# Show uptime in pretty format
uptime -p

# Show since when system is running
uptime -s
```

### df (Disk Space Usage)
```bash
# Show disk usage
df

# Human readable format
df -h

# Show specific filesystem
df -h /

# Show inode usage
df -i
```

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
```

## 📖 Help and Documentation

### man (Manual Pages)
```bash
# Show manual for command
man ls

# Search manual pages
man -k keyword

# Show specific section
man 5 passwd

# Navigation in man:
# Space: Next page
# b: Previous page
# q: Quit
# /pattern: Search
```

### info (Info Documents)
```bash
# Show info document
info ls

# Navigation in info:
# Space: Next page
# b: Previous page
# q: Quit
# n: Next node
# p: Previous node
```

### --help (Command Help)
```bash
# Show command help
ls --help
cp --help
mv --help
```

### which (Locate Command)
```bash
# Show path of command
which ls
which python

# Show all matches
which -a python
```

### whereis (Locate Binary, Source, Manual)
```bash
# Show binary, source, and manual locations
whereis ls
whereis python
```

### type (Command Type)
```bash
# Show command type
type ls
type cd
type which
```

## 🔍 Search Commands

### find (Find Files and Directories)
```bash
# Find by name
find /path -name "filename"

# Find by type
find /path -type f  # files
find /path -type d  # directories

# Find by size
find /path -size +100M  # larger than 100MB
find /path -size -1M    # smaller than 1MB

# Find by modification time
find /path -mtime -7    # modified in last 7 days
find /path -mtime +30   # modified more than 30 days ago

# Execute command on found files
find /path -name "*.txt" -exec rm {} \;
```

### locate (Find Files by Name)
```bash
# Update locate database
sudo updatedb

# Find files by name
locate filename

# Case insensitive search
locate -i filename

# Limit results
locate -l 10 filename
```

## 🔄 Command History

### history (Command History)
```bash
# Show command history
history

# Show last n commands
history 10

# Execute command by number
!123

# Execute last command
!!

# Execute last command starting with string
!ls

# Clear history
history -c
```

## 🎯 Practical Examples

### Daily Navigation Tasks
```bash
# Navigate to project directory
cd ~/projects/myapp

# List all files including hidden
ls -la

# Check current location
pwd

# Go back to previous directory
cd -

# Create project structure
mkdir -p project/{src,docs,tests}
```

### File Management Tasks
```bash
# Create multiple test files
touch test_{1..5}.txt

# View file content
cat test_1.txt

# Check file sizes
ls -lh *.txt

# Remove all test files
rm test_*.txt
```

### System Information Tasks
```bash
# Check system details
uname -a
hostname
whoami
date

# Check resource usage
df -h
free -h
uptime
```

## 🎤 Interview Questions

**Q1: What is the difference between `ls -l` and `ls -la`?**
**A:** `ls -l` shows detailed listing of visible files, while `ls -la` shows detailed listing including hidden files (files starting with dot).

**Q2: How do you create nested directories in one command?**
**A:** Use `mkdir -p path/to/nested/directory`. The `-p` flag creates parent directories as needed.

**Q3: What's the difference between `rm -r` and `rm -rf`?**
**A:** `rm -r` removes directories recursively with confirmation prompts, while `rm -rf` forces removal without prompts.

**Q4: How do you view the last 20 lines of a file?**
**A:** Use `tail -n 20 filename` or `tail -20 filename`.

**Q5: What command shows your current directory?**
**A:** `pwd` (Print Working Directory) shows the current directory path.

## 🎯 Key Takeaways

1. **Navigation**: Master `pwd`, `ls`, `cd` for directory navigation
2. **File Operations**: Use `touch`, `mkdir`, `rm` for file management
3. **Viewing Files**: `cat`, `less`, `head`, `tail` for content viewing
4. **System Info**: `uname`, `whoami`, `df`, `free` for system status
5. **Help**: `man`, `--help`, `info` for command documentation
6. **Practice**: Regular practice builds muscle memory
7. **Safety**: Always double-check before using `rm -rf`

---

**Next**: [02 - File Management](../02-File-Management/) - Advanced file operations and management