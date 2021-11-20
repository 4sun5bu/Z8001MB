!------------------------------------------------------------------------------
! scmnd.s
!   Write command
!
!  Copyright (c) 2019 4sun5bu
!------------------------------------------------------------------------------

	.global	set_cmnd, scmnd_usage 

	sect	.text
	segm

!------------------------------------------------------------------------------
! set_cmnd
!   Memory set from start address      
!
!   input:      rr4 --- options address 
!   destroyed:  r0, r1, r2, r3, rr4, rr6, rr8, rr10

set_cmnd:
	ldl	rr10, setaddr
	testb	@rr4
	jr	z, repeat	! without address
	call	str_to_addr
	jr	c, scmnd_usage
	ldl	setaddr, rr0
	ldl	rr10, rr0
repeat:
	ldl	rr4, rr10    
	call	put_real_addr
	ldb	rl0, #':'
	call	putc
	ldl	rr4, rr10
	call	real_to_seg
	ldl	rr6, rr4	! rr6 - write addres in segmented address
	ldb	rl4, @rr6
	call	puthex8
	call	putsp
	lda	rr4, linebuff
	call	gets
	call	skipsp
	testb	rl0
	jr	nz, repeat2
	addl	rr10, #1
	jr	repeat
repeat2:	
	pushl	@rr14, rr4
	ldl	rr4, rr10
	call	real_to_seg
	ldl	rr6, rr4
	popl	rr4, @rr14
	call	strhex8
	jr	nc, 1f		! illegal value
	ldl	setaddr, rr10
	ret
1:
	ldb	@rr6, rl0
	addl	rr10, #1
	call	skipsp
	testb	rl0
	jr	nz, repeat2
	jr	repeat

scmnd_usage:
	lda	rr4, usage
	jp	puts

!------------------------------------------------------------------------------
	sect	.rodata
usage:
	.asciz 	"Set\t: s [xxxxxx]\r\n"


