#ifndef _MICROS_H_INCLUDED_
#define _MICROS_H_INCLUDED_

#include <stdint.h>

volatile unsigned long timer0_overflow_count = 0;

unsigned long micros() 
{
    unsigned long m;
    uint8_t oldSREG = SREG, t;
    
    #asm("cli")
    m = timer0_overflow_count;
    t = TCNT0;
    if ((TIFR0 & (1<<TOV0)) && (t < 0xFF))  m++;

    SREG = oldSREG;
    
    return ((((m << 8) + t)) << 2) / 10;
}
 
#endif