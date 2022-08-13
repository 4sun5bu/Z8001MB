/****************************************************************************/
/*									    */
/*	                   B A S E P A G E . H                              */
/*	                   -------------------                              */
/*	                                                                    */
/*	This file contains a definition of the CP/M basepage structure,     */
/*	b_page.								    */
/*									    */
/*	NOTE: In the portable CP/M environment, it is NOT guaranteed        */
/*	that the location of the base page is known at link-edit time       */
/*	(as it is, for example, in CP/M-80 and CP/M-86.)  Instead, a        */
/*	pointer to the current basepage is delivered by the BDOS	    */
/*	to each new program which is run.   This pointer, _base, is         */
/*	initialized by the C startup function (startup.s) and is            */
/*	available to C programs as an external.                             */
/*									    */
/*	This file has been modified to live with the BDOS definitions.	    */
/*									    */
/****************************************************************************/

#ifndef BASEPA_H
#define BASEPA_H

struct b_page
	{
		XADDR		ltpa;		/* Low TPA address	    */	
		XADDR		htpa;		/* High TPA address	    */	
		XADDR		lcode;		/* Start address of code seg*/
		long		codelen;	/* Code segment length	    */
		XADDR		ldata;		/* Start address of data seg*/
		long		datalen;	/* Data segment length	    */
		XADDR		lbss;		/* Start address of bss seg */
		long		bsslen;		/* Bss segment length	    */
		long		freelen;	/* Free segment length	    */
		char		resvd1[20];	/* Reserved area	    */
		struct fcb	fcb2;		/* Second basepage FCB	    */
		struct fcb	fcb1;		/* First basepage FCB	    */
		char		buff[128];	/* Default DMA buffer,	    */
						/*   command line tail	    */
	};

#endif /* BASEPA_H */

