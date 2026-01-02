# 02 - File Management

## 📁 Advanced File Operations

### cp (Copy Files and Directories)
```bash
# Copy file
cp source.txt destination.txt

# Copy to directory
cp file.txt /path/to/directory/

# Copy multiple files
cp file1.txt file2.txt /destination/

# Copy directory recursively
cp -r source_dir destination_dir

# Preserve attributes
cp -p file.txt backup.txt

# Interactive copy (prompt before overwrite)
cp -i file.txt existing_file.txt

# Verbose output
cp -v file.txt copy.txt

# Copy with backup
cp --backup=numbered file.txt existing.txt
```

### mv (Move/Rename Files)
```bash
# Rename file
mv oldname.txt newname.txt

# Move file to directory
mv file.txt /path/to/directory/

# Move multiple files
mv file1.txt file2.txt /destination/

# Move directory
mv old_dir new_dir

# Interactive move
mv -i file.txt existing.txt

# Verbose output
mv -v file.txt /new/location/

# No clobber (don't overwrite)
mv -n file.txt existing.txt
```

### ln (Create Links)
```bash
# Create hard link
ln original.txt hardlink.txt

# Create symbolic link
ln -s /path/to/original symlink

# Create symbolic link with relative path
ln -s ../file.txt link_to_file

# Force link creation
ln -sf /path/to/target link_name

# Verbose output
ln -sv /path/to/target link_name
```

## 🔍 File Search and Find

### find (Advanced File Search)
```bash
# Find by name (case sensitive)
find /path -name "filename.txt"

# Find by name (case insensitive)
find /path -iname "filename.txt"

# Find by pattern
find /path -name "*.txt"
find /path -name "file*"

# Find by type
find /path -type f    # regular files
find /path -type d    # directories
find /path -type l    # symbolic links

# Find by size
find /path -size +100M     # larger than 100MB
find /path -size -1M       # smaller than 1MB
find /path -size 50M       # exactly 50MB

# Find by modification time
find /path -mtime -7       # modified in last 7 days
find /path -mtime +30      # older than 30 days
find /path -mtime 0        # modified today

# Find by access time
find /path -atime -1       # accessed in last day

# Find by permissions
find /path -perm 755       # exact permissions
find /path -perm -644      # at least these permissions
find /path -perm /u+w      # user writable

# Find by owner
find /path -user username
find /path -group groupname

# Find empty files/directories
find /path -empty

# Combine conditions (AND)
find /path -name "*.txt" -size +1M

# Combine conditions (OR)
find /path \( -name "*.txt" -o -name "*.log" \)

# Execute commands on found files
find /path -name "*.tmp" -delete
find /path -name "*.txt" -exec cat {} \;
find /path -name "*.log" -exec gzip {} \;

# Find and copy
find /source -name "*.txt" -exec cp {} /destination/ \;
```

### grep (Search Text in Files)
```bash
# Basic search
grep "pattern" file.txt

# Case insensitive search
grep -i "pattern" file.txt

# Search recursively in directories
grep -r "pattern" /path/

# Show line numbers
grep -n "pattern" file.txt

# Show only matching filenames
grep -l "pattern" *.txt

# Show files that don't match
grep -L "pattern" *.txt

# Count matches
grep -c "pattern" file.txt

# Show context lines
grep -A 3 "pattern" file.txt  # 3 lines after
grep -B 3 "pattern" file.txt  # 3 lines before
grep -C 3 "pattern" file.txt  # 3 lines before and after

# Use regular expressions
grep -E "pattern1|pattern2" file.txt

# Search for whole words
grep -w "word" file.txt

# Invert match (show non-matching lines)
grep -v "pattern" file.txt
```

### locate (Fast File Search)
```bash
# Update locate database
sudo updatedb

# Find files by name
locate filename

# Case insensitive search
locate -i filename

# Limit number of results
locate -l 10 filename

# Show statistics
locate -S

# Use regex
locate -r "pattern"
```

## 📦 Archive and Compression

### tar (Archive Files)
```bash
# Create archive
tar -cf archive.tar file1 file2 directory/

# Create compressed archive (gzip)
tar -czf archive.tar.gz file1 file2 directory/

# Create compressed archive (bzip2)
tar -cjf archive.tar.bz2 file1 file2 directory/

# Extract archive
tar -xf archive.tar

# Extract compressed archive
tar -xzf archive.tar.gz
tar -xjf archive.tar.bz2

# List archive contents
tar -tf archive.tar
tar -tzf archive.tar.gz

# Extract to specific directory
tar -xzf archive.tar.gz -C /destination/

# Verbose output
tar -xzvf archive.tar.gz

# Exclude files
tar -czf archive.tar.gz --exclude="*.tmp" directory/

# Create archive with absolute paths
tar -czf archive.tar.gz -P /absolute/path/
```

### gzip/gunzip (Compress Files)
```bash
# Compress file
gzip file.txt
# Creates file.txt.gz and removes original

# Decompress file
gunzip file.txt.gz
# Creates file.txt and removes .gz

# Keep original file
gzip -k file.txt

# Compress with best compression
gzip -9 file.txt

# Compress multiple files
gzip file1.txt file2.txt

# View compressed file content
zcat file.txt.gz
zless file.txt.gz
```

