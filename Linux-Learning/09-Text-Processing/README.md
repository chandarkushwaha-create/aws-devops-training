# 09 - Text Processing

## 📄 Basic Text Viewing

### cat (Concatenate and Display)
```bash
# Display file contents
cat file.txt

# Display multiple files
cat file1.txt file2.txt

# Number all lines
cat -n file.txt

# Number non-empty lines only
cat -b file.txt

# Show tabs as ^I
cat -T file.txt

# Show line endings
cat -E file.txt

# Show all non-printing characters
cat -A file.txt

# Create file with cat
cat > newfile.txt
# Type content, press Ctrl+D to save

# Append to file
cat >> file.txt
```

### less/more (Paging)
```bash
# View file with less (recommended)
less file.txt

# less navigation:
# Space: Next page
# b: Previous page
# /pattern: Search forward
# ?pattern: Search backward
# n: Next search result
# N: Previous search result
# q: Quit

# View file with more
more file.txt

# Show line numbers in less
less -N file.txt

# Case-insensitive search
less -i file.txt

# Follow file changes (like tail -f)
less +F file.txt
```

### head/tail (Beginning/End of Files)
```bash
# Show first 10 lines (default)
head file.txt

# Show first n lines
head -n 20 file.txt
head -20 file.txt

# Show first n bytes
head -c 100 file.txt

# Show last 10 lines (default)
tail file.txt

# Show last n lines
tail -n 20 file.txt
tail -20 file.txt

# Follow file changes (real-time)
tail -f file.txt

# Follow file with retry
tail -F file.txt

# Show last n lines and follow
tail -n 50 -f file.txt

# Multiple files
head file1.txt file2.txt
tail file1.txt file2.txt
```

## 🔍 Text Searching

### grep (Global Regular Expression Print)
```bash
# Basic search
grep "pattern" file.txt

# Case-insensitive search
grep -i "pattern" file.txt

# Search in multiple files
grep "pattern" *.txt

# Recursive search in directories
grep -r "pattern" /path/to/directory

# Show line numbers
grep -n "pattern" file.txt

# Show only matching part
grep -o "pattern" file.txt

# Invert match (show non-matching lines)
grep -v "pattern" file.txt

# Count matches
grep -c "pattern" file.txt

# Show files with matches
grep -l "pattern" *.txt

# Show files without matches
grep -L "pattern" *.txt

# Show context lines
grep -A 3 "pattern" file.txt  # 3 lines after
grep -B 3 "pattern" file.txt  # 3 lines before
grep -C 3 "pattern" file.txt  # 3 lines before and after

# Use regular expressions
grep -E "pattern1|pattern2" file.txt
grep -E "^start.*end$" file.txt

# Fixed string search (no regex)
grep -F "literal.string" file.txt

# Whole word match
grep -w "word" file.txt

# Quiet mode (exit status only)
grep -q "pattern" file.txt && echo "Found"
```

### egrep/fgrep (Extended/Fixed grep)
```bash
# Extended regular expressions
egrep "pattern1|pattern2" file.txt
grep -E "pattern1|pattern2" file.txt

# Fixed string search
fgrep "literal.string" file.txt
grep -F "literal.string" file.txt

# Complex patterns
egrep "^(start|begin)" file.txt
egrep "[0-9]{3}-[0-9]{3}-[0-9]{4}" file.txt  # Phone numbers
egrep "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b" file.txt  # Emails
```

### find with text search
```bash
# Find files containing text
find /path -type f -exec grep -l "pattern" {} \;

# Find and search in one command
find /path -name "*.txt" -exec grep -H "pattern" {} \;

# Find files modified today containing pattern
find /path -type f -mtime 0 -exec grep -l "pattern" {} \;
```

## ✂️ Text Manipulation

### sed (Stream Editor)
```bash
# Basic substitution
sed 's/old/new/' file.txt

# Global substitution (all occurrences)
sed 's/old/new/g' file.txt

# Case-insensitive substitution
sed 's/old/new/gi' file.txt

# Substitute only on specific line
sed '5s/old/new/' file.txt

# Substitute in range of lines
sed '1,10s/old/new/g' file.txt

# Delete lines
sed '5d' file.txt          # Delete line 5
sed '1,3d' file.txt        # Delete lines 1-3
sed '/pattern/d' file.txt  # Delete lines matching pattern

# Insert text
sed '5i\New line text' file.txt     # Insert before line 5
sed '5a\New line text' file.txt     # Insert after line 5

# Replace entire line
sed '5c\Replacement line' file.txt

# Print specific lines
sed -n '1,5p' file.txt     # Print lines 1-5
sed -n '/pattern/p' file.txt # Print lines matching pattern

# Multiple commands
sed -e 's/old1/new1/g' -e 's/old2/new2/g' file.txt

# Edit file in-place
sed -i 's/old/new/g' file.txt

# Create backup before editing
sed -i.bak 's/old/new/g' file.txt

# Advanced examples
sed 's/^/> /' file.txt              # Add prefix to each line
sed 's/$/;/' file.txt               # Add suffix to each line
sed '/^$/d' file.txt                # Remove empty lines
sed 's/[[:space:]]*$//' file.txt    # Remove trailing whitespace
```

