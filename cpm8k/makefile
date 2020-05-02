# makefile for cpm8k

AS = z8k-coff-as
LD = z8k-coff-ld
OBJCOPY = z8k-coff-objcopy

.SUFFIXES: .o .s 

objs = biosboot.o biosif.o biostrap.o biosmem.o\
	bios.o bioscall1.o bioscall2.o bioscall3.o bioscall4.o\
	z8530.o diskio.o put.o\

.PHONY: all
all: cpm8k.bin

cpm8k.bin: $(objs) biosdef.s cpmsys.o libcpm.a cpmsys.x
	$(LD) -mz8002 -T cpmsys.x -L./ -o cpm8k $(objs) cpmsys.o -lcpm
	$(OBJCOPY) -S -O binary cpm8k cpm8k.bin
	#$(OBJCOPY) -S -O ihex cpm8k cpm8k.hex

.s.o:
	$(AS) -z8002 -o $@ $< 

.PHONY: clean
clean:
	$(RM) -f cpm8k cpm8k.bin cpm8k.hex $(objs)
