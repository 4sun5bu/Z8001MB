!------------------------------------------------------------------------------
! CP/M-8000 BIOS func 15, 17-20, 22
!
!  Copyright (c) 2020, 4sun5bu
!------------------------------------------------------------------------------

	.extern	_trapvec, iobyte, dbgbc
	
	.global	func15, func17, func18, func19, func20, func22
	
	unsegm
	sect .text

!------------------------------------------------------------------------------
! func15 
!   Retrun LIST Status TODO: Implement

func15:
	clr	r7
	ret

!------------------------------------------------------------------------------
! func17 
!   ??? 

func17:
	clr	r6
	clr	r7
	ret
	
!------------------------------------------------------------------------------
! func18 
!   Get Memory Region Table Address

func18:
	ld	r6, _sysseg
	lda	r7, memtbl 
	ret

!------------------------------------------------------------------------------
! func19 
!   Get IOBYTE

func19:
	ld	r7, iobyte
	ret

!------------------------------------------------------------------------------
! func20 
!   Set IOBYTE

func20:
	ld	iobyte, r5
	ret
	
!------------------------------------------------------------------------------
! func22 
!   Set Exception Handler Address

func22:
	sll	r5, #2
	ldl	rr0, _trapvec(r5)
	ldl	_trapvec(r5), rr6
	ldl	rr6, rr0
	ret

!------------------------------------------------------------------------------
        sect .data
        even

memtbl:
        .word   0x04
        .long   0x01000000      ! Region 1
        .long   0x00010000
        .long   0x01000000      ! Region 2
        .long   0x00000000
        .long   0x01000000      ! Region 3
        .long   0x00000000
        .long   0x01000000      ! Region 4
        .long   0x00000000
        