### awk (Pattern Scanning and Processing)
```bash
# Print entire file
awk '{print}' file.txt

# Print specific columns
awk '{print $1}' file.txt          # First column
awk '{print $1, $3}' file.txt      # First and third columns
awk '{print $NF}' file.txt         # Last column

# Print with custom separator
awk -F: '{print $1}' /etc/passwd    # Use colon as separator

# Print lines matching pattern
awk '/pattern/ {print}' file.txt

# Print line numbers
awk '{print NR, $0}' file.txt

# Print number of fields per line
awk '{print NF}' file.txt

# Conditional printing
awk '$3 > 100 {print}' file.txt     # Print if 3rd column > 100
awk 'length($0) > 80 {print}' file.txt  # Print long lines

# Calculate sum
awk '{sum += $1} END {print sum}' file.txt

# Calculate average
awk '{sum += $1; count++} END {print sum/count}' file.txt

# Print unique lines
awk '!seen[$0]++' file.txt

# Format output
awk '{printf "%-10s %s\n", $1, $2}' file.txt

# BEGIN and END blocks
awk 'BEGIN {print "Start"} {print $1} END {print "End"}' file.txt

# Multiple conditions
awk '$1 == "error" && $2 > 100 {print}' file.txt

# String functions
awk '{print toupper($1)}' file.txt      # Convert to uppercase
awk '{print length($1)}' file.txt       # String length
awk '{print substr($1, 1, 3)}' file.txt # Substring
```

### tr (Translate Characters)
```bash
# Convert lowercase to uppercase
tr 'a-z' 'A-Z' < file.txt

# Convert uppercase to lowercase
tr 'A-Z' 'a-z' < file.txt

# Delete characters
tr -d 'aeiou' < file.txt        # Delete vowels
tr -d '0-9' < file.txt          # Delete digits

# Squeeze repeated characters
tr -s ' ' < file.txt            # Squeeze multiple spaces to one
tr -s '\n' < file.txt           # Remove empty lines

# Replace characters
tr ' ' '_' < file.txt           # Replace spaces with underscores
tr '\t' ' ' < file.txt          # Replace tabs with spaces

# Character classes
tr '[:lower:]' '[:upper:]' < file.txt
tr '[:space:]' '_' < file.txt
tr -d '[:punct:]' < file.txt    # Delete punctuation

# ROT13 encoding
tr 'A-Za-z' 'N-ZA-Mn-za-m' < file.txt
```

## 🔄 Text Sorting and Filtering

### sort (Sort Lines)
```bash
# Basic sort
sort file.txt

# Reverse sort
sort -r file.txt

# Numeric sort
sort -n file.txt

# Sort by specific column
sort -k 2 file.txt              # Sort by 2nd column
sort -k 2,2 file.txt            # Sort by 2nd column only

# Sort with custom separator
sort -t: -k 3 /etc/passwd       # Sort by 3rd field, colon separator

# Case-insensitive sort
sort -f file.txt

# Remove duplicates while sorting
sort -u file.txt

# Sort by multiple columns
sort -k 1,1 -k 2,2n file.txt    # Sort by 1st column, then 2nd numerically

# Sort by file size
ls -l | sort -k 5n              # Sort by 5th column numerically

# Random sort
sort -R file.txt

# Check if file is sorted
sort -c file.txt

# Merge sorted files
sort -m file1.txt file2.txt
```

### uniq (Remove Duplicates)
```bash
# Remove consecutive duplicates
uniq file.txt

# Count occurrences
uniq -c file.txt

# Show only duplicates
uniq -d file.txt

# Show only unique lines
uniq -u file.txt

# Case-insensitive comparison
uniq -i file.txt

# Skip first n characters
uniq -s 5 file.txt

# Compare only first n characters
uniq -w 10 file.txt

# Common usage with sort
sort file.txt | uniq            # Remove all duplicates
sort file.txt | uniq -c         # Count all occurrences
sort file.txt | uniq -d         # Show all duplicates
```

