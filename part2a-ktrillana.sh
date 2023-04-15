# Flush All Iptables Chains/Firewall rules
echo "-------------------------------------------"
echo "Flush All Iptables Chains/Firewall rules"
iptables -F
iptables -t nat -F

# Delete all Iptables Chains
echo "-------------------------------------------"
echo "Delete all Iptables Chains"
iptables -X

# Allow any INPUT tcp traffic if RELATED or ESTABLISHED
echo "-------------------------------------------"
echo "Allow any INPUT tcp traffic if RELATED or ESTABLISHED"
iptables -A INPUT -p tcp -m state --state RELATED,ESTABLISHED -j ACCEPT

# Allow icmp traffic into the VM
echo "-------------------------------------------"
echo "Allow icmp traffic into the VM"
iptables -A INPUT -p icmp -j ACCEPT

# Allow any traffic from loopback interface into the VM
echo "-------------------------------------------"
echo "Allow any traffic from loopback interface into the VM"
iptables -A INPUT -i lo -j ACCEPT

# Firewall Settings to allow specific traffic on Router FORWARD chain

echo "-------------------------------------------"
echo "DNS"
echo "allow any tcp and udp traffic pass through Linux router for DNS protocol"
iptables -A FORWARD -p tcp -d 172.17.157.36 --dport 53 -j ACCEPT
iptables -A FORWARD -p tcp -s 172.17.157.36 --sport 53 -j ACCEPT
iptables -A FORWARD -p udp -d 172.17.157.36 --dport 53 -j ACCEPT
iptables -A FORWARD -p udp -s 172.17.157.36 --sport 53 -j ACCEPT
iptables -A INPUT -p tcp -s 172.17.157.36 --sport 53 -j ACCEPT

# allow custom port for partner Apache Server
iptables -A FORWARD -p tcp -s 10.61.45.0/24 -d 192.168.158.36 --dport 28158 -j ACCEPT
iptables -A FORWARD -p tcp -s 192.168.158.36 -d 10.61.45.0/24 --sport 28158 -j ACCEPT

# allow custom port for partner MySQL Server
iptables -A FORWARD -p tcp -s 10.61.45.0/24 -d 192.168.158.36 --dport 26158 -j ACCEPT
iptables -A FORWARD -p tcp -s 192.168.158.36 -d 10.61.45.0/24 --sport 26158 -j ACCEPT

# allow custom port for partner IIS Server
iptables -A FORWARD -p tcp -s 10.61.45.0/24 -d 192.168.158.36 --dport 29158 -j ACCEPT
iptables -A FORWARD -p tcp -s 192.168.158.36 -d 10.61.45.0/24 --sport 29158 -j ACCEPT

# allow custom port for partner Windows Server RDP
iptables -A FORWARD -p tcp -s 10.61.45.0/24 -d 192.168.158.36 --dport 23158 -j ACCEPT
iptables -A FORWARD -p tcp -s 192.168.158.36 -d 10.61.45.0/24 --sport 23158 -j ACCEPT

# allow custom port for partner Linux Server SSH
iptables -A FORWARD -p tcp -s 10.61.45.0/24 -d 192.168.158.36 --dport 22158 -j ACCEPT
iptables -A FORWARD -p tcp -s 192.168.158.36 -d 10.61.45.0/24 --sport 22158 -j ACCEPT

echo "-------------------------------------------"
echo "MySQL"
echo "allow any tcp traffic pass through Source WC-157 subnet to Destination LS-xx for destination MySQL protocol"
iptables -A FORWARD -p tcp -s 10.61.45.0/24 -d 172.17.157.37 --dport 3306 -j ACCEPT
echo "allow any tcp traffic pass through Source WS-xx to destination WC-157 subnet for source MySQL protocol"
iptables -A FORWARD -p tcp -d 10.61.45.0/24 -s 172.17.157.37 --sport 3306 -j ACCEPT

echo "-------------------------------------------"
echo "Apache"
echo "allow any tcp traffic pass through Source WC-157 subnet to Destination WS-157 for destination Apache protocol"
iptables -A FORWARD -p tcp -s 10.61.45.0/24 -d 172.17.157.37 --dport 80 -j ACCEPT
echo "allow any tcp traffic pass through Source WS-157 to destination WC-157 subnet for source Apache protocol"
iptables -A FORWARD -p tcp -d 10.61.45.0/24 -s 172.17.157.37 --sport 80 -j ACCEPT

