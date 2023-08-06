#define led_on 1
#define led_off 0
#define max_count_ReceiveData 10
#define len_code 5
//--------------------------
char ReceiveData;
char buffer[15];
int count = 0;
bit oldstate;

char led_on_code[] = "le_on";
char led_off_code[] = "le_of";

char led_on_code2[] = "leon2";
char led_off_code2[] = "leof2";

char start_sign = '@';
char end_sign = '&';
char count_ReceiveData = 0;
char buf_string_receive[max_count_ReceiveData];
char start_Data, end_Data;
char receive_complete = 0;

void Clear_buf_string_receive(void){
   unsigned char i;
   for (i=0;i<=max_count_ReceiveData;i++){
       buf_string_receive[i] = '\0';
   }
}

void interrupt(void){
  if(INTCON.INT0IF == 1){
       INTCON.INT0IF = 0;
       count++;
       sprintf(buffer,"@S%d&",count);
       UART1_Write_Text(buffer);
  }
   else if (INTCON3.INT1F == 1)
     {
         INTCON3.INT1IF = 0;
         RE0_bit = !RE0_bit;
         if (RE0_bit == 0)   //if (RD0_bit == 0)
         {
           // LATE.LATE0 = led_on;
            UART1_Write_Text("@Loff2&");
         }
         else
         {
            //LATE.LATE1 = led_off;
            UART1_Write_Text("@Lon2&");
         }
     }

  else if(PIR1.RCIF == 1){
       PIR1.RCIF = 0;
       ReceiveData = UART1_Read();
       if (ReceiveData == start_sign){
          count_ReceiveData = 0;
          start_Data = ReceiveData;
          buf_string_receive[count_ReceiveData] = ReceiveData;
       }
       if (ReceiveData == end_sign){
          end_Data = ReceiveData;
          buf_string_receive[count_ReceiveData] = ReceiveData;
       }
       if ((start_Data == start_sign) && (end_Data == end_sign)){
         receive_complete = 1;
         count_ReceiveData = 0;
         start_Data = '\0';
         end_Data = '\0';
         }
       else{
            buf_string_receive[count_ReceiveData] = ReceiveData;
            count_ReceiveData++;
            if (count_ReceiveData > max_count_ReceiveData){
               count_ReceiveData = 0;
            }
       }
       
  if (receive_complete == 1){
     if (strncmp(strstr(buf_string_receive,led_on_code),led_on_code,len_code) == 0){
        LATE.LATE1 = led_on;
        UART1_Write_Text("@Lle_on&");
     }
     else if (strncmp(strstr(buf_string_receive,led_off_code),led_off_code,len_code) == 0){
           LATE.LATE1 = led_off;
           UART1_Write_Text("@Lle_of&");
      }
      else if (strncmp(strstr(buf_string_receive,led_on_code2),led_on_code2,len_code) == 0){
           LATE.LATE0 = led_on;
           UART1_Write_Text("@Lleon2&");
     }
     else if (strncmp(strstr(buf_string_receive,led_off_code2),led_off_code2,len_code) == 0){
          LATE.LATE0 = led_off;
          UART1_Write_Text("@Lleof2&");
      }
      else{
           UART1_Write_Text("@Error&");
      }
      receive_complete = 0;
      count_ReceiveData = 0;
      Clear_buf_string_receive();
      }
  }
}
void main()
{
      ADCON1 |= 0x0F;
      CMCON |= 7;
      
      // Cau hinh Port B
      PORTB = 0x00; //LATB = 0x00;
      TRISB.TRISB0 = 1;
      TRISB.TRISB1 = 1;
      
      //Cau hinh Port D
      PORTD = 0x00; LATD = 0x00;
      TRISD0_bit = 1;
      
      // Cau hinh Port E
      PORTE = 0x00; LATE = 0x00;
      TRISE1_bit = 0;
      TRISE0_bit = 0;
      
      // Cau hinh ngat
      INTCON.INT0IF = 0;
      INTCON.INT0IE = 1;

      INTCON3.INT1IF = 0;
      INTCON3.INT1IE = 1;

      INTCON2.INTEDG0 = 1;
      INTCON2.INTEDG1 = 1;

      PIR1.RCIF = 0;
      PIE1.RCIE = 1;
      INTCON.GIE = 1;
      INTCON.PEIE = 1;

      UART1_Init(9600);
      delay_ms(100);

      while(1);
}