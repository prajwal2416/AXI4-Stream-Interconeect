# AXI4 Stream Interconnect 
System-on-a-chip (SoC) designs depend on the Advanced eXtensible Interface (AXI) 4 protocol and essentially AXI4 stream protocol, which enables fast data transfers between multiple master and slaves through interconnect architecture. The development of an AXI 4 Stream protocol interconnect setup with one master and two slave modules under Verilog HDL is shown in this work using a unique technique. We optimize the connection architecture for reliable data transfer using round robin algorithm. The findings show that the suggested configuration guarantees reliable data processing and resilience in a multi-slave context in addition to complying with the AXI4 stream protocol criteria.
- djdn
- naskfnlkasn
- jnflkadn
## OVERVIEW OF THE SYSTEM
We require an interconnect to transfer incoming data from the master to the slaves since I have created a system with one master and two slaves interacting via the AXI4 Stream Protocol. There are four RTL modules. Two slaves, one master, and one AXI4 stream interconnect.
The main process that will take place is described below.
1. The AXI4 stream interconnect module receives the eight bits of data from the master module. 
2. The AXI4 stream interconnect module uses the AXI4 stream protocol and the round robin scheduling technique to transmit the received data to Slaves 1 and 2.
3. Using the AXI4 Stream Protocol, the slaves receive the incoming data from the connection.

![AXI4_stream_interconnect_Image](https://github.com/prajwal2416/AXI4-Stream-Interconeect/assets/144794293/00c17fe2-12a0-47f3-b991-579b50c0505f)

## Working 
The proposed Algorithm is round robin and AXI4 Stream Interconnect use the round robin method to route data originating from the master. There is a master and two slaves, and the master wishes to interact with the slaves. The algorithm works as follows: when the first data enters the interconnect module, it is routed to the first slave. When next data enters the module again, it is routed to the second slave, and so on. The AXI4 Stream Protocol is used for all data transfer. We have a tdest signal that the slaves are allocated a value for. The first slave is allocated the number 1, while the second slave is assigned the number 2. The slaves first decode the tdest value, and if it matches the value assigned, they accept the incoming data.
