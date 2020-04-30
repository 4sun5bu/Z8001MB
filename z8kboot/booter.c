/******************************************************************************
 * booter.c
 *  Boot code for z8kmon, copy binary image from the ATMEGA ROM  
 *  to the Z8001 SRAM at 0x00000, and jump there 
 *
 *  Copyright (c) 2019 4sun5bu
 ******************************************************************************/

#include <avr/io.h>
#include <avr/cpufunc.h>
#include <avr/interrupt.h>

#include "z8kmonimg.h"
#include "z8001macro.h"

unsigned int mem_word_read(unsigned int address)
{
    SET_READ
    SET_WORD_ACCESS
    ACT_MREQ

    // Address set
    SET_AD_OUT   
    ACT_AS
    PORTA = address & 0x00ff;
    PORTC = (address & 0xff00) >> 8;
    DEACT_AS

    // Data read
    SET_AD_IN
    ACT_DS
    unsigned int data = PINA + (PINC << 8); 
    DEACT_DS
    DEACT_MREQ

    return data;
}

unsigned char mem_byte_read(unsigned int address)
{
    SET_READ
    SET_BYTE_ACCESS
    ACT_MREQ

    // Address set
    SET_AD_OUT   
    ACT_AS
    PORTA = address & 0x00ff;
    PORTC = (address & 0xff00) >> 8;
    DEACT_AS

    // Data read
    SET_AD_IN
    ACT_DS
    
    unsigned char data;
    if (address &= 0b00000001)
        data = PINA; 
    else
        data = PINC;
    DEACT_DS
    DEACT_MREQ

    return data;
}

void mem_word_write(unsigned int address, unsigned int data)
{
    SET_WRITE
    SET_WORD_ACCESS
    ACT_MREQ

    // Address set
    SET_AD_OUT   
    ACT_AS
    PORTA = address & 0x00ff;
    PORTC = (address & 0xff00) >> 8;
    DEACT_AS

    // Data write
    ACT_DS
    PORTA = data & 0x00ff;
    PORTC = (data & 0xff00) >> 8;

    DEACT_DS
    DEACT_MREQ
}

void mem_byte_write(unsigned int address, unsigned char data)
{
    SET_WRITE
    SET_BYTE_ACCESS
    ACT_MREQ

    // Address set
    SET_AD_OUT   
    ACT_AS
    PORTA = address & 0x00ff;
    PORTC = (address & 0xff00) >> 8;
    DEACT_AS

    // Data write
    ACT_DS
    if (address &= 0b00000001)
        PORTA = data;
    else
        PORTC = data;

    DEACT_DS
    DEACT_MREQ
}

int main(void)
{
    cli();
   
    FREE_BUS
    SET_AD_IN
    DEACT_BUSREQ;
    DEACT_MREQ;
    DEACT_DS
    DEACT_AS
    START_CLOCK

    ACT_RESET
    for (int i = 0; i < 1024; i++)
    {
        asm("nop");
    }
    DEACT_RESET

    ACT_BUSREQ
    while (CHECK_BUSACK);
    GOT_BUS
    DEACT_AS
    DEACT_DS
    DEACT_MREQ
 
    // Write boot code to SRAM
     __flash const unsigned char *z8kmon_bin = &_binary_z8kmon_bin_start;
    const unsigned int z8kmon_bin_size = (unsigned int)&_binary_z8kmon_bin_size;

    for (int i = 0; i < z8kmon_bin_size; i++)
    {
        int count;
        for (count = 0; count < 3; count++)
        {
            unsigned char data = z8kmon_bin[i];
            mem_byte_write(0x0000 + i, data);
            if (data == mem_byte_read(0x0000 + i))
                break;
        }
        if (count == 3)
        {
            while (1)
            {
                // Boot fale
            }
        }    
    }

    SET_AD_IN
    FREE_BUS
    ACT_RESET
    DEACT_BUSREQ
    for (int i = 0; i < 1024; i++)
    {
        asm("nop");
    }
    DEACT_RESET

    while(1)
    {
    }
}

