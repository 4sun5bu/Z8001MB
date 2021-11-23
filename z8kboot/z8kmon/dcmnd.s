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
!   destroyed:  r0, r1, r2, r3, rr4, rr6

dump_cmnd:
	testb	@rr4
	jr	z, dc1			! EOL
	call	str2saddr
	jr	c, dcmnd_usage		! illegal start address
	ldl	dumpaddr, rr0
	call	skipsp			! end address    
	testb	@rr4
	jr	z, dc1			! only start address
	call	str2saddr
	jr	c, dcmnd_usage		! illegal end address
	ldl	rr6, rr0
	jr	dc2
dc1:
	ldl	rr6, dumpaddr
	add	r7, #255
	jr	nc, dc2
	incb	rh6, #1
	orb	rh6, #0x80
dc2:
	ldl	rr4, dumpaddr
	call	dump
	inc	r7, #1
	jr	nc, dc3
	incb	rh6, #1
dc3:
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
!   destroyed:  r0, r1, r2, r3, rr4, rr6, rr8

dump:
	ldl	rr8, rr4
	lda	rr4, header
	call	puts
	ldl	rr4, rr8
dloop:
	ldl	rr8, rr6
	call	line_dump
	call	putln
	ldl	rr6, rr8
	cpl	rr4, rr6
	jr	le, dloop
	ret

!------------------------------------------------------------------------------
! line_dump
!   Dump 16 bytes in hex and in ascii character 
!   
!   input:      rr4 --- real address for line dump
!   return:     rr4 --- next address 
!   destroyed:  r0, r1, r2, r3, rr6

line_dump:
	ldl	rr6, rr4
	call	put_saddr
	ldb	rl0, #'|'
	call	putc
	call	putsp
	ldl	rr4, rr6
	call	hex_dump
	ldb	rl0, #'|'
	call	putc
	call	putsp
	ldl	rr4, rr6
	call	ascii_dump
	ret

!------------------------------------------------------------------------------
! hex and ascii_dump
!   Dump 16 bytes in hex and ascii 
!   
!   input:      rr4 --- segmented address for line dump
!   return:     rr4 --- next address
!   destroyed:  r0, r1, r2, r3

hex_dump:
	ldl	rr2, rr4
	ldb	rl1, #16
hdloop:
	ldb	rl4, @rr2
	call	puthex8
	call	putsp
	add	r3, #1
	jr	nc, hd1
	incb	rh2, #1
	orb	rh2, #0x80
hd1:
	decb	rl1, #1
	jr	nz, hdloop
	ldl	rr4, rr2
	ret

ascii_dump:
	ldl	rr2, rr4
	ldb	rl1, #16
adloop:
	ldb	rl0, @rr2
	cpb	rl0, #' '
	jr	ge, ad1
	ldb	rl0, #'.'
	jr	ad2
ad1:
	cpb	rl0, #'~'
	jr	le, ad2
	ldb	rl0, #'.'
ad2:
	call	putc
	add	r3, #1
	jr	nc, ad3
	incb	rh2, #1
	orb	rh2, #0x80
ad3:
	decb	rl1, #1
	jr	nz, adloop
	ldl	rr4, rr2
	ret

!------------------------------------------------------------------------------
	sect	.rodata

header:
	.asciz	"Address  +0 +1 +2 +3 +4 +5 +6 +7 +8 +9 +A +B +C +D +E +F\r\n" 
	
usage:
	.asciz	"Dump\t: d [xxxxxx] [yyyyyy]\r\n"

!------------------------------------------------------------------------------
	sect	.bss
	.global	dumpaddr

dumpaddr:
	.long	0

