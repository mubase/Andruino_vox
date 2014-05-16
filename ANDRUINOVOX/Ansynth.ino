// Wavetable Synth
// Adapted by Becky Stewart from
// mechomaniac.com
 #define F_CPU 16000000UL    // clock frequency
 #define BAUDRATE 38400      //baud rate
#define BAUD_PRESCALLER (((F_CPU / (BAUDRATE * 16UL))) - 1)   // baud rate calc
 
#include <stdint.h>
#include <avr/interrupt.h>
#include <avr/io.h>
#include <avr/pgmspace.h>
 
// Map all the input and output pins
#define potPin 0
#define speakerPin 10
#define buttonPin 7
 
 
#define INTERRUPT_PERIOD 512
#define FINT (F_CPU / INTERRUPT_PERIOD) // 16kHz?
#define FS (FINT)
 #define STEPS 256
// sine lookup table pre-calculated
prog_uchar PROGMEM sinetable[256] = {
  128,131,134,137,140,143,146,149,152,156,159,162,165,168,171,174,
  176,179,182,185,188,191,193,196,199,201,204,206,209,211,213,216,
  218,220,222,224,226,228,230,232,234,236,237,239,240,242,243,245,
  246,247,248,249,250,251,252,252,253,254,254,255,255,255,255,255,
  255,255,255,255,255,255,254,254,253,252,252,251,250,249,248,247,
  246,245,243,242,240,239,237,236,234,232,230,228,226,224,222,220,
  218,216,213,211,209,206,204,201,199,196,193,191,188,185,182,179,
  176,174,171,168,165,162,159,156,152,149,146,143,140,137,134,131,
  128,124,121,118,115,112,109,106,103,99, 96, 93, 90, 87, 84, 81, 
  79, 76, 73, 70, 67, 64, 62, 59, 56, 54, 51, 49, 46, 44, 42, 39, 
  37, 35, 33, 31, 29, 27, 25, 23, 21, 19, 18, 16, 15, 13, 12, 10, 
  9,  8,  7,  6,  5,  4,  3,  3,  2,  1,  1,  0,  0,  0,  0,  0,  
  0,  0,  0,  0,  0,  0,  1,  1,  2,  3,  3,  4,  5,  6,  7,  8,  
  9,  10, 12, 13, 15, 16, 18, 19, 21, 23, 25, 27, 29, 31, 33, 35, 
  37, 39, 42, 44, 46, 49, 51, 54, 56, 59, 62, 64, 67, 70, 73, 76, 
  79, 81, 84, 87, 90, 93, 96, 99, 103,106,109,112,115,118,121,124
};

//brass lookup
const double brass[256] = {
  0.000,0.024,0.048,0.071,0.095,0.119,0.143,0.167,0.190,0.214,0.238,0.262,0.286,0.310,0.333,0.357,0.381,0.405,0.429,0.452,
  0.476,0.500,0.524,0.548,0.571,0.595,0.619,0.643,0.667,0.690,0.714,0.738,0.762,0.786,0.810,0.833,0.857,0.881,0.905,0.929,
  0.952,0.979,0.999,0.994,0.988,0.982,0.976,0.970,0.964,0.958,0.952,0.946,0.940,0.935,0.929,0.923,0.917,0.911,0.905,0.899,
  0.893,0.887,0.881,0.875,0.869,0.863,0.857,0.851,0.845,0.839,0.833,0.827,0.821,0.815,0.810,0.804,0.798,0.792,0.786,0.780,
  0.774,0.768,0.762,0.756,0.753,0.751,0.749,0.747,0.745,0.743,0.741,0.739,0.737,0.735,0.733,0.732,0.730,0.728,0.726,0.724,
  0.722,0.720,0.718,0.716,0.714,0.712,0.710,0.708,0.706,0.704,0.702,0.700,0.698,0.696,0.694,0.692,0.690,0.688,0.686,0.684,
  0.682,0.680,0.678,0.676,0.674,0.672,0.670,0.668,0.666,0.664,0.662,0.660,0.658,0.656,0.654,0.652,0.650,0.648,0.646,0.644,
  0.642,0.640,0.638,0.636,0.634,0.632,0.630,0.628,0.626,0.624,0.622,0.620,0.618,0.616,0.614,0.612,0.610,0.608,0.607,0.605,
  0.603,0.601,0.599,0.597,0.595,0.593,0.591,0.589,0.587,0.585,0.583,0.581,0.579,0.577,0.575,0.573,0.571,0.569,0.567,0.565,
  0.563,0.561,0.559,0.557,0.555,0.553,0.551,0.549,0.547,0.545,0.543,0.541,0.539,0.537,0.535,0.533,0.531,0.529,0.527,0.525,
  0.523,0.521,0.519,0.517,0.515,0.513,0.511,0.509,0.507,0.500,0.488,0.476,0.464,0.452,0.440,0.429,0.417,0.405,0.393,0.381,
  0.369,0.357,0.345,0.333,0.321,0.310,0.298,0.286,0.274,0.262,0.250,0.238,0.226,0.214,0.202,0.190,0.179,0.167,0.155,0.143,
  0.131,0.119,0.107,0.095,0.083,0.071,0.060,0.048,0.036,0.024,0.012,0.000,0.000,0.000,0.000,0.000};

 
