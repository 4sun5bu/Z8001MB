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
!   destroyed:  r0, r1, r2, r3, rr4, rr6

set_cmnd:
	ldl	rr6, setaddr
	testb	@rr4
	jr	z, scloop1	! without address
	call	str2saddr
	jr	c, scmnd_usage
	ldl	setaddr, rr0
	ldl	rr6, rr0
scloop1:
	ldl	rr4, rr6
	call	put_saddr
	ldb	rl0, #':'
	call	putc
	ldb	rl4, @rr6
	call	puthex8
	call	putsp
	lda	rr4, linebuff
	call	gets
	call	skipsp
	testb	rl0
	jr	nz, scloop2
	add	r7, #1
	jr	nc, scloop1
	incb	rh6, #1
	orb	rh6, #0x80
	jr	scloop1
scloop2:	
	call	strhex8
	jr	nc, sc1		! illegal value
	ldl	setaddr, rr6
	ret
sc1:
	ldb	@rr6, rl0
	add	r7, #1
	jr	nc, sc2
	incb	rh6, #1
	orb	rh6, #0x80
sc2:
	call	skipsp
	testb	rl0
	jr	nz, scloop2
	jr	scloop1

scmnd_usage:
	lda	rr4, usage
	jp	puts

!------------------------------------------------------------------------------
	sect	.rodata
usage:
	.asciz 	"Set\t: s [xxxxxx]\r\n"

!------------------------------------------------------------------------------
	sect	.bss
	.global	setaddr

setaddr:
	.long	0

