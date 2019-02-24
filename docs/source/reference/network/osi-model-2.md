# OSI Model Layer 2

Second Layer

Data link layer

Defines how to transfer data among network nodes, how data is formatted for transmission,
how access to network is controlled.

Also error detection.

Data in this layer is called frames.

## Devices

* NIC
* Bridge
* Switch

Switch is more common

## LAN

Local Area Network

A network that is local. Usually network entities inside are close to
each other.

## Protocols

There are many protocols that can be used for this layer.

* PPP (Point-to-Point)
* FR (Frame Relay)
* Ethernet
* ...

Ethernet is the most used one.

## Standards

The standards for Ethernet and LAN and so on are defined in:

* IEEE 802.2
* IEEE 802.3
* ...

## Sub-layers

Data Link Layer has 2 sub-layer

* LLC (Logical Link Control Layer)
* MAC (Media Access Control)

## MAC Addressing

Used for communication of a network segment.

There are many nodes in one network

An identification for specific ones

See [MAC address - Wikipedia](https://en.wikipedia.org/wiki/MAC_address)
for more details (about 48-bit structure)

Each MAC address of one hardware is (supposed to be) unique and cannot be changed.

It has 48 bits, 2 parts.

* OUI
  * Organizationally Unique Identification
* Vendor Assigned

MAC Address also has some special bits indicating
unicast vs multicast and globally unique vs locally administered.

Since the number of devices is much larger than 48 bits, MAC address is hard to be unique any more.

It's usually represented in hexadecimal.

## Ethernet Frame Structure

Each layer will "attach" its HDR to the data is OSI model.

And the HDR for this layer with Ethernet as the protocol is
called Ethernet Frame Structure.

[Learn more](https://en.wikipedia.org/wiki/Ethernet_frame#Structure)

FCS (Frame Check Sequence) is used for error detection.

Devices will check the destination address when receiving a frame.

IEEE 802.3.

## Communication Within LAN

* Unicast
  * 1 to 1
* Broadcast
  * 1 to all
  * Use FF:FF:FF:FF:FF:FF as the destination address
* Multicast
  * 1 to more
  * [Wikipedia](https://en.wikipedia.org/wiki/Multicast_address#Ethernet)

## Collisions

Collision happens when multiple devices try to access a medium at the same time.

### CSMA/CD

Wired network

Carrier Sense Multiple Access Collision Detection

[Wikipedia](https://en.wikipedia.org/wiki/Carrier-sense_multiple_access_with_collision_detection)

### CSMA/CA

Wireless network

Carrier Sense Multiple Access Collision Avoidance

[Wikipedia](https://en.wikipedia.org/wiki/Carrier-sense_multiple_access_with_collision_avoidance)