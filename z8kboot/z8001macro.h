/******************************************************************************
 * z8001macro.h
 *  Definition of macros to control Z8001 bus signals 
 *
 *  Copyright (c) 2019 4sun5bu
 ******************************************************************************/

#ifndef __Z8001_MACRO_H__ 
#define __Z8001_MACRO_H__

#define FREE_BUS {DDRB = 0b11111011; DDRD = 0b10000001;}
#define GOT_BUS {DDRB = 0b11111011;  DDRD = 0b11111111;} 

#define SET_AD_IN {DDRA = 0b00000000; DDRC = 0b00000000;} 
#define SET_AD_OUT {DDRA = 0b11111111; DDRC = 0b11111111;}

#define ACT_RESET {PORTB &= 0b11111110;} 
#define DEACT_RESET {PORTB |= 0b00000001;}
#define ACT_BUSREQ {PORTB &= 0b11111101;}
#define DEACT_BUSREQ {PORTB |= 0b00000010;}
#define CHECK_BUSACK (!(PINB & 0b00000100))

#define ACT_AS {PORTD &= 0b11111011;}  
#define DEACT_AS {PORTD |= 0b00000100;}
#define SET_WORD_ACCESS {PORTD &= 0b11110111;}
#define SET_BYTE_ACCESS {PORTD |= 0b00001000;}
#define SET_READ {PORTD |= 0b00010000;}
#define SET_WRITE {PORTD &= 0b11101111;}
#define ACT_MREQ {PORTD &= 0b11011111;}
#define DEACT_MREQ {PORTD |= 0b00100000;}
#define ACT_DS {PORTD &= 0b10111111;}
#define DEACT_DS {PORTD |= 0b01000000;}

#define SET_ST_INTERNAL {PORTB &= 0b11100111; PORTD &= 0b11111100;}
#define SET_ST_SPIO {PORTB &= 0b11100111; PORTD |= 0b00000011;}
#define SET_ST_DTMEM {PORTB &= 0b11100111; PORTB |= 0b00010000; PORTD &= 0b11111100;}
#define SET_ST_INSTMEM {PORTB &= 0b11100111; PORTB |= 0b00011000; PORTD &= 0b11111100;}

#define CLOCK_L {PORTD &= 0b01111111;}
#define CLOCK_H {PORTD |= 0b10000000;}
#define INVERT_CLOCK {PIND |= 0b10000000;}
#define START_CLOCK {TCNT2 = 0; \
    TCCR2A = 0b01000011; \
    TCCR2B = 0b00001001; \
    OCR2A = 0;}
#define STOP_CLOCK {}

#endif // __Z8001_MACRO_H__