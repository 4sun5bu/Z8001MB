!------------------------------------------------------------------------------
! ide.s
!   Subroutines for HDD read and write
!
!  Copyright (c) 2019 4sun5bu
!------------------------------------------------------------------------------

	.global	ide_init, ide_read

	sect	.text
	segm

	!.equ	IDE16, 1

	.equ	IDE_DATAW, 0x0020	! Word access
	.equ	IDE_DATAB, 0x0021	! Byte access
	.equ	IDE_ERROR, 0x0023
	.equ	IDE_FEATURES, 0x0023
	.equ	IDE_SECT_CNT, 0x0025
	.equ	IDE_SECT_NUM, 0x0027
	.equ	IDE_CYL_LOW, 0x0029
	.equ	IDE_CYL_HIGH, 0x002b
	.equ	IDE_DEV_HEAD, 0x002d
	.equ	IDE_STATUS, 0x002f
	.equ	IDE_COMND, 0x002f
	.equ	IDE_ALT_STATUS, 0x003d
	.equ	IDE_DEV_CTRL, 0x003d

	.equ	BSYBIT,  0x80
	.equ	DRDYBIT, 0x40
	.equ	DREQBIT, 0x08
	.equ	ERRBIT,  0x01

chkbsy:
	inb	rl0, #IDE_STATUS
	andb	rl0, #(BSYBIT | DREQBIT)
	jr	nz, chkbsy
	ret

ide_init:
	call chkbsy
.ifdef	IDE16
	ldb	rl0, #0x81		! Word access
.else
	ldb	rl0, #0x01		! Byte access 
.endif
	outb	#IDE_FEATURES, rl0
	ldb	rl0, #0xef
	outb	#IDE_COMND, rl0
	call	chkbsy
	ldb	rl0, #0x08		! set PIO mode 0
	outb	#IDE_SECT_CNT, rl0
	ldb	rl0, #0x03
	outb	#IDE_FEATURES, rl0
	ldb	rl0, #0xef
	outb	#IDE_COMND, rl0
	inb	rl0, #IDE_STATUS
	ret 

!------------------------------------------------------------------------------
! ide_read
!   Read a sector from a IDE disk
!
!   input:      rr2 --- LBA     
!               rr4 --- buffer address 
!   destroyed:  r0, r2, r5

ide_read:
	call	chkbsy			! Device selection
	ldb	rl0, #0x40
	outb	#IDE_DEV_HEAD, rl0
	call	chkbsy
	clrb	rl0			! Clear Features
	outb	#IDE_FEATURES, rl0
	ldb	rl0, #0b00000010	! Disable Interrupt
	outb	#IDE_DEV_CTRL, rl0		
	ldb	rl0, #1			! One sector read
	outb	#IDE_SECT_CNT, rl0
	outb	#IDE_SECT_NUM, rl3	! Set LBA
	outb	#IDE_CYL_LOW, rh3
	outb	#IDE_CYL_HIGH, rl2
	andb	rh2, #0x0f
	orb	rh2, #0x40
	outb	#IDE_DEV_HEAD, rh2
	ldb	rl0, #0x20		! READ SECTOR command
	outb	#IDE_COMND, rl0
.ifdef	IDE16
	inb	rl0, #IDE_ALT_STATUS	! Reset INTRQ
.endif
1:
	inb	rl0, #IDE_STATUS
	bitb	rl0, #0
	setflg	c
	ret	nz
	andb	rl0, #(BSYBIT | DREQBIT)
	cpb	rl0, #DREQBIT
	jr	nz, 1b

.ifdef	IDE16
	ld	r1, #256
2:
	in	r0, #IDE_DATAW
	exb	rl0, rh0
	ld	@rr4, r0
	inc	r5, #2
	djnz	r1, 2b
.else
	ld	r1, #512
2:
	inb	rl0, #IDE_DATAB
	ldb	@rr4, rl0
	inc	r5, #1
	djnz	r1, 2b
.endif	
.ifdef	IDE16
	inb	rl0, #IDE_ALT_STATUS	! 
.endif
	inb	rl0, #IDE_STATUS	!
	resflg	c
	ret

