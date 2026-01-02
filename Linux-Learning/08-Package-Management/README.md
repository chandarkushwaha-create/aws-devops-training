# 08 - Package Management

## 📦 APT (Advanced Package Tool) - Debian/Ubuntu

### Basic APT Commands
```bash
# Update package list
sudo apt update

# Upgrade all packages
sudo apt upgrade

# Full upgrade (may remove packages)
sudo apt full-upgrade

# Install package
sudo apt install package_name

# Install multiple packages
sudo apt install package1 package2 package3

# Install specific version
sudo apt install package_name=version

# Remove package (keep config files)
sudo apt remove package_name

# Remove package and config files
sudo apt purge package_name

# Remove unused packages
sudo apt autoremove

# Clean package cache
sudo apt clean
sudo apt autoclean
```

### APT Search and Information
```bash
# Search for packages
apt search keyword
apt search "web server"

# Show package information
apt show package_name

# List installed packages
apt list --installed

# List upgradable packages
apt list --upgradable

# Show package dependencies
apt depends package_name

# Show reverse dependencies
apt rdepends package_name

# Check if package is installed
dpkg -l | grep package_name
```

### APT Configuration
```bash
# APT configuration file
cat /etc/apt/apt.conf

# APT sources list
cat /etc/apt/sources.list

# Additional sources
ls /etc/apt/sources.list.d/

# Add repository
sudo add-apt-repository ppa:repository/name

# Remove repository
sudo add-apt-repository --remove ppa:repository/name

# Import GPG key
wget -qO - https://example.com/key.gpg | sudo apt-key add -
```

### DPKG (Debian Package Manager)
```bash
# Install .deb package
sudo dpkg -i package.deb

# Remove package
sudo dpkg -r package_name

# List installed packages
dpkg -l

# Show package information
dpkg -s package_name

# List package contents
dpkg -L package_name

# Find which package owns a file
dpkg -S /path/to/file

# Extract package contents
dpkg -x package.deb /path/to/extract/

# Fix broken dependencies
sudo apt --fix-broken install
```

## 🎩 YUM/DNF - Red Hat/CentOS/Fedora

### YUM Commands (CentOS 7 and earlier)
```bash
# Update package list
sudo yum update

# Install package
sudo yum install package_name

# Install multiple packages
sudo yum install package1 package2

# Remove package
sudo yum remove package_name

# Search for packages
yum search keyword

# Show package information
yum info package_name

# List installed packages
yum list installed

# List available packages
yum list available

# Show package dependencies
yum deplist package_name

# Clean cache
sudo yum clean all

# Check for updates
yum check-update

# Update specific package
sudo yum update package_name
```

### DNF Commands (Fedora, CentOS 8+)
```bash
# Update package list
sudo dnf update

# Install package
sudo dnf install package_name

# Remove package
sudo dnf remove package_name

# Search for packages
dnf search keyword

# Show package information
dnf info package_name

# List installed packages
dnf list installed

# Show package history
dnf history

# Undo last transaction
sudo dnf history undo last

# Show package dependencies
dnf repoquery --requires package_name

# Clean cache
sudo dnf clean all

# Install from URL
sudo dnf install https://example.com/package.rpm
```

### RPM (Red Hat Package Manager)
```bash
# Install RPM package
sudo rpm -ivh package.rpm

# Upgrade package
sudo rpm -Uvh package.rpm

# Remove package
sudo rpm -e package_name

# Query installed packages
rpm -qa

# Query package information
rpm -qi package_name

# List package files
rpm -ql package_name

# Find which package owns a file
rpm -qf /path/to/file

# Verify package integrity
rpm -V package_name

# Import GPG key
sudo rpm --import https://example.com/key.gpg

# Check package signature
rpm --checksig package.rpm
```

### Repository Management
```bash
# List repositories (YUM)
yum repolist

# List repositories (DNF)
dnf repolist

# Add repository
sudo yum-config-manager --add-repo https://example.com/repo

# Enable repository
sudo yum-config-manager --enable repository_name

# Disable repository
sudo yum-config-manager --disable repository_name

# Install from specific repository
sudo yum --enablerepo=repository_name install package_name
```

## 🐧 Zypper - openSUSE

### Basic Zypper Commands
```bash
# Update package list
sudo zypper refresh

# Update all packages
sudo zypper update

# Install package
sudo zypper install package_name

# Remove package
sudo zypper remove package_name

# Search for packages
zypper search keyword

# Show package information
zypper info package_name

# List installed packages
zypper search --installed-only

# List repositories
zypper repos

# Add repository
sudo zypper addrepo https://example.com/repo repository_name

# Remove repository
sudo zypper removerepo repository_name
```

## 🏔️ Pacman - Arch Linux

