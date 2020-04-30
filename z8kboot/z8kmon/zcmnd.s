!------------------------------------------------------------------------------
! zcmnd.s
!   Load CP/M-8000 and run
!
	.global	z_cmnd 
	segm

!------------------------------------------------------------------------------
! z_cmnd
!   Load 32kB from the IDE Drive at 0x30000, and jump 
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
	ldb	rl4, #'*'
	call	putc
	popl	rr2, @rr14
	popl	rr4, @rr14
	add	r5, #512
	inc	r3, #1
	cp	r3, #64
	jr	nz, 1b
	jp	0x83000000

!------------------------------------------------------------------------------
	sect .data

zmsg1:
	.string "Load from CF \0"

