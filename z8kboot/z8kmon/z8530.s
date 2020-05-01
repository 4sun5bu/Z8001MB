!------------------------------------------------------------------------------
! z8530.s
!  Serial Communication routines for Z8530 SCC
!
!  Copyright (c) 2019 4sun5bu
!------------------------------------------------------------------------------

	.global	initscc, putc, getc
	
	sect	.text
	segm

	.equ	SCCAC, 0x0005
	.equ	SCCAD, 0x0007

!------------------------------------------------------------------------------
! initscc
!   Initialize Z8530 SCC
!
!   destroyed:  r2, r3 ,rr4 

initscc:
	ld	r2, #(scccmde - scccmds)	! initialize Z8530
	ld	r3, #SCCAC
	ldl	rr4, #scccmds
	otirb	@r3, @rr4, r2
	ret

!------------------------------------------------------------------------------
! putc 
!   print 1 byte 
!
!   input:      rl4 --- Ascii code
!   destroyed:  rl0, r1 

putc:
	ld	r1, #SCCAC
1:
	inb	rl0, @r1
	andb	rl0, #0x04
	jr	z, 1b 
	ld	r1, #SCCAD
	outb	@r1, rl4
	ret

!------------------------------------------------------------------------------
! getc
!   input 1 byte from serial port
!
!   return:     rl4 --- read data
!   destroyed:  r0, r1

getc:
	ld	r1, #SCCAC
 1:  
	mres
	inb	rl0, @r1
	andb	rl0, #0x01
	jr	z, 1b 
	ld	r1, #SCCAD
	inb	rl4, @r1
	ret

!------------------------------------------------------------------------------
	sect .rodata

scccmds:
	.byte	9, 0xc0		! Reset
	.byte	4, 0x44		! x16, 1stop-bit, non-parity
	.byte	3, 0xe0		! Receive  8bit/char, rts auto         
	.byte	5, 0xe2		! Send 8bit/char, dtr rts
	.byte	11, 0x50	! BG use for receiver and transmiter
	.byte	12, 37		! 4800bps at 6MHz clock
	.byte	13, 00
	.byte	14, 0x02	! PCLK for BG
	.byte	14, 0x03	! BG enable
	.byte	3, 0xe1		! Receiver enable
	.byte	5, 0xea		! Transmiter enable
scccmde:
