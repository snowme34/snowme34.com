# OSI Model Layer 1

## First Layer

The physical layer that is responsible for the bit-level transmission.

Define how transmission is achieved, whether via electronic or optical signals.

## Layer 1 Equipments

Use cables to connect.

Different network uses some medium to communicate.

List of some equipments:

* Network interface controller (NIC)
* Repeater
* Ethernet hub
  * like an amplifier, treat the cables connecting to it as if they are directly connected
* Modem
* Fiber media converter

### Network Interface Controller (NIC)

For layer 1

Some network interface controllers might also support functionalities
of layer 2 and layer 3.

### Ethernet Media

This link might be helpful: https://www.electronics-notes.com/articles/connectivity/ethernet-ieee-802-3/cables-types-pinout-cat-5-5e-6.php

Example:

`10 BASE T`

It means, the speed is 100 M, uses baseband transmission, and twisted-pair cable.

Tx: twisted-pair
Fx: fiber

### Twisted-Pair Cable

There are 8 wires, 4 pairs, and an outer jacket for a Twisted-Pair cable.

2 types of twisted-pair cables:

* Unshielded Twisted-Pair Cable (UTP)
  * more common
* Shielded Twisted-Pair Cable (STP)
  * more expensive
  * harder to connect

### RJ-45 Connector

The register jet

Has 8 pins.

### RJ-45 Jack

A slot to plug in connector

### Wiring

Pin Label

* 1 TX+
* 2 TX-
* 3 RX+
* 4 NC
* 5 NC
* 6 RX-
* 7 NC
* 8 NC

4,5 is used for fixed phone
7,8 are not used

* TX: Transmit Data
* RX: Receive Data
* NC: Not Connected

#### Wiring Order

This is the order of wires inside the cable.

* 568A
  * 1 white green
  * 2 green
  * 3 white orange
  * 4 blue
  * 5 white blue
  * 6 orange
  * 7 white brown
  * 8 brown
* 568B
  * 1 white orange
  * 2 orange
  * 3 white green
  * 4 blue
  * 5 white blue
  * 6 green
  * 7 white brown
  * 8 brown

Difference should be 1-3 2-6 only

### Straight-Through and Crossover

Straight-Through

* Same wiring on both ends
* 1 <-> 1
* 2 <-> 2
* 3 <-> 3
* 6 <-> 6

Crossover

* Different wiring on both ends
* 1326
* 1 -> 3
* 2 -> 6
* 3 <- 1
* 6 <- 2

Use crossover for devices with same type

Use Straight-Through for devices with different order.

[Why do I need a crossover cable to connect devices of the same type?](https://networkengineering.stackexchange.com/questions/34425/why-do-i-need-a-crossover-cable-to-connect-devices-of-the-same-type)

### Optical Fiber

Have 2 pairs, so that both sending and receiving can be done in the same time.

Always as a pair

* Single-mode Fiber
  * longer
* Multi-mode Fiber
  * shorter

#### Transmission Distance

Twisted-Pair cables are only reliable under 100 Meters.

In real life, we usually limit it to be 90 meters.

Must use Optical Fiber for longer distance.

Max transmission dist of SX is around thousands of meters.

The one of LX will be longer.

When connecting, as usual, the Rx and Tx ends 

#### Transceiver Module

Might need transceiver modules to use the optical fiber.

When purchasing, make sure the mode matches the one of the fiber.