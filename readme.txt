Problems:
1. can match only two rates by definition
2. what to do with the blocked ips. blacklist permanently. currently blacklisted for 10 minutes
3. more checks to be added?

Things to keep in mind:
1. Rules get applied in order they are present in the table
2. use sudo
3. 10mb -> 10mbytes not mbits, Similarly 10mbps -> 10mbytes per sec
4. hardcoded vals which needs to be changed or put in config:
	a. max elements in ipset blacklist - 10^5
	b. blacklist time - 10 minutes / 600 secs
	c. udp packets destined to port 8002 on the host machine are filtered
	d. rate : 1mbps
	e. burst of 10mbs allowed


Software used to test:
Packet sender:https://packetsender.com/
Under intense traffic mode. With various packet sizes and intervals

things tested:
1. ipset creation for blacklist
2. burst limit works fine. No packets were dropped until burst cap of 10 mb regardless of rate
3. if packet rate exceeds given rate after burst limit: the ip is added to blacklist for 10 minutes, and subsequent packets are dropped

things to test/todo:
1. when does 10 mb burst limit gets reset?
2. does logging work? where does it get logged
3. sample the log. not to log all dropped packets



Commands:

echo -n "hello" >/dev/udp/<ip>/<port>

nc -u <ip> <port> < /dev/random

saving iptables:
sudo /sbin/iptables-save

reset counters:
sudo iptables -Z -t <table>

-P default policy

IPtables
-p udp
--hashlimit-above amount[/second|/minute|/hour|/day]
Match if the rate is above amount/quantum
--hashlimit-burst amount
--hashlimit-mode srcip
// to contruct hash tables per scrip
--hashlimit-name foo
The name for the /proc/net/ipt_hashlimit/foo entry.
srcip option
--hashlimit-htable-size buckets
The number of buckets of the hash table
--hashlimit-htable-max entries
Maximum entries in the hash. what is the max number of entries possible



