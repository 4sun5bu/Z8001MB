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
	testb	@rr4
	jr	z, repeat	! without address, start from wo_addr
	call	str_to_addr	! get address and set to wo_addr
	jr	c, scmnd_usage
	ldl	setaddr, rr0
repeat:
	ldl	rr4, setaddr    
	call	put_real_addr
	ldb	rl0, #':'
	call	putc
	ldl	rr4, setaddr
	call	real_to_seg
	ldl	rr10, rr4	! rr10 - write addres in segmented address
	ldb	rl4, @rr10
	call	puthex8
	call	putsp
	lda	rr4, linebuff
	call	gets
	call	skipsp
	orb	rl0, rl0
	jr	z, next
	cpb	rl0, #'-'	! decrement address
	jr	eq, prev
	cpb	rl0, #'!'	! break
	ret	eq
	call	strhex8
	ret	c		! illegal value
	ldb	@rr10, rl0
next:   
	ldl	rr0, setaddr
	addl	rr0, #1
1:
	ldl	setaddr, rr0
	jr	repeat
prev:
	ldl	rr0, setaddr
	subl	rr0, #1
	jr	1b

scmnd_usage:
	lda	rr4, usage
	jp	puts

!------------------------------------------------------------------------------
	sect	.rodata
usage:
	.asciz 	"Set\t: s [xxxxxx]\r\n"


