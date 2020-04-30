!------------------------------------------------------------------------------
! string.s
!  Subroutines for string output, input and convert
!
!  Copyright (c) 2019 4sun5bu

	.global	puts, putln, putsp, puthex8, puthex16
	.global	gets, skipsp, ishex, strhex8, strhex16
 
	sect	.text
	segm

!------------------------------------------------------------------------------
! putln 
!   Send CR and LF
!
!   destroyed:  rl0, r1, rl4 

putln:
	ldb	rl4, #'\r'
	call	putc
	ldb	rl4, #'\n'
	jp	putc

!------------------------------------------------------------------------------
! putsp 
!   Send ' '
!
!   destroyed:  rl0, r1, rl4 

putsp:
	ldb	rl4, #' '
	jp	putc

!------------------------------------------------------------------------------
! puts
!   Print a zero terminated string 
!
!   input:      rr4 --- start address of the string
!   destroyed:  r2, rr4, rr8               

puts:
	ldl	rr8, rr4
1:
	ldb	rl4, @rr8
	orb	rl4, rl4
	ret	z
	call	putc
	inc	r9, #1
	jr	1b

!------------------------------------------------------------------------------
! puthex4
!   Print a lower 4bit value in hex
!
!   input:      rl4 --- value
!   destroyed:  r0, r1, rl4

puthex4:
	andb	rl4, #0x0f
	addb	rl4, #'0'
	cpb	rl4, #('0' + 10)
	jr	lt, putc
	addb	rl4, #('A' - '0' - 10)
	jr	putc

!------------------------------------------------------------------------------
! puthex8
!   Print a 8bit value in hex 
!
!   input:      rl4 --- value
!   destroyed:  r0, r1, r4

puthex8:
	ldb	rh4, rl4 
	srlb	rl4, #4
	call	puthex4
	ldb	rl4, rh4
	jr	puthex4 

!------------------------------------------------------------------------------
! puthex16
!   Print a 16bit value in hex
!
!   input:      r4 --- value   
!   destroyed:  r0, r1, r4, r5

puthex16:
	ld	r5, r4
	ldb	rl4, rh4
	call	puthex8
	ldb	rl4, rl5
	jr	puthex8

!------------------------------------------------------------------------------
! gets
!   Input 1 line 
!
!   input:      rr4 --- buffer address
!   return:     rr4 --- read string terminated by zero
!   destroyed:  r0, r1, rr4, rr8

gets:
	pushl	@rr14, rr4
	ldl	rr8, rr4 
1:
	call	getc
	cpb	rl4, #'\n'
	jr	eq, 1b
	cpb	rl4, #'\r'
	jr	eq, 2f
	call	putc
	ldb	@rr8, rl4
	inc	r9, #1
	jr	1b
2:  
	call	putln
	ldb	@rr8, #0
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
!   Convert ascii to hex4
!
!   input:      rl4 --- ascii character   
!   return:     rl4 --- 0x00 - 0x0f 
!               CF  --- error 
!   destroyed:  

ishex:
	cpb	rl4, #'0'
	jr	lt, 3f
	cpb	rl4, #'9'
	jr	gt, 1f
	subb	rl4, #'0' 
	ret
1:
	cpb	rl4, #'A'
	jr	lt, 3f
	cpb	rl4, #'F'
	jr	gt, 2f
	subb	rl4, #('A' - 0x0a) 
	ret
2:
	cpb	rl4, #'a'
	jr	lt, 3f
	cpb	rl4, #'f'
	jr	gt, 3f
	subb	rl4, #('a' - 0x0a) 
	ret
3:  
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
!   destroyed:  rr6

strhex8:
	ldl	rr6, rr4
	xorb	rl0, rl0
1:
	ldb	rl4, @rr6
	call	ishex
	ret	c
	ldb	rl0, rl4
	inc	r7, #1
	ldb	rl4, @rr6 
	call	ishex
	ret	c
	rlb	rl0, #2
	rlb	rl0, #2
	addb	rl0, rl4
	inc	r7, #1
	ldl	rr4, rr6
	ret

!------------------------------------------------------------------------------
! strhex16
!   Convert string to 16bit hex
!
!   input:      rr4 --- string address   
!   return:     CF  --- error 
!               r0  --- value
!               rr4 --- next address 
!   destroyed:  rr6

strhex16:
	xor	r0, r0
	call	strhex8
	ret	c
	ldb	rh0, rl0
	jr	strhex8
