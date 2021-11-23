!------------------------------------------------------------------------------
! icmnd.s
!   Reading and Writing I/O port command
!
!  Copyright (c) 2019 4sun5bu
!------------------------------------------------------------------------------

	.global	ior_cmnd, iow_cmnd, icmnd_usage, ocmnd_usage, icmnd_usage

	sect	.text
	segm

!------------------------------------------------------------------------------
! ior_cmnd
!   I/O read and print at a port address
!
!   input:      rr4 --- options address 
!   destroyed:  r0, r1, r2, r3, rr4

ior_cmnd:
	testb	@rr4
	jr	z, icmnd_usage	! EOL
	call	strhex16
	jr	c, icmnd_usage
	push	@rr14, r0
	ld	r4, r0
	call	puthex16
	ldb	rl0, #':'
	call	putc
	pop	r0, @rr14
1:
	inb	rl4, @r0
	call	puthex8
	call	putln
	ret

icmnd_usage:
	lda	rr4, i_usage
	jp	puts

!------------------------------------------------------------------------------
! iow_cmnd
!   I/O write one byte at a port address
!
!   input:      rr4 --- options address 
!   destroyed:  r0, r1, r2, r3, rr4, rr6, rr8

iow_cmnd:
	testb	@rr4
	jr	z, ocmnd_usage	! EOL
	call	strhex16
	jr	c, ocmnd_usage
	ld	ioaddr, r0
	ld	r4, r0
	call	puthex16
	ldb	rl0, #':'
	call	putc
	lda	rr4, linebuff
	call	gets
	call	skipsp
	orb	rl0, rl0
	ret	z
	call	strhex8
	ret	c
	ld	r1, ioaddr
	outb	@r1, rl0
	ret

ocmnd_usage:
	lda	rr4, o_usage
	jp	puts

!------------------------------------------------------------------------------
	sect	.rodata

i_usage:
	.asciz	"Input\t: i xxxx\r\n"
o_usage:
	.asciz	"Output\t: o xxxx\r\n"

!------------------------------------------------------------------------------
	sect	.bss
	.global	ioaddr

ioaddr:
	.word	0

