/****************************************************************************/
/*									    */
/*	                        B D O S . H                                 */
/*	                        -----------                                 */
/*									    */
/*		Copyright (c) 1982, Zilog Incorporated			    */
/*									    */
/*	Macros defining the direct BDOS calls used by the standard CP/M	    */
/*	utilities (ED, PIP, STAT, SET, SHOW.)  Some necessary data	    */
/*	data structures are also defined.				    */
/*									    */
/*	All macros return a long value, even when the BDOS function they    */
/*	call does produce a return parameter.				    */
/*									    */
/*	This header file can be used applications which do not require	    */
/*	to use the C standard I/O library functions.  For applications	    */
/*	which require the library, but which wish to make use of the	    */
/*	additional information in this file, cpm.h should be included in    */
/*	the source ahead of this file.  The compiler flags multiple	    */
/*	definition errors if this ordering is not observed.		    */
/*									    */
/*	portab.h must always be included ahead of this file.		    */
/*									    */
/****************************************************************************/

#ifndef BDOS_H
#define BDOS_H

extern long	__BDOS();			/* BDOS entry point	    */

#define XADDR	long				/* 32-bit address data type */

/****************************************************************************/
/* The following BDOS calls are defined in cpm.h.  Define them only if they */
/* are not defined already.  						    */
/****************************************************************************/

#ifndef EXIT					/* Find out where we stand  */
						/* Define if necessary	    */
#define	EXIT	 	0			/* Exit to BDOS		    */
#define	CONOUT	 	2			/* Direct console output    */
#define	LSTOUT	 	5			/* Direct list device output*/
#define	CONIO	 	6			/* Direct console I/O	    */
#define	CONBUF		10			/* Read console buffer	    */
#define	OPEN		15			/* OPEN a disk file	    */
#define	CLOSE		16			/* Close a disk file	    */
#define	DELETE		19			/* Delete a disk file	    */
#define	CREATE		22			/* Create a disk file	    */
#define	SETDMA		26			/* Set DMA address	    */
#define	B_READ		33			/* Read Random record	    */
#define	B_WRITE		34			/* Write Random record	    */
#define FILSIZ		35			/* Compute File Size	    */
#define SETMSC		44			/* Set Multi-Sector Count   */

#endif

/****************************************************************************/
/* The following BDOS calls are not defined in cpm.h			    */
/****************************************************************************/

#define CONIN		1			/* Single char I/P with echo*/
#define READER		3			/* Paper tape input         */
#define PUNCH		4			/* Paper tape output        */
#define GET_IOB		7			/* Get I/O byte             */
#define SET_IOB		8			/* Set I/O byte             */
#define PRINT		9			/* Print $-terminated line  */
#define CONSTAT		11			/* Check if I/P char waiting*/
#define VERSION		12			/* Return version number    */
#define RS_DISK		13			/* Reset disk system        */
#define SEL_DISK	14			/* Select disk              */
#define SRCH_1ST	17			/* Search 1st filename match*/
#define SRCH_NEXT	18			/* Search next match	    */
#define S_READ		20			/* Sequential read from file*/
#define S_WRITE		21			/* Sequential write to file */
#define RENAME		23			/* Rename a file            */
#define RET_LOGIN	24			/* Return login vector      */
#define RET_CDISK	25			/* Return current disk      */
#define GET_ALLOC	27			/* Get allocation vector    */
#define WR_PROTD	28			/* Write protect disk       */
#define GET_RO		29			/* Get read-only vector     */
#define SET_ATT		30			/* Set file attributes      */
#define GET_DPB		31			/* Get disk parameters      */
#define GSET_UCODE	32			/* Get/set user code        */
#define SET_RAND	36			/* Set random record        */
#define RS_DRIVE	37			/* Reset disk specified drv */
						/* 38, 39 not used	    */
#define B_WRZF		40			/* Write random, zero fill  */
						/* 41 - 43 not used	    */
