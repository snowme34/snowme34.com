# Disk Basics

## Hard Disk Drive

* cylinder
  * the tracks of disk platters that has same diameter
  * a 3d structure looks like a cylinder without top and bottom
* sector
  * the sectors of disk patters
  * looks like a cut cake
* head
  * basic read/write device

## Solid-State Drive

Flash

## Partition

Creating some logical regions on a drive to manage it.

The partition information is stored in a partition table.

### MBR (Master Boot Record)

[MBR - Wikipedia](https://en.wikipedia.org/wiki/Master_boot_record)

The traditional partition table that can be applied to most PCs that use BIOS.

* supports 32bit and 64bit systems
* supports limited number of (primary) partitions
* cannot (officially) support drives larger than 2T due to the way it addresses space

See the tables in wikipedia for the details about structures.

#### MBR Partitions

* Primary partitions
  * at most 4
* Extended partitions
  * uses "space" of a primary partition
* Logical partitions
  * created in extended partitions
  * does not count as a primary partition, can have more than 4

### GPT (GUID Partition Table)

[GPT - Wikipedia](https://en.wikipedia.org/wiki/GUID_Partition_Table)

A partition table for UEFI devices (instead of BIOS)

* supports drives larger than 2T
* limited backward compatibility (for MBR)

Read the table in wikipedia about "Operating-system support"