echo "-------------------------------------------"
echo "IIS"
echo "allow any tcp traffic pass through Source WC-157 subnet to Destination LR-157 for destination HTTP protocol to access IIS"
iptables -A FORWARD -p tcp -s 10.61.45.0/24 -d 172.17.157.36 --dport 80 -j ACCEPT
echo "allow any tcp traffic pass through Source LS-157 to destination WC-157 subnet for source HTTP protocol to access IIS"
iptables -A FORWARD -p tcp -d 10.61.45.0/24 -s 172.17.157.36 --sport 80 -j ACCEPT

echo "-------------------------------------------"
echo "FTP Administration Port"
echo "allow any tcp traffic pass through Source WC-157 subnet to Destination LR-157 for destination FTP protocol"
iptables -A FORWARD -p tcp -s 10.61.45.0/24 -d 172.17.157.36 --dport 21 -j ACCEPT
echo "allow any tcp traffic pass through Source LS-157 to destination WC-157 subnet for source FTP protocol"
iptables -A FORWARD -p tcp -d 10.61.45.0/24 -s 172.17.157.36 --sport 21 -j ACCEPT

echo "-------------------------------------------"
echo "FTP DATA Port"
echo "allow any tcp traffic pass through Source WC-157 subnet to Destination LR-157 for destination FTP protocol"
iptables -A FORWARD -p tcp -s 10.61.45.0/24 -d 172.17.157.36 --dport 50000:51000 -j ACCEPT
echo "allow any tcp traffic pass through Source LS -157 to destination WC-157 subnet for source FTP protocol"
iptables -A FORWARD -p tcp -d 10.61.45.0/24 -s 172.17.157.36 --sport 50000:51000 -j ACCEPT

# Allow all SSH traffic on port 22 from Source IP subnet student_vnet
echo "-------------------------------------------"
echo "Allow all SSH traffic on port 22 from Source IP subnet student_vnet"
iptables -A INPUT -p tcp -s 10.61.45.0/24 -m state --state NEW --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -s 10.61.45.0/24 -m state --state NEW --dport 22157 -j ACCEPT

# Log before DROPPING
echo "-------------------------------------------"
echo "Add a rule to LOG instead of DROPPING INPUT packets"
iptables -A INPUT -p all -m limit --limit 10/s -j LOG  --log-prefix "TO_DROP_INPUT"

# Reject all other INPUT traffic
# echo "-------------------------------------------"
# echo "Reject all other INPUT traffic"
iptables -A INPUT -j DROP

# Allow forwarding SSH traffic on port 22 from Windows Client to Server SN1
echo "-------------------------------------------"
echo "SSH"
echo "Allow forwarding all SSH traffic on port 22 from any source to any destination"
iptables -A FORWARD -p tcp -s 10.61.45.0/24 -d 172.17.157.32/27 --dport 22 -j ACCEPT
iptables -A FORWARD -p tcp -s 172.17.157.32/27 -d 10.61.45.0/24 --sport 22 -j ACCEPT


# Allow forwarding RDP traffic on port 3389 from from Windows Client to Server SN1
echo "-------------------------------------------"
echo "RDP"
echo "Allow forwarding all RDP traffic on port 3389 from any source to any destination"
iptables -A FORWARD -p tcp -s 10.61.45.0/24 -d 172.17.157.32/27 --dport 3389 -j ACCEPT
iptables -A FORWARD -p tcp -s 172.17.157.32/27 -d 10.61.45.0/24 --sport 3389 -j ACCEPT

# Log before DROPPING
echo "-------------------------------------------"
echo "Add a rule to LOG instead of DROPPING FORWARD packets"
iptables -A FORWARD -p all -m limit --limit 10/s -j LOG --log-prefix "TO_DROP_FORWARD"

# Reject all other FORWARD traffic from this machine
# echo "-------------------------------------------"
# echo "Reject all other FORWARD traffic from this machine"
iptables -A FORWARD -j DROP

# Allow all output traffic from this machine
echo "-------------------------------------------"
echo "Allow all output traffic from this machine"
iptables -A OUTPUT -j ACCEPT

# List current iptables status
echo "-------------------------------------------"
echo "list current iptables status"
iptables -nvL --line-number
iptables -nvL -t nat --line-number




