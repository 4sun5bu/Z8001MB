!------------------------------------------------------------------------------
! gocmnd.s
!   go command
!
!  Copyright (c) 2019 4sun5bu

	.global	go_cmnd 
	segm

!------------------------------------------------------------------------------
! go_cmnd
!   Memory write from start address      
!
!   input:      rr4 --- options address
!   destroyed:  r0, r1, r2, r3, rr4, rr6, rr12

go_cmnd:
	testb	@rr4
	jr	z, 1f			! EOL, without address
	call	str_to_addr
	ret	c
	ldl	goaddr, rr0
1:
	ldl	rr4, goaddr
	call	real_to_seg
	call	@rr4
	ret
