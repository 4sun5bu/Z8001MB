Z8K = stat.z8k pip.z8k dump.z8k sizez8k.z8k ed.z8k asz8k.z8k asz8k.pd xcon.z8k\
      ld8k.z8k ar8k.z8k nmz8k.z8k ddt.z8k xdump.z8k\
      zcc.z8k zcc1.z8k zcc2.z8k zcc3.z8k

HEADER = portab.h bdos.h basepa.h stdio.h ctype.h errno.h signal.h unstds.h\
       setjmp.h option.h

LIB = startup.o libcpm.a opt.c opt1.c

all: pack
pack: $(Z8K) $(HEADER) $(LIB)
	rm -f devpack.zip
	zip devpack.zip $(Z8K) $(HEADER) $(LIB)

copy: devpack.zip
	cp devpack.zip ../diska/

