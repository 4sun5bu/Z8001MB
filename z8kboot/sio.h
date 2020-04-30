/******************************************************************************
 * sio.h
 *  Header fine for Sirial Comunication routines 
 *
 *  Copyright (c) 2019 4sun5bu
 ******************************************************************************/

#ifndef __SIO_H__
#define __SIO_H__

void init_usart();
void sout_char(char value);
void sout_string(char *str);
void sout_hex4(unsigned int value);
void sout_hex8(unsigned int value);
void sout_hex16(unsigned int value);

char sin_char();
void sin_string(char *buf);

#endif 