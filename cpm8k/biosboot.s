! ******** biosboot.8kn for cpm.sys + cpmldr.sys*****
! * 	Copyright 1984, Digital Research Inc.
! *
! * 821013 S. Savitzky (Zilog) -- adapt for nonseg.
! * 820930 S. Savitzky (Zilog) -- created
! * 840813 R. Weiser (DRI) -- conditional assembly
! * 
! * 20200229 4sun5bu -- modified for assembling with GNU as
! *
! ****************************************************

	sect	.text
	unsegm

! ****************************************************
! *
! * NOTE -- THIS CODE IS HIGHLY SYSTEM-DEPENDENT
! *
! *	This module contains both the bootstrap
! *	writer, and the code that receives control
! *	after being booted.
! *
! *	The main function of the latter is to make
! *	sure that the system, whose entry point is
! *	called "bios", is passed a valid stack
! *	and PSA pointer.
! *
! *	Although this code runs segmented, it must
! *	be linked with non-segmented code, so it
! *	looks rather odd.
! *
! ****************************************************


! ****************************************************
! *
! * Globl and external 
! *
! ****************************************************

	.global	entry, _start

! ****************************************************
! *
! * Externals
! *
! ****************************************************
	
	.extern	psa
	.extern	_bss_top, _bss_end	! Decleared in the linker script

! ****************************************************
! *
! * Constants
! *
! ****************************************************

	.equ	SYSTEM, 0x03000000		! system address
	.equ	SYSSTK, (SYSTEM + 0x0BFFE)	! system stack top

! ****************************************************
! *
! * Entry Points and post-boot Initialization
! *
! ****************************************************

_start:	! suppress linker warning
entry:
	! segmented mode
	di	vi, nvi
	
	ldl	rr2, #_bss_top	! Clear BSS Region
	ldl	rr4, #_bss_end
	sub	r5, r3
	inc	r5, #1
1:
	clrb	@r2		! clrb @rr2
	inc	r3, #1
	djnz	r5, 1b
	
	ldl	rr14, #SYSSTK	! set system stack pointer

	ldl	rr2, #psa	! set PSAP
	ldctl	psapseg, r2	
	ldctl	psapoff, r3

	ldar	r2, .		! jump to bios in biosif.s 
	ld	r3, #bios
	jp	@r2
