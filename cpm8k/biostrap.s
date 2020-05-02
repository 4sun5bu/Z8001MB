! ********** biostrap.8kn cpm.sys + cpmldr.sys ******
! *	Copyright 1984, Digital Research Inc.
! *
! *	Trap handlers for CP/M-8000(tm) BIOS
! *
! * 821013 S. Savitzky (Zilog) -- created
! * 821123 D. Dunlop (Zilog)   -- added Olivetti M20-
! *	specific code to invalidate track buffer
! *	contents when disk drive motor stops
! *	(fixes directory-overwrite on disk change)
! * 830305 D. Sallume (Zilog)  -- added FPE trap
! *	code.
! * 840815 R. WEISER (DRI) -- conditional assembly
! *
! * 20200211 4sun5bu -- modified and converted for assembling with GNU as

! ****************************************************
! *
! * NOTE
! *	Trap and interrupt handlers are started up
! *	in segmented mode.
! *
! ****************************************************


! ****************************************************
! *
! * Externals 
! *
! ****************************************************

	.extern	biosentry	! Bios
	.extern	memsc		! memory-management SC
	.extern	_sysseg, _psap

! ****************************************************
! *
! * Global declarations
! *
! ****************************************************

	.global	trapinit, _trapvec, _trap, fp_epu
	.global	xfersc, psa
    
! ****************************************************
! *
! * System Call and General Trap Handler And Dispatch
! *
! *     It is assumed that the system runs 
! *     non-segmented on a segmented CPU.
! *
! *     _trap is jumped to segmented, with the 
! *     following information on the stack:
! *
! *             trap type: WORD
! *             reason:    WORD
! *             fcw:       WORD
! *             pc:        LONG
! *
! *     The trap handler is called as a subroutine,
! *     with all registers saved on the stack,
! *     IN SEGMENTED MODE.  This allows the trap
! *     handler to be in another segment (with some
! *     care).  This is useful mainly to the debugger.
! *
! *     All registers except rr0 are also passed
! *     intact to the handler.
! *
! ****************************************************
	.include "biosdef.s"
	 
	unsegm
	sect .text
        
sc_trap:			! system call trap server
	push	@r14,@r14
_trap:
	sub	r15, #30	! push caller state
	ldm	@r14, r0, #14	! r0 - r15
	NONSEG			! go nonsegmented
	ldctl	r1, nsp
	ld	nr14(r15), r14
	ex	r1, nr15(r15)

	! trap# now in r1
	cpb	rh1, #0x7F	! system call?
	jr	ne, trap_disp	! no
	clrb	rh1		! yes: map it
	add	r1, #SC0TRAP

	! === need range check ===

trap_disp:			! dispatch
	sll	r1, #2
	ldl	rr0, _trapvec(r1)
	testl	rr0
	jr	z, _trap_ret	! zero -- no action
				! else call seg @rr0
	pushl	@r15, rr0	! (done via kludge)
	SEG
	popl	rr0, @r14	! popl rr0, @rr14
	calr	trap_1
	jr	_trap_ret
trap_1:				! jp @rr0
	pushl   @r14, rr0	! pushl @rr14, rr0
	ret

	_trap_ret:		! return from trap or interrupt
	NONSEG
	ld	r1, nr15(r15)	! pop state
	ld	r14, nr14(r15)
	ldctl	nsp, r1
	SEG			! go segmented for the iret.
	ldm	r0, @r14, #14	! ldm r0, @rr14, #14
	add	r15, #32	! restore caller state
	iret			! return from interrupt

! ****************************************************
! *
! * Assorted Trap Handlers
! *
! ****************************************************

	epu_trap:
	push	@r14, #EPUTRAP
	jr	_trap

	pi_trap:
	push	@r14, #PITRAP
	jr	_trap

	seg_trap:
	push	@r14, #SEGTRAP
	jr	_trap

	nmi_trap:
	push	@r14, #NMITRAP
	jr	_trap

! ****************************************************
! *
! * Bios system call handler
! *
! * r3 = operation code
! * rr4 = P1
! * rr6 = P2
! ****************************************************

biossc:					! call bios
	NONSEG
	ld	r0, scfcw + 4(r15)	! if caller nonseg, normal
	and	r0, #0xC000
	jr	nz, seg_ok
	ld	r4, scseg + 4(r15)	! then add seg to P1, P2
	ld	r6, r4
