! ******* biosmem.8kn for cpm.sys + cpmldr.sys ********
! * 	Copyright 1984, Digital Research Inc.
! *
! *	Memory Management for CP/M-8000(tm) BIOS
! *	for Olivetti M20 (Z8001) system.
! *
! * 821013 S. Savitzky (Zilog) -- split modules
! * 820913 S. Savitzky (Zilog) -- created.
! * 840815 R. Weiser (DRI) -- conditional assembly
! *
! * 2020  4sun5bu -- modified for assembling with GNU as

	.include "biosdef.s"

	sect .text

! ****************************************************
! *
! *	This module copies data from one memory space
! *	to another.  The machine-dependent parts of
! *	the mapping are well isolated.
! *
! *	Segmented operations are well-isolated, and
! *	are either the same as their non-segmented
! *	counterparts, or constructed using macros.
! *
! ****************************************************


! ****************************************************
! *
! * Global declarations
! *
! ****************************************************

	!.extern _sysseg, _usrseg, _sysstk, _psap
	.global memsc

! ****************************************************
! *
! * Externals
! *
! ****************************************************

	.extern xfersc

! ****************************************************
! *
! * System/User Memory Access
! *
! * _mem_cpy( source, dest, length)
! *	long source, dest, length;
! * _map_adr( addr,  space)	-> paddr
! *	long addr; int space;
! *
! * _map_adr( addr,  -1)	-> addr
! *	sets user seg# from addr
! *
! * _map_adr( addr,  -2)
! *	control transfer to context at addr.
! *
! * system call:  mem_cpy
! *	rr6:	source
! *	rr4:	dest
! *	rr2:	length (0 < length <= 64K)
! *	 returns
! *	registers unchanged
! *
! * system call:  map_adr
! *	rr6:	logical addr
! *	r5:	space code
! *	r4:	ignored
! *	rr2:	0
! *	 returns
! *	rr6:	physical addr
! *
! * space codes:
! *	0:	caller data
! *	1:	caller program
! *	2:	system data
! *	3:	system program
! *	4:	TPA data
! *	5:	TPA program
! *
! *	x+256	x=1, 3, 5 : segmented I-space addr.
! *			    instead of data access
! *
! *	FFFF:	set user segment
! *
! ****************************************************


memsc:      
	! memory manager system call
	! CALLED FROM SC
	! IN SEGMENTED MODE
	! rr6: source
	! rr4: dest   / space
	! rr2: length / 0
	testl	rr2
	jr	z, mem_map

mem_copy:   
	! copy data.
	! rr6: source
	! rr4: dest
	! rr2: length
	ldirb	@r4, @r6, r3
	ldl	rr6, rr4		! rr6 = dest + length
	ret

mem_map:		
	! map address
	! rr6: source
	! r4:  caller's seg.
	! r5:  space
	! r2:  caller's FCW
	NONSEG
	cp 	r5, #-2			! space=-2: xfer
	jp	eq, xfersc
	ld	r4, scseg + 4(r15)
	ld	r2, scfcw + 4(r15)
	calr	map_1
	ldl	cr6 + 4(r15), rr6	! return rr6
	SEG
	ret

map_1:
	! dispatch
	cp	r5, #0xFFFF
	jr	eq, set_usr		! space=-1: user seg
	cpb	rl5, #0
	jr	eq, call_data
	cpb	rl5, #1
	jr	eq, call_prog
	cpb	rl5, #2
	jr	eq, sys_data
	cpb	rl5, #3
	jr	eq, sys_prog
	cpb	rl5, #4
	jr	eq, usr_data
	cpb	rl5, #5
	jr	eq, usr_prog
	ret				! default: no mapping

set_usr:				! -1: set user seg.
	ld	_usrseg, r6
	ret

! *** THE FOLLOWING CODE IS SYSTEM-DEPENDENT ***
! *
! *	rr6= logical address
! *	r4 = caller's PC segment
! *	r2 = caller's FCW
! *	 returns
! *	rr6= mapped address
! *
! * Most of the system dependencies are in map_prog,
! * which maps a program segment into a data segment
! * for access as data.

call_data:
	bit	r2, #15		! segmented caller?
	ret	nz		! yes-- use passed seg
	ld	r6, r4		! no -- use pc segment
	ret			! already mapped

call_prog:
	bit	r2, #15		! segmented caller?
	jr	nz, map_prog	! yes-- use passed seg
	ld	r6, r4		! no -- use pc segment
	jr	map_prog	! map prog as data

sys_data:
	ld	r6, _sysseg
	ret

sys_prog:
	ld	r6, _sysseg
	ret			! assume sys does not
				! separate code, data

usr_data:
	ld      r0, #-1
	cp      r0, _usrseg
	ret     eq
	ld      r6, _usrseg
	ret

usr_prog:
	ld	r0, #-1
	cp	r0, _usrseg
	jr	eq, map_prog
	ld	r6, _usrseg
	jr	map_prog

map_prog:
	! map program addr into data
	! rr6 = address
	testb   rh5		! data access?
	ret     nz		! no: done
	and     r6, #0x7F00	! extract seg bits

	! Z8001MB:   segment 8 is the only one with
	!	     separate I and D spaces, and
	!	     the I space is accessed
	!	     as segment 10's data.
	.if  ID_SPLIT == 1 
	cpb     rh6, #8
	ret     ne
	ldb     rh6, #10
	.endif
	ret
