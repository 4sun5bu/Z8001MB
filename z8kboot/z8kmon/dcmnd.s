!------------------------------------------------------------------------------
! dumpcmnd.s
!  Dump command
!
!  Copyright (c) 2019 4sun5bu
!------------------------------------------------------------------------------

	.global dump_cmnd, dcmnd_usage 

	sect	.text
	segm

!------------------------------------------------------------------------------
! dump_cmnd
!   Memory dump from start address to end address     
!
!   input:      rr4 --- options address 
!   destroyed:  r0, r1, r2, r3, rr4, rr6, rr8

dump_cmnd:
	testb	@rr4
	jr	z, 2f			! EOL
	call	str_to_addr
	jr	c, dcmnd_usage		! illegal start address
	ldl	dumpaddr, rr0
	call	skipsp			! end address    
	testb	@rr4
	jr	z, 2f			! only start address
	call	str_to_addr
	jr	c, dcmnd_usage		! illegal end address
	ldl	rr6, rr0
	ldl	rr4, dumpaddr
	jr	3f			
2:
	ldl	rr4, dumpaddr
	clr	r6
	ld	r7, #0x00ff
	addl	rr6, rr4
3: 
	call	dump
	addl	rr6, #1
	ldl	dumpaddr, rr6
	call	putln
	ret

dcmnd_usage:
	lda	rr4, usage
	jp	puts

!------------------------------------------------------------------------------
! dump
!   Memory dump from start address to end address     
!
!   input:      rr4 --- start address 
!               rr6 --- end address 
!   destroyed:  r0, r1, r2, r3, rr4, rr6, rr8, rr10, rr12

dump:
	ldl	rr10, rr4
	lda	rr4, header
	call	puts
	ldl	rr4, rr10
1:
	pushl	@rr14, rr6
	call	line_dump
	popl	rr6, @rr14
	ldl	rr10, rr4
	call	putln
	ldl	rr4, rr10
	cpl	rr4, rr6
	jr	le, 1b
	ret

!------------------------------------------------------------------------------
! line_dump
!   Dump 16 bytes in hex and in ascii character 
!   
!   input:      rr4 --- real address for line dump
!   return:     rr4 --- next address 
!   destroyed:  r0, r1, r2, r3, rr6, rr8, rr10, rr12

line_dump:
	ldl	rr12, rr4
	call	put_real_addr
	ldb	rl0, #':'
	call	putc
	call	putsp
	ldl	rr4, rr12
	call	hex_dump
	ldb	rl0, #':'
	call	putc
	call	putsp
	ldl	rr4, rr12
	call	ascii_dump
	ret

!------------------------------------------------------------------------------
! hex and ascii_dump
!   Dump 16 bytes in hex or ascii 
!   
!   input:      rr4 --- real address for line dump
!   return:     rr4 --- next address
!   destroyed:  r0, r1, r2, r3, rr6, rr8, rr10

hex_dump:
	ldl	rr8, rr4
	ldb	rl6, #16
1:
	ldl	rr4, rr8
	call	real_to_seg
	ldl	rr10, rr4      
	ldb	rl4, @rr10
	call	puthex8
	call	putsp
	addl	rr8, #1
	decb	rl6, #1
	jr	nz, 1b
	ldl	rr4, rr8
	ret

ascii_dump:
	ldl	rr8, rr4
	ldb	rl6, #16
1:
	ldl	rr4, rr8
	call	real_to_seg
	ldl	rr10, rr4
	ldb	rl0, @rr10
	cpb	rl0, #' '
	jr	ge, 2f
	ldb	rl0, #'.'
	jr	3f
2:
	cpb	rl0, #'~'
	jr	le, 3f
	ldb	rl0, #'.'
3:
	call	putc
	addl	rr8, #1
	decb	rl6, #1
	jr	nz, 1b
	ldl	rr4, rr8
	ret

!------------------------------------------------------------------------------
	sect	.rodata

header:
	.asciz	"Address +0 +1 +2 +3 +4 +5 +6 +7 +8 +9 +A +B +C +D +E +F\r\n" 
	
usage:
	.asciz	"Dump\t: d [xxxxxx] [yyyyyy]\r\n"