### Basic Pacman Commands
```bash
# Update package database
sudo pacman -Sy

# Update all packages
sudo pacman -Syu

# Install package
sudo pacman -S package_name

# Remove package
sudo pacman -R package_name

# Remove package and dependencies
sudo pacman -Rs package_name

# Search for packages
pacman -Ss keyword

# Show package information
pacman -Si package_name

# List installed packages
pacman -Q

# List explicitly installed packages
pacman -Qe

# Clean package cache
sudo pacman -Sc

# Remove orphaned packages
sudo pacman -Rs $(pacman -Qtdq)
```

## 📦 Snap Packages

### Snap Commands
```bash
# Install snap
sudo apt install snapd  # Ubuntu/Debian
sudo yum install snapd  # CentOS/RHEL

# List available snaps
snap find

# Install snap package
sudo snap install package_name

# List installed snaps
snap list

# Update all snaps
sudo snap refresh

# Update specific snap
sudo snap refresh package_name

# Remove snap
sudo snap remove package_name

# Show snap information
snap info package_name

# Connect snap interfaces
sudo snap connect package_name:interface

# Disconnect snap interfaces
sudo snap disconnect package_name:interface

# List snap interfaces
snap interfaces
```

## 🥞 Flatpak

### Flatpak Commands
```bash
# Install flatpak
sudo apt install flatpak  # Ubuntu/Debian
sudo yum install flatpak  # CentOS/RHEL

# Add Flathub repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Search for applications
flatpak search keyword

# Install application
flatpak install flathub app.id

# List installed applications
flatpak list

# Update all applications
flatpak update

# Update specific application
flatpak update app.id

# Remove application
flatpak uninstall app.id

# Run application
flatpak run app.id

# Show application information
flatpak info app.id

# List repositories
flatpak remotes

# Remove unused runtimes
flatpak uninstall --unused
```

## 🐍 Language-Specific Package Managers

### Python - pip
```bash
# Install pip
sudo apt install python3-pip  # Ubuntu/Debian
sudo yum install python3-pip  # CentOS/RHEL

# Install package
pip install package_name

# Install specific version
pip install package_name==1.2.3

# Install from requirements file
pip install -r requirements.txt

# List installed packages
pip list

# Show package information
pip show package_name

# Update package
pip install --upgrade package_name

# Uninstall package
pip uninstall package_name

# Create requirements file
pip freeze > requirements.txt

# Install in virtual environment
python -m venv myenv
source myenv/bin/activate
pip install package_name
```

### Node.js - npm
```bash
# Install Node.js and npm
sudo apt install nodejs npm  # Ubuntu/Debian
sudo yum install nodejs npm  # CentOS/RHEL

# Install package globally
sudo npm install -g package_name

# Install package locally
npm install package_name

# Install from package.json
npm install

# List installed packages
npm list

# List global packages
npm list -g

# Update package
npm update package_name

# Uninstall package
npm uninstall package_name

# Show package information
npm info package_name

# Initialize new project
npm init

# Run scripts
npm run script_name
```

### Ruby - gem
```bash
# Install Ruby and gem
sudo apt install ruby-full  # Ubuntu/Debian
sudo yum install ruby rubygems  # CentOS/RHEL

# Install gem
gem install gem_name

# Install specific version
gem install gem_name -v 1.2.3

# List installed gems
gem list

# Update gem
gem update gem_name

# Uninstall gem
gem uninstall gem_name

# Show gem information
gem info gem_name

# Install from Gemfile
bundle install

# Update Gemfile.lock
bundle update
```

## 🔧 Package Management Best Practices

### Security Updates
```bash
# Ubuntu/Debian - security updates only
sudo apt update && sudo apt upgrade -s | grep -i security

# Install security updates
sudo unattended-upgrade

# Configure automatic updates
sudo dpkg-reconfigure -plow unattended-upgrades

# CentOS/RHEL - security updates
sudo yum --security update

# List security updates
yum --security check-update
```

### Package Verification
```bash
# Verify package integrity (Debian/Ubuntu)
sudo apt install debsums
debsums -c

# Verify RPM packages
rpm -Va

# Check package signatures
rpm --checksig package.rpm

# Verify snap packages
snap info package_name | grep publisher
```

### Repository Management
```bash
# Backup sources list (Debian/Ubuntu)
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

# Backup repository configuration (CentOS/RHEL)
sudo cp -r /etc/yum.repos.d/ /etc/yum.repos.d.backup/

# Test repository connectivity
curl -I https://repository.url/

# Check repository GPG keys
apt-key list  # Debian/Ubuntu
rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n'  # CentOS/RHEL
```

## 🎯 Real-World Scenarios

