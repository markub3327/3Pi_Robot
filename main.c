/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 3Pi Robot
Version : 1.2
Date    : 9. 9. 2018
Author  : Martin Kubovcik
Company : Robot Lab
Comments: HW: 5x IR reflexive,
              2x IR distance,
              RC receiver


Chip type               : ATmega328P
Program type            : Application
AVR Core Clock frequency: 20,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega328p.h>

#include <delay.h>
#include <stdio.h>

#include "Sensors\IR_reflex.h"
#include "Sensors\IR_distance.h"

#include "Motors.h"
#include "Micros.h"
#include "Neuron.h"
#include "ADC.h"

#define  BUTTON_PIN    (PINB)
#define  BUTTON_A      (1<<PORTB1)
#define  BUTTON_B      (1<<PORTB4)
#define  BUTTON_C      (1<<PORTB5)

#define  LED_PORT      (PORTD)
#define  LED_RED       (1<<PORTD1)
#define  LED_GREEN     (1<<PORTD7)

#define  LF_NN_M       (2)
#define  LF_NN_N       (5)

#define  OD_NN_M       (2)
#define  OD_NN_N       (4)

#define  MODE_LF       (0)
#define  MODE_LF_T     (1)
#define  MODE_OD       (2)
#define  MODE_OD_T     (3)

// Declare your global variables here

struct {
    float /*eeprom*/ Weights[LF_NN_M][LF_NN_N+1];      //  Mx(N+1) matrix (+ bias)
    float y[LF_NN_M];
    float d[LF_NN_M]; 
    uint16_t /*eeprom*/ Inputs[LF_NN_N+1];    
} LF_NN;

struct {
    float /*eeprom*/ Weights[OD_NN_M][OD_NN_N+1];      //  Mx(N+1) matrix (+ bias)
    float y[OD_NN_M];
    float d[OD_NN_M]; 
    uint16_t /*eeprom*/ Inputs[OD_NN_N+1];    
} OD_NN;

// Rx variables
#define  neutralPulseTime   1502   // 1.5 ms
#define  minPulseTime        900   // 0.9 ms
const uint8_t PCInt_RX_Pins[2] = { (1<<PORTD2), (1<<PORTD4) };
volatile uint16_t rcValue[2];
volatile int16_t  motorValue[2];

// predefined PC pin block
#define RX_PIN_CHECK(pin_pos, rc_value_pos)                        \
  if (mask & PCInt_RX_Pins[pin_pos]) {                             \
    if (!(pin & PCInt_RX_Pins[pin_pos])) {                         \
      dTime = (cTime - edgeTime[pin_pos]);                         \
      if (900<dTime && dTime<2200) {                               \
        rcValue[rc_value_pos] = dTime;                             \
      }                                                            \
      else {                                                       \
        rcValue[rc_value_pos] = 0;                                 \
      }                                                            \
    } else edgeTime[pin_pos] = cTime;                              \
  }  
  
// Pin change 16-23 interrupt service routine
interrupt [PC_INT2] void pin_change_isr2(void)
{
    static uint8_t PCintLast;
    static uint32_t edgeTime[2];
    uint16_t dTime;
  
    // Save a snapshot of PIND at the current time
    uint8_t pin = PIND;               // PIND indicates the state of each PIN for the arduino port dealing with Ports digital pins   
    uint8_t mask = pin ^ PCintLast;   // doing a ^ between the current interruption and the last one indicates wich pin changed
    uint32_t cTime = micros();        // micros() return a uint32_t, but it is not usefull to keep the whole bits => we keep only 16 bits
    #asm("sei")                       // re enable other interrupts at this point, the rest of this interrupt is not so time critical and can be interrupted safely
    PCintLast = pin;                  // we memorize the current state of all PINs [D0-D7]
  
    RX_PIN_CHECK(0,0);
    RX_PIN_CHECK(1,1);
    
    motorValue[0] = (neutralPulseTime - (long)rcValue[1]) + (neutralPulseTime - (long)rcValue[0]);
    motorValue[1] = (neutralPulseTime - (long)rcValue[1]) - (neutralPulseTime - (long)rcValue[0]);
    
    motorValue[0] = (int16_t)((((int32_t)motorValue[0]) << 8) / 2696);
    motorValue[1] = (int16_t)((((int32_t)motorValue[1]) << 8) / 2696);                                               
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    // Place your code here
    timer0_overflow_count ++;
}


