
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 20,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _calibratedMaximum=R3
	.DEF _calibratedMaximum_msb=R4
	.DEF _calibratedMinimum=R5
	.DEF _calibratedMinimum_msb=R6

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _pin_change_isr2
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_Line_Pins:
	.DB  0x1,0x2,0x4,0x8,0x10
_PCInt_RX_Pins:
	.DB  0x4,0x10

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0xE8,0x3

_0x0:
	.DB  0x50,0x6F,0x6C,0x6F,0x6C,0x75,0x20,0x33
	.DB  0x70,0x69,0x20,0x52,0x6F,0x62,0x6F,0x74
	.DB  0xA,0xD,0x0,0x4C,0x69,0x6E,0x65,0x20
	.DB  0x66,0x6F,0x6C,0x6C,0x6F,0x77,0x65,0x72
	.DB  0xA,0xD,0x0,0x25,0x66,0x3B,0x25,0x66
	.DB  0x3B,0x0,0x25,0x64,0x3B,0x25,0x64,0x3B
	.DB  0x25,0x64,0x3B,0x25,0x64,0xA,0xD,0x0
	.DB  0x25,0x64,0x3B,0x25,0x64,0x3B,0x25,0x64
	.DB  0x3B,0x25,0x64,0x3B,0x25,0x64,0x3B,0x25
	.DB  0x64,0x3B,0x25,0x64,0x3B,0x25,0x64,0xA
	.DB  0xD,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x03
	.DW  __REG_VARS*2

	.DW  0x03
	.DW  _0x66
	.DW  _0x0*2+16

	.DW  0x03
	.DW  _0x66+3
	.DW  _0x0*2+16

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : 3Pi Robot
;Version : 1.2
;Date    : 9. 9. 2018
;Author  : Martin Horvath
;Company : Robot Lab
;Comments: HW: 5x IR reflexive,
;              2x IR distance,
;              RC receiver
;
;
;Chip type               : ATmega328P
;Program type            : Application
;AVR Core Clock frequency: 20,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;
;#include <delay.h>
;#include <stdio.h>
;
;#include "Sensors\IR_reflex.h"

	.CSEG
_micros:
; .FSTART _micros
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	m -> Y+2
;	oldSREG -> R17
;	t -> R16
	IN   R17,63
	cli
	LDS  R30,_timer0_overflow_count
	LDS  R31,_timer0_overflow_count+1
	LDS  R22,_timer0_overflow_count+2
	LDS  R23,_timer0_overflow_count+3
	CALL SUBOPT_0x0
	IN   R16,38
	SBIS 0x15,0
	RJMP _0x4
	CPI  R16,255
	BRLO _0x5
_0x4:
	RJMP _0x3
_0x5:
	CALL SUBOPT_0x1
	__SUBD1N -1
	CALL SUBOPT_0x0
_0x3:
	OUT  0x3F,R17
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
	MOV  R30,R16
	LDI  R31,0
	CALL __CWD1
	CALL __ADDD21
	LDI  R30,LOW(2)
	CALL __LSLD12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0xA
	CALL __DIVD21U
	RJMP _0x20A000B
; .FEND
_Line_read:
; .FSTART _Line_read
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,10
	CALL __SAVELOCR6
;	*lineValue -> Y+16
;	cTime -> Y+12
;	lastTime -> Y+8
;	dTime -> R16,R17
;	pin -> R19
;	lastPin -> R18
;	mask -> R21
;	i -> Y+6
	__GETWRN 16,17,0
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x7:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,5
	BRGE _0x8
	CALL SUBOPT_0x4
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	RJMP _0x7
_0x8:
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0xA:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,5
	BRGE _0xB
	CALL SUBOPT_0x7
	OR   R30,R26
	CALL SUBOPT_0x8
	OR   R30,R26
	OUT  0x8,R30
	CALL SUBOPT_0x6
	RJMP _0xA
_0xB:
	__DELAY_USB 67
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0xD:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,5
	BRGE _0xE
	CALL SUBOPT_0x7
	COM  R30
	AND  R30,R26
	CALL SUBOPT_0x8
	COM  R30
	AND  R30,R26
	OUT  0x8,R30
	CALL SUBOPT_0x6
	RJMP _0xD
_0xE:
	IN   R18,6
	RCALL _micros
	__PUTD1S 8
_0xF:
	__CPWRN 16,17,1000
	BRSH _0x11
	IN   R19,6
	MOV  R30,R18
	EOR  R30,R19
	MOV  R21,R30
	RCALL _micros
	CALL SUBOPT_0x9
	MOV  R18,R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x13:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,5
	BRGE _0x14
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUBI R30,LOW(-_Line_Pins*2)
	SBCI R31,HIGH(-_Line_Pins*2)
	LPM  R30,Z
	AND  R30,R21
	BREQ _0x15
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUBI R30,LOW(-_Line_Pins*2)
	SBCI R31,HIGH(-_Line_Pins*2)
	LPM  R30,Z
	AND  R30,R19
	BRNE _0x16
	CALL SUBOPT_0x4
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R16
	STD  Z+1,R17
_0x16:
_0x15:
	CALL SUBOPT_0x6
	RJMP _0x13
_0x14:
	RJMP _0xF
_0x11:
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x18:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,5
	BRGE _0x19
	CALL SUBOPT_0x4
	CALL SUBOPT_0xA
	SBIW R30,0
	BRNE _0x1A
	CALL SUBOPT_0x4
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   X+,R30
	ST   X,R31
_0x1A:
	CALL SUBOPT_0x6
	RJMP _0x18
_0x19:
	CALL __LOADLOCR6
	ADIW R28,18
	RET
; .FEND
_Line_autoCalib:
; .FSTART _Line_autoCalib
	CALL SUBOPT_0xB
;	*lineValue -> Y+2
;	i -> R16,R17
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CP   R30,R3
	CPC  R31,R4
	BREQ _0x1C
	CLR  R0
	CP   R0,R5
	CPC  R0,R6
	BRNE _0x1B
_0x1C:
	CLR  R3
	CLR  R4
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	__PUTW1R 5,6
_0x1B:
	__GETWRN 16,17,0
_0x1F:
	__CPWRN 16,17,5
	BRGE _0x20
	CALL SUBOPT_0xC
	CALL SUBOPT_0xA
	CP   R3,R30
	CPC  R4,R31
	BRSH _0x21
	CALL SUBOPT_0xC
	ADD  R26,R30
	ADC  R27,R31
	LD   R3,X+
	LD   R4,X
_0x21:
	CALL SUBOPT_0xC
	CALL SUBOPT_0xA
	CP   R30,R5
	CPC  R31,R6
	BRSH _0x22
	CALL SUBOPT_0xC
	ADD  R26,R30
	ADC  R27,R31
	LD   R5,X+
	LD   R6,X
_0x22:
	__ADDWRN 16,17,1
	RJMP _0x1F
_0x20:
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A000A
; .FEND
_Line_readLine:
; .FSTART _Line_readLine
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	*_lineValue -> Y+4
;	threshold -> R16,R17
;	i -> R18,R19
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _Line_read
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _Line_autoCalib
	__GETWRN 18,19,0
_0x24:
	__CPWRN 18,19,5
	BRGE _0x25
	__GETW2R 3,4
	SUB  R26,R5
	SBC  R27,R6
	MOVW R30,R26
	LSR  R31
	ROR  R30
	ADD  R30,R5
	ADC  R31,R6
	MOVW R16,R30
	CALL SUBOPT_0xD
	CALL SUBOPT_0xA
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x26
	CALL SUBOPT_0xD
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x86
_0x26:
	CALL SUBOPT_0xD
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x86:
	ST   X+,R30
	ST   X,R31
	__ADDWRN 18,19,1
	RJMP _0x24
_0x25:
	CALL __LOADLOCR4
	RJMP _0x20A000C
; .FEND
;#include "Sensors\IR_distance.h"
_read_adc:
; .FSTART _read_adc
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	STS  124,R30
	__DELAY_USB 67
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
_0x28:
	LDS  R30,122
	ANDI R30,LOW(0x10)
	BREQ _0x28
	LDS  R30,122
	ORI  R30,0x10
	STS  122,R30
	LDS  R30,120
	LDS  R31,120+1
	JMP  _0x20A0009
