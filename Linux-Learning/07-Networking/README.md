# 07 - Networking

## 🌐 Network Configuration

### ip (Modern Network Configuration)
```bash
# Show all network interfaces
ip addr show
ip a

# Show specific interface
ip addr show eth0

# Add IP address to interface
sudo ip addr add 192.168.1.100/24 dev eth0

# Remove IP address
sudo ip addr del 192.168.1.100/24 dev eth0

# Enable/disable interface
sudo ip link set eth0 up
sudo ip link set eth0 down

# Show routing table
ip route show
ip r

# Add route
sudo ip route add 192.168.2.0/24 via 192.168.1.1

# Delete route
sudo ip route del 192.168.2.0/24

# Show ARP table
ip neigh show
```

### ifconfig (Legacy Network Configuration)
```bash
# Show all interfaces
ifconfig

# Show specific interface
ifconfig eth0

# Configure IP address
sudo ifconfig eth0 192.168.1.100 netmask 255.255.255.0

# Enable/disable interface
sudo ifconfig eth0 up
sudo ifconfig eth0 down

# Set MAC address
sudo ifconfig eth0 hw ether 00:11:22:33:44:55
```

### route (Routing Table)
```bash
# Show routing table
route -n

# Add default gateway
sudo route add default gw 192.168.1.1

# Add specific route
sudo route add -net 192.168.2.0/24 gw 192.168.1.1

# Delete route
sudo route del -net 192.168.2.0/24
```

## 🔍 Network Diagnostics

### ping (Connectivity Test)
```bash
# Basic ping
ping google.com

# Ping with count
ping -c 4 google.com

# Ping with interval
ping -i 2 google.com

# Ping with packet size
ping -s 1000 google.com

# Ping IPv6
ping6 google.com

# Flood ping (root only)
sudo ping -f google.com

# Quiet output
ping -q -c 4 google.com
```

### traceroute (Route Tracing)
```bash
# Trace route to destination
traceroute google.com

# Use ICMP instead of UDP
traceroute -I google.com

# Use TCP
traceroute -T google.com

# Set maximum hops
traceroute -m 15 google.com

# IPv6 traceroute
traceroute6 google.com
```

### nslookup (DNS Lookup)
```bash
# Basic DNS lookup
nslookup google.com

# Reverse DNS lookup
nslookup 8.8.8.8

# Query specific record type
nslookup -type=MX google.com
nslookup -type=NS google.com
nslookup -type=A google.com

# Use specific DNS server
nslookup google.com 8.8.8.8
```

### dig (DNS Investigation)
```bash
# Basic DNS query
dig google.com

# Query specific record type
dig google.com MX
dig google.com NS
dig google.com AAAA

# Reverse DNS lookup
dig -x 8.8.8.8

# Use specific DNS server
dig @8.8.8.8 google.com

# Short output
dig +short google.com

# Trace DNS resolution
dig +trace google.com

# Query all record types
dig google.com ANY
```

### host (DNS Lookup)
```bash
# Basic lookup
host google.com

# Reverse lookup
host 8.8.8.8

# Query specific record type
host -t MX google.com
host -t NS google.com

# Verbose output
host -v google.com
```

## 🔌 Port and Service Management

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

# Show multicast groups
netstat -g
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

# Show socket summary
ss -s
```

### lsof (List Open Files)
```bash
# Show network connections
lsof -i

# Show connections on specific port
lsof -i :80
lsof -i :22

# Show connections by protocol
lsof -i tcp
lsof -i udp

# Show connections by process
lsof -i -p PID

# Show listening ports
lsof -i -sTCP:LISTEN

# Show established connections
lsof -i -sTCP:ESTABLISHED
```

### nmap (Network Mapper)
```bash
# Install nmap
sudo apt install nmap  # Ubuntu/Debian
sudo yum install nmap  # CentOS/RHEL

# Scan single host
nmap 192.168.1.1

# Scan range of IPs
nmap 192.168.1.1-254

# Scan subnet
nmap 192.168.1.0/24

# Scan specific ports
nmap -p 22,80,443 192.168.1.1

# Scan port range
nmap -p 1-1000 192.168.1.1

# TCP SYN scan
nmap -sS 192.168.1.1

# UDP scan
nmap -sU 192.168.1.1

# OS detection
nmap -O 192.168.1.1

# Service version detection
nmap -sV 192.168.1.1

# Aggressive scan
nmap -A 192.168.1.1

# Fast scan
nmap -F 192.168.1.1
```

## 📡 Network Monitoring

### tcpdump (Packet Capture)
```bash
# Capture all traffic
sudo tcpdump

# Capture on specific interface
sudo tcpdump -i eth0

# Capture specific protocol
sudo tcpdump icmp
sudo tcpdump tcp
sudo tcpdump udp

