# z8kBoot

## About z8kboot and z8kmon
* Z8kboot is a booter program running on the ATMEGA164P micro controller. It copies a z8kmon binary to the SRAM, and run it.  
* The z8kmon is a simple machine code monitor for Zilog Z8001 CPU running in segmeted mode. It has basic monitor commands such as Dump memory, Set data, Load HEX file, etc. It can also boot a program from the 1st resion of IDE drive.  

## LICENSE
This software is released under the MIT License, see LICENSE.

## Build
On Debian-based distribution 
* Install gcc-avr, avr-libc and avrdude packages.   
* Download and build binutils with **--target=z8k-coff** option and install.
* In the z8kboot directory, type **make**. 
* Write **z8kboot.elf** file to the ATMEGA164P. In the makefile there is a target to program with the avrdude and the Atmel AVRISP mkII. 

## z8kmon Commands
* d \<saddr> \<eaddr>\
Memory dump from **saddr** to **eaddr**. Without **eaddr**, it dumps 256 bytes from **saddr**. Just typing **d** dumps from the next address where dumped last time.

* s \<addr>\
Memory set at **addr**. It shows a value at the address, and you can set a value in 8bit hex. Pressing '**Enter**', without a value.  To quit, enter '**!**'.    

* g \<addr>\
Go command calls **addr**. It keeps **addr**, and the address is used, if **g** command doesn't have **addr**.

* l \
Load Intel HEX format. After entering '**l**', upload intel hex format file. Start Adress in the HEX format is applied for '**g**' command.   

* z \
Load 32kB from the first sector of the IDE drive to the SRAM at 0x30000, and jump to start. This command is for booting CP/M-8000. 

## Modification for your machine
* z8kmon assumes that RAM area starts from 0x000000, and the size is 64k byte at least. The monitor is located at 0x000000. If you want to relocate at other address, you need to edit linker scriput **z8001mb.x**, and change the reset vector in **z8kmon.s** to start up from the address.