// lookup table for output waveform
unsigned char wavetable[STEPS];
 
unsigned int frequencyCoef = 100;
bool soundEnabled = true;
bool soundPWM = false;
bool soundOn = false;
 
 //fm brass vars
 float i=0;
float delta=0;
int n=0;

int j=0;
float  k=0;
int count = 0;
int signal, mod1, env_signal; 

//ratio of w1/w2 will determine the sound and harmonics and all that
double w1 = 1;
int w2 = 4; 
int m = 0;
 
 //control vars
int currentVoice = 0;
 float x;
int tableNum;
int val2;    // sliderread 1 & 2 return variables
int val3;
int f;  // Global slider read variables
int f2;
int f3;
int what;
int cutoff;
int freq;
void USART_init(void);   // USART initialisation function
unsigned char USART_receive(void);  // USART recieve character function.
void USART_send( unsigned char data);   // USART send function
void USART_putstring(char* StringPtr);    // not used
char String[]="Hello world!!";    //String[] is in fact an array but when we put the text between the " " symbols the compiler threats it as a String and automatically puts the null termination character in the end of the text
 int data;
 

unsigned int value;    // global variable used in the USART recieve character interrupt as the data recieved
unsigned char vol;   // volume var
/*----------------------------------------------------
 functions to handle converting PCM to PWM and 
 outputting sound
 ----------------------------------------------------*/
 // Timer Interrupt 
// This is called at sampling freq to output 8-bit samples to PWM
ISR(TIMER1_COMPA_vect)
{
  static unsigned int phase0;
  static unsigned int sig0;
  static unsigned char flag = 0;
  static unsigned int tempphase;
 
  if (soundPWM)
  {
    tempphase = phase0 + frequencyCoef;
    sig0 = wavetable[phase0>>8];
    phase0 = tempphase;
    OCR2A = sig0>>vol; // output the sample
  } 
  else { //square wave 
    flag ^= 1;
    digitalWrite(speakerPin, flag);
  }
}      
 
 
 
void setupPWMSound()
{
  // Set up Timer 2 to do pulse width modulation on the speaker pin.
  // Use internal clock (datasheet p.160)
  ASSR &= ~(_BV(EXCLK) | _BV(AS2));
  // Set fast PWM mode  (p.157)
  TCCR2A |= _BV(WGM21) | _BV(WGM20);
  TCCR2B &= ~_BV(WGM22);
  // Do non-inverting PWM on pin OC2A (p.155)
  // On the Arduino this is pin 11.
  TCCR2A = (TCCR2A | _BV(COM2A1)) & ~_BV(COM2A0);
  TCCR2A &= ~(_BV(COM2B1) | _BV(COM2B0));
  // No prescaler (p.158)
  TCCR2B = (TCCR2B & ~(_BV(CS12) | _BV(CS11))) | _BV(CS10);
  // Set initial pulse width to the first sample.
  OCR2A = 0;
  // Set up Timer 1 to send a sample every interrupt.
  cli();
  // Set CTC mode (Clear Timer on Compare Match) (p.133)
  // Have to set OCR1A *after*, otherwise it gets reset to 0!
  TCCR1B = (TCCR1B & ~_BV(WGM13)) | _BV(WGM12);
  TCCR1A = TCCR1A & ~(_BV(WGM11) | _BV(WGM10));
  // No prescaler (p.134)
  TCCR1B = (TCCR1B & ~(_BV(CS12) | _BV(CS11))) | _BV(CS10);
  // Set the compare register (OCR1A).
  // OCR1A is a 16-bit register, so we have to do this with
  // interrupts disabled to be safe.
  OCR1A = INTERRUPT_PERIOD;
  // Enable interrupt when TCNT1 == OCR1A (p.136)
  TIMSK1 |= _BV(OCIE1A);
  sei();
  soundPWM = true;
}
 
void startSound()
{
  // Enable interrupt when TCNT1 == OCR1A (p.136)  
  cli();
  TIMSK1 |= _BV(OCIE1A);
  sei();
  soundOn = true;
} 
 
void stopSound()
{
  cli();  
  // Disable playback per-sample interrupt.
  TIMSK1 &= ~_BV(OCIE1A);
  sei();
  soundOn = false;
}
 
void setFrequency(unsigned int freq)
{
  if (soundPWM) {
    unsigned long templong = freq;
    frequencyCoef = templong * 65536 / FS;
  } 
  else {
    unsigned long periode = F_CPU/(2*freq); //multiply by 2, because its only toggled once per cycle
    cli();
    OCR1A = periode;
  }
}
 
/*----------------------------------------------------
 functions to determine the wavetable content
 ----------------------------------------------------*/