#define RET_ERRORS	45			/* Set error return mode    */
#define GET_DFS		46			/* Get free disk space      */
#define CHAIN		47			/* Chain to program via CCP */
#define FLUSH		48			/* Flush buffers to disk    */
#define GSET_SCB	49			/* Get/set system control bk*/
#define BIOS_CALL	50			/* Direct call to BIOS      */
						/* 51 - 58 not used	    */
#define PROG_LOAD	59			/* Program load             */
						/* 60 unused		    */
#define SET_EXV		61			/* Set exception vector     */
#define SET_SUP		62			/* Set supervisor state	    */
#define SET_LABEL	100			/* Set directory label	    */
#define GET_LABEL	101			/* Get directory label	    */
#define GET_XFCB	102			/* Get extended FCB         */
#define SET_XFCB	103			/* Set extended FCB         */
#define COND_LST	161			/* Conditionally attach LST:*/

/****************************************************************************/
/* The macros themselves...						    */
/****************************************************************************/

#define _conin()	(__BDOS(CONIN, (long) 0))

#define _conout(a)	(__BDOS(CONOUT, (long) (a)))

#define _reader()	(__BDOS(READER, (long) 0))

#define _punch(a)	(__BDOS(PUNCH, (long) (a)))

#define _lstout(a)	(__BDOS(LSTOUT, (long) (a)))

#define _conio(a)	(__BDOS(CONIO, (long) (a)))

#define _get_iob()	(__BDOS(GET_IOB, (long) 0))

#define _set_iob(a)	(__BDOS(SET_IOB, (long) (a)))

#define _print(a)	(__BDOS(PRINT, (long) (a)))

#define _conbuf(a)	(__BDOS(CONBUF, (long) (a)))

#define _constat()	(__BDOS(CONSTAT, (long) 0))

#define _version()	(__BDOS(VERSION, (long) 0))

#define _rs_disk(a)	(__BDOS(RS_DISK, (long) (a)))

#define _sel_disk(a)	(__BDOS(SEL_DISK, (long) (a)))

#define _open(a)	(__BDOS(OPEN, (long) (a)))

#define _close(a)	(__BDOS(CLOSE, (long) (a)))

#define _srch_1st(a)	(__BDOS(SRCH_1ST, (long) (a)))

#define _srch_next()	(__BDOS(SRCH_NEXT, (long) 0))

#define _delete(a)	(__BDOS(DELETE, (long) (a)))

#define _s_read(a)	(__BDOS(S_READ, (long) (a)))

#define _s_write(a)	(__BDOS(S_WRITE, (long) (a)))

#define _create(a)	(__BDOS(CREATE, (long) (a)))

#define _rename(a)	(__BDOS(RENAME, (long) (a)))

#define _ret_login()	(__BDOS(RET_LOGIN, (long) 0))

#define _ret_cdisk()	(__BDOS(RET_CDISK, (long) 0))

#define _setdma(a)	(__BDOS(SETDMA, (long) (a)))

#define _get_alloc()	(__BDOS(GET_ALLOC, (long) 0))

#define _wr_protd()	(__BDOS(WR_PROTD, (long) 0))

#define _get_ro()	(__BDOS(GET_RO, (long) 0))

#define _set_att(a)	(__BDOS(SET_ATT, (long) (a)))

						/* _get_dpb has parameter in*/
						/*   some implementations   */
						/*   of CP/M but not others */
						/* This macro suitable only */
						/*   for former		    */
#define _get_dpb(a)	(__BDOS(GET_DPB, (long) (a)))
						/* This one handles latter  */
#define _get_dpa()	(__BDOS(GET_DPB, (long) 0))

#define _gset_ucode(a)	(__BDOS(GSET_UCODE, (long) (a)))

#define _b_read(a)	(__BDOS(B_READ, (long) (a)))

#define _b_write(a)	(__BDOS(B_WRITE, (long) (a)))

#define _filsiz(a)	(__BDOS(FILSIZ, (long) (a)))

#define _set_rand(a)	(__BDOS(SET_RAND, (long) (a)))

#define _rs_drive(a)	(__BDOS(RS_DRIVE, (long) (a)))

