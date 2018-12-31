# Network DevOps Basic

The basic and simplified network knowledge to know for DevOps

## Addressing

### Goal

Computers need a way to decide the target server to communicate.

To have a unique address is "addressing".

### IP Addressing (IP Protocol)

The most popular way of addressing.

An IP address represents a host or a network interface.

### IPv4

Currently the most commonly used.

But the total number of unique IPv4 addresses is not enough as the internet grows.

IPv4 is a 32-bit number and is divided into 4 parts with 8 bits each part.

```bash
192.168.1.1
11000000.10101000.000000001.000000001
```

This 32-bit number is also divided to be 2 parts:

* Network Identifier
* Host Identifier

There is no fixed length for these 2 parts.

Another numerical label, "subnet mask", is used to determine this length.

Subnet mask is usually simple. It also has 32 bits and each bit corresponds to a bit in IP address.

```bash
255.255.255.0
11111111.11111111.11111111.00000000
```

The "1" bits of subnet mask represents the network identifer part of this IP address. 

Only given both IP address and subnet mask can we decide which is which.

The example above can be represented as:

```bash
192.168.1.1/24
```

where 24 means there are 24 "1" bits in subnet mask.

### IPv6

IPv6 is 128-bit long. It basically solves the problem of insufficient IP addresses caused by the short length of IPv4.

People are gradually switching to IPv6 from IPv4.

[Read more about IP addresses](https://www.cisco.com/c/en/us/about/press/internet-protocol-journal/back-issues/table-contents-12/ip-addresses.html)

## MAC (Media Access Control)

Used for communication within the same network.

MAC is the "hardware" address for a network interface controller.

In OSI model, this is the second layer. (IP is the third layer)

## Communication within Same Network

When the IP addresses of different devices share the same network identifier
(the bits "masked" by the subnet mask are identical), we say theses devices
are within the same network.

1. Sender uses ARP (Address Resolve Protocol) to retrieve MAC address from the IP address of receiver
     * All devices receives this ARP, but only the device with the requested IP address will respond
2. Get MAC address
3. Communicate
     * Usually devices within the same network are connected with wires or network switches.

## Communication outside of Same Network

Routers or gateways are needed. (Devices with routing functionality)

Usually there are more than 10 routers between 2 devices.

### Router

Forwards packets between different networks.

Each router has multiple data lines that are connected to different networks.

Routers forward data packets based on routing tables.

### Procedure

1. Receiver is decided to be in another network
2. Sender sens packet to router/gateway
3. Router looks up the routing table
4. It forwards data
    * For example, from eth0 to eth1

## Domain Name

The URLs uses type in the address bar of the browsers.

They are case-insensitive.

It is hard to memorize the IP address, so people use domain names.

Domain name is divided into 3 parts:

```bash
www.some.domain.
```

It is read from right to left:

1. type of this domain (Top-level domain)
    * com: company
    * net
    * org: organization
    * edu
    * gov
2. domain (Second-level domain)
3. host name
    * In the example above, www represents a host called "www" in the domain of "some"
    * "www" is a convention or something historical ([more](https://serverfault.com/questions/145777/what-s-the-point-in-having-www-in-a-url))

Note the dot at the end represents the root domain.

Host name can be anything.

First locate the domain then the host.

### DNS (Domain Name Service)

Translates domain name to IP.

DNS are provided by DNS servers.

## Basic Network Config

### Local Area Network

* IP
* Subnet Mask

### Wide Area Network

* IP
* Subnet Mask
* Gateway

### Internet

* IP
* Subnet Mask
* Gateway
* DNS