### cut (Extract Columns)
```bash
# Extract specific columns
cut -c 1-5 file.txt             # Characters 1-5
cut -c 1,3,5 file.txt           # Characters 1, 3, and 5
cut -c 5- file.txt              # From character 5 to end

# Extract fields
cut -f 1 file.txt               # First field (tab-separated)
cut -f 1,3 file.txt             # Fields 1 and 3
cut -f 2- file.txt              # From field 2 to end

# Custom delimiter
cut -d: -f 1 /etc/passwd        # First field, colon-separated
cut -d' ' -f 2 file.txt         # Second field, space-separated

# Extract ranges
cut -d: -f 1-3 /etc/passwd      # Fields 1 through 3

# Complement selection
cut --complement -f 2 file.txt  # All fields except 2nd

# Output delimiter
cut -d: -f 1,3 --output-delimiter=' ' /etc/passwd
```

### paste (Merge Lines)
```bash
# Merge files side by side
paste file1.txt file2.txt

# Custom delimiter
paste -d: file1.txt file2.txt

# Merge all lines into one
paste -s file.txt

# Custom delimiter for serial paste
paste -s -d, file.txt           # Comma-separated

# Merge with different delimiters
paste -d:, file1.txt file2.txt file3.txt
```

## 🔢 Text Statistics and Analysis

### wc (Word Count)
```bash
# Count lines, words, characters
wc file.txt

# Count lines only
wc -l file.txt

# Count words only
wc -w file.txt

# Count characters only
wc -c file.txt

# Count bytes
wc -c file.txt

# Count characters (multibyte aware)
wc -m file.txt

# Multiple files
wc *.txt

# Longest line length
wc -L file.txt
```

### comm (Compare Files)
```bash
# Compare sorted files
comm file1.txt file2.txt

# Show only lines unique to file1
comm -23 file1.txt file2.txt

# Show only lines unique to file2
comm -13 file1.txt file2.txt

# Show only common lines
comm -12 file1.txt file2.txt

# Suppress columns
comm -1 file1.txt file2.txt     # Suppress column 1
comm -2 file1.txt file2.txt     # Suppress column 2
comm -3 file1.txt file2.txt     # Suppress column 3
```

### diff (Compare Files)
```bash
# Basic difference
diff file1.txt file2.txt

# Unified format
diff -u file1.txt file2.txt

# Context format
diff -c file1.txt file2.txt

# Side-by-side comparison
diff -y file1.txt file2.txt

# Ignore case
diff -i file1.txt file2.txt

# Ignore whitespace
diff -w file1.txt file2.txt

# Ignore blank lines
diff -B file1.txt file2.txt

# Recursive directory comparison
diff -r dir1/ dir2/

# Brief format (only show if files differ)
diff -q file1.txt file2.txt
```

## 🎯 Advanced Text Processing

### Regular Expressions
```bash
# Basic patterns
grep "^start" file.txt          # Lines starting with "start"
grep "end$" file.txt            # Lines ending with "end"
grep "^$" file.txt              # Empty lines
grep "." file.txt               # Any character
grep "a*" file.txt              # Zero or more 'a'
grep "a+" file.txt              # One or more 'a' (extended regex)
grep "a?" file.txt              # Zero or one 'a' (extended regex)

# Character classes
grep "[0-9]" file.txt           # Any digit
grep "[a-z]" file.txt           # Any lowercase letter
grep "[A-Z]" file.txt           # Any uppercase letter
grep "[^0-9]" file.txt          # Any non-digit

# POSIX character classes
grep "[[:digit:]]" file.txt     # Digits
grep "[[:alpha:]]" file.txt     # Letters
grep "[[:alnum:]]" file.txt     # Letters and digits
grep "[[:space:]]" file.txt     # Whitespace
grep "[[:punct:]]" file.txt     # Punctuation

# Word boundaries
grep "\bword\b" file.txt        # Whole word match

# Quantifiers
grep "a\{3\}" file.txt          # Exactly 3 'a's
grep "a\{3,\}" file.txt         # 3 or more 'a's
grep "a\{3,5\}" file.txt        # 3 to 5 'a's
```

