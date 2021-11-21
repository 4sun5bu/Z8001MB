!------------------------------------------------------------------------------
! z8530.s
!  Serial I/O routines for Z8530 SCC
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
!   output 1 byte to the PORT A 
!
!   input:      rl0 --- Ascii code
!   destroyed:  r0

putc:
	inb	rh0, #SCCAC
	andb	rh0, #0x04
	jr	z, putc
	outb	#SCCAD, rl0
	ret

!------------------------------------------------------------------------------
! getc
!   input 1 byte from the PORT A
!
!   return:     rl0 --- read data
!   destroyed:  r0

getc:
	inb	rh0, #SCCAC
	andb	rh0, #0x01
	jr	z, getc 
	inb	rl0, #SCCAD
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
