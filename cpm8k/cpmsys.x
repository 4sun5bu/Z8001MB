OUTPUT_FORMAT("coff-z8k")
OUTPUT_ARCH("z8002")
ENTRY(_start)

MEMORY
{
	CPMSYS : ORIGIN = 0x30000, LENGTH = 64k
	/* ROM : ORIGIN =    , LENGTH = */ 
}

SECTIONS
{
	.text :
	{
		*(.text)
	} > CPMSYS

	.psa :
	{
		. = ALIGN(256);
		*(.psa)
	} > CPMSYS

	.rodata :
	{
		*(.rdata)
		*(.rodata)
	} > CPMSYS
	
	.data :
	{
		*(.data)
	} > CPMSYS
	
	.bss :
	{
	   	_bss_top = . ;
	  	*(.bss);
	   	_bss_end = . ;
	} > CPMSYS
}

