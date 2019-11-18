#ifndef _MOTORS_H_INCLUDED_
#define _MOTORS_H_INCLUDED_

#include <stdbool.h>

void Motors_setSpeeds(int speedM1, int speedM2)
{
    bool reverseM1 = false, reverseM2 = false;

    if (speedM1 < 0)
    {
        speedM1 = -speedM1; // make speed a positive quantity
        reverseM1 = true;  // preserve the direction
    }
    if (speedM1 > 0xFF) // 0xFF = 255
        speedM1 = 0xFF;

    if (speedM2 < 0)
    {
        speedM2 = -speedM2; // make speed a positive quantity
        reverseM2 = true;  // preserve the direction
    }
    if (speedM2 > 0xFF) // 0xFF = 255
        speedM2 = 0xFF;

    if (reverseM1)
    {
        OCR0B = 0;    // hold one driver input high
        OCR0A = speedM1;  // pwm the other input
    }
    else  // forward
    {
        OCR0B = speedM1;  // pwm one driver input
        OCR0A = 0;    // hold the other driver input high
    }

    if (reverseM2)
    {
        OCR2B = 0;    // hold one driver input high
        OCR2A = speedM2;  // pwm the other input
    }
    else  // forward
    {
        OCR2B = speedM2;  // pwm one driver input
        OCR2A = 0;    // hold the other driver input high
    }
}

#endif