# Capture specific port
sudo tcpdump port 80
sudo tcpdump port 22

# Capture specific host
sudo tcpdump host 192.168.1.1

# Capture and save to file
sudo tcpdump -w capture.pcap

# Read from file
tcpdump -r capture.pcap

# Verbose output
sudo tcpdump -v
sudo tcpdump -vv
sudo tcpdump -vvv

# Show packet contents
sudo tcpdump -X

# Capture specific number of packets
sudo tcpdump -c 100
```

### wireshark (GUI Packet Analyzer)
```bash
# Install wireshark
sudo apt install wireshark  # Ubuntu/Debian
sudo yum install wireshark  # CentOS/RHEL

# Start wireshark
wireshark

# Command line version
tshark

# Capture to file
tshark -w capture.pcap

# Read from file
tshark -r capture.pcap

# Filter traffic
tshark -f "tcp port 80"
```

### iftop (Interface Traffic Monitor)
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

# Don't resolve hostnames
sudo iftop -n
```

### nethogs (Process Network Usage)
```bash
# Install nethogs
sudo apt install nethogs  # Ubuntu/Debian
sudo yum install nethogs  # CentOS/RHEL

# Monitor network usage by process
sudo nethogs

# Monitor specific interface
sudo nethogs eth0

# Refresh delay
sudo nethogs -d 5
```

## 🔧 Network Configuration Files

### /etc/network/interfaces (Debian/Ubuntu)
```bash
# Static IP configuration
auto eth0
iface eth0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
    dns-nameservers 8.8.8.8 8.8.4.4

# DHCP configuration
auto eth0
iface eth0 inet dhcp

# Restart networking
sudo systemctl restart networking
```

### NetworkManager (Modern Linux)
```bash
# Show connections
nmcli connection show

# Show devices
nmcli device status

# Create connection
nmcli connection add type ethernet con-name "my-connection" ifname eth0

# Modify connection
nmcli connection modify "my-connection" ipv4.addresses 192.168.1.100/24
nmcli connection modify "my-connection" ipv4.gateway 192.168.1.1
nmcli connection modify "my-connection" ipv4.dns 8.8.8.8
nmcli connection modify "my-connection" ipv4.method manual

# Activate connection
nmcli connection up "my-connection"

# Show WiFi networks
nmcli device wifi list

# Connect to WiFi
nmcli device wifi connect "SSID" password "password"
```

### /etc/hosts (Host Resolution)
```bash
# Edit hosts file
sudo nano /etc/hosts

# Example entries:
127.0.0.1       localhost
192.168.1.100   server1.local server1
192.168.1.101   server2.local server2

# Test host resolution
getent hosts server1.local
```

### /etc/resolv.conf (DNS Configuration)
```bash
# View DNS configuration
cat /etc/resolv.conf

# Example configuration:
nameserver 8.8.8.8
nameserver 8.8.4.4
search local.domain
domain local.domain

# Test DNS resolution
nslookup google.com
```

## 🔒 Network Security

### iptables (Firewall)
```bash
# Show current rules
sudo iptables -L

# Show rules with line numbers
sudo iptables -L --line-numbers

# Allow incoming SSH
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow incoming HTTP
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Allow incoming HTTPS
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Block specific IP
sudo iptables -A INPUT -s 192.168.1.100 -j DROP

# Allow loopback traffic
sudo iptables -A INPUT -i lo -j ACCEPT

# Allow established connections
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Set default policies
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Save rules (Ubuntu/Debian)
sudo iptables-save > /etc/iptables/rules.v4

# Restore rules
sudo iptables-restore < /etc/iptables/rules.v4

# Delete rule by number
sudo iptables -D INPUT 1

# Flush all rules
sudo iptables -F
```

### ufw (Uncomplicated Firewall)
```bash
# Enable firewall
sudo ufw enable

# Disable firewall
sudo ufw disable

# Show status
sudo ufw status
sudo ufw status verbose

# Allow service
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https

# Allow specific port
sudo ufw allow 8080

# Allow from specific IP
sudo ufw allow from 192.168.1.100

# Deny traffic
sudo ufw deny 23

# Delete rule
sudo ufw delete allow ssh

# Reset firewall
sudo ufw --force reset
```

## 📊 Network Performance Testing

### iperf3 (Bandwidth Testing)
```bash
# Install iperf3
sudo apt install iperf3  # Ubuntu/Debian
sudo yum install iperf3  # CentOS/RHEL

# Start server
iperf3 -s

# Start client
iperf3 -c server_ip

# Test for specific duration
iperf3 -c server_ip -t 30

# Test UDP
iperf3 -c server_ip -u

# Test with multiple streams
iperf3 -c server_ip -P 4

# Test reverse direction
iperf3 -c server_ip -R
```

