# Z8kBoot

## About Z8kboot and Z8kmon
* Z8kboot is a booter program running on the ATMEGA164P micro controller. It copies Z8kMon binary to the Z8001 SRAM, and jumps to it.  
* Z8kmon is a simple machine code monitor for Zilog Z8001 CPU running in segmeted mode. It has basic monitor commands such as Dump memory, Set data, Load HEX file, etc. It can also boot a program from the 1st resion of IDE drive.  

## LICENSE
This software is released under the MIT License, see LICENSE.

## Build
To build, type **make** in the source code directory.
Then binary file **z8kboot.hex** is buit in the directory.This file includes the Z8kmon binary. You can write it to the ATMEGA164P with AVRISP.

## Modification for your machine
* Z8kmon assumes that RAM area starts from 0x000000, and the size is 64k byte at least. The monitor is located at 0x000000. If you want to relocate at other address, you need to edit linker scriput **z8001mb.x**, and change the reset vector in **z8kmon.s** to start up from the address.

* If your machine has other chips for serial communication, you need to rewrite **z8530.s**, and add code to initialize, serial input and output for your chip.

## Z8kmon Commands
* d \<saddr> \<eaddr>\
Memory dump from **saddr** to **eaddr**. Without **eaddr**, it dumps 256 bytes from **saddr**. Just typing **d** dumps from the next address where dumped last time.

* s \<addr>\
Memory set at **addr**. It shows a value at the address, and you can set a value in 8bit hex. Pressing '**Enter**', without a value,  skips to the next address. Entering '**-**' decrements the address point. To quit, enter '**!**'.    

* g \<addr>\
Go command calls **addr**. It keeps **addr**, and the address is used, if **g** command doesn't have **addr**.

* l \
Load Intel HEX format. After entering '**l**', upload intel hex format file. Start Adress in the HEX format is applied for '**g**' command.   

* z \
Load 32kB from the first sector of the IDE drive at 0x30000, and jump there to start. This command was added for booting CP/M-8000. 