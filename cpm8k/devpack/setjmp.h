/****************************************************************************/
/*									    */
/*			    s e t j m p . h				    */
/*			    ---------------				    */
/*									    */
/*		Copyright 1982 by Zilog Inc.  All rights reserved	    */
/*									    */
/*	Definitions for setjmp and longjmp non-local goto library functions.*/
/*	jmp_buf is large enough to hold copies of the eight "safe"	    */
/*	registers and a segmented return address.  Thus the last word is    */
/*	not used in non-segmented environments				    */
/*									    */
/****************************************************************************/

#ifndef SETJMP_H
#define SETJMP_H

typedef int jmp_buf[10];

extern int setjmp(), longjmp();

#endif /* SETJMP_H */

