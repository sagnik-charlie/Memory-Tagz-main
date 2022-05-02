#include <avr/io.h>
#include <stdio.h>

#define UBRRVAL 6
#define KEY_PRT   PORTB
#define KEY_DDR   DDRB
#define KEY_PIN   PINB

void usart_init(void);
void sendbyte(unsigned char);
void sendstr(unsigned char*);
unsigned char receivebyte(void);
void receivestr(unsigned char*);
  
unsigned char rxdata;
unsigned char welcome_msg[]="All is well\n";
unsigned char success_msg[]=" Removed TAG_";
unsigned char suffix_msg[]="\n";
unsigned char keypad[4][4] = { {'1','2','3','A'},
        {'4','5','6','B'},
        {'7','8','9','C'},
        {'*','0','#','D'}};
unsigned char count[4][4] = {{'0','0','0','0'},{'0','0','0','0'},{'0','0','0','0'},{'0','0','0','0'}};



int main()
{ 
  usart_init();
  Serial.begin(9600);
  rxdata=receivebyte();
  if(rxdata='1'){
    sendstr(welcome_msg);
  while(1)
  {   
      KEY_DDR = 0b10000000;
      KEY_PRT |= 0b10000000;                                                              /* check for pressed key in 1st row */
      asm("NOP");
      _delay_ms(300);
      if((KEY_PIN & 0b00000001)==0b00000000 && count[0][0]!='Z')
            {
              sendstr(success_msg);
   sendbyte(keypad[0][0]);
   sendstr(suffix_msg);
    count[0][0]='Z';
      }
      
     if((KEY_PIN & 0b00000010)==0b00000000 && count[0][1]!='Z')
            {
   sendstr(success_msg);
   sendbyte(keypad[0][1]);
   sendstr(suffix_msg);
    count[0][1]='Z';
      }
      
      if((KEY_PIN & 0b00000100)==0b00000000 && count[0][2]!='Z')
            {
    sendstr(success_msg);
   sendbyte(keypad[0][2]);
   sendstr(suffix_msg);
    count[0][2]='Z';
      }
      
     if((KEY_PIN & 0b00001000)==0b00000000 && count[0][3]!='Z')
            {
     sendstr(success_msg);
   sendbyte(keypad[0][3]);
   sendstr(suffix_msg);
    count[0][3]='Z';
      }                               /*end of 1st row checking*/
    else{
        KEY_DDR = 0b11110000;
        KEY_PRT = 0b00000000;
      }

      KEY_DDR = 0b01000000;
      KEY_PRT |= (1<<PB6);          /* check for pressed key in 2st row */
      asm("NOP");
      _delay_ms(300);
      if((KEY_PIN & 0b00000001)==0b00000000 && count[1][0]!='Z')
            {
     sendstr(success_msg);
   sendbyte(keypad[1][0]);
   sendstr(suffix_msg);
    count[1][0]='Z';
      }
      
      if((KEY_PIN & 0b00000010)==0b00000000 && count[1][1]!='Z')
            {
   sendstr(success_msg);
   sendbyte(keypad[1][1]);
   sendstr(suffix_msg);
    count[1][1]='Z';
      }
      
     if((KEY_PIN & 0b00000100)==0b00000000 && count[1][2]!='Z')
            {
    sendstr(success_msg);
   sendbyte(keypad[1][2]);
   sendstr(suffix_msg);
    count[1][2]='Z';
      }
      
      if((KEY_PIN & 0b00001000)==0b00000000 && count[1][3]!='Z')
            {
    sendstr(success_msg);
   sendbyte(keypad[1][3]);
   sendstr(suffix_msg);
    count[1][3]='Z';
      }
      else{
        KEY_DDR = 0b11110000;
        KEY_PRT = 0b00000000;
      }

      KEY_DDR = 0b00100000;
      KEY_PRT |= (1<<PB5);            /* check for pressed key in 3rd row */
      asm("NOP");
      _delay_ms(300);
      //KEY_DDR = 0b00000000;
      if((KEY_PIN & 0b00000001)==0b00000000 && count[2][0]!='Z')
            {
    sendstr(success_msg);
   sendbyte(keypad[2][0]);
   sendstr(suffix_msg);
    count[2][0]='Z';
      }
      
      if((KEY_PIN & 0b00000010)==0b00000000 && count[2][1]!='Z')
            {
    sendstr(success_msg);
   sendbyte(keypad[2][1]);
   sendstr(suffix_msg);
    count[2][1]='Z';
      }
      
      if((KEY_PIN & 0b00000100)==0b00000000 && count[2][2]!='Z')
            {
    sendstr(success_msg);
   sendbyte(keypad[2][2]);
   sendstr(suffix_msg);
    count[2][2]='Z';
      }
      
       if((KEY_PIN & 0b00001000)==0b00000000 && count[2][3]!='Z')
            {
   sendstr(success_msg);
   sendbyte(keypad[2][3]);
   sendstr(suffix_msg);
    count[2][3]='Z';
      }
      else{
        KEY_DDR = 0b11110000;
        KEY_PRT = 0b00000000;
      }

      KEY_DDR=0b00010000;
      KEY_PRT |= (1<<PB4);   /* check for pressed key in 4th row */
      asm("NOP");
      _delay_ms(300);
      if((KEY_PIN & 0b00000001)==0b00000000 && count[3][0]!='Z')
            {
    sendstr(success_msg);
   sendbyte(keypad[3][0]);
   sendstr(suffix_msg);
    count[3][0]='Z';
      }
      
      if((KEY_PIN & 0b00000010)==0b00000000 && count[3][1]!='Z')
            {
    sendstr(success_msg);
   sendbyte(keypad[3][1]);
  sendstr(suffix_msg);
    count[3][1]='Z';
      }
      
       if((KEY_PIN & 0b00000100)==0b00000000 && count[3][2]!='Z')
            {
   sendstr(success_msg);
   sendbyte(keypad[3][2]);
   sendstr(suffix_msg);
    count[3][2]='Z';
      }
     
       if((KEY_PIN & 0b00001000)==0b00000000 && count[3][3]!='Z')
            {
    sendstr(success_msg);
   sendbyte(keypad[3][3]);
   sendstr(suffix_msg);
    count[3][3]='Z';
      }
      else{
        KEY_DDR = 0b11110000;
        KEY_PRT = 0b00000000;
      }
      }
  }
  else{
  }
}

void usart_init(void){
  UBRR0H= (unsigned char)(UBRRVAL>>8);   //high byte
    UBRR0L=(unsigned char)UBRRVAL;          //low byte
    UCSR0B |= (1<<TXEN0) | (1<<RXEN0);    //Enable Transmitter and Receiver
    UCSR0C |= (1<<UCSZ01)|(1<<UCSZ00);  //Set data frame format: asynchronous mode,no parity, 1 stop bit, 8 bit size
}

void sendbyte(unsigned char MSG){
    while((UCSR0A&(1<<UDRE0)) == 0);     // Wait if a byte is being transmitted
    UDR0 = MSG; 
}

void sendstr(unsigned char* s){
  unsigned char i = 0;
  while(s[i] != '\0'){
   sendbyte(s[i]);
   i++;
   }
}

unsigned char receivebyte(void){
  while(!(UCSR0A & (1<<RXC0)));
    return UDR0;
}
