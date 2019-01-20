# OSI Model

Open Systems Interconnection (OSI) Model

[Wikipedia](https://en.wikipedia.org/wiki/OSI_model)

Use 7 layers to define basic functions of Internet.

Published by ISO in 1984.

The basic model for today's Internet.

OSI is just a model, not any implementation.

The most popular TCP/IP protocol is designed based on OSI model, or,
an implementation of several layers of OSI.

(Why include links? Repeating is meaningless. Here is just a summary)

## Why

* Reduces complexity
* Standardizes interfaces
* Facilitates modular engineering
* Ensures interoperable technology
* Accelerates evolution
* Simplifies teaching and learning

It defines standardized interfaces between different layers.
So that all layers can be independent and can have different implementations.

## Layers

From bottom to top.

```markdown
7 Application
6 Presentation
5 Session
4 Transport
3 Network
2 Data Link
1 Physical
```

## 1 Physical Layer

Bits

The most basic physical transmission.

"Is the wifi working?"

Binary raw bit transmission.

* electrical, mechanical, procedural, and functional specifications of the physical link

From wikipedia:

> The physical layer is responsible for the transmission and reception of unstructured
> raw data between a device and a physical transmission medium.
> It converts the digital bits into electrical, radio, or optical signals.

[Wikipedia](https://en.wikipedia.org/wiki/Physical_layer)

## 2 Data Link Layer

Frames

Defines basic format of data, how they are transmitted and denoted via the wires.

2 sub-layers: logical link control (LLC) and media access control (MAC).

* functional and procedural data transmission
* error detection and correction

[Wikipedia](https://en.wikipedia.org/wiki/Data_link_layer)

## 3 Network Layer

Packets

Addressing and Routing

1. Connectionless communication
2. Host addressing (IP address)
3. Message forwarding

Data Delivery

[Wikipedia](https://en.wikipedia.org/wiki/Network_layer)

## 4 Transport Layer

* TCP: segment
* UDP: datagram

host-to-host communication

TCP/UDP

How to transport data between 2 hosts reliably and effectively

* connection-oriented communication
* Same order delivery
* reliability
* flow control
* Congestion avoidance
* multiplexing

* transportation issues handling
* virtual circuits

[Wikipedia](https://en.wikipedia.org/wiki/Transport_layer)

## 5 Session Layer

Basically, the top 3 layers, application presentation and session layers,
can be regarded as the "Application" since they are all controlled by applications.

Session layers manages different sessions between application processes between end-users

> Establishes, manages, and terminates sessions between applications

[Wikipedia](https://en.wikipedia.org/wiki/Session_layer)

## 6 Presentation Layer

data translation

Also called "syntax layer".

* Data conversion
* Character code translation
* Compression
* Encryption and Decryption

[Wikipedia](https://en.wikipedia.org/wiki/Presentation_layer)

## 7 Application

Different definitions for OSI and TCP/IP (actually same name, different layers).

The applications are responsible for 5,6,7 three layers.
Some applications might be simple, will only implement functionality of 7th layer.

Network Processes to Application

> defines user interface responsible for displaying received information to the user

[Wikipedia](https://en.wikipedia.org/wiki/Application_layer)

## Data Encapsulation

applications generate data

Data begin with 7th layer, the application layer.
They will be transmitted from top to bottom.
Each layer will include a HDR (header) to the data.
Each layer stores its information in HDR.

The process of "data going throughout 7 layers from top to lowermost one"
in which each layer concatenates its header (or footer or both)
is called data encapsulation.

![osi-data-encapsulation](https://i.imgur.com/7vJObbO.png)

Upon receiving, data will be "de-encapsulated".

Each layer will check the information it is responsible for.

From lowermost level to topmost layer.

At the end only the original data will be transmitted to application.

## TCP/IP Stack

Now everyone uses TCP/IP. It is an implementation of OSI model.

It has 4 layers.

![TCP/IP-OSI](https://i.imgur.com/P1UaRNu.png)

The most "important" ones are 3rd and 4th layer.

## Summary

For networking, it usually refers to the 4 low layers.

For software engineering, people care the top 3 layers more.