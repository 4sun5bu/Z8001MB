!------------------------------------------------------------------------------ 
! bios.s
!  CP/M-8000 BIOS Main
!  This BIOS was written based on Digital Research CP/M-8000 BIOS
!
!  Copyright (c) 2020, 4sun5bu
!------------------------------------------------------------------------------

	.extern	sysinit initscc, disk_init, puts
	.extern	func0, func1, func2, func3, func4 
	.extern	func5, func6, func7, func8, func9
	.extern	func10, func11, func12, func13, func14 
	.extern	func15, func16, func17, func18, func19
	.extern	func20, func21, func22
	.extern secbvalid, secbdirty
	
	.global	biosinit, biosentry
	.global _sysseg, _usrseg, _sysstk, _psap, _trapvec
	.global	iobyte
	
	.include "biosdef.s"

	unsegm
	sect .text

biosinit:
	clr	secbLBA
	clr	secbLBA + 2
	clrb	secbvalid
	clrb	secbdirty
	ret

biosentry:
	cp	r3, #22
	jr	gt, false
	sll	r3, #1
	ld	r1, biostbl(r3)
	jp	@r1
false:
	ret

!------------------------------------------------------------------------------
! BIOS Jump Table

	sect .data
	.even

biostbl:
	.word	func0
	.word	func1
	.word	func2
	.word	func3
	.word	func4
	.word	func5
	.word	func6
	.word	func7
	.word	func8
	.word	func9
	.word	func10
	.word	func11
	.word	func12
	.word	func13
	.word	func14
	.word	func15
	.word	func16
	.word	func17
	.word	func18
	.word	func19
	.word	func20
	.word	func21
	.word	func22

!------------------------------------------------------------------------------
	sect	.data
iobyte:
	.word	0

!------------------------------------------------------------------------------

	sect .bss
	.even

_sysseg:
	.space	2	! system segment
_usrseg:
	.space	2	! user segment
_sysstk:
	.space	4	! system stack pointer
_psap:
	.space	4	! program status area ptr

_trapvec:
	.space  NTRAPS * 4
