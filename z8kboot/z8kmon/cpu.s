!------------------------------------------------------------------------------
! cpu.s
!  Misc routines for Z8001
!
!  Copyright (c) 2019 4sun5bu
!------------------------------------------------------------------------------

	.global	real_to_seg, seg_to_real, put_real_addr, str_to_addr
	
	sect	.text
	segm

!------------------------------------------------------------------------------
! real_to_seg
!   Convert real address to segmented address
!   input:  rr4 --- real address
!   return: rr4 --- segmented address

real_to_seg:
	ldb	rh4, rl4
	xorb	rl4, rl4
	orb	rh4, #0x80 
	ret

!------------------------------------------------------------------------------
! seg_to_sreal
!   Convert segmented address to real address
!
!   input:  rr4 --- segmented address
!   return: rr4 --- real address

seg_to_real:
	ldb	rl4, rh4
	xorb	rh4, rh4
	andb	rl4, #0x7f 
	ret

!------------------------------------------------------------------------------
! put_real_addr
!   Print a real address in 24 bit hex 
!
!   input:      rr4 --- real address
!   destroyed:  r0, r1, r2, rr4, rr6

put_real_addr:
	ldl	rr6, rr4     
	ldb	rl4, rl6
	call	puthex8
	ld	r4, r7
	call	puthex16
	ret

!------------------------------------------------------------------------------
! str_to_addr
!   Convert string to 24bit real address
!
!   input:      rr4 --- string address   
!   return:     CF  --- Error     
!               rr0 --- 24bit address
!               rr4 --- next address                      
!   destroyed:  rr2, rr6

str_to_addr:
	ldl	rr6, rr4 
	clr	r0
	ld	r1, r0
	ld	r4, r0
	ld	r5, r0
	ldb	rl4, @rr6 
	call	ishex
	ldb	rl1, rl4
	jr	c, 3f		! The first charactor is not hex number
1:
	inc	r7, #1
	ldb	rl4, @rr6
	call	ishex
	jr	c, 2f 
	slll	rr0, #4		! 4 bit shift left 
	add	r1, r4		
	adc	r0, r5		! shift the carry flag to r0 
	jr	1b
2:
	resflg	c	! reset carry flag
3:
	ldl	rr4, rr6
	ret
    