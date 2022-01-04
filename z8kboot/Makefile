OBJS = booter.o z8kbootimg.o

.PHONY: all
all: z8kbooter.elf

z8kbooter.elf: $(OBJS)
	avr-gcc -mmcu=atmega164p -o z8kbooter.elf $(OBJS)
	avr-objcopy -I elf32-avr -O ihex z8kbooter.elf z8kbooter.hex

booter.o: booter.c z8001macro.h z8kmonimg.h 
	avr-gcc -O0 -mmcu=atmega164p -c booter.c  

z8kbootimg.o: z8kmon  
	cp ./z8kmon/z8kmon.bin ./
	avr-objcopy -I binary -B avr -O elf32-avr z8kmon.bin z8kbootimg.o \
	--rename-section .data=.progmem.data,contents,alloc,load,readonly,data 

sio.o: sio.c sio.h
		avr-gcc -O0 -mmcu=atmega164p -c sio.c

.PHONY: z8kmon
z8kmon:
	make -C ./z8kmon

.PHONY: write
write:
	#/mnt/c/WinAVR-20100110/bin/avrdude.exe -c avrisp2 -P usb -p m164p -U flash:w:z8kbooter.hex:i -v
	avrdude -c avrisp2 -P usb -p m164p -U flash:w:z8kbooter.elf:e -v

.PHONY: clean
clean:
	rm -f booter.o sio.o z8kbootimg.o z8kbooter.elf z8kmon.bin z8kbooter.hex
	make -C z8kmon clean
