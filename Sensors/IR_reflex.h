#ifndef _IR_reflex_H_INCLUDED_
#define _IR_reflex_H_INCLUDED_

#include <delay.h>
#include <stdint.h>

#include "Micros.h"

#define numSensors  (5)

const uint8_t Line_Pins[numSensors] = { (1 << PORTC0), (1 << PORTC1), (1 << PORTC2), (1 << PORTC3), (1 << PORTC4) };
uint16_t calibratedMaximum = 0, calibratedMinimum = 1000;


void Line_read(uint16_t *lineValue)
{
    uint32_t cTime, lastTime;
    uint16_t dTime = 0;
    uint8_t  pin, lastPin, mask;
    int i;
    
    // reset the values
    for (i = 0; i < numSensors; i++)
        lineValue[i] = 0;

    for (i = 0; i < numSensors; i++)
    {
        // set all sensor pins to outputs
        DDRC |= Line_Pins[i];
    
        // drive high for 10 us
        PORTC |= Line_Pins[i];
    }
    
    delay_us(10);

    for (i = 0; i < numSensors; i++)
    {
        // set all ports to inputs
        DDRC &= ~Line_Pins[i];
  
        // turn off pull ups
        PORTC &= ~Line_Pins[i];
    }
    
    lastPin = PINC;
    lastTime = micros();
    while (dTime < 1000)
    {
        // Save a snapshot of PINC at the current time
        pin = PINC;              // PINC indicates the state of each PIN for the arduino port dealing with Ports digital pins   
        mask = pin ^ lastPin;   // doing a ^ between the current interruption and the last one indicates wich pin changed
        cTime = micros();       // micros() return a uint32_t, but it is not usefull to keep the whole bits => we keep only 16 bits
        lastPin = pin;          // we memorize the current state of all PINs [D0-D7]
        dTime = cTime - lastTime;
        
        for (i = 0; i < numSensors; i++)
        {
            if (mask & Line_Pins[i]) 
            {
                if (!(pin & Line_Pins[i])) 
                {
                    lineValue[i] = dTime;
                }
            }
        }          
    }

    for (i = 0; i < numSensors; i++)
    {
        if (!lineValue[i])
            lineValue[i] = 1000;
    }
}

void Line_autoCalib(uint16_t *lineValue)
{
    int i;
    
    // start calib from 'zero'
    if ((calibratedMaximum == 1000) || (calibratedMinimum == 0))
    {
      calibratedMaximum = 0;
      calibratedMinimum = 1000;
    }
    
    for (i = 0; i < numSensors; i++)
    {
        // set the max we found THIS time
        if(calibratedMaximum < lineValue[i])
            calibratedMaximum = lineValue[i];

        // set the min we found THIS time
        if(calibratedMinimum > lineValue[i])
            calibratedMinimum = lineValue[i];
    }  
}

void Line_readLine(uint16_t *_lineValue)
{
    uint16_t threshold;
    int i;
        
    Line_read(_lineValue);
    Line_autoCalib(_lineValue);

    for (i = 0; i < numSensors; i++)
    {
        threshold = ((calibratedMaximum - calibratedMinimum) >> 1) + calibratedMinimum;

        if (_lineValue[i] > threshold)
        {
            _lineValue[i] = 1;
        }
        else
        {
            _lineValue[i] = 0;
        } 
    }
}

#endif