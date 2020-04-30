# Z8001MB

This Board is designed for Zilog Z8001. The CPU runs at 6MHz clock speed, and it has 256kB SRAM, 2ch Serial ports and one IDE interface. 

* 6Mh CPU clock is generate from the 12MHz crystal oscillator by ATMEGA164 micro controller. 74F TTL logic ICs are chosen for 10MHz clock. At slower clock speed, 4 or 6MHz, 74LS logic ICs would be work. 
* This board dosen't have ROMs to store a boot program. At the cold start, ATMEGA164 controls Z8001 CPU bus, and write the boot code to the RAM. After the copying, ATMEGA frees the bus and negates the reset signal. Then Z8001 CPU wakes up. 
* 256kB SRAM was chosen for running CP/M-8000 which requires at least 128kB RAM. Due to execute CP/M commands, a special memory managiment hardware is requierd to split memory space for Instraction and Data. But this board dosen't have the mechanism. 
* Zilog Z8530 SCC is a serial communication chip. Z8kmon uses it at 4800bps. To connect PC you need a level converter or a  USB-Serial converter.
* IDE interface is connected with 8bit bus. 16bit connection would be work, but I haven't tried yet. A CF card is connected via a conversion adapter, and store the CP/M-8000 disk image in it.

To work this board, you need to write boot code on the ATMEGA chip, and change fuse bits of the ATMEGA so that JTAG disabled and external clock selected.
