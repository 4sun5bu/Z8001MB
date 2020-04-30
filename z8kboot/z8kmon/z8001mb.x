OUTPUT_FORMAT("coff-z8k")
OUTPUT_ARCH("z8001")
ENTRY(_start)

MEMORY
{
	RAM : ORIGIN = 0x0000, LENGTH = 256k
	/* ROM : ORIGIN =    , LENGTH = */ 
}

SECTIONS
{
	.rstvec :
	{
		*(.rstvec)
	} > RAM

	.text :
	{
		*(.text)
	} > RAM
 	
	.rodata :
	{
	   	*(.rodata)
	} > RAM
	
	.data :
	{
		*(.data)
	} > RAM
	
	.bss :
	{
	   	__start_bss = . ;
	  	*(.bss);
	  	*(COMMON);
	   	__end_bss = . ;
	} > RAM
}