void loadVoice(int voice)
{
  if(soundOn) // if sound is on
  {
    stopSound(); // turn sound off
  }
  switch (voice)
  {
  // sine
  case 0:
    sineWave();
    break;
  // sawtooth
  case 1:
    sawtoothWave();
    break;
  // triangle
  case 2:
    triangleWave();
    break;
  // square
  case 3:
    squareWave();
    break;
  }
  if(!soundPWM) 
  {
    setupPWMSound();
  }
  startSound(); // start sound again
}
 
void sineWave()
{
  for (int i = 0; i < 256; ++i) {
    wavetable[i] = pgm_read_byte_near(sinetable + i);
  }
}
 
void sawtoothWave()
{
  for (int i = 0; i < 256; ++i) {
    wavetable[i] = i; // sawtooth
  }
}
 
 
void triangleWave()
{
  for (int i = 0; i < 128; ++i) {
    wavetable[i] = i * 2;
  }
  int value = 255;
  for (int i = 128; i < 256; ++i) {
    wavetable[i] = value;
    value -= 2;
  }
}
 
void squareWave()
{
  for (int i = 0; i < 128; ++i) {
    wavetable[i] = 187;
  }
  for (int i = 128; i < 256; ++i) {
    wavetable[i] = 0;
  }
}
 
/*----------------------------------------------------
 setup and loop functions
 ----------------------------------------------------*/
int prevButtonValue = 0;
 
void setup()
{ 
   USART_init();        //Call the USART initialization code
 sei();  // global interrupts
  pinMode(speakerPin, OUTPUT); 
  pinMode(buttonPin, INPUT); 
  // Choose one signal type to initially load into wavetable
  // 0 - sine
  // 1 - sawtooth
  // 2 - triangle
  // 3 - square  
  loadVoice(3);
} 
 
 
void loop() 
{
  // read all sensor values
  
  //read from potentiometer
 
 
 
 
}

int slider1read( int value1)   // read the Android GUI's slider 1 and return the value
{
 int valuesend=value; // read the serial
  if (valuesend !='q' && valuesend !='s')
  {
     
    value1=valuesend;
 
  }
  return value1;
}
int slider2read (int value2)   // read the Android GUI slider 2 and return the value
{
 int valuesend=value;// read the serial
if(valuesend <114 && valuesend !=113)
{
 value2=valuesend;
}
return value2;
  
}
int slider3read (int value3)   // read the Android slider 3 and return the value
{
 int valuesend=value;// read the serial
if(valuesend !=117)
{
 value3=valuesend;
}
return value3;
  
}

void USART_init(void){
 
 UBRR0H = (uint8_t)(BAUD_PRESCALLER>>8);
 UBRR0L = (uint8_t)(BAUD_PRESCALLER);
 UCSR0B = (1<<RXEN0)|(1<<TXEN0) | (1 << RXCIE0);
 UCSR0C = (3<<UCSZ00);
  pinMode(13,OUTPUT);
}
 
unsigned char USART_receive(void){
 
 while(!(UCSR0A & (1<<RXC0)));
 return UDR0;
 
}
 
void USART_send( unsigned char data){
 
 while(!(UCSR0A & (1<<UDRE0)));
 UDR0 = data;
 
}
 
void USART_putstring(char* StringPtr){
 
while(*StringPtr != 0x00){
 USART_send(*StringPtr);
 StringPtr++;}
 
}
int USART_putInt(int intData)
{
 
intData=  USART_receive();
  USART_send(intData);

  return intData;
}
// USART interrupt

ISR (USART0_RX_vect)    //USART recieve character interrupt. Much faster than polling and no clicks. :)
{

value = UDR0; // Fetch the received byte value into the variable "value"
UDR0 = value;   //Put the value to UDR
switch(UDR0)   // switch case for the characters sent from Android
{
  case 'q':
 val2=slider1read(f);     // change the wave frequency according to slider 1 value
 freq = map(slider1read(f), 0, 50, 440, 1320); 
  setFrequency(freq);
  break;
  case 'r':
  vol=map(slider2read(f2),0,100,8,0);     // change the volume according to slider 2 value
  //vol=slider2read(f2);
  break;
  case 's' :
  
   currentVoice = (currentVoice + 1) %4;    // change the wave shape when "wave" button on GUI is pressed. Switches between sine, square, tri and saw
     loadVoice(currentVoice);
     break;
  case 'u':
  cutoff=slider3read(f3);    // TODO: work out low pass filter in code.
 break;
  case 't' :
 
  break;
  case 'v':

  break;
 
  default:
  
  break;
// aSin.setFreq(slider1read((value*10)+100)); 
}
}

void decay(void) {     // experimenting with ADSR decay but how????
  int i, j;
  for (j=0; j<128; j++) {
    for (i=0; i<STEPS; i++) {
      if (wavetable[i]<127) {
        wavetable[i]++;
      }
      if (wavetable[i]>127) {
        wavetable[i]--;
      }
    }
    delay(10);
  }
 
}


