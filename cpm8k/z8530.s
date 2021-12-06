!------------------------------------------------------------------------------
! z8530.s
!   Serial Communication routines for Z8530 SCC
!    
!   Copyright(c) 2020 4sun5bu 

    .equ SCCAC, 0x0005
    .equ SCCAD, 0x0007

    .global  scc_init, scc_out, scc_in, scc_status

    unsegm
    sect .text

!------------------------------------------------------------------------------
! scc_init
!   initialize Z8530 SCC
!   destroyed:  r2, r3, r4 

scc_init:
    ld      r2, #(scccmde - scccmds)    ! initialize Z8530
    ld      r3, #SCCAC
    ld      r4, #scccmds
    otirb   @r3, @r4, r2
    ret

!------------------------------------------------------------------------------
! scc_out 
!   output 1 byte to the serial port
!   input:      r5 --- Ascii code
!   destroyed:  rl0

scc_out:
    inb     rl0, #SCCAC
    andb    rl0, #0x04
    jr      z, scc_out
    outb    #SCCAD, rl5
    ret

!------------------------------------------------------------------------------
! scc_in
!   input 1 byte from the serial port
!   return:     r7 --- read data
!   destroyed:  r0, r1

scc_in:
    inb     rl0, #SCCAC
    andb    rl0, #0x01
    jr      z, scc_in 
    clr     r7
    inb     rl7, #SCCAD 
    ret

!------------------------------------------------------------------------------
! scc_status
!   return:     r7 --- 0xff:data exists, 0x00:no data
!   destroyed:  r1, r10

scc_status:
    inb     rl0, #SCCAC
    clr     r7
    andb    rl0, #0x01
    ret     z
    com     r7
    ret

!------------------------------------------------------------------------------
    sect .rdata

scccmds:
    !.byte   9, 0xc0     ! Reset
    .byte   3, 0xc0     ! Receiver disable
    .byte   5, 0xe2     ! Transmiter disable
    .byte   4, 0x44     ! x16, 1stop-bit, non-parity
    .byte   3, 0xe0     ! Receive  8bit/char 
    .byte   5, 0xe2     ! Send 8bit/char dtr rts
    .byte   11, 0x50    ! BG use for receiver and transmiter
    .byte   12, 37      ! 4800bps at 6MHz clock
    .byte   13, 00
    .byte   14, 0x02    ! PCLK for BG
    .byte   14, 0x03    ! BG enable
    .byte   3, 0xe1     ! Receiver enable
    .byte   5, 0xea     ! Transmiter enable
scccmde:
