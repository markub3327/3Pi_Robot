#ifndef _ADC_H_INCLUDED_
#define _ADC_H_INCLUDED_

#include <delay.h>

// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
    ADMUX = adc_input | ADC_VREF_TYPE;
    
    // Delay needed for the stabilization of the ADC input voltage
    delay_us(10);
    
    // Start the AD conversion
    ADCSRA |= (1<<ADSC);
    
    // Wait for the AD conversion to complete
    while ((ADCSRA & (1<<ADIF))==0);
    ADCSRA |= (1<<ADIF);
    
    return ADCW;
}

#endif