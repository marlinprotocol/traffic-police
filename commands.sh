# creating an ipset to add blacklist nodes to
# max elements: 10^5, blacklisted for 10 minutes
ipset create throttled-ips hash:ip timeout 600 family inet maxelem 100000

# drop udp packets belonging to throttled ip's
# drop at raw - prerouting stage itself because thats more efficient
iptables -t raw -A PREROUTING -p udp -m set --match-set throttled-ips src -j DROP

# Create the destination chain/target
iptables -N MARLIN_PUBSUB_TRACKING

# To be configured appropriately
# Direct packets which match certain rules to this chain. src port, dst port
iptables -A INPUT -p udp --dport 8002 \
        -j MARLIN_PUBSUB_TRACKING


iptables -A MARLIN_PUBSUB_TRACKING -m hashlimit \
	--hashlimit-mode srcip \
	--hashlimit-upto 1mb/s \
	--hashlimit-burst 10mb \
	--hashlimit-name marlin-pubsub-packets \
	--hashlimit-htable-max 100000 \
	-j ACCEPT


iptables -A MARLIN_PUBSUB_TRACKING -j SET --add-set throttled-ips srcip --timeout 600 --exist

iptables -A MARLIN_PUBSUB_TRACKING -j LOG --log-prefix "DDOS PROTECTION: "
iptables -A MARLIN_PUBSUB_TRACKING -j DROP


#show ip table rules
sudo iptables -S OUTPUT

#delete rules
sudo iptables -D <chainname> <rule>

#packet counts and sizes
sudo iptables -L INPUT -v
