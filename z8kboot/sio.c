/******************************************************************************
 * sio.c
 *  Sirial Comunication routines for ATMEGA164P 
 *
 *  Copyright (c) 2019 4sun5bu
 ******************************************************************************/

#include <avr/io.h>
#include <avr/cpufunc.h>
#include <avr/interrupt.h>

#include "sio.h"

void init_usart()
{
    // USART 初期化
    UBRR0H = 0x00; // 19200bps
	UBRR0L = 38; 
    UCSR0A = 0x00; //  
	UCSR0B = 0x18; // 00011000b receive/send enable
	UCSR0C = 0x06; // 00000110b 8bit, one stop bit, none-parity
}

void sout_char(char value)
{
    while ((UCSR0A & 0x20) == 0); 
    UDR0 = value;
}

void sout_string(char *str)
{
    while (*str != 0)
    {
        sout_char(*str);
        str ++;
    }
}

void sout_hex4(unsigned int value)
{
    unsigned char four_bit;

    four_bit = value & 0x000f;
    if (four_bit < 10)
        sout_char('0' + four_bit); 
    else
        sout_char('a' + four_bit - 10);
}

void sout_hex8(unsigned int value)
{
    sout_hex4((value & 0x00f0) >> 4);
    sout_hex4(value & 0x000f);    
}

void sout_hex16(unsigned int value)
{
    sout_hex8(value >> 8);
    sout_hex8(value & 0xff);
}

char sin_char()
{
    if (!(UCSR0A & 0x80))
        return 0x00;
    return UDR0;
}

void sin_string(char *buf)
{
    while (1) 
    {
        if (!(UCSR0A & 0x80)) 
            continue;
        *buf = UDR0;
        if (*buf == '\n')
        {
            *buf == 0;
            return;
        }
        buf++;
    }
}