; .FEND
_Objects_readANN:
; .FSTART _Objects_readANN
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	*objValue -> Y+4
;	s1 -> R16,R17
;	s2 -> R18,R19
	LDI  R26,LOW(5)
	RCALL _read_adc
	MOVW R16,R30
	LDI  R26,LOW(7)
	RCALL _read_adc
	MOVW R18,R30
	__CPWRN 16,17,267
	BRLO _0x2B
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0xE
	ADIW R26,2
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x87
_0x2B:
	__CPWRN 16,17,123
	BRSH _0x2D
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x5
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,2
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x87
_0x2D:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x5
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,2
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x87:
	ST   X+,R30
	ST   X,R31
	__CPWRN 18,19,267
	BRLO _0x2F
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,4
	CALL SUBOPT_0xE
	ADIW R26,6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x88
_0x2F:
	__CPWRN 18,19,123
	BRSH _0x31
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,4
	CALL SUBOPT_0x5
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x88
_0x31:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,4
	CALL SUBOPT_0x5
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,6
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x88:
	ST   X+,R30
	ST   X,R31
	CALL __LOADLOCR4
	RJMP _0x20A000C
; .FEND
;
;#include "Motors.h"
_Motors_setSpeeds:
; .FSTART _Motors_setSpeeds
	CALL SUBOPT_0xB
;	speedM1 -> Y+4
;	speedM2 -> Y+2
;	reverseM1 -> R17
;	reverseM2 -> R16
	LDI  R17,0
	LDI  R16,0
	LDD  R26,Y+5
	TST  R26
	BRPL _0x33
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL __ANEGW1
	STD  Y+4,R30
	STD  Y+4+1,R31
	LDI  R17,LOW(1)
_0x33:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x34
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+4,R30
	STD  Y+4+1,R31
_0x34:
	LDD  R26,Y+3
	TST  R26
	BRPL _0x35
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL __ANEGW1
	STD  Y+2,R30
	STD  Y+2+1,R31
	LDI  R16,LOW(1)
_0x35:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x36
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+2,R30
	STD  Y+2+1,R31
_0x36:
	CPI  R17,0
	BREQ _0x37
	LDI  R30,LOW(0)
	OUT  0x28,R30
	LDD  R30,Y+4
	RJMP _0x89
_0x37:
	LDD  R30,Y+4
	OUT  0x28,R30
	LDI  R30,LOW(0)
_0x89:
	OUT  0x27,R30
	CPI  R16,0
	BREQ _0x39
	LDI  R30,LOW(0)
	STS  180,R30
	LDD  R30,Y+2
	RJMP _0x8A
_0x39:
	LDD  R30,Y+2
	STS  180,R30
	LDI  R30,LOW(0)
_0x8A:
	STS  179,R30
	RJMP _0x20A000B
; .FEND
;#include "Micros.h"
;#include "Neuron.h"
_Init:
; .FSTART _Init
	CALL SUBOPT_0xB
;	*Weights -> Y+4
;	N -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x3C:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x3D
	MOVW R30,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0xF
	PUSH R31
	PUSH R30
	CALL _rand
	CALL SUBOPT_0x10
	__GETD1N 0x46FFFE00
	CALL __DIVF21
	POP  R26
	POP  R27
	CALL __PUTDP1
	__ADDWRN 16,17,1
	RJMP _0x3C
_0x3D:
_0x20A000B:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A000C:
	ADIW R28,6
	RET
; .FEND
_GetOutput:
; .FSTART _GetOutput
	CALL SUBOPT_0x11
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
;	*Inputs -> Y+10
;	*Weights -> Y+8
;	N -> Y+6
;	y -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x3F:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x40
	MOVW R30,R16
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	CALL SUBOPT_0x2
	CALL __ADDF12
	CALL SUBOPT_0x0
	__ADDWRN 16,17,1
	RJMP _0x3F
_0x40:
	CALL SUBOPT_0x2
	CALL _tanh
	CALL SUBOPT_0x13
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,12
	RET
; .FEND
_NewWeights:
; .FSTART _NewWeights
	CALL SUBOPT_0xB
;	*Weights -> Y+14
;	*Inputs -> Y+12
;	ni -> Y+8
;	delta -> Y+4
;	N -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x42:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x43
	MOVW R30,R16
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0xF
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x14
	__GETD2S 8
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __PUTDP1
	__ADDWRN 16,17,1
	RJMP _0x42