seg_ok:
	! set up C stack frame, TODO: modify for assembly subroutine
	pushl	@r15, rr6
	pushl	@r15, rr4
	push	@r15, r3
	call	biosentry			! call C program 

	! clean stack & return
	add	r15, #10
	ldl	cr6 +4(r15), rr6	! with long in rr6
	SEG
	ret

! ****************************************************
! *
! * Context Switch System Call
! *
! *	xfer(context)
! *	long context;
! *
! * context is the physical (long) address of:
! *	r0
! *     ...
! *	r13
! *	r14 (normal r14)
! *	r15 (normal r15)
! *	ignored word
! *	FCW (had better specify normal mode)
! *	PC segment
! *	PC offset
! *
! * The system stack pointer is not affected.
! *
! * Control never returns to the caller.
! *
! ****************************************************

xfersc:		
! enter here from system call
! build frame on system stack
! when called from system call, the frame replaces
! the caller's context, which will never be resumed.

	SEG
	inc	r15, #4			! discard return addr
	ldl	rr4, rr14		! move context
	ld 	r2, #FRAMESZ / 2
	ldir	@r4, @r6, r2
	jr	_trap_ret		! restore context

! ****************************************************
! *
! * _trapinit -- initialize trap system
! *
! ****************************************************

! *
! * PSA (Program Status Area) structure
! *
	.equ	ps, 8			! size of a program status entry
	! --- segmented ---
	.equ	psa_epu, 1 * ps			! EPU trap offset
	.equ	psa_prv, 2 * ps			! priviledged instruction trap
	.equ	psa_sc,  3 * ps			! system call trap
	.equ	psa_seg, 4 * ps			! segmentation trap
	.equ	psa_nmi, 5 * ps			! non-maskable interrupt
	.equ	psa_nvi, 6 * ps			! non-vectored interrupt
	.equ	psa_vi,  7 * ps			! vectored interrupt
	.equ	psa_vec, psa_vi + (ps / 2)	! vectors

trapinit:
	! initialize trap table
	lda	r2, _trapvec
	ld	r0, #NTRAPS
	subl	rr4, rr4
clrtraps:
	ldl	@r2, rr4
	inc	r2, #4
	djnz	r0, clrtraps

	ld	r2, _sysseg
	lda	r3, biossc
	ldl	_trapvec + (BIOS_SC + SC0TRAP) * 4, rr2
	lda	r3, memsc
	ldl	_trapvec + (MEM_SC + SC0TRAP) * 4, rr2
	lda	r3, fp_epu
	ldl	_trapvec + EPUTRAP * 4, rr2

	! initialize some PSA entries.
	! rr0	PSA entry: FCW  (ints ENABLED)
	! rr2	PSA entry: PC
	! rr4	-> PSA slot

	ldl	rr4, _psap
	SEG
	ldl	rr0, #0x0000D800	! FCW

	add	r5, #ps			! EPU trap
	ldar	r2, epu_trap		! ldar rr2, epu_trap
	ldm	@r4, r0, #4		! ldm @rr4, r0, #4

	add	r5, #ps			! Priviledged Inst
	ldar	r2, pi_trap
	ldm	@r4, r0, #4

	add	r5, #ps			! System Call
	ldar	r2, sc_trap
	ldm	@r4, r0, #4

	add	r5, #ps			! segmentation
	ldar	r2, seg_trap
	ldm	@r4, r0, #4

	add	r5, #ps			! Non-Maskable Int.
	ldar	r2, nmi_trap
	ldm	@r4, r0, #4

	NONSEG
	ret


fp_epu:
        ret
/*
dbgbc:  
	! Segmented mode
	.word	0x5d00	! ldl 0x03a000, rr0
	.word	0x8300
	.word	0xa000
	.word	0x5d02	! ldl 0x03a004, rr2
	.word	0x8300
	.word	0xa004
	.word	0x5d04	! ldl 0x03a008, rr4
	.word	0x8300
	.word	0xa008
	.word	0x5d06	! ldl 0x03a00c, rr6
	.word	0x8300
	.word	0xa00c
	.word	0x5d08	! ldl 0x03a010, rr8
	.word	0x8300
	.word	0xa010
	.word	0x5d0a	! ldl 0x03a014, rr10
	.word	0x8300
	.word	0xa014
	.word	0x5d0c	! ldl 0x03a018, rr12
	.word	0x8300
	.word	0xa018
	.word	0x5d0e	! ldl 0x03a01c, rr14
	.word	0x8300
	.word	0xa01c
	mset
	halt
*/

!-------------------------------------------------------------------------------
	sect .psa
	
	! PSA is located by the linker script
psa:
	.space  100
