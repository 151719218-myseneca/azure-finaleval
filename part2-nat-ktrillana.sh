iptables -t nat -F

# to allow other students to access APACHE server 
iptables -t nat -A PREROUTING -p tcp --dport 28157 -j LOG --log-prefix "log-captures-masquerading-Apache "
iptables -t nat -A PREROUTING -p tcp --dport 28157 -j DNAT --to-destination 172.17.157.37:80

# to allow other students to access MySQL server 
iptables -t nat -A PREROUTING -p tcp --dport 26157 -j LOG --log-prefix "log-captures-masquerading-MySQL "
iptables -t nat -A PREROUTING -p tcp --dport 26157 -j DNAT --to-destination 172.17.157.37:3306

# to allow other students to access Linux server - SSH 
iptables -t nat -A PREROUTING -p tcp --dport 22157 -j LOG --log-prefix "log-captures-masquerading-SSH "
iptables -t nat -A PREROUTING -p tcp --dport 22157 -j DNAT --to-destination 172.17.157.37:22

# to allow other students to access IIS server 
iptables -t nat -A PREROUTING -p tcp --dport 29157 -j LOG --log-prefix "log-captures-masquerading-IIS "
iptables -t nat -A PREROUTING -p tcp --dport 29157 -j DNAT --to-destination 172.17.157.36:80

# to allow other students to access Windows server - RDP 
iptables -t nat -A PREROUTING -p tcp --dport 23157 -j LOG --log-prefix "log-captures-masquerading-RDP "
iptables -t nat -A PREROUTING -p tcp --dport 23157 -j DNAT --to-destination 172.17.157.36:3389

# post route
iptables -t nat -A POSTROUTING -o eth0 -j LOG --log-prefix "log-captures-masquerading-Postrouting "
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE