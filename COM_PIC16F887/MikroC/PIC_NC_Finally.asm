
_Clear_buf_string_receive:

;PIC_NC_Finally.c,24 :: 		void Clear_buf_string_receive(void){
;PIC_NC_Finally.c,26 :: 		for (i=0;i<=max_count_ReceiveData;i++){
	CLRF        R1 
L_Clear_buf_string_receive0:
	MOVF        R1, 0 
	SUBLW       10
	BTFSS       STATUS+0, 0 
	GOTO        L_Clear_buf_string_receive1
;PIC_NC_Finally.c,27 :: 		buf_string_receive[i] = '\0';
	MOVLW       _buf_string_receive+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_buf_string_receive+0)
	MOVWF       FSR1H 
	MOVF        R1, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;PIC_NC_Finally.c,26 :: 		for (i=0;i<=max_count_ReceiveData;i++){
	INCF        R1, 1 
;PIC_NC_Finally.c,28 :: 		}
	GOTO        L_Clear_buf_string_receive0
L_Clear_buf_string_receive1:
;PIC_NC_Finally.c,29 :: 		}
L_end_Clear_buf_string_receive:
	RETURN      0
; end of _Clear_buf_string_receive

_interrupt:

;PIC_NC_Finally.c,31 :: 		void interrupt(void){
;PIC_NC_Finally.c,32 :: 		if(INTCON.INT0IF == 1){
	BTFSS       INTCON+0, 1 
	GOTO        L_interrupt3
;PIC_NC_Finally.c,33 :: 		INTCON.INT0IF = 0;
	BCF         INTCON+0, 1 
;PIC_NC_Finally.c,34 :: 		count++;
	INFSNZ      _count+0, 1 
	INCF        _count+1, 1 
;PIC_NC_Finally.c,35 :: 		sprintf(buffer,"@S%d&",count);
	MOVLW       _buffer+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_1_PIC_NC_Finally+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_1_PIC_NC_Finally+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_1_PIC_NC_Finally+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        _count+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        _count+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	CALL        _sprintf+0, 0
;PIC_NC_Finally.c,36 :: 		UART1_Write_Text(buffer);
	MOVLW       _buffer+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_NC_Finally.c,37 :: 		}
	GOTO        L_interrupt4
L_interrupt3:
;PIC_NC_Finally.c,38 :: 		else if (INTCON3.INT1F == 1)
	BTFSS       INTCON3+0, 0 
	GOTO        L_interrupt5
;PIC_NC_Finally.c,40 :: 		INTCON3.INT1IF = 0;
	BCF         INTCON3+0, 0 
;PIC_NC_Finally.c,41 :: 		RE0_bit = !RE0_bit;
	BTG         RE0_bit+0, BitPos(RE0_bit+0) 
;PIC_NC_Finally.c,42 :: 		if (RE0_bit == 0)   //if (RD0_bit == 0)
	BTFSC       RE0_bit+0, BitPos(RE0_bit+0) 
	GOTO        L_interrupt6
;PIC_NC_Finally.c,45 :: 		UART1_Write_Text("@Loff2&");
	MOVLW       ?lstr2_PIC_NC_Finally+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_PIC_NC_Finally+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_NC_Finally.c,46 :: 		}
	GOTO        L_interrupt7
L_interrupt6:
;PIC_NC_Finally.c,50 :: 		UART1_Write_Text("@Lon2&");
	MOVLW       ?lstr3_PIC_NC_Finally+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_PIC_NC_Finally+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_NC_Finally.c,51 :: 		}
L_interrupt7:
;PIC_NC_Finally.c,52 :: 		}
	GOTO        L_interrupt8
L_interrupt5:
;PIC_NC_Finally.c,54 :: 		else if(PIR1.RCIF == 1){
	BTFSS       PIR1+0, 5 
	GOTO        L_interrupt9
;PIC_NC_Finally.c,55 :: 		PIR1.RCIF = 0;
	BCF         PIR1+0, 5 
;PIC_NC_Finally.c,56 :: 		ReceiveData = UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _ReceiveData+0 
;PIC_NC_Finally.c,57 :: 		if (ReceiveData == start_sign){
	MOVF        R0, 0 
	XORWF       _start_sign+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt10
;PIC_NC_Finally.c,58 :: 		count_ReceiveData = 0;
	CLRF        _count_ReceiveData+0 
;PIC_NC_Finally.c,59 :: 		start_Data = ReceiveData;
	MOVF        _ReceiveData+0, 0 
	MOVWF       _start_Data+0 
;PIC_NC_Finally.c,60 :: 		buf_string_receive[count_ReceiveData] = ReceiveData;
	MOVLW       _buf_string_receive+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_buf_string_receive+0)
	MOVWF       FSR1H 
	MOVF        _count_ReceiveData+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        _ReceiveData+0, 0 
	MOVWF       POSTINC1+0 
;PIC_NC_Finally.c,61 :: 		}
L_interrupt10:
;PIC_NC_Finally.c,62 :: 		if (ReceiveData == end_sign){
	MOVF        _ReceiveData+0, 0 
	XORWF       _end_sign+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt11
;PIC_NC_Finally.c,63 :: 		end_Data = ReceiveData;
	MOVF        _ReceiveData+0, 0 
	MOVWF       _end_Data+0 
;PIC_NC_Finally.c,64 :: 		buf_string_receive[count_ReceiveData] = ReceiveData;
	MOVLW       _buf_string_receive+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_buf_string_receive+0)
	MOVWF       FSR1H 
	MOVF        _count_ReceiveData+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        _ReceiveData+0, 0 
	MOVWF       POSTINC1+0 
;PIC_NC_Finally.c,65 :: 		}
L_interrupt11:
;PIC_NC_Finally.c,66 :: 		if ((start_Data == start_sign) && (end_Data == end_sign)){
	MOVF        _start_Data+0, 0 
	XORWF       _start_sign+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt14
	MOVF        _end_Data+0, 0 
	XORWF       _end_sign+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt14
L__interrupt29:
;PIC_NC_Finally.c,67 :: 		receive_complete = 1;
	MOVLW       1
	MOVWF       _receive_complete+0 
;PIC_NC_Finally.c,68 :: 		count_ReceiveData = 0;
	CLRF        _count_ReceiveData+0 
;PIC_NC_Finally.c,69 :: 		start_Data = '\0';
	CLRF        _start_Data+0 
;PIC_NC_Finally.c,70 :: 		end_Data = '\0';
	CLRF        _end_Data+0 
;PIC_NC_Finally.c,71 :: 		}
	GOTO        L_interrupt15
L_interrupt14:
;PIC_NC_Finally.c,73 :: 		buf_string_receive[count_ReceiveData] = ReceiveData;
	MOVLW       _buf_string_receive+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_buf_string_receive+0)
	MOVWF       FSR1H 
	MOVF        _count_ReceiveData+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        _ReceiveData+0, 0 
	MOVWF       POSTINC1+0 
;PIC_NC_Finally.c,74 :: 		count_ReceiveData++;
	INCF        _count_ReceiveData+0, 1 
;PIC_NC_Finally.c,75 :: 		if (count_ReceiveData > max_count_ReceiveData){
	MOVF        _count_ReceiveData+0, 0 
	SUBLW       10
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt16
;PIC_NC_Finally.c,76 :: 		count_ReceiveData = 0;
	CLRF        _count_ReceiveData+0 
;PIC_NC_Finally.c,77 :: 		}
L_interrupt16:
;PIC_NC_Finally.c,78 :: 		}
L_interrupt15:
;PIC_NC_Finally.c,80 :: 		if (receive_complete == 1){
	MOVF        _receive_complete+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt17
;PIC_NC_Finally.c,81 :: 		if (strncmp(strstr(buf_string_receive,led_on_code),led_on_code,len_code) == 0){
	MOVLW       _buf_string_receive+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_buf_string_receive+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       _led_on_code+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(_led_on_code+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strncmp_s1+0 
	MOVF        R1, 0 
	MOVWF       FARG_strncmp_s1+1 
	MOVLW       _led_on_code+0
	MOVWF       FARG_strncmp_s2+0 
	MOVLW       hi_addr(_led_on_code+0)
	MOVWF       FARG_strncmp_s2+1 
	MOVLW       5
	MOVWF       FARG_strncmp_len+0 
	CALL        _strncmp+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt33
	MOVLW       0
	XORWF       R0, 0 
L__interrupt33:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt18
;PIC_NC_Finally.c,82 :: 		LATE.LATE1 = led_on;
	BSF         LATE+0, 1 
;PIC_NC_Finally.c,83 :: 		UART1_Write_Text("@Lle_on&");
	MOVLW       ?lstr4_PIC_NC_Finally+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_PIC_NC_Finally+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_NC_Finally.c,84 :: 		}
	GOTO        L_interrupt19
L_interrupt18:
;PIC_NC_Finally.c,85 :: 		else if (strncmp(strstr(buf_string_receive,led_off_code),led_off_code,len_code) == 0){
	MOVLW       _buf_string_receive+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_buf_string_receive+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       _led_off_code+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(_led_off_code+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strncmp_s1+0 
	MOVF        R1, 0 
	MOVWF       FARG_strncmp_s1+1 
	MOVLW       _led_off_code+0
	MOVWF       FARG_strncmp_s2+0 
	MOVLW       hi_addr(_led_off_code+0)
	MOVWF       FARG_strncmp_s2+1 
	MOVLW       5
	MOVWF       FARG_strncmp_len+0 
	CALL        _strncmp+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt34
	MOVLW       0
	XORWF       R0, 0 
L__interrupt34:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt20
;PIC_NC_Finally.c,86 :: 		LATE.LATE1 = led_off;
	BCF         LATE+0, 1 
;PIC_NC_Finally.c,87 :: 		UART1_Write_Text("@Lle_of&");
	MOVLW       ?lstr5_PIC_NC_Finally+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr5_PIC_NC_Finally+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_NC_Finally.c,88 :: 		}
	GOTO        L_interrupt21
L_interrupt20:
;PIC_NC_Finally.c,89 :: 		else if (strncmp(strstr(buf_string_receive,led_on_code2),led_on_code2,len_code) == 0){
	MOVLW       _buf_string_receive+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_buf_string_receive+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       _led_on_code2+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(_led_on_code2+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strncmp_s1+0 
	MOVF        R1, 0 
	MOVWF       FARG_strncmp_s1+1 
	MOVLW       _led_on_code2+0
	MOVWF       FARG_strncmp_s2+0 
	MOVLW       hi_addr(_led_on_code2+0)
	MOVWF       FARG_strncmp_s2+1 
	MOVLW       5
	MOVWF       FARG_strncmp_len+0 
	CALL        _strncmp+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt35
	MOVLW       0
	XORWF       R0, 0 
L__interrupt35:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt22
;PIC_NC_Finally.c,90 :: 		LATE.LATE0 = led_on;
	BSF         LATE+0, 0 
;PIC_NC_Finally.c,91 :: 		UART1_Write_Text("@Lleon2&");
	MOVLW       ?lstr6_PIC_NC_Finally+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr6_PIC_NC_Finally+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_NC_Finally.c,92 :: 		}
	GOTO        L_interrupt23
L_interrupt22:
;PIC_NC_Finally.c,93 :: 		else if (strncmp(strstr(buf_string_receive,led_off_code2),led_off_code2,len_code) == 0){
	MOVLW       _buf_string_receive+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_buf_string_receive+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       _led_off_code2+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(_led_off_code2+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strncmp_s1+0 
	MOVF        R1, 0 
	MOVWF       FARG_strncmp_s1+1 
	MOVLW       _led_off_code2+0
	MOVWF       FARG_strncmp_s2+0 
	MOVLW       hi_addr(_led_off_code2+0)
	MOVWF       FARG_strncmp_s2+1 
	MOVLW       5
	MOVWF       FARG_strncmp_len+0 
	CALL        _strncmp+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt36
	MOVLW       0
	XORWF       R0, 0 
L__interrupt36:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt24
;PIC_NC_Finally.c,94 :: 		LATE.LATE0 = led_off;
	BCF         LATE+0, 0 
;PIC_NC_Finally.c,95 :: 		UART1_Write_Text("@Lleof2&");
	MOVLW       ?lstr7_PIC_NC_Finally+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr7_PIC_NC_Finally+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_NC_Finally.c,96 :: 		}
	GOTO        L_interrupt25
L_interrupt24:
;PIC_NC_Finally.c,98 :: 		UART1_Write_Text("@Error&");
	MOVLW       ?lstr8_PIC_NC_Finally+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr8_PIC_NC_Finally+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;PIC_NC_Finally.c,99 :: 		}
L_interrupt25:
L_interrupt23:
L_interrupt21:
L_interrupt19:
;PIC_NC_Finally.c,100 :: 		receive_complete = 0;
	CLRF        _receive_complete+0 
;PIC_NC_Finally.c,101 :: 		count_ReceiveData = 0;
	CLRF        _count_ReceiveData+0 
;PIC_NC_Finally.c,102 :: 		Clear_buf_string_receive();
	CALL        _Clear_buf_string_receive+0, 0
;PIC_NC_Finally.c,103 :: 		}
L_interrupt17:
;PIC_NC_Finally.c,104 :: 		}
L_interrupt9:
L_interrupt8:
L_interrupt4:
;PIC_NC_Finally.c,105 :: 		}
L_end_interrupt:
L__interrupt32:
	RETFIE      1
; end of _interrupt

_main:

;PIC_NC_Finally.c,106 :: 		void main()
;PIC_NC_Finally.c,108 :: 		ADCON1 |= 0x0F;
	MOVLW       15
	IORWF       ADCON1+0, 1 
;PIC_NC_Finally.c,109 :: 		CMCON |= 7;
	MOVLW       7
	IORWF       CMCON+0, 1 
;PIC_NC_Finally.c,112 :: 		PORTB = 0x00; //LATB = 0x00;
	CLRF        PORTB+0 
;PIC_NC_Finally.c,113 :: 		TRISB.TRISB0 = 1;
	BSF         TRISB+0, 0 
;PIC_NC_Finally.c,114 :: 		TRISB.TRISB1 = 1;
	BSF         TRISB+0, 1 
;PIC_NC_Finally.c,117 :: 		PORTD = 0x00; LATD = 0x00;
	CLRF        PORTD+0 
	CLRF        LATD+0 
;PIC_NC_Finally.c,118 :: 		TRISD0_bit = 1;
	BSF         TRISD0_bit+0, BitPos(TRISD0_bit+0) 
;PIC_NC_Finally.c,121 :: 		PORTE = 0x00; LATE = 0x00;
	CLRF        PORTE+0 
	CLRF        LATE+0 
;PIC_NC_Finally.c,122 :: 		TRISE1_bit = 0;
	BCF         TRISE1_bit+0, BitPos(TRISE1_bit+0) 
;PIC_NC_Finally.c,123 :: 		TRISE0_bit = 0;
	BCF         TRISE0_bit+0, BitPos(TRISE0_bit+0) 
;PIC_NC_Finally.c,126 :: 		INTCON.INT0IF = 0;
	BCF         INTCON+0, 1 
;PIC_NC_Finally.c,127 :: 		INTCON.INT0IE = 1;
	BSF         INTCON+0, 4 
;PIC_NC_Finally.c,129 :: 		INTCON3.INT1IF = 0;
	BCF         INTCON3+0, 0 
;PIC_NC_Finally.c,130 :: 		INTCON3.INT1IE = 1;
	BSF         INTCON3+0, 3 
;PIC_NC_Finally.c,132 :: 		INTCON2.INTEDG0 = 1;
	BSF         INTCON2+0, 6 
;PIC_NC_Finally.c,133 :: 		INTCON2.INTEDG1 = 1;
	BSF         INTCON2+0, 5 
;PIC_NC_Finally.c,135 :: 		PIR1.RCIF = 0;
	BCF         PIR1+0, 5 
;PIC_NC_Finally.c,136 :: 		PIE1.RCIE = 1;
	BSF         PIE1+0, 5 
;PIC_NC_Finally.c,137 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;PIC_NC_Finally.c,138 :: 		INTCON.PEIE = 1;
	BSF         INTCON+0, 6 
;PIC_NC_Finally.c,140 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	MOVLW       2
	MOVWF       SPBRGH+0 
	MOVLW       8
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;PIC_NC_Finally.c,141 :: 		delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main26:
	DECFSZ      R13, 1, 1
	BRA         L_main26
	DECFSZ      R12, 1, 1
	BRA         L_main26
	DECFSZ      R11, 1, 1
	BRA         L_main26
	NOP
	NOP
;PIC_NC_Finally.c,143 :: 		while(1);
L_main27:
	GOTO        L_main27
;PIC_NC_Finally.c,144 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