_0x43:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20A0007
; .FEND
;#include "ADC.h"
;
;#define  BUTTON_PIN    (PINB)
;#define  BUTTON_A      (1<<PORTB1)
;#define  BUTTON_B      (1<<PORTB4)
;#define  BUTTON_C      (1<<PORTB5)
;
;#define  LED_PORT      (PORTD)
;#define  LED_RED       (1<<PORTD1)
;#define  LED_GREEN     (1<<PORTD7)
;
;#define  LF_NN_M       (2)
;#define  LF_NN_N       (5)
;
;#define  OD_NN_M       (2)
;#define  OD_NN_N       (4)
;
;#define  MODE_LF       (0)
;#define  MODE_LF_T     (1)
;#define  MODE_OD       (2)
;#define  MODE_OD_T     (3)
;
;// Declare your global variables here
;
;struct {
;    float /*eeprom*/ Weights[LF_NN_M][LF_NN_N+1];      //  Mx(N+1) matrix (+ bias)
;    float y[LF_NN_M];
;    float d[LF_NN_M];
;    uint16_t /*eeprom*/ Inputs[LF_NN_N+1];
;} LF_NN;
;
;struct {
;    float /*eeprom*/ Weights[OD_NN_M][OD_NN_N+1];      //  Mx(N+1) matrix (+ bias)
;    float y[OD_NN_M];
;    float d[OD_NN_M];
;    uint16_t /*eeprom*/ Inputs[OD_NN_N+1];
;} OD_NN;
;
;// Rx variables
;#define  neutralPulseTime   1502   // 1.5 ms
;#define  minPulseTime        900   // 0.9 ms
;const uint8_t PCInt_RX_Pins[2] = { (1<<PORTD2), (1<<PORTD4) };
;volatile uint16_t rcValue[2];
;volatile int16_t  motorValue[2];
;
;// predefined PC pin block
;#define RX_PIN_CHECK(pin_pos, rc_value_pos)                        \
;  if (mask & PCInt_RX_Pins[pin_pos]) {                             \
;    if (!(pin & PCInt_RX_Pins[pin_pos])) {                         \
;      dTime = (cTime - edgeTime[pin_pos]);                         \
;      if (900<dTime && dTime<2200) {                               \
;        rcValue[rc_value_pos] = dTime;                             \
;      }                                                            \
;      else {                                                       \
;        rcValue[rc_value_pos] = 0;                                 \
;      }                                                            \
;    } else edgeTime[pin_pos] = cTime;                              \
;  }
;
;// Pin change 16-23 interrupt service routine
;interrupt [PC_INT2] void pin_change_isr2(void)
; 0000 0062 {
_pin_change_isr2:
; .FSTART _pin_change_isr2
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0063     static uint8_t PCintLast;
; 0000 0064     static uint32_t edgeTime[2];
; 0000 0065     uint16_t dTime;
; 0000 0066 
; 0000 0067     // Save a snapshot of PIND at the current time
; 0000 0068     uint8_t pin = PIND;               // PIND indicates the state of each PIN for the arduino port dealing with Ports di ...
; 0000 0069     uint8_t mask = pin ^ PCintLast;   // doing a ^ between the current interruption and the last one indicates wich pin  ...
; 0000 006A     uint32_t cTime = micros();        // micros() return a uint32_t, but it is not usefull to keep the whole bits => we  ...
; 0000 006B     #asm("sei")                       // re enable other interrupts at this point, the rest of this interrupt is not so  ...
	SBIW R28,4
	CALL __SAVELOCR4
;	dTime -> R16,R17
;	pin -> R19
;	mask -> R18
;	cTime -> Y+4
	IN   R19,9
	LDS  R30,_PCintLast_S000000A000
	EOR  R30,R19
	MOV  R18,R30
	RCALL _micros
	CALL SUBOPT_0x15
	sei
; 0000 006C     PCintLast = pin;                  // we memorize the current state of all PINs [D0-D7]
	STS  _PCintLast_S000000A000,R19
; 0000 006D 
; 0000 006E     RX_PIN_CHECK(0,0);
	LDI  R30,LOW(_PCInt_RX_Pins*2)
	LDI  R31,HIGH(_PCInt_RX_Pins*2)
	LPM  R30,Z
	AND  R30,R18
	BREQ _0x44
	LDI  R30,LOW(_PCInt_RX_Pins*2)
	LDI  R31,HIGH(_PCInt_RX_Pins*2)
	LPM  R30,Z
	AND  R30,R19
	BRNE _0x45
	LDS  R26,_edgeTime_S000000A000
	LDS  R27,_edgeTime_S000000A000+1
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
	__CPWRN 16,17,901
	BRLO _0x47
	__CPWRN 16,17,2200
	BRLO _0x48
_0x47:
	RJMP _0x46
_0x48:
	__PUTWMRN _rcValue,0,16,17
	RJMP _0x49
_0x46:
	LDI  R30,LOW(0)
	STS  _rcValue,R30
	STS  _rcValue+1,R30
_0x49:
	RJMP _0x4A
_0x45:
	CALL SUBOPT_0x14
	STS  _edgeTime_S000000A000,R30
	STS  _edgeTime_S000000A000+1,R31
	STS  _edgeTime_S000000A000+2,R22
	STS  _edgeTime_S000000A000+3,R23
_0x4A:
_0x44:
; 0000 006F     RX_PIN_CHECK(1,1);
	__POINTW1FN _PCInt_RX_Pins,1
	LPM  R30,Z
	AND  R30,R18
	BREQ _0x4B
	__POINTW1FN _PCInt_RX_Pins,1
	LPM  R30,Z
	AND  R30,R19
	BRNE _0x4C
	__GETW1MN _edgeTime_S000000A000,4
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SUB  R26,R30
	SBC  R27,R31
	MOVW R16,R26
	__CPWRN 16,17,901
	BRLO _0x4E
	__CPWRN 16,17,2200
	BRLO _0x4F
_0x4E:
	RJMP _0x4D
_0x4F:
	__POINTW1MN _rcValue,2
	ST   Z,R16
	STD  Z+1,R17
	RJMP _0x50
_0x4D:
	__POINTW1MN _rcValue,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
_0x50:
	RJMP _0x51
_0x4C:
	CALL SUBOPT_0x14
	__PUTD1MN _edgeTime_S000000A000,4
_0x51:
_0x4B:
; 0000 0070 
; 0000 0071     motorValue[0] = (neutralPulseTime - (long)rcValue[1]) + (neutralPulseTime - (long)rcValue[0]);
	CALL SUBOPT_0x16
	ADD  R30,R0
	ADC  R31,R1
	STS  _motorValue,R30
	STS  _motorValue+1,R31
; 0000 0072     motorValue[1] = (neutralPulseTime - (long)rcValue[1]) - (neutralPulseTime - (long)rcValue[0]);
	CALL SUBOPT_0x16
	MOVW R26,R30
	MOVW R30,R0
	SUB  R30,R26
	SBC  R31,R27
	__PUTW1MN _motorValue,2
; 0000 0073 
; 0000 0074     motorValue[0] = (int16_t)((((int32_t)motorValue[0]) << 8) / 2696);
	LDS  R26,_motorValue
	LDS  R27,_motorValue+1
	CALL __CWD2
	CALL SUBOPT_0x3
	CALL SUBOPT_0x17
	STS  _motorValue,R30
	STS  _motorValue+1,R31
; 0000 0075     motorValue[1] = (int16_t)((((int32_t)motorValue[1]) << 8) / 2696);
	CALL SUBOPT_0x18
	CALL __CWD2
	CALL SUBOPT_0x3
	CALL SUBOPT_0x17
	__PUTW1MN _motorValue,2
; 0000 0076 }
	CALL __LOADLOCR4
	ADIW R28,8
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 007A {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 007B     // Place your code here
; 0000 007C     timer0_overflow_count ++;
	LDI  R26,LOW(_timer0_overflow_count)
	LDI  R27,HIGH(_timer0_overflow_count)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 007D }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