### System Update Script
```bash
#!/bin/bash
# system_update.sh

# Detect package manager
if command -v apt &> /dev/null; then
    echo "Using APT package manager"
    sudo apt update
    sudo apt upgrade -y
    sudo apt autoremove -y
    sudo apt autoclean
elif command -v yum &> /dev/null; then
    echo "Using YUM package manager"
    sudo yum update -y
    sudo yum autoremove -y
    sudo yum clean all
elif command -v dnf &> /dev/null; then
    echo "Using DNF package manager"
    sudo dnf update -y
    sudo dnf autoremove -y
    sudo dnf clean all
else
    echo "No supported package manager found"
    exit 1
fi

echo "System update completed"
```

### Package Installation Script
```bash
#!/bin/bash
# install_packages.sh

PACKAGES="git curl wget vim htop tree"

# Function to install packages based on distribution
install_packages() {
    if command -v apt &> /dev/null; then
        sudo apt update
        sudo apt install -y $PACKAGES
    elif command -v yum &> /dev/null; then
        sudo yum install -y $PACKAGES
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y $PACKAGES
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm $PACKAGES
    else
        echo "Unsupported package manager"
        exit 1
    fi
}

install_packages
echo "Package installation completed"
```

### Dependency Resolution
```bash
# Check package dependencies before installation
apt-cache depends package_name  # Debian/Ubuntu
yum deplist package_name        # CentOS/RHEL
dnf repoquery --requires package_name  # Fedora

# Simulate installation
apt install -s package_name     # Debian/Ubuntu
yum install --assumeno package_name  # CentOS/RHEL
dnf install --assumeno package_name  # Fedora
```

## 📊 Package Management Monitoring

### Package Audit
```bash
# List packages by size (Debian/Ubuntu)
dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n

# List packages by installation date
grep " install " /var/log/dpkg.log | tail -20

# Find packages not from repositories
apt list --installed | grep -v "automatic"

# Check for broken packages
sudo apt check
sudo dpkg --audit
```

### Repository Health Check
```bash
# Test repository connectivity
apt update 2>&1 | grep -E "(Failed|Error)"

# Check repository signatures
apt-key list | grep -E "(expired|EXPIRED)"

# Verify repository URLs
grep -r "^deb" /etc/apt/sources.list /etc/apt/sources.list.d/
```

## 📚 Interview Questions & Answers

### Fresher Level (1-10)

**Q1: What is a package manager in Linux?**
A: A package manager is a tool that automates the installation, updating, configuration, and removal of software packages. Examples include APT (Debian/Ubuntu), YUM/DNF (Red Hat/CentOS), and Pacman (Arch Linux).

**Q2: What's the difference between apt and apt-get?**
A: apt is a newer, more user-friendly command that combines features from apt-get and apt-cache. apt provides colored output, progress bars, and is designed for interactive use, while apt-get is more stable for scripting.

**Q3: How do you install a package in Ubuntu?**
A: Use `sudo apt update` to refresh package list, then `sudo apt install package_name` to install. You can also install multiple packages: `sudo apt install package1 package2`.

**Q4: What is the difference between remove and purge in APT?**
A: `apt remove` removes the package but keeps configuration files. `apt purge` removes both the package and its configuration files completely.

**Q5: How do you search for packages in different Linux distributions?**
A: Ubuntu/Debian: `apt search keyword`, CentOS/RHEL: `yum search keyword` or `dnf search keyword`, Arch: `pacman -Ss keyword`.

### Intermediate Level (6-15)

**Q6: How do you handle broken package dependencies?**
A: Use `sudo apt --fix-broken install` (Ubuntu/Debian) or `sudo yum-complete-transaction --cleanup-only` (CentOS). Also check with `sudo dpkg --configure -a` and `sudo apt autoremove`.

**Q7: Explain the difference between YUM and DNF.**
A: DNF is the next-generation package manager that replaced YUM in Fedora 22+ and CentOS 8+. DNF has better dependency resolution, improved performance, cleaner API, and uses libsolv for dependency solving.

**Q8: How do you add a third-party repository safely?**
A: Import the GPG key first, add the repository with proper authentication, verify the repository URL, and test with a non-critical package before full use. Always backup existing repository configuration.

**Q9: What are Snap and Flatpak packages?**
A: Universal package formats that work across distributions. Snap (by Canonical) and Flatpak provide sandboxed applications with their dependencies, solving the "dependency hell" problem but using more disk space.

**Q10: How do you perform security-only updates?**
A: Ubuntu: `sudo unattended-upgrade` or configure automatic security updates. CentOS/RHEL: `sudo yum --security update`. Always test in staging environment first.

## 🔑 Key Takeaways

- **Distribution-Specific**: Each Linux distribution has its preferred package manager
- **Security First**: Always verify package signatures and use official repositories
- **Dependency Management**: Understand how package dependencies work and resolve conflicts
- **Automation**: Use scripts for consistent package management across systems
- **Monitoring**: Regularly audit installed packages and keep systems updated