#define _b_wrzf(a)	(__BDOS(B_WRZF, (long) (a)))

#define _setmsc(a)	(__BDOS(SETMSC, (long) (a)))

#define _ret_errors(a)	(__BDOS(RET_ERRORS, (long) (a)))

#define _get_dfs(a)	(__BDOS(GET_DFS, (long) (a)))

#define _chain()	(__BDOS(CHAIN, (long) 0))

#define _flush()	(__BDOS(FLUSH, (long) 0))

#define _gset_scb(a)	(__BDOS(GSET_SCB, (long) (a)))

#define _bios_call(a)	(__BDOS(BIOS_CALL, (long) (a)))

#define _prog_load(a)	(__BDOS(PROG_LOAD, (long) (a)))

#define _set_exv(a)	(__BDOS(SET_EXV, (long) (a)))

#define _set_sup(a)	(__BDOS(SET_SUP, (long) 0))

#define _get_label(a)	(__BDOS(GET_LABEL, (long) (a)))

#define _set_label(a)	(__BDOS(SET_LABEL, (long) (a)))

#define _get_xfcb(a)	(__BDOS(GET_XFCB, (long) (a)))

#define _set_xfcb(a)	(__BDOS(SET_XFCB, (long) (a)))

#define _cond_lst()	(__BDOS(COND_LST, (long) 0))

/****************************************************************************/
/* BIOS calls, for use in conjunction with BDOS call 50 & struct bios_parms */
/****************************************************************************/

#define	_INIT		0			/* Cold start		    */
#define _WARM		1			/* Warm start		    */
#define _CONST		2			/* Console status	    */
#define _CONIN		3			/* Read console character   */
#define _CONOUT		4			/* Write console character  */
#define _LIST		5			/* Write listing character  */
#define _PUNCH		6			/* Write punch character    */
#define _READER		7			/* Read tape character	    */
#define _HOME		8			/* Move to track 0	    */
#define _SELDSK		9			/* Select disk drive	    */
#define _SETTRK		10			/* Set track number	    */
#define _SETSEC		11			/* Set sector number	    */
#define _SETDMA		12			/* Set DMA address	    */
#define _READ		13			/* Read selected sector	    */
#define _WRITE		14			/* Write selected sector    */
#define _LISTST		15			/* Return list status	    */
#define _GETMRT		16			/* Get memory region table  */
						/*   address		    */
#define _GETIOB		17			/* Get IOBYTE value	    */
#define _SETIOB		18			/* Set IOBYTE value	    */
#define _FLUSH		19			/* Flush buffers	    */
#define _SETEXC		20			/* Set exception vector	    */

/****************************************************************************/
/* FCB structure is defined in cpm.h.  Define it here only if it is not	    */
/* defined already.  Declare some useful values at the same time.	    */
/****************************************************************************/

#ifndef SECSIZ					/* Not already declared?    */
struct	fcbtab					/* File control block	    */
{						/*			    */
	BYTE	drive;				/* Disk drive field	    */
	BYTE	fname[8];			/* File name		    */
	BYTE	ftype[3];			/* File type		    */
	BYTE	extent;				/* Current extent number    */
	BYTE	s1,s2;				/* "system reserved"	    */
	BYTE	reccnt;				/* Record counter	    */
	BYTE	resvd[16];			/* More "system reserved"   */
	LONG	record;				/* Note -- we overlap the   */
						/* current record field to  */
						/* make this useful.	    */
};

#define fcb	fcbtab				/* A useful synonym	    */
#define SECSIZ		128			/* size of CP/M sector	    */
#define _MAXSXFR	1			/* max # sectors xferrable  */
#define _MAXSHFT	12			/* shift right BDOS rtn val */

#endif

/****************************************************************************/
/* Data structures not defined in cpm.h					    */
/****************************************************************************/

