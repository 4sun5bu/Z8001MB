!------------------------------------------------------------------------------
! zcmnd.s
!   Load CP/M-8000 and run
!
!   Copyright (c) 2019 4sun5bu
!------------------------------------------------------------------------------

	.global	z_cmnd, zcmnd_usage

	sect	.text
	segm

!------------------------------------------------------------------------------
! z_cmnd
!   Load 32kB data from the first IDE Drive to 0x30000, and jump 
!
!   input:      rr4 --- options address 
!   destroyed:  r0, r1, r2, r3, rr4, rr12

z_cmnd:
	lda	rr4, zmsg1
	call	puts
	call	ide_init
	ldl	rr2, #0
	ldl	rr4, #0x03000000
1:
	pushl	@rr14, rr4
	pushl	@rr14, rr2
	call	ide_read
	ldb	rl0, #'*'
	call	putc
	popl	rr2, @rr14
	popl	rr4, @rr14
	add	r5, #512
	inc	r3, #1
	cp	r3, #64
	jr	nz, 1b
	jp	0x83000000

zcmnd_usage:
	lda	rr4, usage
	jp	puts

!------------------------------------------------------------------------------
	sect .rodata

zmsg1:
	.string "Load from CF \0"

usage:
	.asciz	"Z boot\t: z (no options)\r\n"