### zip/unzip (ZIP Archives)
```bash
# Create zip archive
zip archive.zip file1.txt file2.txt

# Create zip with directory
zip -r archive.zip directory/

# Extract zip archive
unzip archive.zip

# Extract to specific directory
unzip archive.zip -d /destination/

# List zip contents
unzip -l archive.zip

# Test zip integrity
unzip -t archive.zip

# Update existing zip
zip -u archive.zip newfile.txt

# Exclude files
zip -r archive.zip directory/ -x "*.tmp"
```

## 📊 File Information and Statistics

### file (Determine File Type)
```bash
# Show file type
file filename.txt
file image.jpg
file script.sh

# Show MIME type
file -i filename.txt

# Don't follow symlinks
file -h symlink
```

### stat (File Statistics)
```bash
# Show detailed file information
stat filename.txt

# Show filesystem information
stat -f filename.txt

# Custom format
stat -c "%n %s %y" filename.txt
```

### du (Directory Usage)
```bash
# Show directory size
du directory/

# Human readable format
du -h directory/

# Show total size only
du -sh directory/

# Show sizes of all subdirectories
du -h --max-depth=1 directory/

# Sort by size
du -h directory/ | sort -hr

# Exclude certain files
du -h --exclude="*.tmp" directory/
```

### wc (Word Count)
```bash
# Count lines, words, characters
wc filename.txt

# Count lines only
wc -l filename.txt

# Count words only
wc -w filename.txt

# Count characters only
wc -c filename.txt

# Count multiple files
wc *.txt
```

## 🔄 File Comparison

### diff (Compare Files)
```bash
# Compare two files
diff file1.txt file2.txt

# Unified format
diff -u file1.txt file2.txt

# Context format
diff -c file1.txt file2.txt

# Side by side comparison
diff -y file1.txt file2.txt

# Ignore case differences
diff -i file1.txt file2.txt

# Ignore whitespace
diff -w file1.txt file2.txt

# Compare directories
diff -r dir1/ dir2/
```

### cmp (Compare Files Byte by Byte)
```bash
# Compare files
cmp file1.txt file2.txt

# Verbose output
cmp -l file1.txt file2.txt

# Silent mode (exit code only)
cmp -s file1.txt file2.txt
```

## 🔗 File Attributes and Extended Attributes

### lsattr (List File Attributes)
```bash
# List attributes
lsattr filename.txt

# List directory attributes
lsattr -d directory/

# Recursive listing
lsattr -R directory/
```

### chattr (Change File Attributes)
```bash
# Make file immutable
sudo chattr +i filename.txt

# Remove immutable attribute
sudo chattr -i filename.txt

# Make file append-only
sudo chattr +a logfile.txt

# Secure deletion
sudo chattr +s filename.txt
```

## 🎯 Practical File Management Scenarios

### Backup Operations
```bash
# Create timestamped backup
cp important.txt important.txt.$(date +%Y%m%d_%H%M%S)

# Backup directory with compression
tar -czf backup_$(date +%Y%m%d).tar.gz /important/directory/

# Sync directories
rsync -av source/ destination/

# Backup with exclusions
rsync -av --exclude="*.tmp" --exclude="logs/" source/ backup/
```

### Log File Management
```bash
# Find large log files
find /var/log -name "*.log" -size +100M

# Compress old logs
find /var/log -name "*.log" -mtime +30 -exec gzip {} \;

# Archive logs by date
tar -czf logs_$(date +%Y%m).tar.gz /var/log/*.log

# Clean temporary files
find /tmp -type f -mtime +7 -delete
```

### File Organization
```bash
# Organize files by extension
for ext in txt pdf doc; do
    mkdir -p sorted/$ext
    mv *.$ext sorted/$ext/ 2>/dev/null
done

# Find duplicate files by size
find . -type f -exec du -b {} \; | sort -n | uniq -d -w10

# Remove empty directories
find . -type d -empty -delete
```

## 🎤 Interview Questions

**Q1: What's the difference between hard links and symbolic links?**
**A:** Hard links point directly to inode data and work only within same filesystem. Symbolic links are pointers to file paths and can cross filesystems but break if target is moved.

**Q2: How do you find all files larger than 100MB in /var directory?**
**A:** `find /var -type f -size +100M`

**Q3: What's the difference between `cp -r` and `cp -a`?**
**A:** `cp -r` copies recursively, while `cp -a` (archive) preserves all attributes, permissions, timestamps, and symbolic links.

**Q4: How do you create a compressed archive excluding certain files?**
**A:** `tar -czf archive.tar.gz --exclude="*.tmp" --exclude="logs/" directory/`

**Q5: What command shows the difference between two directories?**
**A:** `diff -r dir1/ dir2/` shows recursive differences between directories.

## 🎯 Key Takeaways

1. **File Operations**: Master `cp`, `mv`, `ln` for file manipulation
2. **Search Tools**: Use `find` and `grep` for powerful file searching
3. **Archives**: Learn `tar`, `gzip`, `zip` for file compression
4. **File Info**: Use `file`, `stat`, `du` for file analysis
5. **Comparison**: Use `diff` and `cmp` for file comparison
6. **Organization**: Develop systematic approaches to file management
7. **Automation**: Combine commands for efficient file operations

---

**Next**: [03 - File Permissions](../03-File-Permissions/) - Understanding and managing Linux file permissions