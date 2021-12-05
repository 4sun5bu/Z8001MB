!------------------------------------------------------------------------------
! put.s
!  Subroutines for console out
!

	.global	putln, putsp, puts, puthex8, puthex16
	
	.extern	scc_out
 
 	unsegm
	sect .text

!------------------------------------------------------------------------------
! putln 
!   print CR and LF
!   destroyed:  rl0, r1, rl5 

putln:
	ldb	rl5, #'\r'
	call	scc_out
	ldb	rl5, #'\n'
	jp	scc_out

!------------------------------------------------------------------------------
! putsp 
!   print ' '
!   destroyed:  rl0, r1, rl5 

putsp:
	ldb	rl5, #' '
	jp	scc_out

!------------------------------------------------------------------------------
! puts 
!   print a zero terminated string
!   destroyed:  rl0, r1, rl5 

puts:
	ldb	rl5, @r4
	testb	rl5
	ret	z
	call	scc_out
	inc	r4, #1
	jr	puts

!------------------------------------------------------------------------------
! puthex4
!   print a lower 4bit value in hex
!   input:      rl5 --- value
!   destroyed:  r0, r1, rl5

puthex4:
	andb	rl5, #0x0f
	addb	rl5, #'0'
	cpb	rl5, #('0' + 10)
	jp	lt, scc_out
	addb	rl5, #('A' - '0' - 10)
	jp	scc_out

!------------------------------------------------------------------------------
! puthex8
!   print a 8bit value in hex 
!   input:      rl5 --- value
!   destroyed:  r0, r1, r5

puthex8:
	ldb	rh5, rl5 
	rrb	rl5, #2
	rrb	rl5, #2
	call	puthex4
	ldb	rl5, rh5
	jr	puthex4 

!------------------------------------------------------------------------------
! puthex16
!   print a 16bit value in hex
!   input:      r5 --- value   
!   destroyed:  r0, r1, r4, r5

puthex16:
	ld	r4, r5
	ldb	rl5, rh5
	call	puthex8
	ldb	rl5, rl4
	jr	puthex8
