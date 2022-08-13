/****************************************************************************/
/*									    */
/*				   C P M . H				    */
/*				   ---------				    */
/*	Copyright 1982 by Digital Research Inc. All rights reserved.	    */
/*									    */
/*	This file contains CP/M specific definitions for the CP/M 	    */
/*	C Run Time Library.						    */
/*	This file is intended only for inclusion with those functions	    */
/*	dealing directly with the BDOS, as well as any function which	    */
/*	has hardware dependent code (byte storage order, for instance).	    */
/*									    */
/*	<portab.h> must be included BEFORE this file.			    */
/*									    */
/****************************************************************************/

/*
 *	CP/M FCB definition
 */

#ifndef CPM_H
#define CPM_H

struct	fcbtab					/****************************/
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
};						/****************************/
#define SECSIZ		128			/* size of CP/M sector	    */
#define _MAXSXFR	1			/* max # sectors xferrable  */
#define _MAXSHFT	12			/* shift right BDOS rtn val */
						/*   to obtain nsecs on err */
						/****************************/
/****************************************************************************/
/*									    */
/*	Channel Control Block (CCB)					    */
/*									    */
/*	One CCB is allocated (statically) for each of the 16 possible open  */
/*	files under C (including STDIN, STDOUT, STDERR).  Permanent data    */
/*	regarding the channel is kept here.				    */
/*									    */
/*									    */
/****************************************************************************/

struct	ccb				/************************************/
{					/*				    */
	BYTE	flags;			/*	Flags byte		    */
	BYTE	chan;			/*	Channel number being used   */
	LONG	offset;			/*	File offset word (bytes)    */
	LONG	sector;			/* 	Sector currently in buffer  */
	LONG	hiwater;		/*	High water mark		    */
	struct fcbtab fcb;		/*	File FCB (may have TTY info)*/
	BYTE	buffer[SECSIZ];		/*	Read/write buffer	    */
};					/************************************/

#define	MAXCCBS	16			/*	Maximum # CC Blocks 	    */
extern	struct	ccb	_fds[MAXCCBS];	/*	Declare storage		    */
#define FD struct ccb			/*	FD Type definition	    */
					/************************************/
/*	Flags word bit definitions					    */
					/************************************/
#define	OPENED	0x01			/*	Channel is OPEN		    */
#define	ISTTY	0x02			/*	Channel open to TTT	    */
#define	ISLPT	0x04			/*	Channel open to LPT	    */
#define	ISREAD	0x08			/*	Channel open readonly	    */
#define	ISASCII	0x10			/*	ASCII file attached	    */
#define	ATEOF	0x20			/*	End of file encountered	    */
#define DIRTY	0x40			/*	Buffer needs writing	    */
#define ISSPTTY	0x80			/*	Special tty info	    */
					/************************************/
#define READ	0			/* Read mode parameter for open	    */
#define WRITE	1			/* Write mode			    */

/*	CCB manipulation macros		*************************************/
#define _getccb(i) (&_fds[i])		/* 	Get CCB addr		    */

/*	Error handling 			*************************************/
EXTERN WORD errno;			/* error place for assigning	    */
EXTERN WORD __cpmrv;			/* the last BDOS return value	    */
EXTERN WORD _errcpm;			/* place to save __cpmrv	    */
#define RETERR(val,err) {errno=(err);_errcpm=__cpmrv;return(val);}
					/************************************/

/****************************************************************************/
/*									    */
/*		B D O S   F u n c t i o n   D e f i n i t i o n s	    */
/*		-------------------------------------------------	    */
/*									    */
/*	Following are BDOS function definitions used by the C runtime 	    */
/*	library.							    */
/*									    */
/****************************************************************************/

						/****************************/
#define	EXIT	 0				/* Exit to BDOS		    */
#define	CONOUT	 2				/* Direct console output    */
#define	LSTOUT	 5				/* Direct list device output*/
#define	CONIO	 6				/* Direct console I/O	    */
#define	CONBUF	10				/* Read console buffer	    */
#define	OPEN	15				/* OPEN a disk file	    */
#define	CLOSE	16				/* Close a disk file	    */
#define	DELETE	19				/* Delete a disk file	    */
#define	CREATE	22				/* Create a disk file	    */
#define	SETDMA	26				/* Set DMA address	    */
#define	B_READ	33				/* Read Random record	    */
#define	B_WRITE	34				/* Write Random record	    */
#define FILSIZ	35				/* Compute File Size	    */
#define SETMSC	44				/* Set Multi-Sector Count   */
						/****************************/

/****************************************************************************/
/* Other CP/M definitions						    */
/****************************************************************************/
#define	TERM	"CON:"				/* Console file name	    */
#define	LIST	"LST:"				/* List device file name    */
#define	EOFCHAR	0x1a				/* End of file character-^Z */
						/****************************/
/****************************************************************************/
/*	Hardware dependencies						    */
/****************************************************************************/
#define HILO					/* used when bytes stored   */
						/* Hi,Lo		    */
						/****************************/
#ifdef HILO					/* Hi/Lo storage used in    */
struct {					/*   68K		    */
	BYTE lbhihi;				/* Use this for accessing   */
	BYTE lbhilo;				/*   ordered bytes in 32 bit*/
	BYTE lblohi;				/*   LONG qtys.		    */
	BYTE lblolo;				/*			    */
};						/*			    */
struct {					/* Use this for accessing   */
	WORD lwhi;				/*   ordered words in 32 bit*/
	WORD lwlo;				/*   LONG qtys.		    */
};						/*			    */
#else						/****************************/
struct {					/* Lo/Hi storage use on     */
	BYTE lblolo;				/*   PDP-11, VAX, 8086,...  */
	BYTE lblohi;				/*			    */
	BYTE lbhilo;				/*			    */
	BYTE lbhihi;				/*			    */
};						/*			    */
struct {					/*			    */
	WORD lwlo;				/*			    */
	WORD lwhi;				/*			    */
};						/*			    */
#endif						/****************************/
/*************************** end of cpm.h ***********************************/

#endif /* CPM_H */

