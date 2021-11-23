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
1:
	ldb	rl0, #'>'
	call	putc
	call	putsp
	lda	rr4, linebuff
	call	gets
	ldb	rh0, @rr4
	inc	r5, #1
	call	skipsp
	cpb	rh0, #'d'
	jr	ne, 2f
	call	dump_cmnd
	jr	1b
2:
	cpb	rh0, #'s'
	jr	ne, 3f
	call	set_cmnd
	jr	1b
3:
	cpb	rh0, #'g'
	jr	ne, 4f
	call	go_cmnd
	jr	1b
4:
	cpb	rh0, #'l'
	jr	ne, 5f
	call	load_cmnd
	jr	1b
5:
	cpb	rh0, #'i'
	jr	ne, 6f
	call	ior_cmnd
	jr	1b
6:
	cpb	rh0, #'o'
	jr	ne, 7f
	call	iow_cmnd
	jr	1b
7:
	cpb	rh0, #'z'
	jr	ne, 8f
	call	z_cmnd

8:
	cpb	rh0, #'h'
	jr	ne, err_cmnd
	call	dcmnd_usage
	call	scmnd_usage
	call	gcmnd_usage
	call	lcmnd_usage
	call	icmnd_usage
	call	ocmnd_usage
	call	zcmnd_usage
	jr	1b

err_cmnd:
	testb	linebuff
	jr	z, 1b
	lda	rr4, errmsg
	call	puts
	lda	rr4, linebuff
	call	puts
	call	putln
	jr	1b

!------------------------------------------------------------------------------
	sect .rodata

bootmsg:
	.asciz	"\033[2J\033[0;0HZ8001 Machine Code Monitor Ver.0.1.3\r\n"
errmsg:
	.asciz	"??? "

!------------------------------------------------------------------------------
	sect	.bss
	.global	linebuff

linebuff:  
	.space  80
