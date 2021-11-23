!------------------------------------------------------------------------------
! lcmnd.s
!   Load Intel HEX file command
!
!  Copyright (c) 2019 4sun5bu
!------------------------------------------------------------------------------

	.global	load_cmnd, lcmnd_usage 

	sect	.text
	segm

!------------------------------------------------------------------------------
! load_cmnd
!   Load intel hex file 
!
!   input:      rr4 --- options address 
!   destroyed:  r0, r1, r2, r3, rr4, rr6, rr8

load_cmnd:
	clr	segment
	clr	segment + 2
	clr	offset
	testb	@rr4
	jr	z, lcloop
	call	strhex16
	jp	c, lcmnd_usage
	ld	offset, r0
lcloop:
	lda	rr4, buff
	call	gets
	call	ihex_line
	testb	rl0
	ret	mi		! Error
	ret	z		! ihex end
	jr	lcloop

checksum:
	clrb	rh2
	call	strhex8
	jr	c, ihex_err
	addb	rh2, rl0
	ldb	rl2, rl0
	addb	rl2, #3
cs1:
	call	strhex8
	jr	c, ihex_err
	addb	rh2, rl0
	dbjnz	rl2, cs1
	call	strhex8		! checksum
	jr	c, ihex_err
	negb	rh2
	cpb	rl0, rh2
	jr	ne, cs_err
	ret

ihex_line:
	cpb	@rr4, #':'
	jr	ne, ihex_err
	inc	r5, #1
	ldl	rr6, rr4
	call	checksum
	ldl	rr4, rr6
	call	strhex8
	ldb	rl6, rl0	! rl6 --- byte count
	call	strhex16
	ld	r2, r0		! r2  --- data address
	call	strhex8		! rl0 --- record type
	testb	rl0
	jr	z, data_rec	! type 0
	decb	rl0, #1
	jr	z, data_end	! type 1
	decb	rl0, #1
	jr	z, seg_addr	! type 2
	decb	rl0, #1
	jr	z, seg_saddr	! type 3
	decb	rl0, #1
	jr	z, linr_addr	! type 4
	decb	rl0, #1
	jr	z, linr_saddr	! type 5 
ihex_err:
	lda	rr4, errmsg1
	jr	ce1
cs_err:
	lda	rr4, errmsg2
ce1:
	call	puts
	ldb	rl0, #0xff
	ret

data_rec:
	ldl	rr8, rr4	! copy rr4 to rr6
	ld	r5, offset
	add	r5, r2		! 
	clr	r4		! rr4 --- offset + address
	addl	rr4, segment	! add segment address
	call	linr2seg
	ldl	rr2, rr4	! rr2 --- segmented address 
	ldl	rr4, rr8	! return rr4 
dr1:
	call	strhex8
	ldb 	@rr2, rl0
	add	r3, #1		! increment lower address
	jr	nc, dr2
	incb	rh2, #1
	orb	rh2, #0x80
dr2:
	dbjnz	rl6, dr1
	jr	no_err

data_end:
	xorb	rl0, rl0
	ret

seg_addr:
	call	strhex16
	ld	r1, r0		! rr0 --- DS
	clr	r0
	slll	rr0, #4
	ldl	segment, rr0 
	jr	no_err

seg_saddr:
	call	strhex16
	ld	r3, r0		
	clr	r2		! rr2 --- CS
	call	strhex16
	ld	r5, r0
	clr	r4		! rr4 --- IP
	slll	rr2, #4
	addl	rr4, rr2	! add CS + IP
	call	linr2seg
	ldl	goaddr, rr4 
	jr	no_err

linr_addr:
	call	strhex16
	ld	segment, r0
	clr	segment + 2
	jr	no_err

linr_saddr:
	call	strhex16
	ld	r2, r0
	call	strhex16
	ld	r5, r0
	ld	r4, r2
	call	linr2seg
	ldl	goaddr, rr4
no_err:
	ldb	rl0, #0x01
	ret 

lcmnd_usage:
	lda	rr4, usage
	jp	puts

!------------------------------------------------------------------------------
	sect	.rodata
usage:
	.asciz	"Load HEX: l [xxxx]\r\n"

errmsg1:
	.asciz	"Illegal input\r\n"

errmsg2:
	.asciz	"Checksum error\r\n"

!------------------------------------------------------------------------------
	sect	.bss

segment:
	.long	0
offset:
	.word	0
buff:
	.space	80
