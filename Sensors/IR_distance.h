#ifndef _IR_distance_H_INCLUDED_
#define _IR_distance_H_INCLUDED_ 

#define  IR_OBJ_PIN1    (5)
#define  IR_OBJ_PIN2    (7)


#include "ADC.h"

void Objects_readANN(uint16_t *objValue) 
{
    uint16_t s1 = read_adc(5);    
    uint16_t s2 = read_adc(7);
    
    // blizka
    if (s1 > 266)
    {
        objValue[0] = 1;
        objValue[1] = 0;
    }            
    // ziadna
    else if (s1 < 123)
    {
        objValue[0] = 0;
        objValue[1] = 0;
    }
    else
    {
        objValue[0] = 0;
        objValue[1] = 1;
    }     
    
    /******************************/
    
    // blizka
    if (s2 > 266)
    {
        objValue[2] = 1;
        objValue[3] = 0;
    }            
    // ziadna
    else if (s2 < 123)
    {
        objValue[2] = 0;
        objValue[3] = 0;
    }
    else
    {
        objValue[2] = 0;
        objValue[3] = 1;
    }     
}                                        

#endif