; .FEND
;
;
;// Read battery voltage level
;uint16_t readBatteryMillis()
; 0000 0082 {
_readBatteryMillis:
; .FSTART _readBatteryMillis
; 0000 0083     uint32_t temp = read_adc(6) * 5000L;
; 0000 0084 
; 0000 0085     temp = temp >> 10;
	SBIW R28,4
;	temp -> Y+0
	LDI  R26,LOW(6)
	RCALL _read_adc
	CLR  R22
	CLR  R23
	__GETD2N 0x1388
	CALL __MULD12U
	CALL SUBOPT_0x19
	CALL __GETD2S0
	LDI  R30,LOW(10)
	CALL __LSRD12
	CALL SUBOPT_0x19
; 0000 0086     temp = (temp * 3) >> 1;
	CALL SUBOPT_0x1A
	__GETD2N 0x3
	CALL __MULD12U
	CALL __LSRD1
	CALL SUBOPT_0x19
; 0000 0087 
; 0000 0088     return temp;
	LD   R30,Y
	LDD  R31,Y+1
_0x20A000A:
	ADIW R28,4
	RET
; 0000 0089 }
; .FEND
;
;
;void main(void)
; 0000 008D {
_main:
; .FSTART _main
; 0000 008E // Declare your local variables here
; 0000 008F uint16_t m, k, bat;
; 0000 0090 uint8_t mode = MODE_LF_T;
; 0000 0091 
; 0000 0092 // Crystal Oscillator division factor: 1
; 0000 0093 #pragma optsize-
; 0000 0094 CLKPR=(1<<CLKPCE);
	SBIW R28,1
	LDI  R30,LOW(1)
	ST   Y,R30
;	m -> R16,R17
;	k -> R18,R19
;	bat -> R20,R21
;	mode -> Y+0
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0095 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0096 #ifdef _OPTIMIZE_SIZE_
; 0000 0097 #pragma optsize+
; 0000 0098 #endif
; 0000 0099 
; 0000 009A // Input/Output Ports initialization
; 0000 009B // Port B initialization
; 0000 009C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 009D DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(8)
	OUT  0x4,R30
; 0000 009E // State: Bit7=T Bit6=T Bit5=P Bit4=P Bit3=0 Bit2=T Bit1=P Bit0=T
; 0000 009F PORTB=(0<<PORTB7) | (0<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (1<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(50)
	OUT  0x5,R30
; 0000 00A0 
; 0000 00A1 // Port C initialization
; 0000 00A2 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00A3 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 00A4 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00A5 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x8,R30
; 0000 00A6 
; 0000 00A7 // Port D initialization
; 0000 00A8 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 00A9 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (1<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(232)
	OUT  0xA,R30
; 0000 00AA // State: Bit7=0 Bit6=0 Bit5=0 Bit4=P Bit3=0 Bit2=P Bit1=T Bit0=T
; 0000 00AB PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (1<<PORTD4) | (0<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(20)
	OUT  0xB,R30
; 0000 00AC 
; 0000 00AD // Timer/Counter 0 initialization
; 0000 00AE // Clock source: System Clock
; 0000 00AF // Clock value: 2500,000 kHz
; 0000 00B0 // Mode: Fast PWM top=0xFF
; 0000 00B1 // OC0A output: Inverted PWM
; 0000 00B2 // OC0B output: Inverted PWM
; 0000 00B3 // Timer Period: 0,1024 ms
; 0000 00B4 // Output Pulse(s):
; 0000 00B5 // OC0A Period: 0,1024 ms Width: 0,1024 ms
; 0000 00B6 // OC0B Period: 0,1024 ms Width: 0,1024 ms
; 0000 00B7 TCCR0A=(1<<COM0A1) | (1<<COM0A0) | (1<<COM0B1) | (1<<COM0B0) | (1<<WGM01) | (1<<WGM00);
	LDI  R30,LOW(243)
	OUT  0x24,R30
; 0000 00B8 TCCR0B=(0<<WGM02) | (0<<CS02) | (1<<CS01) | (0<<CS00);
	LDI  R30,LOW(2)
	OUT  0x25,R30
; 0000 00B9 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00BA OCR0A=0x00;
	OUT  0x27,R30
; 0000 00BB OCR0B=0x00;
	OUT  0x28,R30
; 0000 00BC 
; 0000 00BD // Timer/Counter 2 initialization
; 0000 00BE // Clock source: System Clock
; 0000 00BF // Clock value: 2500,000 kHz
; 0000 00C0 // Mode: Fast PWM top=0xFF
; 0000 00C1 // OC2A output: Inverted PWM
; 0000 00C2 // OC2B output: Inverted PWM
; 0000 00C3 // Timer Period: 0,1024 ms
; 0000 00C4 // Output Pulse(s):
; 0000 00C5 // OC2A Period: 0,1024 ms Width: 0,1024 ms// OC2B Period: 0,1024 ms Width: 0,1024 ms
; 0000 00C6 ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 00C7 TCCR2A=(1<<COM2A1) | (1<<COM2A0) | (1<<COM2B1) | (1<<COM2B0) | (1<<WGM21) | (1<<WGM20);
	LDI  R30,LOW(243)
	STS  176,R30
; 0000 00C8 TCCR2B=(0<<WGM22) | (0<<CS22) | (1<<CS21) | (0<<CS20);
	LDI  R30,LOW(2)
	STS  177,R30
; 0000 00C9 TCNT2=0x00;
	LDI  R30,LOW(0)
	STS  178,R30
; 0000 00CA OCR2A=0x00;
	STS  179,R30
; 0000 00CB OCR2B=0x00;
	STS  180,R30
; 0000 00CC 
; 0000 00CD // Timer/Counter 0 Interrupt(s) initialization
; 0000 00CE TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 00CF 
; 0000 00D0 // External Interrupt(s) initialization
; 0000 00D1 // INT0: Off
; 0000 00D2 // INT1: Off
; 0000 00D3 // Interrupt on any change on pins PCINT0-7: Off
; 0000 00D4 // Interrupt on any change on pins PCINT8-14: Off
; 0000 00D5 // Interrupt on any change on pins PCINT16-23: On
; 0000 00D6 EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	STS  105,R30
; 0000 00D7 EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 00D8 PCICR=(1<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	LDI  R30,LOW(4)
	STS  104,R30
; 0000 00D9 PCMSK2=(0<<PCINT23) | (0<<PCINT22) | (0<<PCINT21) | (1<<PCINT20) | (0<<PCINT19) | (1<<PCINT18) | (0<<PCINT17) | (0<<PCIN ...
	LDI  R30,LOW(20)
	STS  109,R30
; 0000 00DA PCIFR=(1<<PCIF2) | (0<<PCIF1) | (0<<PCIF0);
	LDI  R30,LOW(4)
	OUT  0x1B,R30
; 0000 00DB 
; 0000 00DC // USART initialization
; 0000 00DD // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00DE // USART Receiver: On
; 0000 00DF // USART Transmitter: On
; 0000 00E0 // USART0 Mode: Asynchronous
; 0000 00E1 // USART Baud Rate: 115200
; 0000 00E2 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	LDI  R30,LOW(0)
	STS  192,R30
; 0000 00E3 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	STS  193,R30
; 0000 00E4 UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 00E5 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 00E6 UBRR0L=0x0A;
	LDI  R30,LOW(10)
	STS  196,R30
; 0000 00E7 
; 0000 00E8 // ADC initialization
; 0000 00E9 // ADC Clock frequency: 625,000 kHz
; 0000 00EA // ADC Voltage Reference: AVCC pin
; 0000 00EB // ADC Auto Trigger Source: ADC Stopped
; 0000 00EC // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 00ED // ADC4: On, ADC5: On
; 0000 00EE DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
	LDI  R30,LOW(0)
	STS  126,R30
; 0000 00EF ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	STS  124,R30
; 0000 00F0 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(133)
	STS  122,R30
; 0000 00F1 ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 00F2 
; 0000 00F3 // Global enable interrupts
; 0000 00F4 #asm("sei")
	sei
; 0000 00F5 
; 0000 00F6 // Init brain
; 0000 00F7 Init(LF_NN.Weights[0], LF_NN_N);
	CALL SUBOPT_0x1B
	RCALL _Init
; 0000 00F8 Init(LF_NN.Weights[1], LF_NN_N);
	CALL SUBOPT_0x1C
	RCALL _Init
; 0000 00F9 
; 0000 00FA Init(OD_NN.Weights[0], OD_NN_N);
	CALL SUBOPT_0x1D
	RCALL _Init
; 0000 00FB Init(OD_NN.Weights[1], OD_NN_N);
	CALL SUBOPT_0x1E
	RCALL _Init
; 0000 00FC 
; 0000 00FD // Set bias inputs
; 0000 00FE LF_NN.Inputs[LF_NN_N] = 1.0f;
	__POINTW1MN _LF_NN,74
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 00FF OD_NN.Inputs[OD_NN_N] = 1.0f;
	__POINTW1MN _OD_NN,64
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0100 
; 0000 0101 // Start message
; 0000 0102 printf("Pololu 3pi Robot\n\r");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x1F
; 0000 0103 printf("Line follower\n\r");
	__POINTW1FN _0x0,19
	CALL SUBOPT_0x1F
; 0000 0104 
; 0000 0105 // Wait until user push button B
; 0000 0106 while (BUTTON_PIN & BUTTON_B);
_0x52:
	SBIC 0x3,4
	RJMP _0x52
; 0000 0107 // Wait until user release button B
; 0000 0108 while (!(BUTTON_PIN & BUTTON_B));
_0x55:
	SBIS 0x3,4
	RJMP _0x55
; 0000 0109 
; 0000 010A // LED blink before start
; 0000 010B LED_PORT |= LED_GREEN;
	SBI  0xB,7
; 0000 010C delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 010D LED_PORT &= ~LED_GREEN;
	CBI  0xB,7
; 0000 010E 
; 0000 010F // Forever loop
; 0000 0110 while (1)
_0x58:
; 0000 0111       {
; 0000 0112           // Read line sensors
; 0000 0113           Line_readLine(LF_NN.Inputs);
	__POINTW2MN _LF_NN,64
	RCALL _Line_readLine
; 0000 0114 
; 0000 0115           // Read object sensors
; 0000 0116           Objects_readANN(OD_NN.Inputs);
	__POINTW2MN _OD_NN,56
	RCALL _Objects_readANN
; 0000 0117 
; 0000 0118           // Calc output - LF
; 0000 0119           LF_NN.y[0] = GetOutput((float *)&LF_NN.Inputs[0], LF_NN.Weights[0], LF_NN_N);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1B
	RCALL _GetOutput
	__PUTD1MN _LF_NN,48
; 0000 011A           LF_NN.y[1] = GetOutput((float *)&LF_NN.Inputs[0], LF_NN.Weights[1], LF_NN_N);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1C
	RCALL _GetOutput
	__PUTD1MN _LF_NN,52
; 0000 011B 
; 0000 011C           // Calc output - OD
; 0000 011D           OD_NN.y[0] = GetOutput((float *)&OD_NN.Inputs[0], OD_NN.Weights[0], OD_NN_N);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1D
	RCALL _GetOutput
	__PUTD1MN _OD_NN,40
; 0000 011E           OD_NN.y[1] = GetOutput((float *)&OD_NN.Inputs[0], OD_NN.Weights[1], OD_NN_N);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1E
	RCALL _GetOutput
	__PUTD1MN _OD_NN,44
; 0000 011F 
; 0000 0120           switch (mode)
	LD   R30,Y
	LDI  R31,0
; 0000 0121           {
; 0000 0122               // For line follower training
; 0000 0123               case MODE_LF_T:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x5E
; 0000 0124                   // Set motors
; 0000 0125                   Motors_setSpeeds(motorValue[0], motorValue[1]);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
; 0000 0126 
; 0000 0127                   for (m = 0, k = 0; m < LF_NN_M; m++)
_0x60:
	__CPWRN 16,17,2
	BRLO PC+2
	RJMP _0x61
; 0000 0128                   {
; 0000 0129                       // NN error
; 0000 012A                       LF_NN.d[m] = Delta(((float)motorValue[m] / 256.0f), LF_NN.y[m]);
	__POINTW2MN _LF_NN,56
	MOVW R30,R16
	CALL SUBOPT_0xF
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x24
	CALL SUBOPT_0x10
	CALL SUBOPT_0x25
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__POINTW2MN _LF_NN,48
	MOVW R30,R16
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x26
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 012B 
; 0000 012C                       // Change weights
; 0000 012D                       if ((LF_NN.d[m] > ERR_MAX) || (LF_NN.d[m] < (-ERR_MAX)))
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
	BREQ PC+3
	BRCS PC+2
	RJMP _0x63
	CALL SUBOPT_0x27
	CALL SUBOPT_0x29
	BRSH _0x62
_0x63:
; 0000 012E                       {
; 0000 012F                           // Bad
; 0000 0130                           NewWeights(LF_NN.Weights[m], (float *)&LF_NN.Inputs[0], 0.1f, LF_NN.d[m], LF_NN_N);
	__MULBNWRU 16,17,24
	SUBI R30,LOW(-_LF_NN)
	SBCI R31,HIGH(-_LF_NN)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x20
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x27
	CALL __PUTPARD1
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _NewWeights
; 0000 0131                       }
; 0000 0132                       else
	RJMP _0x65
_0x62:
; 0000 0133                       {
; 0000 0134                           // Good
; 0000 0135                           k++;
	__ADDWRN 18,19,1
; 0000 0136                       }
_0x65:
; 0000 0137 
; 0000 0138                       printf("%f;%f;", LF_NN.y[m], LF_NN.d[m]);
	__POINTW1FN _0x0,35
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _LF_NN,48
	MOVW R30,R16
	CALL SUBOPT_0x12
	CALL __PUTPARD1
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2B
; 0000 0139                   }
	__ADDWRN 16,17,1
	RJMP _0x60
_0x61:
; 0000 013A                   puts("\n\r");
	__POINTW2MN _0x66,0
	CALL SUBOPT_0x2C
; 0000 013B                   // LED signalization
; 0000 013C                   if (k == LF_NN_M)
	BRNE _0x67
; 0000 013D                   {
; 0000 013E                       LED_PORT |= LED_GREEN;
	SBI  0xB,7
; 0000 013F                   }
; 0000 0140                   else
	RJMP _0x68
_0x67:
; 0000 0141                   {
; 0000 0142                       LED_PORT &= ~LED_GREEN;
	CBI  0xB,7
; 0000 0143                   }
_0x68:
; 0000 0144                   break;
	RJMP _0x5D
; 0000 0145 
; 0000 0146               // For object detector training
; 0000 0147               case MODE_OD_T:
_0x5E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x69
; 0000 0148                   // Set motors
; 0000 0149                   Motors_setSpeeds(motorValue[0], motorValue[1]);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
; 0000 014A 
; 0000 014B                   for (m = 0, k = 0; m < OD_NN_M; m++)
_0x6B:
	__CPWRN 16,17,2
	BRLO PC+2
	RJMP _0x6C
; 0000 014C                   {
; 0000 014D                       // NN error
; 0000 014E                       OD_NN.d[m] = Delta(((float)motorValue[m] / 256.0f), OD_NN.y[m]);
	__POINTW2MN _OD_NN,48
	MOVW R30,R16
	CALL SUBOPT_0xF
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x24
	CALL SUBOPT_0x10
	CALL SUBOPT_0x25
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__POINTW2MN _OD_NN,40
	MOVW R30,R16
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x26
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 014F 
; 0000 0150                       // Change weights
; 0000 0151                       if ((OD_NN.d[m] > ERR_MAX) || (OD_NN.d[m] < (-ERR_MAX)))
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x28
	BREQ PC+3
	BRCS PC+2
	RJMP _0x6E
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x29
	BRSH _0x6D
_0x6E:
; 0000 0152                       {
; 0000 0153                           // Bad
; 0000 0154                           NewWeights(OD_NN.Weights[m], (float *)&OD_NN.Inputs[0], 0.1f, OD_NN.d[m], OD_NN_N);
	__MULBNWRU 16,17,20
	SUBI R30,LOW(-_OD_NN)
	SBCI R31,HIGH(-_OD_NN)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x21
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2D
	CALL __PUTPARD1
	LDI  R26,LOW(4)
	LDI  R27,0
	RCALL _NewWeights
; 0000 0155                       }
; 0000 0156                       else
	RJMP _0x70
_0x6D:
; 0000 0157                       {
; 0000 0158                           // Good
; 0000 0159                           k++;
	__ADDWRN 18,19,1
; 0000 015A                       }
_0x70:
; 0000 015B 
; 0000 015C                       printf("%f;%f;", OD_NN.y[m], OD_NN.d[m]);
	__POINTW1FN _0x0,35
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _OD_NN,40
	MOVW R30,R16
	CALL SUBOPT_0x12
	CALL __PUTPARD1
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2B
; 0000 015D                   }
	__ADDWRN 16,17,1
	RJMP _0x6B
_0x6C:
; 0000 015E                   puts("\n\r");
	__POINTW2MN _0x66,3
	CALL SUBOPT_0x2C
; 0000 015F                   // LED signalization
; 0000 0160                   if (k == OD_NN_M)
	BRNE _0x71
; 0000 0161                   {
; 0000 0162                       LED_PORT |= LED_GREEN;
	SBI  0xB,7
; 0000 0163                   }
; 0000 0164                   else
	RJMP _0x72
_0x71:
; 0000 0165                   {
; 0000 0166                       LED_PORT &= ~LED_GREEN;
	CBI  0xB,7
; 0000 0167                   }
_0x72:
; 0000 0168                   break;
	RJMP _0x5D
; 0000 0169 
; 0000 016A               // Automatic mode line follower
; 0000 016B               case MODE_LF:
_0x69:
	SBIW R30,0
	BRNE _0x73
; 0000 016C                   // Set motors
; 0000 016D                   Motors_setSpeeds((LF_NN.y[0] * 256.0f), (LF_NN.y[1] * 256.0f));
	__GETD2MN _LF_NN,48
	CALL SUBOPT_0x2E
	__GETD1MN _LF_NN,52
	RJMP _0x8B
; 0000 016E                   break;
; 0000 016F 
; 0000 0170               // Automatic mode object detector
; 0000 0171               case MODE_OD:
_0x73:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x5D
; 0000 0172                   // Set motors
; 0000 0173                   Motors_setSpeeds((OD_NN.y[0] * 256.0f), (OD_NN.y[1] * 256.0f));
	__GETD2MN _OD_NN,40
	CALL SUBOPT_0x2E
	__GETD1MN _OD_NN,44
_0x8B:
	__GETD2N 0x43800000
	CALL __MULF12
	CALL __CFD1
	MOVW R26,R30
	RCALL _Motors_setSpeeds
; 0000 0174                   break;
; 0000 0175           }
_0x5D:
; 0000 0176 
; 0000 0177 
; 0000 0178           // Read battery level
; 0000 0179           bat = readBatteryMillis();
	RCALL _readBatteryMillis
	MOVW R20,R30
; 0000 017A 
; 0000 017B           // Create log message
; 0000 017C           printf("%d;%d;%d;%d\n\r", OD_NN.Inputs[0], OD_NN.Inputs[1], OD_NN.Inputs[2], OD_NN.Inputs[3]);
	__POINTW1FN _0x0,42
	ST   -Y,R31
	ST   -Y,R30
	__GETW1MN _OD_NN,56
	CALL SUBOPT_0x2F
	__GETW1MN _OD_NN,58
	CALL SUBOPT_0x2F
	__GETW1MN _OD_NN,60
	CALL SUBOPT_0x2F
	__GETW1MN _OD_NN,62
	CALL SUBOPT_0x2F
	LDI  R24,16
	CALL _printf
	ADIW R28,18
; 0000 017D           printf("%d;%d;%d;%d;%d;%d;%d;%d\n\r", LF_NN.Inputs[0], LF_NN.Inputs[1], LF_NN.Inputs[2], LF_NN.Inputs[3], LF_N ...
	__POINTW1FN _0x0,56
	ST   -Y,R31
	ST   -Y,R30
	__GETW1MN _LF_NN,64
	CALL SUBOPT_0x2F
	__GETW1MN _LF_NN,66
	CALL SUBOPT_0x2F
	__GETW1MN _LF_NN,68
	CALL SUBOPT_0x2F
	__GETW1MN _LF_NN,70
	CALL SUBOPT_0x2F
	__GETW1MN _LF_NN,72
	CALL SUBOPT_0x2F
	LDS  R30,_motorValue
	LDS  R31,_motorValue+1
	CALL __CWD1
	CALL __PUTPARD1
	__GETW1MN _motorValue,2
	CALL __CWD1
	CALL __PUTPARD1
	MOVW R30,R20
	CALL SUBOPT_0x2F
	LDI  R24,32
	RCALL _printf
	ADIW R28,34
; 0000 017E 
; 0000 017F           // if user push button A   - mode LF/LF_T
; 0000 0180           if (!(BUTTON_PIN & BUTTON_A))
	SBIC 0x3,1
	RJMP _0x75
; 0000 0181           {
; 0000 0182               // Wait until user release button A
; 0000 0183               while (!(BUTTON_PIN & BUTTON_A));
_0x76:
	SBIS 0x3,1
	RJMP _0x76
; 0000 0184 
; 0000 0185               if (mode == MODE_LF)         mode = MODE_LF_T;
	LD   R30,Y
	CPI  R30,0
	BREQ _0x8C
; 0000 0186               else if (mode == MODE_LF_T)  mode = MODE_LF;
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x7B
	LDI  R30,LOW(0)
	RJMP _0x8D
; 0000 0187               else                         mode = MODE_LF_T;
_0x7B:
_0x8C:
	LDI  R30,LOW(1)
_0x8D:
	ST   Y,R30
; 0000 0188           }
; 0000 0189 
; 0000 018A           // if user push button B  - mode OD/OD_T
; 0000 018B           if (!(BUTTON_PIN & BUTTON_B))
_0x75:
	SBIC 0x3,4
	RJMP _0x7D
; 0000 018C           {
; 0000 018D               // Wait until user release button B
; 0000 018E               while (!(BUTTON_PIN & BUTTON_B));
_0x7E:
	SBIS 0x3,4
	RJMP _0x7E
; 0000 018F 
; 0000 0190               if (mode == MODE_OD)         mode = MODE_OD_T;
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BREQ _0x8E
; 0000 0191               else if (mode == MODE_OD_T)  mode = MODE_OD;
	CPI  R26,LOW(0x3)
	BRNE _0x83
	LDI  R30,LOW(2)
	RJMP _0x8F
; 0000 0192               else                         mode = MODE_OD_T;
_0x83:
_0x8E:
	LDI  R30,LOW(3)
_0x8F:
	ST   Y,R30
; 0000 0193           }
; 0000 0194       }
_0x7D:
	RJMP _0x58
; 0000 0195 }
_0x85:
	RJMP _0x85
; .FEND

	.DSEG
_0x66:
	.BYTE 0x6
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
_0x2000006:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	LD   R30,Y
	STS  198,R30
_0x20A0009:
	ADIW R28,1
	RET
; .FEND
_puts:
; .FSTART _puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000009:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000B
	MOV  R26,R17
	RCALL _putchar
	RJMP _0x2000009
_0x200000B:
	LDI  R26,LOW(10)
	RCALL _putchar
	LDD  R17,Y+0
	RJMP _0x20A0008
; .FEND
_put_usart_G100:
; .FSTART _put_usart_G100
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x20A0008:
	ADIW R28,3
	RET
; .FEND
__ftoe_G100:
; .FSTART __ftoe_G100
	CALL SUBOPT_0x11
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x200001F
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,0
	CALL _strcpyf
	RJMP _0x20A0006
_0x200001F:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x200001E
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,1
	CALL _strcpyf
	RJMP _0x20A0006
_0x200001E:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x2000021
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x2000021:
	LDD  R17,Y+11
_0x2000022:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000024
	CALL SUBOPT_0x30
	RJMP _0x2000022
_0x2000024:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x2000025
	LDI  R19,LOW(0)
	CALL SUBOPT_0x30
	RJMP _0x2000026
_0x2000025:
	LDD  R19,Y+11
	CALL SUBOPT_0x31
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000027
	CALL SUBOPT_0x30
_0x2000028:
	CALL SUBOPT_0x31
	BRLO _0x200002A
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	RJMP _0x2000028
_0x200002A:
	RJMP _0x200002B
_0x2000027:
_0x200002C:
	CALL SUBOPT_0x31
	BRSH _0x200002E
	CALL SUBOPT_0x32
	CALL SUBOPT_0x34
	CALL SUBOPT_0x9
	SUBI R19,LOW(1)
	RJMP _0x200002C
_0x200002E:
	CALL SUBOPT_0x30
_0x200002B:
	__GETD1S 12
	CALL SUBOPT_0x35
	CALL SUBOPT_0x9
	CALL SUBOPT_0x31
	BRLO _0x200002F
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
_0x200002F:
_0x2000026:
	LDI  R17,LOW(0)
_0x2000030:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x2000032
	__GETD2S 4
	CALL SUBOPT_0x36
	CALL SUBOPT_0x35
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x15
	CALL SUBOPT_0x14
	CALL SUBOPT_0x32
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x32
	CALL SUBOPT_0x26
	CALL SUBOPT_0x9
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x2000030
	CALL SUBOPT_0x37
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x2000030
_0x2000032:
	CALL SUBOPT_0x39
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x2000034
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2000119
_0x2000034:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2000119:
	ST   X,R30
	CALL SUBOPT_0x39
	CALL SUBOPT_0x39
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x39
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0006:
	CALL __LOADLOCR4
_0x20A0007:
	ADIW R28,16
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x5
_0x2000036:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000038
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200003C
	CPI  R18,37
	BRNE _0x200003D
	LDI  R17,LOW(1)
	RJMP _0x200003E
_0x200003D:
	CALL SUBOPT_0x3A
_0x200003E:
	RJMP _0x200003B
_0x200003C:
	CPI  R30,LOW(0x1)
	BRNE _0x200003F
	CPI  R18,37
	BRNE _0x2000040
	CALL SUBOPT_0x3A
	RJMP _0x200011A
_0x2000040:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000041
	LDI  R16,LOW(1)
	RJMP _0x200003B
_0x2000041:
	CPI  R18,43
	BRNE _0x2000042
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x200003B
_0x2000042:
	CPI  R18,32
	BRNE _0x2000043
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x200003B
_0x2000043:
	RJMP _0x2000044
_0x200003F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000045
_0x2000044:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000046
	ORI  R16,LOW(128)
	RJMP _0x200003B
_0x2000046:
	RJMP _0x2000047
_0x2000045:
	CPI  R30,LOW(0x3)
	BRNE _0x2000048
_0x2000047:
	CPI  R18,48
	BRLO _0x200004A
	CPI  R18,58
	BRLO _0x200004B
_0x200004A:
	RJMP _0x2000049
_0x200004B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200003B
_0x2000049:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x200004C
	LDI  R17,LOW(4)
	RJMP _0x200003B
_0x200004C:
	RJMP _0x200004D
_0x2000048:
	CPI  R30,LOW(0x4)
	BRNE _0x200004F
	CPI  R18,48
	BRLO _0x2000051
	CPI  R18,58
	BRLO _0x2000052
_0x2000051:
	RJMP _0x2000050
_0x2000052:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x200003B
_0x2000050:
_0x200004D:
	CPI  R18,108
	BRNE _0x2000053
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x200003B
_0x2000053:
	RJMP _0x2000054
_0x200004F:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x200003B
_0x2000054:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000059
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3B
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x3D
	RJMP _0x200005A
_0x2000059:
	CPI  R30,LOW(0x45)
	BREQ _0x200005D
	CPI  R30,LOW(0x65)
	BRNE _0x200005E
_0x200005D:
	RJMP _0x200005F
_0x200005E:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x2000060
_0x200005F:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x3E
	CALL __GETD1P
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x40
	LDD  R26,Y+13
	TST  R26
	BRMI _0x2000061
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x2000063
	CPI  R26,LOW(0x20)
	BREQ _0x2000065
	RJMP _0x2000066
_0x2000061:
	CALL SUBOPT_0x41
	CALL __ANEGF1
	CALL SUBOPT_0x3F
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000063:
	SBRS R16,7
	RJMP _0x2000067
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x3D
	RJMP _0x2000068
_0x2000067:
_0x2000065:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000068:
_0x2000066:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x200006A
	CALL SUBOPT_0x41
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x200006B
_0x200006A:
	CALL SUBOPT_0x41
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G100
_0x200006B:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x42
	RJMP _0x200006C
_0x2000060:
	CPI  R30,LOW(0x73)
	BRNE _0x200006E
	CALL SUBOPT_0x40
	CALL SUBOPT_0x43
	CALL SUBOPT_0x42
	RJMP _0x200006F
_0x200006E:
	CPI  R30,LOW(0x70)
	BRNE _0x2000071
	CALL SUBOPT_0x40
	CALL SUBOPT_0x43
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x200006F:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x2000073
	CP   R20,R17
	BRLO _0x2000074
_0x2000073:
	RJMP _0x2000072
_0x2000074:
	MOV  R17,R20
_0x2000072:
_0x200006C:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x2000075
_0x2000071:
	CPI  R30,LOW(0x64)
	BREQ _0x2000078
	CPI  R30,LOW(0x69)
	BRNE _0x2000079
_0x2000078:
	ORI  R16,LOW(4)
	RJMP _0x200007A
_0x2000079:
	CPI  R30,LOW(0x75)
	BRNE _0x200007B
_0x200007A:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007C
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x44
	LDI  R17,LOW(10)
	RJMP _0x200007D
_0x200007C:
	__GETD1N 0x2710
	CALL SUBOPT_0x44
	LDI  R17,LOW(5)
	RJMP _0x200007D
_0x200007B:
	CPI  R30,LOW(0x58)
	BRNE _0x200007F
	ORI  R16,LOW(8)
	RJMP _0x2000080
_0x200007F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20000BE
_0x2000080:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000082
	__GETD1N 0x10000000
	CALL SUBOPT_0x44
	LDI  R17,LOW(8)
	RJMP _0x200007D
_0x2000082:
	__GETD1N 0x1000
	CALL SUBOPT_0x44
	LDI  R17,LOW(4)
_0x200007D:
	CPI  R20,0
	BREQ _0x2000083
	ANDI R16,LOW(127)
	RJMP _0x2000084
_0x2000083:
	LDI  R20,LOW(1)
_0x2000084:
	SBRS R16,1
	RJMP _0x2000085
	CALL SUBOPT_0x40
	CALL SUBOPT_0x3E
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x200011B
_0x2000085:
	SBRS R16,2
	RJMP _0x2000087
	CALL SUBOPT_0x40
	CALL SUBOPT_0x43
	CALL __CWD1
	RJMP _0x200011B
_0x2000087:
	CALL SUBOPT_0x40
	CALL SUBOPT_0x43
	CLR  R22
	CLR  R23
_0x200011B:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000089
	LDD  R26,Y+13
	TST  R26
	BRPL _0x200008A
	CALL SUBOPT_0x41
	CALL __ANEGD1
	CALL SUBOPT_0x3F
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200008A:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x200008B
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x200008C
_0x200008B:
	ANDI R16,LOW(251)
_0x200008C:
_0x2000089:
	MOV  R19,R20
_0x2000075:
	SBRC R16,0
	RJMP _0x200008D
_0x200008E:
	CP   R17,R21
	BRSH _0x2000091
	CP   R19,R21
	BRLO _0x2000092
_0x2000091:
	RJMP _0x2000090
_0x2000092:
	SBRS R16,7
	RJMP _0x2000093
	SBRS R16,2
	RJMP _0x2000094
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x2000095
_0x2000094:
	LDI  R18,LOW(48)
_0x2000095:
	RJMP _0x2000096
_0x2000093:
	LDI  R18,LOW(32)
_0x2000096:
	CALL SUBOPT_0x3A
	SUBI R21,LOW(1)
	RJMP _0x200008E
_0x2000090:
_0x200008D:
_0x2000097:
	CP   R17,R20
	BRSH _0x2000099
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200009A
	CALL SUBOPT_0x45
	BREQ _0x200009B
	SUBI R21,LOW(1)
_0x200009B:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x200009A:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x3D
	CPI  R21,0
	BREQ _0x200009C
	SUBI R21,LOW(1)
_0x200009C:
	SUBI R20,LOW(1)
	RJMP _0x2000097
_0x2000099:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x200009D
_0x200009E:
	CPI  R19,0
	BREQ _0x20000A0
	SBRS R16,3
	RJMP _0x20000A1
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x20000A2
_0x20000A1:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x20000A2:
	CALL SUBOPT_0x3A
	CPI  R21,0
	BREQ _0x20000A3
	SUBI R21,LOW(1)
_0x20000A3:
	SUBI R19,LOW(1)
	RJMP _0x200009E
_0x20000A0:
	RJMP _0x20000A4
_0x200009D:
_0x20000A6:
	CALL SUBOPT_0x46
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A8
	SBRS R16,3
	RJMP _0x20000A9
	SUBI R18,-LOW(55)
	RJMP _0x20000AA
_0x20000A9:
	SUBI R18,-LOW(87)
_0x20000AA:
	RJMP _0x20000AB
_0x20000A8:
	SUBI R18,-LOW(48)
_0x20000AB:
	SBRC R16,4
	RJMP _0x20000AD
	CPI  R18,49
	BRSH _0x20000AF
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20000AE
_0x20000AF:
	RJMP _0x20000B1
_0x20000AE:
	CP   R20,R19
	BRSH _0x200011C
	CP   R21,R19
	BRLO _0x20000B4
	SBRS R16,0
	RJMP _0x20000B5
_0x20000B4:
	RJMP _0x20000B3
_0x20000B5:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000B6
_0x200011C:
	LDI  R18,LOW(48)
_0x20000B1:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000B7
	CALL SUBOPT_0x45
	BREQ _0x20000B8
	SUBI R21,LOW(1)
_0x20000B8:
_0x20000B7:
_0x20000B6:
_0x20000AD:
	CALL SUBOPT_0x3A
	CPI  R21,0
	BREQ _0x20000B9
	SUBI R21,LOW(1)
_0x20000B9:
_0x20000B3:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x46
	CALL __MODD21U
	CALL SUBOPT_0x3F
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x44
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20000A7
	RJMP _0x20000A6
_0x20000A7:
_0x20000A4:
	SBRS R16,0
	RJMP _0x20000BA
_0x20000BB:
	CPI  R21,0
	BREQ _0x20000BD
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x3D
	RJMP _0x20000BB
_0x20000BD:
_0x20000BA:
_0x20000BE:
_0x200005A:
_0x200011A:
	LDI  R17,LOW(0)
_0x200003B:
	RJMP _0x2000036
_0x2000038:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	CALL SUBOPT_0x11
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x202000D
	CALL SUBOPT_0x47
	__POINTW2FN _0x2020000,0
	CALL _strcpyf
	RJMP _0x20A0005
_0x202000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x202000C
	CALL SUBOPT_0x47
	__POINTW2FN _0x2020000,1
	CALL _strcpyf
	RJMP _0x20A0005
_0x202000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x202000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x48
	CALL SUBOPT_0x49
	LDI  R30,LOW(45)
	ST   X,R30
_0x202000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2020010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2020010:
	LDD  R17,Y+8
_0x2020011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2020013
	CALL SUBOPT_0x2
	CALL SUBOPT_0x36
	CALL SUBOPT_0x0
	RJMP _0x2020011
_0x2020013:
	CALL SUBOPT_0x4A
	CALL __ADDF12
	CALL SUBOPT_0x48
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	CALL SUBOPT_0x0
_0x2020014:
	CALL SUBOPT_0x4A
	CALL __CMPF12
	BRLO _0x2020016
	CALL SUBOPT_0x2
	CALL SUBOPT_0x34
	CALL SUBOPT_0x0
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2020017
	CALL SUBOPT_0x47
	__POINTW2FN _0x2020000,5
	CALL _strcpyf
	RJMP _0x20A0005
_0x2020017:
	RJMP _0x2020014
_0x2020016:
	CPI  R17,0
	BRNE _0x2020018
	CALL SUBOPT_0x49
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2020019
_0x2020018:
_0x202001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x202001C
	CALL SUBOPT_0x2
	CALL SUBOPT_0x36
	CALL SUBOPT_0x35
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x13
	CALL SUBOPT_0x4B
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x49
	CALL SUBOPT_0x38
	LDI  R31,0
	CALL SUBOPT_0x2
	CALL SUBOPT_0x4C
	CALL __MULF12
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x26
	CALL SUBOPT_0x48
	RJMP _0x202001A
_0x202001C:
_0x2020019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20A0004
	CALL SUBOPT_0x49
	LDI  R30,LOW(46)
	ST   X,R30
_0x202001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2020020
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x34
	CALL SUBOPT_0x48
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x49
	CALL SUBOPT_0x38
	LDI  R31,0
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x26
	CALL SUBOPT_0x48
	RJMP _0x202001E
_0x2020020:
_0x20A0004:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0005:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG
_rand:
; .FSTART _rand
	LDS  R30,__seed_G101
	LDS  R31,__seed_G101+1
	LDS  R22,__seed_G101+2
	LDS  R23,__seed_G101+3
	__GETD2N 0x41C64E6D
	CALL __MULD12U
	__ADDD1N 30562
	STS  __seed_G101,R30
	STS  __seed_G101+1,R31
	STS  __seed_G101+2,R22
	STS  __seed_G101+3,R23
	movw r30,r22
	andi r31,0x7F
	RET
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL SUBOPT_0x19
    brne __floor1
__floor0:
	CALL SUBOPT_0x1A
	RJMP _0x20A0003
__floor1:
    brtc __floor0
	CALL SUBOPT_0x1A
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20A0003:
	ADIW R28,4
	RET
; .FEND
_exp:
; .FSTART _exp
	CALL __PUTPARD2
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x4D
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x204000F
	__GETD1N 0x0
	RJMP _0x20A0002
_0x204000F:
	CALL SUBOPT_0x41
	CALL __CPD10
	BRNE _0x2040010
	__GETD1N 0x3F800000
	RJMP _0x20A0002
_0x2040010:
	CALL SUBOPT_0x4D
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2040011
	__GETD1N 0x7F7FFFFF
	RJMP _0x20A0002
_0x2040011:
	CALL SUBOPT_0x4D
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x4D
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x26
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL SUBOPT_0x26
	__PUTD1S 6
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x13
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0x4E
	__PUTD1S 6
	CALL SUBOPT_0x1
	__GETD2N 0x41A68D28
	CALL __ADDF12
	CALL SUBOPT_0x0
	__GETD1S 6
	CALL SUBOPT_0x2
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 6
	CALL SUBOPT_0x1
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL __PUTPARD1
	MOVW R26,R16
	CALL _ldexp
_0x20A0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
; .FEND
_tanh:
; .FSTART _tanh
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	LDD  R26,Y+8
	TST  R26
	BRPL _0x204001E
	CALL SUBOPT_0x4F
	CALL __ANEGF1
	__PUTD1S 5
	LDI  R17,LOW(1)
_0x204001E:
	__GETD2S 5
	RCALL _exp
	__PUTD1S 5
	CALL SUBOPT_0x4F
	__GETD2N 0x3F800000
	CALL SUBOPT_0x50
	__GETD2S 1
	CALL SUBOPT_0x4F
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x51
	__GETD2S 5
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x50
	CPI  R17,0
	BREQ _0x204001F
	CALL SUBOPT_0x51
	CALL __ANEGF1
	RJMP _0x20A0001
_0x204001F:
	CALL SUBOPT_0x51
_0x20A0001:
	LDD  R17,Y+0
	ADIW R28,9
	RET
; .FEND

	.CSEG

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_timer0_overflow_count:
	.BYTE 0x4
_LF_NN:
	.BYTE 0x4C
_OD_NN:
	.BYTE 0x42
_rcValue:
	.BYTE 0x4
_motorValue:
	.BYTE 0x4
_PCintLast_S000000A000:
	.BYTE 0x1
_edgeTime_S000000A000:
	.BYTE 0x8
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x0:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(8)
	CALL __LSLD12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	IN   R30,0x7
	MOV  R26,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUBI R30,LOW(-_Line_Pins*2)
	SBCI R31,HIGH(-_Line_Pins*2)
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	OUT  0x7,R30
	IN   R30,0x8
	MOV  R26,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUBI R30,LOW(-_Line_Pins*2)
	SBCI R31,HIGH(-_Line_Pins*2)
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	MOVW R30,R18
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x11:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x12:
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0x0
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x14:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x16:
	__GETW1MN _rcValue,2
	LDI  R26,LOW(1502)
	LDI  R27,HIGH(1502)
	SUB  R26,R30
	SBC  R27,R31
	MOVW R0,R26
	LDS  R26,_rcValue
	LDS  R27,_rcValue+1
	LDI  R30,LOW(1502)
	LDI  R31,HIGH(1502)
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	__GETD1N 0xA88
	CALL __DIVD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	__GETW2MN _motorValue,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(_LF_NN)
	LDI  R31,HIGH(_LF_NN)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	__POINTW1MN _LF_NN,24
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(_OD_NN)
	LDI  R31,HIGH(_OD_NN)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(4)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	__POINTW1MN _OD_NN,20
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(4)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	__POINTW1MN _LF_NN,64
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	__POINTW1MN _OD_NN,56
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	LDS  R30,_motorValue
	LDS  R31,_motorValue+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	CALL _Motors_setSpeeds
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	MOVW R30,R16
	LDI  R26,LOW(_motorValue)
	LDI  R27,HIGH(_motorValue)
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	__GETD1N 0x43800000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x26:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x27:
	__POINTW2MN _LF_NN,56
	MOVW R30,R16
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3A83126F
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0xBA83126F
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	__GETD1N 0x3DCCCCCD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	CALL __PUTPARD1
	LDI  R24,8
	CALL _printf
	ADIW R28,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	CALL _puts
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R18
	CPC  R31,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2D:
	__POINTW2MN _OD_NN,48
	MOVW R30,R16
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2E:
	__GETD1N 0x43800000
	CALL __MULF12
	CALL __CFD1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2F:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x30:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x31:
	RCALL SUBOPT_0x14
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x32:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x33:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RCALL SUBOPT_0x9
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x34:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x36:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x39:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3A:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x3B:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3C:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3D:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3E:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3F:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x40:
	RCALL SUBOPT_0x3B
	RJMP SUBOPT_0x3C

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x41:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x42:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x43:
	RCALL SUBOPT_0x3E
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x44:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x45:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x48:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x49:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	RCALL SUBOPT_0x1
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4B:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4D:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	__GETD2S 6
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4F:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x50:
	CALL __DIVF21
	__PUTD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x51:
	__GETD1S 1
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x1388
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

_ldexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	ADD  R23,R26
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD21:
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__LSRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRD1:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
