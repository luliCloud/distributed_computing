#!/bin/bash
# Namespace allow users to isolate mount points, PIDs, networks, IPCs, UTS(hostname)
# and user IDs. In this exercise, we will focus on the network virtualization feature
# of namespace

# add two namespace
sudo ip netns add namespace1
sudo ip netns add namespace2
ip netns list
# linke veth1 to 2 via veth (veth1 not link to namespace1 yet)
sudo ip link ad veth1 type veth peer name veth2
# set veth1 named namespace1
sudo ip link set veth1 netns namespace1
sudo ip link set veth2 netns namespace2
# make veth up. ip netns executing following command
sudo ip netns exec namespace1 ip link set dev veth1 up
sudo ip netns exec namespace2 ip link set dev veth2 up
# assign two ip address to 2 veths. noting 192.168.1.1 and 1.2 correspond to 2 veths
sudo ip netns exec namespace1 ip addr add 192.168.1.1/24 dev veth1
sudo ip netns exec namespace2 ip addr add 192.168.1.2/24 dev veth2
# ping from veth1 to 2
sudo ip netns exec namespace1 ping -c5 192.168.1.2
#PING 192.168.1.2 (192.168.1.2) 56(84) bytes of data.
#64 bytes from 192.168.1.2: icmp_seq=1 ttl=64 time=0.058 ms
#64 bytes from 192.168.1.2: icmp_seq=2 ttl=64 time=0.063 ms
#64 bytes from 192.168.1.2: icmp_seq=3 ttl=64 time=0.057 ms
#64 bytes from 192.168.1.2: icmp_seq=4 ttl=64 time=0.039 ms
#64 bytes from 192.168.1.2: icmp_seq=5 ttl=64 time=0.050 ms

#- -- 192.168.1.2 ping statistics ---
#5 packets transmitted, 5 received, 0% packet loss, time 4099ms
#rtt min/avg/max/mdev = 0.039/0.053/0.063/0.008 ms
sudo ip netns exec namespace2 ping -c5 192.168.1.1

# delete two namespaces
sudo ip netns delete namespace1
sudo ip netns delete namespace2
netns list

# sudo ip netns exec namespace1 ip route
# ip netns : ip command with netnamesapce; exec: executing following command
# this command is used for debugging, when I found the ping of ns1 receive 0 response 
# from namespace2

# 我用这个发现ns1 和 2都连接到192.168.1.1 显然这个连接是错的，并且没有被后面的连接覆盖
# 所以我重设了整个过程