### wget/curl (HTTP Testing)
```bash
# Download speed test
wget -O /dev/null http://speedtest.example.com/file

# Curl with timing
curl -w "@curl-format.txt" -o /dev/null -s http://example.com

# Curl format file:
echo "     time_namelookup:  %{time_namelookup}\n
        time_connect:  %{time_connect}\n
     time_appconnect:  %{time_appconnect}\n
    time_pretransfer:  %{time_pretransfer}\n
       time_redirect:  %{time_redirect}\n
  time_starttransfer:  %{time_starttransfer}\n
                     ----------\n
          time_total:  %{time_total}\n" > curl-format.txt
```

## 🎯 Real-World Scenarios

### Network Troubleshooting Workflow
```bash
#!/bin/bash
# network_troubleshoot.sh

echo "=== Network Troubleshooting ==="

# Check interface status
echo "1. Interface Status:"
ip addr show

# Check routing
echo "2. Routing Table:"
ip route show

# Check DNS
echo "3. DNS Resolution:"
nslookup google.com

# Check connectivity
echo "4. Connectivity Test:"
ping -c 4 8.8.8.8

# Check services
echo "5. Listening Services:"
ss -tulpn
```

### Port Scanner Script
```bash
#!/bin/bash
# port_scan.sh

HOST=$1
START_PORT=$2
END_PORT=$3

if [ $# -ne 3 ]; then
    echo "Usage: $0 <host> <start_port> <end_port>"
    exit 1
fi

echo "Scanning $HOST from port $START_PORT to $END_PORT"

for port in $(seq $START_PORT $END_PORT); do
    timeout 1 bash -c "echo >/dev/tcp/$HOST/$port" 2>/dev/null && 
    echo "Port $port is open"
done
```

## 📚 Interview Questions & Answers

### Fresher Level (1-10)

**Q1: What is the difference between TCP and UDP?**
A: TCP (Transmission Control Protocol) is connection-oriented, reliable, and ensures data delivery with error checking. UDP (User Datagram Protocol) is connectionless, faster, but doesn't guarantee delivery. TCP is used for web browsing, email; UDP for streaming, gaming.

**Q2: How do you check network connectivity in Linux?**
A: Use ping command: `ping google.com` to test connectivity. Also use `traceroute` to see the path, `telnet host port` to test specific ports, and `nc -zv host port` for port testing.

**Q3: What is the purpose of /etc/hosts file?**
A: The /etc/hosts file maps hostnames to IP addresses locally, bypassing DNS. It's checked before DNS queries. Format: `IP_ADDRESS hostname alias`. Used for local development, blocking sites, or quick hostname resolution.

**Q4: How do you find which process is using a specific port?**
A: Use `netstat -tulpn | grep :port` or `ss -tulpn | grep :port` or `lsof -i :port`. These commands show the process ID and name using the specified port.

**Q5: What is the difference between netstat and ss commands?**
A: ss is the modern replacement for netstat. ss is faster, provides more information, and is actively maintained. netstat is legacy but still widely used. Both show network connections and listening ports.

### Intermediate Level (6-15)

**Q6: How do you configure a static IP address in Linux?**
A: Edit `/etc/network/interfaces` (Debian/Ubuntu) or use NetworkManager: `nmcli connection modify "connection-name" ipv4.addresses 192.168.1.100/24 ipv4.gateway 192.168.1.1 ipv4.method manual`

**Q7: Explain the OSI model layers.**
A: 7 layers: Physical (cables), Data Link (MAC), Network (IP), Transport (TCP/UDP), Session (connections), Presentation (encryption), Application (HTTP, FTP). Each layer has specific functions in network communication.

**Q8: How do you capture network packets in Linux?**
A: Use `tcpdump`: `sudo tcpdump -i eth0 -w capture.pcap` to capture packets to file. Use `wireshark` or `tshark` for GUI analysis. Filter with expressions like `tcpdump host 192.168.1.1` or `tcpdump port 80`.

**Q9: What is NAT and how does it work?**
A: Network Address Translation translates private IP addresses to public IPs. Allows multiple devices to share one public IP. Types: Static NAT (1:1), Dynamic NAT (pool), PAT/NAPT (port-based). Essential for IPv4 address conservation.

**Q10: How do you troubleshoot DNS issues?**
A: Check `/etc/resolv.conf` for DNS servers, use `nslookup` or `dig` to test resolution, verify `/etc/hosts` file, check network connectivity to DNS servers, and test with different DNS servers like 8.8.8.8.

## 🔑 Key Takeaways

- **Modern Tools**: Prefer `ip` over `ifconfig`, `ss` over `netstat`
- **Security**: Always configure firewalls and monitor network traffic
- **Troubleshooting**: Follow systematic approach: interface → routing → DNS → connectivity
- **Monitoring**: Use appropriate tools for different network aspects
- **Documentation**: Keep network configurations documented and backed up