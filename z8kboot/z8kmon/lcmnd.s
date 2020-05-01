!------------------------------------------------------------------------------
! lcmnd.s
!   Load Intel HEX file command
!
!  Copyright (c) 2019 4sun5bu
!------------------------------------------------------------------------------

	.global	load_cmnd 

	sect	.text
	segm

!------------------------------------------------------------------------------
! load_cmnd
!   Load intel hex file 
!
!   input:      rr4 --- options address 
!   destroyed:  r0, r1, r2, r3, rr4, rr12

load_cmnd:
	clr	uaddr
	clr	segaddr
	clr	segaddr + 2
 1:
	lda	rr4, buff
	call	gets
	call	ihex_line
	orb	rl0, rl0
	ret	mi		! Error
	ret	z		! ihex end
	jr	1b

ihex_line:
	ldb	rl0, @rr4
	cpb	rl0, #':'
	jr	ne, ihex_err
	inc	r5, #1
	call	strhex8
	jr	c, ihex_err
	ldb	rl1, rl0	! rl1 --- byte count
	ldb	rh1, rl0	! rh1 --- CRC
	call	strhex16
	jr	c, ihex_err
	ld	r2, r0		! r2  --- data address
	addb	rh1, rh0
	addb	rh1, rl0
	call	strhex8		! rl0 --- record type
	jr	c, ihex_err
	addb	rh1, rl0
	orb	rl0, rl0
	jr	z, data_rec	! type 0
	decb	rl0, #1
	jr	z, data_end	! type 1
	decb	rl0, #1
	jr	z, seg_addr	! type 2
	decb	rl0, #1
	jr	z, seg_saddr	! type 3
	decb	rl0, #1
	jr	z, ext_addr	! type 4
	decb	rl0, #1
	jr	z, ext_saddr	! type 5 
ihex_err:
	ldb	rl0, #0xff 
	ret

data_rec:
	ldl	rr12, rr4	! save rr4 to rr12
	ld	r5, r2
	ld	r4, uaddr	! rr4 --- real address  
	addl	rr4, segaddr	! add segment address      
	call	real_to_seg
	ldl	rr2, rr4	! rr2 --- segmente address 
	ldl	rr4, rr12	! rr4 --- return rr4 from rr12 
1:
	call	strhex8
	jr	c, ihex_err
	ldb 	@rr2, rl0
	add	r3, #1		! increment lower address
	addb	rh1, rl0
	dbjnz	rl1, 1b
	call	strhex8		! rl0 --- CRC
	jr	c, ihex_err 
	negb	rh1
	cpb	rl0, rh1
	jr	ne, ihex_err 
	jr	no_err

data_end:
	xorb	rl0, rl0
	ret

seg_saddr:
	call	strhex16
	jr	c, ihex_err
	ld	r3, r0
	clr	r2		! rr2 --- CS
	call	strhex16
	jr	c, ihex_err
	ld	r5, r0
	clr	r4		! rr4 --- 32bit extended IP
	addl	rr2, rr2
	addl	rr2, rr2
	addl	rr2, rr2
	addl	rr2, rr2	! rr2 --- 4bit left shifted CS
	addl	rr4, rr2	! add CS + IP
	call	real_to_seg
	ldl	goaddr, rr4 
	jr	no_err

seg_addr:
	call	strhex16
	jr	c, ihex_err
	ld	r1, r0
	clr	r0
	addl	rr0, rr0
	addl	rr0, rr0
	addl	rr0, rr0
	addl	rr0, rr0
	ldl	segaddr, rr0 
	jr	no_err

ext_addr:
	call	strhex16
	jr	c, ihex_err
	ld	uaddr, r0
	jr	no_err

ext_saddr:
	call	strhex16
	jr	c, ihex_err
	ld	r2, r0
	call	strhex16
	jr	c, ihex_err
	ld	r3, r0
	ldl	goaddr, rr2
no_err:
	ldb	rl0, #0x01
	ret 

!------------------------------------------------------------------------------
	sect	.bss

segaddr:
	.long	0
uaddr:
	.word	0
buff:
	.space	80
