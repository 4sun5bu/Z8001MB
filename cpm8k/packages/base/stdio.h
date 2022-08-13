/*****************************************************************************
*
*		    C P / M   C   H E A D E R   F I L E
*		    -----------------------------------
*	Copyright 1982 by Digital Research Inc.  All rights reserved.
*
*	This is the standard include file for the CP/M C Run Time Library.
*
*****************************************************************************/

#ifndef STDIO_H
#define STDIO_H
					/*				    */
#ifndef BYTE				/* If it looks like portab.h not    */
#include <portab.h>			/*   included already, include it   */
#endif					/*				    */
					/*				    */
/****************************************************************************
*	Stream I/O File Definitions
*****************************************************************************/
#define BUFSIZ	512			/*	Standard (ascii) buf size   */
#define MAXFILES	16		/*	Max # open files ( < 32 )   */
struct _iobuf {				/*				    */
	WORD _fd;			/* file descriptor for low level io */
	WORD _flag;			/* stream info flags		    */
	BYTE *_base;			/* base of buffer		    */
	BYTE *_ptr;			/* current r/w pointer		    */
	WORD _cnt;			/* # chars to be read/have been wrt */
};					/*				    */
#ifndef FILE				/* conditionally include:	    */
extern struct _iobuf _iob[MAXFILES];	/* an array of this info	    */
#define FILE struct _iobuf		/* stream definition		    */
#endif					/* flag byte definition		    */

#define _IOREAD	0x01			/* readable file		    */
#define _IOWRT	0x02			/* writeable file		    */
#define _IOABUF	0x04			/* alloc'd buffer		    */
#define _IONBUF	0x08			/* no buffer			    */
#define _IOERR	0x10			/* error has occurred		    */
#define _IOEOF	0x20			/* EOF has occurred		    */
#define _IOLBUF 0x40			/* handle as line buffer	    */
#define _IOSTRI	0x80			/* this stream is really a string   */
#define _IOASCI	0x100			/* this was opened as an ascii file */
					/************************************/
#define stdin (&_iob[0])		/* standard input stream	    */
#define stdout (&_iob[1])		/*    "     output  "		    */
#define stderr (&_iob[2])		/*    "     error   "		    */
					/************************************/
#define clearerr(p) ((p)->_flag & ~_IOERR) /* clear error flag		    */
#define feof(p) ((p)->_flag & _IOEOF)	/* EOF encountered on stream	    */
#define ferror(p) ((p)->_flag & _IOERR)	/* error encountered on stream	    */
#define fileno(p) ((p)->_fd)		/* get stream's file descriptor	    */
#define getchar() getc(stdin)		/* get char from stdin 		    */
#define putchar(c) putc(c,stdout)	/* put char to stdout		    */
#define putc fputc
#define getc fgetc

FILE *fopen(), *fopena(), *fopenb(), *fdopen();
FILE *freopen(), *freopa(), *freopb();
LONG ftell(), getl();
BYTE *fgets(), *gets();

int opena();
int openb();
int creat();
long lseek();
int close();
int read();
int write();

/****************************************************************************/
/*									    */
/*				M A C R O S				    */
/*				-----------				    */
/*									    */
/*	Define some stuff as macros ....				    */
/*									    */
/****************************************************************************/

#define	abs(x)	((x) < 0 ? -(x) : (x))	/*	Absolute value function	    */

#define	max(x,y)   (((x) > (y)) ? (x) :  (y))	/* Max function		    */
#define	min(x,y)   (((x) < (y)) ? (x) :  (y))	/* Min function		    */

/*************************** end of stdio.h *********************************/

#endif /* STDIO_H */

