# CP/M-8000

![CPM8k](./cpm8k-1.png)

This directory includes CP/M-8000 BIOS source codes for the Z8001MB board. You can build your own CP/M-8000 system by cross assembling these codes on Linux and Windows. 

## Preparation
* **GNU Binutils** \
 You need cross building tools which operate COFF file format. I use GNU Binutils 2.34, not required the latest version.
* **xout2coff** and **xarch** \
 BDOS and CPP are provided in XOUT format which is a relocatable format for CP/M-8000. XOUT files can not be linked with GNU linker, so format converting is necessary.   
 The xout2coff is a converter from XOUT format to COFF format, and the xarch is a tool to unpack XOUT library. These are included in **xoututils** in my GitHub repository. 
* **CP/M-8000**\
Download from [The Unofficial CP/M Web site](http://www.cpm.z80.de/), you can find the source code **CP/M-8000 1.1** in [Digital Research Source Code](http://www.cpm.z80.de/source.html).  

## How to build
First Step is converting **cpmsys.rel**.  
In the download directory, 
```
$ unzip cpm8k11.zip
$ cp cpm8k11/disk4/symsys.rel xxx/cpm8k/  
$ cd xxx/cpm8k
$ xout2conf cpmsys.rel
```
**"xxx/cpm8k"** is a working directory where to build cpm8k. 

Second step is converting **libcpm.a**. In the xarch directory there is **convxlib.sh** which converts XOUT library.     
 In the download directory, 
```
$ mkdir libcpm
$ cd libcpm
$ cp ../cpm8k11/disk3/libcpm.a ./
$ cp yyy/src/xarch/convxlib.sh ./
$ sh convxlib.sh libcpm.a
$ cp libcpm.a xxx/cpm8k/
```
**"yyy"** is the xoututils directory. 

Third step is building CP/M.  
In the cpm8k directory    
```
$ cd xxx/cpm8k
$ make
```
If you want to make CP/M disk image and write it on a disk drive, 
```
$ make diskimg
$ sudo dd if=cpm8k.bin of=/dev/sdx 
``` 
**"sdx"** is your drive to write the disk image.  
To make CP/M disk image you need to install cpmtools and modify **/etc/cpmtools/diskdefs**. Sample disk definition is in the cpm8k directory. 
Be careful with executing **dd**. Do not set a wrong disk drive for **"of"**.    