# Ubuntu 18.04 Server installation notes

Networking is always tricky. Unfortunately this particular version of
Ubuntu Server made it much worse:
* the `netplan.io` makes it difficult to set up any scenarios
* the `systemd-networkd` cannot use any extra dhcp request parameters

### My situation

My company is ipv4 based, completely ingoring ipv6.
Strangely private ipv6 work at least on single network segment.
Company uses specific DHCPv4 request parameters, particularly
_vendor-class-identifier_ and _user-class_. If they are provided, the
client machine is added to company DNS, it is allowed to go through
http proxy and also obtains "normal" mtu 1500. Otherwise the client has
no DNS record, no internet access, and mtu just 576. I also tried to set up
"static" ipv6 address (see https://simpledns.com/private-ipv6 ), but it
requires mtu 1200+.

### What's wrong with systemd-networkd

When systemd-networkd obtains new lease or refreshes old one, it removes
all other dhcp-based addresses. While it is theoretically possible to run
dhclient in paralel, once it's _networkd_ turn, it acts that ugly. It also
sets mtu to the dhcp obtained one, ignoring needs of ipv6.
On top of it _networkd_ is barely configurable. 

## Manual workaround just to have internet access (until reboot)

1. Find the ethernet interface name and mac address
   <pre>
   ip link
   </pre>
1. turn of systemd-networkd
   <pre>
   systemctl stop    systemd-networkd.socket systemd-networkd networkd-dispatcher systemd-networkd-wait-online
   systemctl disable systemd-networkd.socket systemd-networkd networkd-dispatcher systemd-networkd-wait-online
   systemctl mask    systemd-networkd.socket systemd-networkd networkd-dispatcher systemd-networkd-wait-online
   </pre>
1. Configure /etc/dhcp/dhclient.conf according to company rules
1. run dhclient
   <pre>
   dhclient -r
   dhclient -v
   dhclient -r
   dhclient -v
   </pre>
1. check ip address and mtu size
   <pre>
   ip addr
   </pre>

#### Optional: add ipv6 address 
1. Find usable unique private IPv6 address range, e.g. at
   https://simpledns.com/private-ipv6
   Is is basically /64 prefix, so
   it could be clever to use :0:_<mac_address> as the machine part.
   Of course all machines on the same network segment must have the same
   prefix to be mutualy reachable.
1. configure ipv6:
   <pre>
   ETH=<i>interface name></i>
   ADDR=<i>ipv6 private address</i>
   ip link set dev $ETH mtu 1500
   ip -6 addr add $ADDR/64 dev $ETH
   ip link set dev $ETH up
   </pre>
1. It works until next reboot. Use it to install permanent solution.

## Permanent solution

1. Prerequisities:
   * systemd-networkd turned off (see above)
   * temporary gained correct ipv4 address via dhclient (see above)
1. install classic networking suite
   <pre>
   apt-get install ifupdown
   apt-get remove --purge netplan.io
   </pre>
1. Find the ethernet interface name and mac address
   <pre>
   ip link
   </pre>
1. configure network interfaces replacing _eno1_ with correct network interface name
   <pre>
   auto lo
   iface lo inet loopback

   auto <i>eno1</i>
   allow-hotplug <i>eno1</i>
   iface <i>eno1</i> inet dhcp

   iface <i>eno1</i> inet6 static
   address <i>your-static-ipv6-address</i>/64
   <pre>
1. restart networking
   <pre>
   systemctl restart networking
   </pre>