struct	dpbs					/* Disk parameter block	    */
	{
		UWORD	spt;			/* Sectors per track	    */
		BYTE	bls;			/* Block shift factor	    */
		BYTE	bms;			/* Block mask		    */
		BYTE	exm;			/* Extent mark		    */
	/*	BYTE	filler;			 ***  Pad to align words  ***/
		UWORD	mxa;			/* Maximum allocation (blks)*/
		UWORD	dmx;			/* Max directory entries    */
		UWORD	dbl;			/* Directory alloc. map	    */
		UWORD	cks;			/* Directory checksum	    */
		UWORD	ofs;			/* Track offset from track 0*/
	};

struct bios_parm				/* BIOS parameters for BDOS */
	{					/*   call 50		    */
		UWORD	req;			/* BIOS request code	    */
		LONG	p1;			/* First parameter	    */
		LONG	p2;			/* Second parameter	    */
	};

struct scbs					/* System control block	    */
	{
		BYTE	resvd_1[6];		/* Reserved for system use  */
		BYTE	u_flags[4];		/* Utility flags	    */
		BYTE	d_flags[4];		/* Display flags	    */
		BYTE	clp_flags[2];		/* Command Line Proc flags  */
		UWORD	p_error;		/* Program error return code*/
		BYTE	resvd_2[8];		/* Reserved for system use  */
		BYTE	con_w;			/* Console width	    */
		BYTE	con_c;			/* Console column	    */
		BYTE	con_l;			/* Console page length	    */
		BYTE	resvd_3[5];		/* Reserved for system use  */
		UWORD	conin_r;		/* CONIN redirection flag   */
		UWORD	conout_r;		/* CONOUT redirection flag  */
		UWORD	auxin_r;		/* AUXIN redirection flag   */
		UWORD	auxout_r;		/* AUXOUT redirection flag  */
		UWORD	lstout_r;		/* LSTOUT redirection flag  */
		BYTE	resvd_4[2];		/* Reserved for system use  */
		BOOLEAN	ctl_h_a;		/* Backspace active	    */
		BOOLEAN	rubout_a;		/* Rubout active	    */
		BYTE	resvd_5[2];		/* Reserved for system use  */
		UWORD	c_xlate;		/* Console translate func.  */
		UWORD	con_m;			/* Console mode (raw/cooked)*/
		UWORD	buff_a;			/* 128 byte buffer available*/
		BYTE	o_delim;		/* Output delimiter	    */
		BOOLEAN lo_flag;		/* List output flag	    */
		BYTE	resvd_6[2];		/* Reserved for system use  */
		UWORD	d_m_a;			/* Current DMA address	    */
		BYTE	disk_no;		/* Current disk		    */
		BYTE	bdos_info[2];		/* BDOS variable info	    */
		BYTE	resvd_7[3];		/* Reserved for system use  */
		BYTE	user_no;		/* Current user number	    */
		BYTE	resvd_8[6];		/* Reserved for system use  */
		BYTE	bdos_mode;		/* BDOS error mode	    */
		BYTE	c_chain[4];		/* Current search chain	    */
		BYTE	tmp_drv;		/* Drive for temporary files*/
		BYTE	resvd_9[7];		/* Reserved for system use  */
		BYTE	date_s[5];		/* Date stamp		    */
		BYTE	error_jmp[3];		/* Error jump 		    */
		UWORD	cmb_a;			/* Common memory base addr  */
		UWORD	bdos_ent;		/* BDOS entry point	    */
	};

struct scbpb					/* SCB parameter block	    */
	{
		BYTE	off;			/* Index to data in SCB	    */
		BYTE	op;			/* Operation: 0xff Set byte */
						/*	      0xfe Set word */
						/*	      else Get word */
		UWORD	val;			/* Byte/word value to be set*/
	};

#define	SET_BYTE	0xff
#define	SET_WORD	0xfe
#define GET		0

/****************************************************************************/
/* HILO must be defined for the Z8000.  Undefine it first, in case cpm.h    */
/* has already defined it.  The tagless structures defining byte ordering   */
/* which are declared in cpm.h are not redeclared here (the use of members  */
/* of tagless structures to define offsets is an obsolete feature of the C  */
/* language.)	    							    */
/****************************************************************************/

#undef  HILO
#define HILO

#endif /* BDOS_H */