### Complex Text Processing Examples
```bash
# Extract email addresses
grep -oE "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b" file.txt

# Extract IP addresses
grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" file.txt

# Extract URLs
grep -oE "https?://[^\s]+" file.txt

# Process CSV files
awk -F, '{print $1, $3}' data.csv          # Print columns 1 and 3
awk -F, 'NR>1 {sum+=$2} END {print sum}' data.csv  # Sum column 2, skip header

# Log file analysis
awk '{print $1}' access.log | sort | uniq -c | sort -nr  # Top IP addresses
grep "ERROR" app.log | wc -l                             # Count errors
awk '{print $4}' access.log | cut -c2-12 | sort | uniq -c  # Requests per hour

# Text formatting
fmt -w 80 file.txt              # Format to 80 characters width
fold -w 80 file.txt             # Wrap lines at 80 characters
expand file.txt                 # Convert tabs to spaces
unexpand file.txt               # Convert spaces to tabs
```

## 📊 Text Processing Pipelines

### Common Pipeline Patterns
```bash
# Most frequent words
cat file.txt | tr ' ' '\n' | sort | uniq -c | sort -nr | head -10

# Lines containing pattern, sorted by length
grep "pattern" file.txt | awk '{print length, $0}' | sort -n | cut -d' ' -f2-

# Remove duplicates and sort
sort file.txt | uniq

# Count unique values in column
cut -d, -f2 data.csv | sort | uniq -c

# Extract and count file extensions
find . -type f | sed 's/.*\.//' | sort | uniq -c | sort -nr

# Process log files
tail -f /var/log/access.log | grep "ERROR" | awk '{print $1, $4}' | sort | uniq -c

# Clean and format data
sed 's/[[:space:]]*$//' file.txt | sed '/^$/d' | sort | uniq
```

## 📚 Interview Questions & Answers

### Fresher Level (1-10)

**Q1: What's the difference between cat and less commands?**
A: cat displays entire file content at once, while less displays content page by page with navigation controls. less is better for large files as it doesn't load everything into memory.

**Q2: How do you search for a pattern in a file?**
A: Use grep command: `grep "pattern" filename`. Add -i for case-insensitive, -n for line numbers, -r for recursive search in directories.

**Q3: What does the sed command do?**
A: sed (Stream Editor) performs text transformations on files. Common uses: `sed 's/old/new/g'` for substitution, `sed '5d'` to delete line 5, `sed -n '1,5p'` to print lines 1-5.

**Q4: How do you count lines, words, and characters in a file?**
A: Use wc command: `wc filename` shows lines, words, characters. Use `wc -l` for lines only, `wc -w` for words only, `wc -c` for characters only.

**Q5: What's the difference between sort and uniq commands?**
A: sort arranges lines in order, uniq removes consecutive duplicate lines. Often used together: `sort file.txt | uniq` to remove all duplicates.

### Intermediate Level (6-15)

**Q6: How do you extract specific columns from a file?**
A: Use cut command: `cut -f1,3 file.txt` for fields 1 and 3 (tab-separated), `cut -d: -f1 /etc/passwd` for colon-separated first field, `cut -c1-5 file.txt` for characters 1-5.

**Q7: Explain the difference between grep, egrep, and fgrep.**
A: grep uses basic regex, egrep (or grep -E) uses extended regex with +, ?, |, (), fgrep (or grep -F) treats patterns as literal strings without regex interpretation.

**Q8: How do you find and replace text in multiple files?**
A: Use sed with find: `find . -name "*.txt" -exec sed -i 's/old/new/g' {} \;` or use grep to find files first: `grep -l "pattern" *.txt | xargs sed -i 's/old/new/g'`.

**Q9: What's the purpose of awk command and give examples?**
A: awk is a pattern-scanning language for data extraction and reporting. Examples: `awk '{print $1}' file.txt` (print first column), `awk -F: '{print $1}' /etc/passwd` (custom separator), `awk '$3 > 100' file.txt` (conditional).

**Q10: How do you process CSV files in Linux?**
A: Use awk with comma separator: `awk -F, '{print $1, $3}' data.csv`, or cut: `cut -d, -f1,3 data.csv`. For complex processing, combine with other tools or use specialized tools like csvkit.

## 🔑 Key Takeaways

- **Pipeline Power**: Combine multiple text processing tools using pipes for complex operations
- **Regular Expressions**: Master regex patterns for powerful text matching and manipulation
- **Context Matters**: Choose the right tool for the task (grep for searching, sed for editing, awk for processing)
- **Performance**: For large files, consider memory usage and processing time
- **Backup First**: Always backup files before in-place editing with sed -i or similar commands