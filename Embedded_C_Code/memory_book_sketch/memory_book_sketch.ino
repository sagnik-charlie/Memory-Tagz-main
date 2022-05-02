#include <avr/io.h>

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
unsigned char keypad[4][4] = { {'1','2','3','A'},
        {'4','5','6','B'},
        {'7','8','9','C'},
        {'X','Y','Z','D'}};
        
char count[4][4]={{'A','A','A','A'},{'A','A','A','A'},{'A','A','A','A'},{'A','A','A','A'}};


unsigned char colloc, rowloc;


int main()
{
usart_init();
  Serial.begin(9600);
  while(1)
  {
      KEY_DDR = 0xF0;           /* set port direction as input-output */
      KEY_PRT = 0xFF;

      do
      {
    KEY_PRT &= 0x0F;      /* mask PORT for column read only */
    asm("NOP");
    colloc = (KEY_PIN & 0x0F); /* read status of column */
      }while(colloc != 0x0F);
    
      do
      {
    do
    {
              _delay_ms(20);             /* 20ms key debounce time */
        colloc = (KEY_PIN & 0x0F); /* read status of column */
    }while(colloc == 0x0F);        /* check for any key press */
      
    _delay_ms (40);             /* 20 ms key debounce time */
    colloc = (KEY_PIN & 0x0F);
      }while(colloc == 0x0F);
      while(1){
     /* now check for rows */
      KEY_PRT = 0xEF;            /* check for pressed key in 1st row */
      asm("NOP");
      colloc = (KEY_PIN & 0x0F);
      if(colloc != 0x0F)
            {
    rowloc = 0;
    break;
      }

      KEY_PRT = 0xDF;   /* check for pressed key in 2nd row */
      asm("NOP");
      colloc = (KEY_PIN & 0x0F);
      if(colloc != 0x0F)
      {
    rowloc = 1;
    break;
      }
    
      KEY_PRT = 0xBF;   /* check for pressed key in 3rd row */
      asm("NOP");
            colloc = (KEY_PIN & 0x0F);
      if(colloc != 0x0F)
      {
    rowloc = 2;
    break;
      }

      KEY_PRT = 0x7F;   /* check for pressed key in 4th row */
      asm("NOP");
      colloc = (KEY_PIN & 0x0F);
      if(colloc != 0x0F)
      {
    rowloc = 3;
    break;
      }
  }
  if(colloc == 0x0E && count[rowloc][0]=='A'){
    sendbyte(keypad[rowloc][0]);
    count[rowloc][0] = 'Z';
  }
  else if(colloc == 0x0D && count[rowloc][1]=='A'){
    sendbyte(keypad[rowloc][1]);
    count[rowloc][1]='Z';
  }
  else if(colloc == 0x0B && count[rowloc][2]=='A'){
    sendbyte(keypad[rowloc][2]);
    count[rowloc][2]='Z'; 
  }
  else if(colloc == 0x07 && count[rowloc][3]=='A'){
    sendbyte(keypad[rowloc][3]);
    count[rowloc][3]='Z';
   }
   else{}
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
