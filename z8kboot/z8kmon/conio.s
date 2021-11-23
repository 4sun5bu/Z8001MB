!------------------------------------------------------------------------------
! string.s
!  Subroutines for string output, input and convert
!
!  Copyright (c) 2019 4sun5bu
!------------------------------------------------------------------------------

	.global	puts, putln, putsp, puthex8, puthex16
	.global	gets, skipsp, ishex, strhex8, strhex16
	.global	toupper

	sect	.text
	segm

!------------------------------------------------------------------------------
! putln 
!   Send CR and LF
!
!   destroyed:  r0 

putln:
	ldb	rl0, #'\r'
	call	putc
	ldb	rl0, #'\n'
	jp	putc

!------------------------------------------------------------------------------
! putsp 
!   Send SPACE
!
!   destroyed:  r0

putsp:
	ldb	rl0, #' '
	jp	putc

!------------------------------------------------------------------------------
! puts
!   Print a zero terminated string 
!
!   input:      rr4 --- string address
!   destroyed:  r0, rr4

puts:
	ldb	rl0, @rr4
	testb	rl0
	ret	z
	call	putc
	inc	r5, #1
	jr	puts

!------------------------------------------------------------------------------
! puthex4
!   Print a lower 4bit value in hex
!
!   input:      rl0 --- value
!   destroyed:  r0

puthex4:
	andb	rl0, #0x0f
	addb	rl0, #'0'
	cpb	rl0, #('0' + 10)
	jp	lt, putc
	addb	rl0, #('A' - '0' - 10)
	jp	putc

!------------------------------------------------------------------------------
! puthex8
!   Print a 8bit value in hex 
!
!   input:      rl4 --- value
!   destroyed:  r0, r4

puthex8:
	ldb	rl0, rl4 
	srlb	rl0, #4
	call	puthex4
	ldb	rl0, rl4
	jr	puthex4 

!------------------------------------------------------------------------------
! puthex16
!   Print a 16bit value in hex
!
!   input:      r4 --- value   
!   destroyed:  r0, r1, r4

puthex16:
	ld	r1, r4
	ldb	rl4, rh4
	call	puthex8
	ldb	rl4, rl1
	jr	puthex8

!------------------------------------------------------------------------------
! gets
!   Input 1 line 
!
!   input:      rr4 --- buffer address
!   return:     rr4 --- address of zero terminated string
!   destroyed:  r0

gets:
	pushl	@rr14, rr4
	push	@rr14, r2
	clr	r2
1:
	call	getc
	cpb	rl0, #'\b'
	jr	nz, 2f
	test	r2
	jr	z, 1b
	call	putc
	ldb	rl0, #' '
	call	putc
	ldb	rl0, #'\b'
	call	putc
	dec	r5, #1
	dec	r2, #1
	jr	1b
2:
	cpb	rl0, #'\r'
	jr	eq, 3f
	cpb	rl0, #'\n'
	jr	eq, 3f
	call	putc
	ldb	@rr4, rl0
	inc	r5, #1
	inc	r2, #1
	jr	1b
3:  
	call	putln
	ldb	@rr4, #0
	pop	r2, @rr14
	popl	rr4, @rr14
	ret

!------------------------------------------------------------------------------
! skipsp
!   Skip space
!
!   input:      rr4 --- string address   
!   return:     rr4 --- next character address 
!               rl0 --- next character

skipsp:
	ldb	rl0, @rr4
	cpb	rl0, #' '
	ret	ne
	inc	r5, #1
	jr	skipsp

!------------------------------------------------------------------------------
! ishex
!   Check and convert an ascii code to 4-bit hex value
!
!   input:      rl0 --- ascii character   
!   return:     rl0 --- 0x00 - 0x0f 
!               CF  --- error 
!   destroyed:  

ishex:
	cpb	rl0, #'0'
	jr	lt, 2f
	cpb	rl0, #'9'
	jr	gt, 1f
	subb	rl0, #'0' 
	ret
1:
	call	toupper
	cpb	rl0, #'A'
	jr	lt, 2f
	cpb	rl0, #'F'
	jr	gt, 2f
	subb	rl0, #('A' - 0x0a) 
	ret
2:  
	setflg	c 
	ret

!------------------------------------------------------------------------------
! strhex8
!   Convert string to 8bit hex
!
!   input:      rr4 --- string address   
!   return:     rl0 --- value
!               CF  --- error 
!               rr4 --- next address 
!   destroyed:  r0

strhex8:
	ldb	rl0, @rr4
	call	ishex
	ret	c
	ldb	rh0, rl0
	inc	r5, #1
	ldb	rl0, @rr4 
	call	ishex
	ret	c
	rlb	rh0, #2
	rlb	rh0, #2
	addb	rl0, rh0
	inc	r5, #1
	ret

!------------------------------------------------------------------------------
! strhex16
!   Convert string to 16bit hex
!
!   input:      rr4 --- string address   
!   return:     r0  --- value
!               CF  --- error 
!               rr4 --- next address 
!   destroyed:  r0, rl1

strhex16:
	call	strhex8
	ldb	rl1, rl0
	ret	c
	call	strhex8
	ldb	rh0, rl1
	ret

!------------------------------------------------------------------------------
! toupper
!   Convert lowercase letter to uppercase
! 
!   input:      rl0 --- ascii code
!   output:     rl0 --- converted ascii code
!   destroyed:

toupper:
	cpb	rl0, #'a'
	ret	lt
	cpb	rl0, #'z'
	ret	gt
	subb	rl0, #0x20
	ret

