 !------------------------------------------------------------------------------
 ! z8kmon.s
 !  Machine code monitor for Z8001 in segment mode
 !
 !      Copyright (c) 2019 4sun5bu
 !      Released under the MIT license, see LICENSE.
 !------------------------------------------------------------------------------

	sect	.text
	segm 
	
!------------------------------------------------------------------------------
	sect    .rstvec

	.word	0x0000
	.word	0xc000
	.word	0x0000
	.word	_start

!------------------------------------------------------------------------------
	sect	.text

	.global	_start

 _start:
	ldl	rr14, #0x80000000	! set stack pointer
	call	initscc
	lda	rr4, bootmsg 
	call	puts
	clr	r1
	ld	r0, #0x8000
	ldl	dumpaddr, rr0
	ldl	setaddr, rr0
	ldl	goaddr, rr0
loop:
	ldb	rl0, #'>'
	call	putc
	call	putsp
	lda	rr4, linebuff
	call	gets
	call	skipsp
	ldb	rl0, @rr4
	testb	rl0
	jr	z, loop
	call	toupper
	ldb	rh0, rl0
	inc	r5, #1
	call	skipsp
	ldb	rl0, #((tbl_end - cmnd_tbl) / 6)
	lda	rr2, cmnd_tbl
lp1:	
	cpb	rh0, @rr2
	jr	eq, lp2
	inc	r3, #6
	dbjnz	rl0, lp1
	jr	lp3
lp2:
	inc	r3, #2
	ldl	rr2, @rr2
	call	@rr2
	jr	loop
lp3:
	cpb	rh0, #'H'
	jr	ne, cmnderr
	call	dcmnd_usage
	call	scmnd_usage
	call	gcmnd_usage
	call	lcmnd_usage
	call	icmnd_usage
	call	ocmnd_usage
	call	zcmnd_usage
	jr	loop
cmnderr:	
	lda	rr4, errmsg
	call	puts
	lda	rr4, linebuff
	call	puts
	call	putln
	jr	loop

!------------------------------------------------------------------------------
	sect .rodata

cmnd_tbl:
	.byte	'D', ' '
	.long	dump_cmnd
	.byte	'S', ' '
	.long	set_cmnd
	.byte	'L', ' '
	.long	load_cmnd
	.byte	'G', ' '
	.long	go_cmnd
	.byte	'Z', ' '
	.long	z_cmnd
	.byte	'I', ' '
	.long	ior_cmnd
	.byte	'O', ' '
	.long	iow_cmnd
tbl_end:

bootmsg:
	.asciz	"\033[2J\033[0;0HZ8001 Machine Code Monitor Ver.0.1.3\r\n"
errmsg:
	.asciz	"??? "

!------------------------------------------------------------------------------
	sect	.bss
	.global	linebuff

linebuff:  
	.space  80
