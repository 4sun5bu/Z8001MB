! ********* biosif.8kn for cpm.sys + cpmldr.sys *******
! * 	Copyright 1984, Digital Research Inc.
! *
! * Assembly language interface for CP/M-8000(tm) BIOS
! *	----- System-Independent -----
! *
! * 821013 S. Savitzky (Zilog) -- split into modules
! * 820913 S. Savitzky (Zilog) -- created.
! * 840811 R. Weiser (DRI)   -- conditional assembly
! *
! * 20200211 4sun5bu -- modified for assembling with GNU as

	.include "biosdef.s"

	unsegm
	sect .text

! ****************************************************
! *
! * NOTE
! *	The C portion of the BIOS is non-segmented.
! *
! *	This assembly-language module is assembled
! *	non-segmented, and serves as the interface.
! *
! *	Segmented operations are well-isolated, and
! *	are either the same as their non-segmented
! *	counterparts, or constructed using macros.
! *	The resulting code looks a little odd.
! *
! ****************************************************

! ****************************************************
! *
! * Externals
! *
! ****************************************************

	.extern biosinit	! BIOS init
	.extern _flush		! Flush buffers
	.extern ccp		! Command Processor
	.extern trapinit	! trap startup
	.extern flush
	.extern scc_init
	.extern disk_init
	.extern _psap, _sysseg, _sysstk

! ****************************************************
! *
! * Global declarations
! *
! ****************************************************

	.global bios		! initialization
	.global _wboot		! arm boot
	.global _input		! input a byte
	.global _output		! output a byte

! ****************************************************
! *
! * Bios Initialization and Entry Point
! *
! *	This is where control comes after boot.
! * 	If (the label LOADER is true 1)
! * 	Control is transferred to -ldcpm
! * 	else
! *	Control is transferred to the ccp.
! *
! *	We get here from bootstrap with:
! *		segmented mode
! *		valid stack pointer
! *		valid PSA in RAM
! *
! ****************************************************

bios:
	! segmented mode
	! Get system (PC) segment into r4
	di	vi, nvi
	calr	kludge		! get PC segment on stack
kludge:
	popl	rr4, @r14
	ldctl	r2, PSAPSEG	! get PSAP into rr2.
	ldctl	r3, PSAPOFF

	! go non-segmented.  save PSAP, system segment,
	! system stack pointer (in system segment, please)
	NONSEG
	ldl	_psap, rr2
	ld	_sysseg, r4
	ld	r14, _sysseg
	ldl	_sysstk, rr14
	
	push	@r15, #_wboot	! set up system stack so that a return will warm boot
	
	call	trapinit	! set up traps, then enable interrupts
	ei	vi, nvi

	call	scc_init	! set up serial port and prrint a message
	lda	r4, bootmsg
	call	puts

	call	disk_init	! set up disk drive

	call	biosinit	! set up C part of Bios
	jp	ccp		! Turn control over to command processor

! *****************************************************
! *
! * Warm Boot
! *
! *	flush buffers and initialize Bios
! *	then transfer to CCP
! *
! *****************************************************

_wboot:
	call	flush
	call	biosinit
	ldl	rr14, _sysstk
	jp	ccp

!------------------------------------------------------------------------------
	sect	.rodata
bootmsg:
	.asciz	"\r\nCP/M-8000 BIOS ver.0.11" 

