# Linux Network Config

## Ethernet

In Linux, ethernet interfaces are labelled as eth0, eth1, ...

## Display Hardware Information

`lspci`

pci network cards

`lsusb`

usb network cards

## Display Interface Information

```bash
ip addr
ip link
ip -s link

#ifconfig # obsolete
```

### Interface Terms

`eth0`

ethernet interface

`lo`

loopback interface (127.0.0.1)

`rx`

receive

`tx`

transmit

## Enable/Disable Interfaces

```bash
ifup eth0
ifdown eth0
```

## Network Config Files

This changes for different distributions.

Read the document for your linux distribution to understand how to config those.

### Debian Interface Config

```bash
man interfaces
sudo vim /etc/network/interfaces
```

### DNS Config

```bash
/etc/resolv.config
```

### Hostname Config

```bash
hostname
hostname <some-name>
sudo vim /etc/hostname
```

### Hosts

Static table lookup for hostnames.

```bash
/etc/hosts
```

## Network Testing Commands

Test connection

```bash
ping IP
ping URL
```

DNS

```bash
host URL
dig URL
```

Display routing table

```bash
ip route
```

Trace route (traces the routing devices)

```bash
traceroute URL/IP
# there might be some restrictions for output
```

Both traceroute and ping

* Updates dynamically
* Continuously send packets to calculate the loss rate
* Contact the network provider of the ones with high loss rate

```bash
mtr URL
```

## Network Troubleshoot

From lower to higher, from inner to outer.

1. Check config files
    * ip
    * subnet mask
    * gateway
    * DNS
2. ping gateway
3. DNS
    * host