// Read battery voltage level
uint16_t readBatteryMillis()
{
    uint32_t temp = read_adc(6) * 5000L;

    temp = temp >> 10;
    temp = (temp * 3) >> 1;
    
    return temp;
} 


void main(void)
{
// Declare your local variables here
uint16_t m, k, bat;
uint8_t mode = MODE_LF_T;

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=P Bit4=P Bit3=0 Bit2=T Bit1=P Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (1<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (1<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=P Bit3=0 Bit2=P Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (1<<PORTD4) | (0<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 2500,000 kHz
// Mode: Fast PWM top=0xFF
// OC0A output: Inverted PWM
// OC0B output: Inverted PWM
// Timer Period: 0,1024 ms
// Output Pulse(s):
// OC0A Period: 0,1024 ms Width: 0,1024 ms
// OC0B Period: 0,1024 ms Width: 0,1024 ms
TCCR0A=(1<<COM0A1) | (1<<COM0A0) | (1<<COM0B1) | (1<<COM0B0) | (1<<WGM01) | (1<<WGM00);
TCCR0B=(0<<WGM02) | (0<<CS02) | (1<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 2500,000 kHz
// Mode: Fast PWM top=0xFF
// OC2A output: Inverted PWM
// OC2B output: Inverted PWM
// Timer Period: 0,1024 ms
// Output Pulse(s):
// OC2A Period: 0,1024 ms Width: 0,1024 ms
// OC2B Period: 0,1024 ms Width: 0,1024 ms
ASSR=(0<<EXCLK) | (0<<AS2);
TCCR2A=(1<<COM2A1) | (1<<COM2A0) | (1<<COM2B1) | (1<<COM2B0) | (1<<WGM21) | (1<<WGM20);
TCCR2B=(0<<WGM22) | (0<<CS22) | (1<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: On
EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
EIMSK=(0<<INT1) | (0<<INT0);
PCICR=(1<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
PCMSK2=(0<<PCINT23) | (0<<PCINT22) | (0<<PCINT21) | (1<<PCINT20) | (0<<PCINT19) | (1<<PCINT18) | (0<<PCINT17) | (0<<PCINT16);
PCIFR=(1<<PCIF2) | (0<<PCIF1) | (0<<PCIF0);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART0 Mode: Asynchronous
// USART Baud Rate: 115200
UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
UBRR0H=0x00;
UBRR0L=0x0A;

// ADC initialization
// ADC Clock frequency: 625,000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: ADC Stopped
// Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
// ADC4: On, ADC5: On
DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (1<<ADPS0);
ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

// Global enable interrupts
#asm("sei")

// Init brain
Init(LF_NN.Weights[0], LF_NN_N);
Init(LF_NN.Weights[1], LF_NN_N);

Init(OD_NN.Weights[0], OD_NN_N);
Init(OD_NN.Weights[1], OD_NN_N);

// Set bias inputs
LF_NN.Inputs[LF_NN_N] = 1.0f;
OD_NN.Inputs[OD_NN_N] = 1.0f;

// Start message
printf("Pololu 3pi Robot\n\r");
printf("Line follower\n\r");  

// Wait until user push button B
while (BUTTON_PIN & BUTTON_B);
// Wait until user release button B
while (!(BUTTON_PIN & BUTTON_B));

// LED blink before start
LED_PORT |= LED_GREEN;
delay_ms(1000);
LED_PORT &= ~LED_GREEN;

// Forever loop
while (1)
      {   
          // Read line sensors
          Line_readLine(LF_NN.Inputs);
          
          // Read object sensors
          Objects_readANN(OD_NN.Inputs);
            
          // Calc output - LF
          LF_NN.y[0] = GetOutput((float *)&LF_NN.Inputs[0], LF_NN.Weights[0], LF_NN_N);
          LF_NN.y[1] = GetOutput((float *)&LF_NN.Inputs[0], LF_NN.Weights[1], LF_NN_N);
          
          // Calc output - OD
          OD_NN.y[0] = GetOutput((float *)&OD_NN.Inputs[0], OD_NN.Weights[0], OD_NN_N);
          OD_NN.y[1] = GetOutput((float *)&OD_NN.Inputs[0], OD_NN.Weights[1], OD_NN_N);
          
          switch (mode)
          {          
              // For line follower training
              case MODE_LF_T:
                  // Set motors
                  Motors_setSpeeds(motorValue[0], motorValue[1]);
              
                  for (m = 0, k = 0; m < LF_NN_M; m++)
                  {
                      // NN error
                      LF_NN.d[m] = Delta(((float)motorValue[m] / 256.0f), LF_NN.y[m]);
                                
                      // Change weights
                      if ((LF_NN.d[m] > ERR_MAX) || (LF_NN.d[m] < (-ERR_MAX)))
                      {           
                          // Bad                      
                          NewWeights(LF_NN.Weights[m], (float *)&LF_NN.Inputs[0], 0.1f, LF_NN.d[m], LF_NN_N);
                      }
                      else
                      {   
                          // Good       
                          k++;
                      }
                      
                      printf("%f;%f;", LF_NN.y[m], LF_NN.d[m]);
                  }
                  puts("\n\r");                  
                  // LED signalization
                  if (k == LF_NN_M)
                  {
                      LED_PORT |= LED_GREEN; 
                  }
                  else
                  {
                      LED_PORT &= ~LED_GREEN;
                  }
                  break;
                  
              // For object detector training    
              case MODE_OD_T:
                  // Set motors
                  Motors_setSpeeds(motorValue[0], motorValue[1]);

                  for (m = 0, k = 0; m < OD_NN_M; m++)
                  {
                      // NN error
                      OD_NN.d[m] = Delta(((float)motorValue[m] / 256.0f), OD_NN.y[m]);
                                
                      // Change weights
                      if ((OD_NN.d[m] > ERR_MAX) || (OD_NN.d[m] < (-ERR_MAX)))
                      {           
                          // Bad                      
                          NewWeights(OD_NN.Weights[m], (float *)&OD_NN.Inputs[0], 0.1f, OD_NN.d[m], OD_NN_N);
                      }
                      else
                      {   
                          // Good       
                          k++;
                      }
                      
                      printf("%f;%f;", OD_NN.y[m], OD_NN.d[m]);
                  }
                  puts("\n\r");
                  // LED signalization
                  if (k == OD_NN_M)
                  {
                      LED_PORT |= LED_GREEN; 
                  }
                  else
                  {
                      LED_PORT &= ~LED_GREEN;
                  }
                  break;  

              // Automatic mode line follower                  
              case MODE_LF:
                  // Set motors
                  Motors_setSpeeds((LF_NN.y[0] * 256.0f), (LF_NN.y[1] * 256.0f));
                  break;
                  
              // Automatic mode object detector                  
              case MODE_OD:
                  // Set motors
                  Motors_setSpeeds((OD_NN.y[0] * 256.0f), (OD_NN.y[1] * 256.0f));
                  break;
          }
                              
                    
          // Read battery level
          bat = readBatteryMillis();
         
          // Create log message
          printf("%d;%d;%d;%d\n\r", OD_NN.Inputs[0], OD_NN.Inputs[1], OD_NN.Inputs[2], OD_NN.Inputs[3]);
          printf("%d;%d;%d;%d;%d;%d;%d;%d\n\r", LF_NN.Inputs[0], LF_NN.Inputs[1], LF_NN.Inputs[2], LF_NN.Inputs[3], LF_NN.Inputs[4], motorValue[0], motorValue[1], bat);

          // if user push button A   - mode LF/LF_T
          if (!(BUTTON_PIN & BUTTON_A))
          {
              // Wait until user release button A
              while (!(BUTTON_PIN & BUTTON_A));
              
              if (mode == MODE_LF)         mode = MODE_LF_T;
              else if (mode == MODE_LF_T)  mode = MODE_LF;
              else                         mode = MODE_LF_T;
          }

          // if user push button B  - mode OD/OD_T
          if (!(BUTTON_PIN & BUTTON_B))
          {
              // Wait until user release button B
              while (!(BUTTON_PIN & BUTTON_B));
              
              if (mode == MODE_OD)         mode = MODE_OD_T;
              else if (mode == MODE_OD_T)  mode = MODE_OD;
              else                         mode = MODE_OD_T;
          }          
      }
}
                                                                  