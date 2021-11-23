!------------------------------------------------------------------------------
! gocmnd.s
!   go command
!
!  Copyright (c) 2019 4sun5bu
!------------------------------------------------------------------------------

	.global	go_cmnd, gcmnd_usage 

	sect	.text
	segm

!------------------------------------------------------------------------------
! go_cmnd
!   Memory write from start address      
!
!   input:      rr4 --- options address
!   destroyed:  r0, r1, r2, rr4

go_cmnd:
	testb	@rr4
	jr	z, gc1			! EOL, without address
	call	str2saddr
	jr	c, gcmnd_usage
	ldl	goaddr, rr0
gc1:
	ldl	rr4, goaddr
	call	@rr4
	ret

gcmnd_usage:
	lda	rr4, usage
	jp	puts

!------------------------------------------------------------------------------
	sect	.rodata
usage:
	.asciz 	"Go\t: g [xxxxxx]\r\n"

!------------------------------------------------------------------------------
	sect	.bss
	.global	goaddr

goaddr:
	.long	0

