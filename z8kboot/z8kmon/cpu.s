!------------------------------------------------------------------------------
! cpu.s
!  Misc routines for Z8001
!
!  Copyright (c) 2019 4sun5bu
!------------------------------------------------------------------------------

	.global	linr2seg, seg2linr, put_laddr, str2saddr, put_saddr

	sect	.text
	segm

!------------------------------------------------------------------------------
! linr2seg
!   Convert linear address to segmented address

!   input:  rr4 --- linear address
!   return: rr4 --- segmented address

linr2seg:
	ldb	rh4, rl4
	xorb	rl4, rl4
	orb	rh4, #0x80 
	ret

!------------------------------------------------------------------------------
! seg2linr
!   Convert segmented address to linear address
!
!   input:  rr4 --- segmented address
!   return: rr4 --- linear address

seg2linr:
	ldb	rl4, rh4
	xorb	rh4, rh4
	andb	rl4, #0x7f 
	ret

!------------------------------------------------------------------------------
! str2saddr
!   Convert string to segmented address
!
!   input:      rr4 --- string address   
!   return:     CF  --- Error     
!               rr0 --- segmented address
!               rr4 --- next string address                      
!   destroyed:  r2 

str2saddr:
	call	strhex8
	ret	c
	ldb	rh2, rl0
	orb	rh2, #0x80
	clrb	rl2
	cpb	@rr4, #':'
	jr	ne, 1f
	inc	r5, #1
1:
	call	strhex16
	ret	c
	ld	r1, r0
	ld	r0, r2
	ret

!------------------------------------------------------------------------------
! put_saddr
!   Print a segmented address in hex 
!
!   input:      rr4 --- segmented address
!   destroyed:  r0, r1, rr2, rr4

put_saddr:
	ldl	rr2, rr4     
	ldb	rl4, rh2
	andb	rl4, #0x7f
	call	puthex8
	ldb	rl0, #':'
	call	putc
	ld	r4, r3
	call	puthex16
	ret

