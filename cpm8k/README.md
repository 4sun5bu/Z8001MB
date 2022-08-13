# CP/M-8000

![CPM8k](./cpm8k-1.png)

This directory includes CP/M-8000 BIOS source codes for the Z8001MB and COFF-converted object files releaced by Digital Research. You can build your own CP/M-8000 system by cross assembling on Linux and Windows. To build CP/M-8000 system you need GNU tools and set up them before.  

## Preparation
* Download GNU Binutils and buid it with **--target==z8k-coff** option. I use GNU Binutils 2.34.
* Download **CP/M-8000 1.1** in [Digital Research Source Code](http://www.cpm.z80.de/source.html) and unzip it. There are 4 disk images containing CP/M commands in the ZIP file. You can skip this step if you don't need.
* Install cpmtools package, and append the **diskdefs** in the cpm8k directory to **/etc/cpmtools/diskdefs**. 

## Build and make a boot disk image
* Type **make** in the cpm8k directory.
* Chose files in packages/, and copy them into diska/b/c/d directories.
* Type **make dskimg**
* Write **disk.img** to a boot device with **dd** command.
 
```
In the cpm8k directory
$ make 
$ cp packages/base/*.* diska/
$ make dskmg
$ sudo dd if=disk.img.bin of=/dev/sd? 
``` 
**"sd?"** is your device to write the boot disk image.  
Execute **dd** with care. Do not set a wrong device for **"of"**.    
   

## License
cpmsys.rel, cpmsys.o, libcpm.a and files in packages/base - These files by Digital Resarch. See "The Unofficial CP/M Web Site"   
others - MIT License
