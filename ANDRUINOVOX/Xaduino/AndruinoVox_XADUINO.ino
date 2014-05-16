//S.Scutt Final Project. London Metropolitan University. Audio systems 2014.
//Modification of GordonJCP's FMTOY to work on XMEGA128a3. 
// Uses on board DAC as opposed to PWM. 
//Controlled by Bluetooth through Serial port 0 from an Android tablet. 
//Thanks to Erik.T (AVR_Freaks) for the advice on using the DAC. 


#include<avr/io.h> 
#include<avr/interrupt.h> 
#include <avr/pgmspace.h> 
#include <stdint.h> 
#include <avr/wdt.h>

int wshape=2;  // variables for case statement controlling LFO wave shape.
int wshape2=2;

// tables of 256 sine values / one sine period / stored in flash memory 
//sine wave for voice 1
PROGMEM  prog_uchar sine256[]  = { 
  127,130,133,136,139,143,146,149,152,155,158,161,164,167,170,173,176,178,181,184,187,190,192,195,198,200,203,205,208,210,212,215,217,219,221,223,225,227,229,231,233,234,236,238,239,240, 
  242,243,244,245,247,248,249,249,250,251,252,252,253,253,253,254,254,254,254,254,254,254,253,253,253,252,252,251,250,249,249,248,247,245,244,243,242,240,239,238,236,234,233,231,229,227,225,223, 
  221,219,217,215,212,210,208,205,203,200,198,195,192,190,187,184,181,178,176,173,170,167,164,161,158,155,152,149,146,143,139,136,133,130,127,124,121,118,115,111,108,105,102,99,96,93,90,87,84,81,78, 
  76,73,70,67,64,62,59,56,54,51,49,46,44,42,39,37,35,33,31,29,27,25,23,21,20,18,16,15,14,12,11,10,9,7,6,5,5,4,3,2,2,1,1,1,0,0,0,0,0,0,0,1,1,1,2,2,3,4,5,5,6,7,9,10,11,12,14,15,16,18,20,21,23,25,27,29,31,
  33,35,37,39,42,44,46,49,51,54,56,59,62,64,67,70,73,76,78,81,84,87,90,93,96,99,102,105,108,111,115,118,121,124 
}; 
//sine wave for voice 2
PROGMEM  prog_uchar sine256_2[]  = { 
  127,130,133,136,139,143,146,149,152,155,158,161,164,167,170,173,176,178,181,184,187,190,192,195,198,200,203,205,208,210,212,215,217,219,221,223,225,227,229,231,233,234,236,238,239,240, 
  242,243,244,245,247,248,249,249,250,251,252,252,253,253,253,254,254,254,254,254,254,254,253,253,253,252,252,251,250,249,249,248,247,245,244,243,242,240,239,238,236,234,233,231,229,227,225,223, 
  221,219,217,215,212,210,208,205,203,200,198,195,192,190,187,184,181,178,176,173,170,167,164,161,158,155,152,149,146,143,139,136,133,130,127,124,121,118,115,111,108,105,102,99,96,93,90,87,84,81,78, 
  76,73,70,67,64,62,59,56,54,51,49,46,44,42,39,37,35,33,31,29,27,25,23,21,20,18,16,15,14,12,11,10,9,7,6,5,5,4,3,2,2,1,1,1,0,0,0,0,0,0,0,1,1,1,2,2,3,4,5,5,6,7,9,10,11,12,14,15,16,18,20,21,23,25,27,29,31,
  33,35,37,39,42,44,46,49,51,54,56,59,62,64,67,70,73,76,78,81,84,87,90,93,96,99,102,105,108,111,115,118,121,124 
}; 
// LFO saw tooth wave
PROGMEM prog_uchar sine256_3[] = {
0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 
25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 
48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70,
71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93,
94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113,
114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132,
133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151,
152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170,
171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189,
190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208,
209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227,
228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246,
247, 248, 249, 250, 251, 252, 253, 254, 255, };
// LFO square wave
PROGMEM prog_uchar sine256_4[] = {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255
,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255
,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255
,255,255,255,255,255,255,255,255,255,255,255,255,255,};
//LFO Random waveshape. Good for percussive sounds.
PROGMEM prog_uchar sine256_5[] = {
104,29,89,98,20,87,73,40,123,111,184,104,254,194,197,250,88,144,
144,126,159,217,196,3,170,87,241,164,207,197,129,233,46,74,138,101
,14,149,195,147,244,181,117,175,184,152,76,69,141,162,115,97,216,
63,134,69,155,164,252,166,15,247,83,185,112,192,169,215,208,89,29,
128,94,162,251,158,180,192,209,13,241,251,171,127,174,180,244,64,
55,14,72,200,96,92,116,5,253,117,16,40,59,22,114,131,169,178,192,
193,248,74,224,51,119,91,24,172,56,200,83,241,94,126,201,79,79,76
,39,159,121,169,195,198,60,73,187,87,207,203,131,226,130,217,61,
141,174,108,142,241,15,71,50,209,31,228,24,152,203,220,210,217,9,
183,36,134,89,158,235,207,127,163,144,160,139,224,2,168,56,245,
196,179,160,34,29,53,179,78,243,59,208,49,192,116,176,57,42,33,
234,61,72,80,148,37,189,184,178,156,19,150,42,159,14,53,128,205,
171,107,154,51,213,42,48,203,90,240,219,17,197,102,164,202,88,43
,229,83,163,166,128,102,79,83,228,212,115,11,64,131,127,7,59,139
,236,100,242,120,116,174,};

// MIDI note pitches in Hz 
PROGMEM float pitchtable[] = { 
8.18,  8.66,  9.18,  9.72,  10.30,  10.91,  11.56,  12.25,  12.98,  13.75,  14.57,  15.43,  16.35,  17.32,  18.35,  19.45,  20.60,  21.83,  23.12,  24.50,  25.96,  27.50,  29.14,  30.87,  32.70,  34.65,  36.71,  38.89,  41.20,  43.65,  46.25,  49.00,  51.91,  55.00,  58.27,  61.74,  65.41,  69.30,  73.42,  77.78,  82.41,  87.31,  92.50,  98.00,  103.83,  110.00,  116.54,  123.47,  130.81,  138.59,  146.83,  155.56,  164.81,  174.61,  185.00,  196.00,  207.65,  220.00,  233.08,  246.94,  261.63,  277.18,  293.66,  311.13,  329.63,  349.23,  369.99,  392.00,  415.30,  440.00,  466.16,  493.88,  523.25,  554.37,  587.33,  622.25,  659.26,  698.46,  739.99,  783.99,  830.61,  880.00,  932.33,  987.77,  1046.50,  1108.73,  1174.66,  1244.51,  1318.51,  1396.91,  1479.98,  1567.98,  1661.22,  1760.00,  1864.66,  1975.53,  2093.00,  2217.46,  2349.32,  2489.02,  2637.02,  2793.83,  2959.96,  3135.96,  3322.44,  3520.00,  3729.31,  3951.07,  4186.01,  4434.92,  4698.64,  4978.03,  5274.04,  5587.65,  5919.91,  6271.93,  6644.88,  7040.00,  7458.62,  7902.13,  8372.02,  8869.84,  9397.27,  9956.06,  10548.08,  11175.30,  11839.82,  12543.85, 
};
PROGMEM float pitchtable2[] = { 
8.18*2,  8.66*2,  9.18*2,  9.72*2,  10.30*2,  10.91*2,  11.56*2,  12.25*2,  12.98*2,  13.75*2,  14.57*2,  15.43*2,  16.35*2,  17.32*2,  18.35*2,  19.45*2,  20.60*2,  21.83*2,  23.12*2,  24.50*2,  25.96*2,  27.50*2,  29.14*2,  30.87*2,  32.70*2,  34.65*2,  36.71*2,  38.89*2,  41.20*2,  43.65*2,  46.25*2,  49.00*2,  51.91*2,  55.00*2,  58.27*2,  61.74*2,  65.41*2,  69.30*2,  73.42*2,  77.78*2,  82.41*2,  87.31*2,  92.50*2,  98.00*2,  103.83*2,  110.00*2,  116.54*2,  123.47*2,  130.81*2,  138.59*2,  146.83*2,  155.56,  164.81*2,  174.61*2,  185.00*2,  196.00*2,  207.65*2,  220.00*2,  233.08*2,  246.94*2,  261.63*2,  277.18*2,  293.66*2,  311.13*2,  329.63*2,  349.23*2,  369.99*2,  392.00*2,  415.30*2,  440.00*2,  466.16*2,  493.88*2,  523.25*2,  554.37*2,  587.33*2,  622.25*2,  659.26*2,  698.46*2,  739.99*2,  783.99*2,  830.61*2,  880.00*2,  932.33*2,  987.77*2,  1046.50*2,  1108.73*2,  1174.66*2,  1244.51*2,  1318.51*2,  1396.91*2,  1479.98*2,  1567.98*2,  1661.22*2,  1760.00*2,  1864.66*2,  1975.53*2,  2093.00*2,  2217.46*2,  2349.32*2,  2489.02*2,  2637.02*2,  2793.83*2,  2959.96*2,  3135.96*2,  3322.44*2,  3520.00*2,  3729.31*2,  3951.07*2,  4186.01*2,  4434.92*2,  4698.64*2,  4978.03*2,  5274.04*2,  5587.65*2,  5919.91*2,  6271.93*2,  6644.88*2,  7040.00*2,  7458.62*2,  7902.13*2,  8372.02*2,  8869.84*2,  9397.27*2,  9956.06*2,  10548.08*2,  11175.30*2,  11839.82*2,  12543.85*2, 
}; 
// structure for voice and patches
typedef struct { 
    // Patch structure 
    // parameters stored as bytes, containing values from 0-127 
    // exactly as received over MIDI 

    // Operator 1 
    byte op1_ratio;   // 0-127, only 0-7 useful 
    byte op1_detune;  // -64 to 63, u64 = 0 
    byte op1_lfo;     // 0-127, scaled 
    byte op1_gain;    // 0-127, scaled 
    byte op1_env;     // -64 to 63, u64 = 0 
    byte op1_a, op1_d, op1_s, op1_r; 

    // Operator 2 
    byte op2_ratio; 
    byte op2_detune; 
    byte op2_lfo; 
    byte op2_gain; 
    byte op2_env; 
    byte op2_a, op2_d, op2_s, op2_r; 
    
    // lfo 
    byte lfo_rate; 
    byte lfo_shape; 
    byte lfo_delay; 
    
    // instrument 
    byte portamento; 
    byte fb; 
} patch; 

typedef struct { 
    // Patch structure 
    // parameters stored as bytes, containing values from 0-127 
    // exactly as received over MIDI 

    // Operator 1 
    byte op3_ratio;   // 0-127, only 0-7 useful 
    byte op3_detune;  // -64 to 63, u64 = 0 
    byte op3_lfo;     // 0-127, scaled 
    byte op3_gain;    // 0-127, scaled 
    byte op3_env;     // -64 to 63, u64 = 0 
    byte op3_a, op3_d, op3_s, op3_r; 

    // Operator 2 
    byte op4_ratio; 
    byte op4_detune; 
    byte op4_lfo; 
    byte op4_gain; 
    byte op4_env; 
    byte op4_a, op4_d, op4_s, op4_r; 
    
    // lfo 
    byte lfo_rate2; 
    byte lfo_shape2; 
    byte lfo_delay2; 
    
    // instrument 
    byte portamento2; 
    byte fbB; 
} patch2; 

// Voice Patches
// if you add more patches, don't forget to change the limit in set_patch() 
PROGMEM patch patches[] = { 
    {2, 64, 3, 5, 82, 0, 83, 0, 75, 2, 64, 3, 64, 127, 68, 80, 75, 64, 25, 0, 0, 0, 73, },
{1, 64, 0, 77, 127, 0, 75, 0, 75, 7, 64, 0, 64, 127, 0, 91, 0, 0, 64, 0, 0, 0, 38, },
    {6, 64, 0, 3, 98, 0, 79, 0, 75, 2, 64, 0, 64, 127, 0, 80, 75, 64, 24, 0, 0, 0, 0, },
    {1, 64, 5, 49, 127, 48, 101, 0, 75, 2, 64, 5, 64, 127, 0, 80, 75, 64, 19, 0, 0, 0, 56, },
    {7, 64, 0, 12, 79, 0, 75, 0, 75, 2, 64, 0, 64, 127, 0, 91, 0, 90, 64, 0, 0, 0, 0, },
    {7, 64, 0, 12, 79, 0, 75, 0, 75, 1, 64, 0, 64, 127, 0, 91, 0, 90, 64, 0, 0, 0, 0, },
    {1, 64, 0, 12, 79, 0, 75, 0, 75, 7, 64, 0, 64, 127, 0, 91, 0, 90, 64, 0, 0, 0, 0, },
    {4, 64, 0, 2, 94, 0, 66, 0, 75, 2, 64, 0, 64, 127, 0, 80, 75, 64, 24, 0, 0, 0, 37, },

}; 

PROGMEM patch2 patches2[] = { 
    {2, 64, 3, 5, 82, 0, 83, 0, 75, 2, 64, 3, 64, 127, 68, 80, 75, 64, 25, 0, 0, 0, 73, },
{1, 64, 0, 77, 127, 0, 75, 0, 75, 7, 64, 0, 64, 127, 0, 91, 0, 0, 64, 0, 0, 0, 38, },
    {6, 64, 0, 3, 98, 0, 79, 0, 75, 2, 64, 0, 64, 127, 0, 80, 75, 64, 24, 0, 0, 0, 0, },
    {1, 64, 5, 49, 127, 48, 101, 0, 75, 2, 64, 5, 64, 127, 0, 80, 75, 64, 19, 0, 0, 0, 56, },
    {7, 64, 0, 12, 79, 0, 75, 0, 75, 2, 64, 0, 64, 127, 0, 91, 0, 90, 64, 0, 0, 0, 0, },
    {7, 64, 0, 12, 79, 0, 75, 0, 75, 1, 64, 0, 64, 127, 0, 91, 0, 90, 64, 0, 0, 0, 0, },
    {1, 64, 0, 12, 79, 0, 75, 0, 75, 7, 64, 0, 64, 127, 0, 91, 0, 90, 64, 0, 0, 0, 0, },
    {4, 64, 0, 2, 94, 0, 66, 0, 75, 2, 64, 0, 64, 127, 0, 80, 75, 64, 24, 0, 0, 0, 37, },


}; 
// Voice patch index numbers
#define N_PATCH 8
#define N_PATCH2 8 
// shortcuts for clearing and setting bits
#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit)) 
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit)) 

// envelopes 
byte eg1_phase, eg2_phase; 
float eg1_rate[3], eg1_rate_level[3]; 
float eg2_rate[3], eg2_rate_level[3]; 
float eg1_s, eg2_s; 
float eg1, eg2; 

byte eg3_phase, eg4_phase; 
float eg3_rate[3], eg3_rate_level[3]; 
float eg4_rate[3], eg4_rate_level[3]; 
float eg3_s, eg4_s; 
float eg3, eg4; 
//tuning words 
double dfreq; 
double tfreq; 
double dfreq2; 
double tfreq2; 

// note, velocity, pitchbend, modulator vars
char note2; 
char velocity2; 
char modwheel2; 
char cutoff2; 
char note; 
char velocity; 
char modwheel; 
char cutoff; 

// const double refclk=31372.549;  // =16MHz / 510 
const double refclk=31250.0; 

// midi note queue variables 
#define NOTEQUEUE 12 
char notes[NOTEQUEUE]; 
#define NOTEQUEUE2 12 
char notesB[NOTEQUEUE2]; 
// MIDI byte message variables read by Serial.
byte st, p1, p2; 

// variables used inside interrupt service declared as voilatile 
// variables for phase increments, Feedback and DAC outputs
volatile byte icnt;              // var inside interrupt 
volatile byte icnt1;             // var inside interrupt 
volatile byte y1, fb1;           // feedback 
volatile byte y2; 
volatile unsigned int fb2;    // mod depth 

volatile byte icntB;              // var inside interrupt 
volatile byte icnt1B;             // var inside interrupt 
volatile byte y1B, fb1B;           // feedback 
volatile byte y2B; 
volatile unsigned int fb2B;    // mod depth 

volatile unsigned long phaccu1;   // phase accumulator 
volatile unsigned long phaccu2;   // phase accumulator 
volatile byte fb; 

volatile unsigned long phaccu1B;   // phase accumulator 
volatile unsigned long phaccu2B;   // phase accumulator 
volatile byte fbB; 

volatile unsigned int gain1; 
volatile unsigned int gain2; 
volatile unsigned long tword_m1;  // dds tuning word m 
volatile unsigned long tword_m2;  // dds tuning word m 

volatile unsigned int gain1B; 
volatile unsigned int gain2B; 
volatile unsigned long tword_m1B;  // dds tuning word m 
volatile unsigned long tword_m2B;  // dds tuning word m 

// update variable to update MID & Voice status
volatile byte do_update; 

// lfo tuning and phase accumulators
unsigned int tword_lfo; 
unsigned int phaccu_lfo; 
float lfo; 
byte lfo_icnt; 

unsigned int tword_lfoB; 
unsigned int phaccu_lfoB; 
float lfoB; 
byte lfo_icntB; 

float portamento; 
float portamentoB; 

/* controllers  Pitch Bend deprecated
float bend, mod=1;
float bendB, modB=1;
*/
int i; // random general purpose counter 
int i2;
// current ads to patch struct
patch current; 
patch2 current2; 
// Wiring gets in the way of using structs 
// so we just do both in one handler 
// Envelope update functions for all 4 Operators
void set_env() { 
    float k,k2; 
    eg1_s = current.op1_s/127.0;    
    k = exp(-4*(current.op1_a/127.0)*2.3); 
    eg1_rate_level[0] = k * 0.99; // attack time 
    eg1_rate[0] = 1 - k; 
    k = exp(-4*(current.op1_d/127.0)*2.3); 
    eg1_rate_level[1] = k * eg1_s * 0.99; 
    eg1_rate[1] = 1 - k; 
    k = exp(-4*(current.op1_r/127.0)*2.3); 
    eg1_rate_level[2] = 0; // final level 
    eg1_rate[2] = 1-k; 
    
    eg2_s = current.op2_s/127.0;    
    k = exp(-4*(current.op2_a/127.0)*2.3); 
    eg2_rate_level[0] = k * 0.99; // attack time 
    eg2_rate[0] = 1 - k; 
    k = exp(-4*(current.op2_d/127.0)*2.3); 
    eg2_rate_level[1] = k * eg2_s * 0.99; 
    eg2_rate[1] = 1 - k; 
    k = exp(-4*(current.op2_r/127.0)*2.3); 
    eg2_rate_level[2] = 0; // final level 
    eg2_rate[2] = 1-k; 
    
     eg3_s = current2.op3_s/127.0;    
    k2 = exp(-4*(current2.op3_a/127.0)*2.3); 
    eg3_rate_level[0] = k2 * 0.99; // attack time 
    eg3_rate[0] = 1 - k2; 
    k2 = exp(-4*(current2.op3_d/127.0)*2.3); 
    eg3_rate_level[1] = k2 * eg3_s * 0.99; 
    eg3_rate[1] = 1 - k2; 
    k2 = exp(-4*(current2.op3_r/127.0)*2.3); 
    eg3_rate_level[2] = 0; // final level 
    eg3_rate[2] = 1-k2; 
    
    eg4_s = current2.op4_s/127.0;    
    k2 = exp(-4*(current2.op4_a/127.0)*2.3); 
    eg4_rate_level[0] = k2 * 0.99; // attack time 
    eg4_rate[0] = 1 - k2; 
    k2 = exp(-4*(current2.op4_d/127.0)*2.3); 
    eg4_rate_level[1] = k2 * eg4_s * 0.99; 
    eg4_rate[1] = 1 - k2; 
    k2 = exp(-4*(current2.op4_r/127.0)*2.3); 
    eg4_rate_level[2] = 0; // final level 
    eg4_rate[2] = 1-k2; 
    
} 
// Set the synth patch
void set_patch(int p) { 
    // Fetch a patch from ROM 
    
    if (p > N_PATCH) p=0;// only have one patch! update when we add more 
    patch *ptr = &patches[p]; 
    memcpy_P(&current, ptr, sizeof(patch)); 
    fb = current.fb; 
    set_env(); 
    tword_lfo = pow(2,16)*current.lfo_rate/4000; 
     
} 

void set_patch2(int p) { 
    // Fetch a patch from ROM 
    
    if (p > N_PATCH2) p=N_PATCH2;// only have one patch! update when we add more 
    patch2 *ptr = &patches2[p]; 
    memcpy_P(&current2, ptr, sizeof(patch2)); 
    fbB = current2.fbB; 
    set_env(); 
    tword_lfoB = pow(2,16)*current2.lfo_rate2/4000; 
} 
// Initialise Interrupt timer & DAC 
void initialization ( void ) 
{ 
 cli ();   // Disable interrupts 
 // # # # # # # # # # # # # # # # # # 
  
 OSC_PLLCTRL = 16;  // PLL mult. factor ( 2MHz x8 ) and set clk source to PLL. 

OSC_CTRL = 0x10;    // Enable PLL 

while( !( OSC_STATUS & 0x10 ) );    // Is PLL clk rdy to go ? 

CCP = 0xD8; //Unlock seq. to access CLK_CTRL 
CLK_CTRL = 0x04;  // Select PLL as sys. clk. These 2 lines can ONLY go here to engage the PLL ( reverse of what manual A pg 81 says ) 
 // # # # # # # # # # # # # # # # # # Timer0 - 1Khz 
  TCC0.CTRLA  = TC_CLKSEL_DIV256_gc ;  // Prescaler 256 
  TCC0.CTRLB  =  0x00 ;  // select mode: Normal 
 TCC0.PER  =  4 ;  // counter top value of 1000 Hz  // 16000000/256/2 for interrupt :32KHz 
 TCC0.CNT  =  0x00 ;  // Reset counter 
 TCC0.INTCTRLA  =  0b00000011 ;  // Interrupt High Level 
  
 // # # # # # # # # # # # # # # # Share # # interrupts high-, medium-and lowlevel 
 PMIC.CTRL  |= PMIC_HILVLEN_bm | PMIC_MEDLVLEN_bm | PMIC_LOLVLEN_bm ; 
 // Setting up the DAC Single Conversion mode.    
   DACB.CTRLB=0b01000000; 
   DACB.CTRLC=0x00; 
   DACB.TIMCTRL=0; 
   DACB.CTRLA=0b00001101; 
 sei ();  // interrupts enabled 
} 

void setup2() 
{ 
  
  Serial.begin(38400);        // connect to the Serial port 
  Serial.println("FMToy"); 
  
pinMode(5,OUTPUT);
  
  
  set_patch(0); 
  set_patch2(0);
  
 pinMode(2, INPUT); 

  analogWrite(3, 255); 
} 

int main(void) 
{ 
 setup2(); 
  initialization(); 
  while(1){ 
   // st=0x90;p1=69;p2=125; 
  byte note = 60; 
  byte note2=60;
  while(Serial.available()<10) { 
    // has update changed?
     if (do_update) { 
      do_update=0; 
      st=Serial.read(); 

      if (st != 0xff) { 

        // crufty, not all statuses expect two values 
        if (st >= 0x80 ) { // note off 
          do { 
            p1 = Serial.read(); 
            
          } while (p1 == 0xff); 
          if (st != 0xc0) do {  // don't wait for a second byte 
            p2 = Serial.read(); 
            
          } while (p2 == 0xff); 
        } 
        // If there is a note off or velocity 0 message start envelope phase 2
        if ((st == 0x90 && p2 == 0) || st == 0x80) { 
         eg1_phase=2; 
            eg2_phase=2; 
            
             digitalWrite(13, LOW);  // LED off 
        } 
            if ((st == 0x91 && p2 == 0) || st == 0x81) { 
         
            eg3_phase=2; 
            eg4_phase=2; 
             digitalWrite(13, LOW);  // LED off 
        } 
          int j, k; 
          k = notes[0];  // keep current key 
          // remove note from note queue 
          for(i=0; i<NOTEQUEUE; i++) { 
            if (p1==notes[i]) { 
              // nudge rest up 
              for(j=i+1; j<NOTEQUEUE; j++) { 
                notes[j-j] = notes[j]; 
              } 
              notes[NOTEQUEUE-1]=0; 
              break; 
            } 
          } 
           int j2, k2; 
          k2 = notesB[0];  // k2eep current k2ey 
          // remove note from note queue 
          for(i2=0; i2<NOTEQUEUE2; i2++) { 
            if (p1==notesB[i2]) { 
              // nudge rest up 
              for(j2=i2+1; j2<NOTEQUEUE2; j2++) { 
                notesB[j2-j2] = notesB[j2]; 
              } 
              notesB[NOTEQUEUE2-1]=0; 
              break; 
            } 
          } 
          if (notes[0]!=k && notes[0]!=0) { 
            // top note released 
           // note = notes[0]; 
            tfreq=pgm_read_float_near(pitchtable+note); 
            // tfreq2=pgm_read_float_near(pitchtable+note);      
         
          
          if (notes[0]==0) { 
            // no notes left to play 
            digitalWrite(13, LOW);  // LED off 
            // envelopes to release 
            eg1_phase=2; 
            eg2_phase=2; 
           
           
            
          } 

      } 
      
       if (notesB[0]!=k2 && notesB[0]!=0) { 
            // top note released 
           // note = notesB[0]; 
            
             tfreq2=pgm_read_float_near(pitchtable+note2);      
          
          
          if (notesB[0]==0) { 
           // start envelope release
            eg3_phase=2; 
            eg4_phase=2; 
             } 

          }
         // if there is a note on message 
       if (st ==0x90 && p2 > 0) { 
          // scan for highest note 
          int j, k; 
          k = notes[0]; 
         for(i=0; i<NOTEQUEUE; i++) { 
            if (p1>=notes[i]) 
              // nudge rest down 
              for(j=NOTEQUEUE-1; j>=i; j--) 
                notes[j-1] = notes[j]; 
              
              notes[i]=p1; 
             // Serial.println(k); 
              break; 
                    
          } 
            
          if (notes[0]!=k) { 
            // top note released 
            note = notes[0]; 
              
            tfreq=pgm_read_float_near(pitchtable+note);
           
           
          } 
            // note on, set target frequency 
            if (k==0) { 
                // new note; 
                eg1_phase=0; 
                eg2_phase=0; 
                velocity = p2; 
                phaccu1=0; 
                phaccu2=0; 
               
                
            } 

            digitalWrite(13, HIGH);  // LED on 
     
        }
         if (st ==0x91 && p2 > 0) { 
          // scan for highest note 
          int j2, k2; 
          k2 = notesB[0]; 
         for(i2=0; i2<NOTEQUEUE2; i2++) { 
            if (p1>=notesB[i2]) 
              // nudge rest down 
              for(j2=NOTEQUEUE2-1; j2>=i2; j2--) 
                notesB[j2-1] = notesB[j2]; 
              
              notesB[i2]=p1; 
             // Serial.println(k2); 
              break; 
                    
          } 
            
          if (notesB[0]!=k2) { 
            // top note released 
            note2 = notesB[0]; 
            tfreq2=pgm_read_float_near(pitchtable+note2); 
          } 
          
            // note on, set target frequency 
            if (k2==0) { 
                // new note; 
                
                eg3_phase=0; 
                eg4_phase=0; 
                velocity2 = p2; 
                phaccu1B=0; 
                phaccu2B=0; 
                
            } 
        }
         //Switch case statement for controller messages.
       if (st == 0xB0) { 
          switch(p1) { 
            // LFO waveshape button pressed???
             case 11:
            switch(p2)
            {
             case 0:
            wshape=0;
           break; 
           case 1:
           wshape=1;
           break;
           case 2:
           wshape=2;
           break;
           case 3:
           wshape=3;
           break;
           default:
           break;
            }
            case 12:
            switch(p2)
            {
             case 0:
            wshape2=0;
           break; 
           case 1:
           wshape2=1;
           break;
           case 2:
           wshape2=2;
           break;
           case 3:
           wshape2=3;
           break;
           default:
           break;
            }
                
            case 28: current.op1_gain = p2; break;
                     current2.op3_gain = p2; break;   // Op1 Level 
            case 29: { 
                current.op1_lfo = p2; // set LFO level for both 
                current.op2_lfo = p2; 
                //current2.op3_lfo = p2; // set LFO level for both 
                //current2.op4_lfo = p2; 
                break; 
            } 
            case 30: current.op1_env = p2;
                     current2.op3_env = p2;
            break;    // Op1 EG Depth 
           // attack
            case 108: { 
                current.op2_a = p2; 
                set_env();
                current2.op4_a = p2; 
                set_env(); 
                break; 
            } 
            //decay
            case 109: { 
                current.op2_d = p2; 
                set_env(); 
                current2.op4_d = p2; 
                set_env(); 
                break; 
            } 
            //sustain
            case 110: { 
                current.op2_s = p2; 
                set_env();
               current2.op4_s = p2; 
                set_env(); 
                break; 
            } 
            //release
            case 111: { 
                current.op2_r = p2; 
                set_env();
               current2.op4_r = p2; 
                set_env(); 
                break; 
            } 
            //attack
            case 114: { 
                current.op1_a = p2; 
                set_env(); 
                current2.op3_a = p2; 
                set_env(); 
                break; 
            } 
            //decay
            case 115: { 
                current.op1_d = p2; 
                set_env(); 
                 current2.op3_d = p2; 
                set_env(); 
                break; 
            } 
            // sustain
            case 116: { 
                current.op1_s = p2; 
                set_env(); 
                 current2.op3_s = p2; 
                set_env(); 
                break; 
            } 
            // release
            case 117: { 
                current.op1_r = p2; 
                set_env(); 
                 current2.op3_r = p2; 
                set_env(); 
                break; 
            } 
            // op 1 ratio
            case 41:    // osc1 ratio 
                current.op1_ratio = p2;
               
                break; 
                
            case 23:    // feedback 
                current.fb = p2; 
                fb = current.fb; 
                current2.fbB = p2; 
                fbB = current2.fbB; 
                break; 
           
            case 16:    // lfo speed 
                current.lfo_rate = p2; 
                tword_lfo = pow(2,16)*p2/4000; 
                 current2.lfo_rate2 = p2; 
                tword_lfoB = pow(2,16)*p2/4000; 
                break; 
            case 17:    // detune 
                current.op1_detune=p2; 
               // current2.op3_detune=p2; 
                
                break; 
                 case 50: 
                     current2.op3_gain = p2; break;   // Op1 Level 
            case 51: { 
             
                current2.op3_lfo = p2; // set LFO level for both 
                current2.op4_lfo = p2; 
                break; 
            } 
            case 52: 
                     current2.op3_env = p2;
            break;    // Op1 EG Depth 
      /* Envelopes 3 & 4 controllers for ADSR */
            case 53: { 
               
                current2.op4_a = p2; 
                set_env(); 
                break; 
            } 
            case 54: { 
               
                current2.op4_d = p2; 
                set_env(); 
                break; 
            } 
            case 55: { 
               
               current2.op4_s = p2; 
                set_env(); 
                break; 
            } 
            case 56: { 
               
               current2.op4_r = p2; 
                set_env(); 
                break; 
            } 
            case 57: { 
                
                current2.op3_a = p2; 
                set_env(); 
                break; 
            } 
            case 58: { 
                
                 current2.op3_d = p2; 
                set_env(); 
                break; 
            } 
            case 59: { 
               
                 current2.op3_s = p2; 
                set_env(); 
                break; 
            } 
            case 60: { 
                
                 current2.op3_r = p2; 
                set_env(); 
                break; 
            } 
            
            case 61:    // osc1 ratio 
                
                current2.op3_ratio = p2; 
                break; 
            case 62:    // feedback 
                
                current2.fbB = p2; 
                fbB = current2.fbB; 
                break; 
            case 63:    // lfo speed 
                 
                 current2.lfo_rate2 = p2; 
                tword_lfoB = pow(2,16)*p2/4000; 
                break; 
            case 64:    // lfo speed 
               
                current2.op3_detune=p2; 
                
                break;  
                // Voice Gains.
                case 94:
                current.op1_gain=p2;
                break;
                 case 95:
                current.op2_gain=p2;
                break; 
                case 96:
                current2.op3_gain=p2;
                break; 
                case 97:
                current2.op4_gain=p2;
                break;
            
            case 105:    // "real" cutoff 
            // deprecated
                analogWrite(3, p2*2); 
                break; 
// init rebbot switch (reset the Xaduino.)
            case 234: 
             software_Reboot();
                break; 

            default:  break; 
          }            
       } 
      } 
      // change Voice patch
      if (st == 's') { 
        Serial.flush();
        int pa; 
          set_patch(pa++); 
          set_patch2(pa++); 
          if (pa>20) 
          pa=0; 
      }
           
      
      
      // update the voices 
      
      phaccu_lfo += tword_lfo; 
      lfo_icnt = phaccu_lfo >> 8; 
     // LFO switch case changes LFO Waveshape
      switch(wshape)
      {
        case 0:
      lfo = (pgm_read_byte_near(sine256_3+lfo_icnt)-127)/128.0f;
     break;
    case 1:
    lfo = (pgm_read_byte_near(sine256_4+lfo_icnt)-127)/128.0f;//saw
    break;
    case 2:
    lfo = (pgm_read_byte_near(sine256+lfo_icnt)-127)/128.0f;//sqr
    break;
    case 3:
     lfo = (pgm_read_byte_near(sine256_5+lfo_icnt)-127)/128.0f;//tri
     break;
    default:
    lfo = (pgm_read_byte_near(sine256+lfo_icnt)-127)/128.0f;
    break;
      }
      /*****************************************************/
    //    lfo = (pgm_read_byte_near(sine256_4+lfo_icnt)-127)/128.0f;//sqr
   
      eg1 = eg1_rate_level[eg1_phase] + eg1_rate[eg1_phase] * eg1; 
      if (!eg1_phase && eg1 > 0.98) eg1_phase=1; 

      eg2 = eg2_rate_level[eg2_phase] + eg2_rate[eg2_phase] * eg2; 
      if (!eg2_phase && eg2 > 0.98) eg2_phase=1; 
      
      
      gain1 = (current.op1_gain<<1) + (eg1 * ((current.op1_env-64)<<1));// + keyfollow ; 
      if (gain1 < 0) gain1 = 0; 
      
      gain2 = (current.op2_env<<1)*eg2; 
   
      dfreq=tfreq; 
      tword_m1 = pow(2,32)*((dfreq* current.op1_ratio)/2 * (1+(lfo*current.op1_lfo)/256.0))/refclk; 
      tword_m2 = pow(2,32)*((dfreq* current.op2_ratio)/2 * (1+(lfo*current.op2_lfo)/256.0))/refclk; 
      
       phaccu_lfoB += tword_lfoB; 
      lfo_icntB = phaccu_lfoB >> 8; 
      // switch statement for LFO waveshape of Sequencer LFO
      switch(wshape2)
      {
        case 0:
      lfoB = (pgm_read_byte_near(sine256_3+lfo_icnt)-127)/128.0f;
     break;
    case 1:
    lfoB = (pgm_read_byte_near(sine256_4+lfo_icnt)-127)/128.0f;//saw
    break;
    case 2:
    lfoB = (pgm_read_byte_near(sine256_2+lfo_icnt)-127)/128.0f;//sqr
    break;
    case 3:
     lfoB = (pgm_read_byte_near(sine256_5+lfo_icnt)-127)/128.0f;//tri
     break;
    default:
    lfoB = (pgm_read_byte_near(sine256+lfo_icnt)-127)/128.0f;
    break;
      }
     // lfoB = (pgm_read_byte_near(sine256_2+lfo_icntB)-127)/128.0f; 
    
      eg3 = eg3_rate_level[eg3_phase] + eg3_rate[eg3_phase] * eg3; 
      if (!eg3_phase && eg3 > 0.98) eg3_phase=1; 

      eg4 = eg4_rate_level[eg4_phase] + eg4_rate[eg4_phase] * eg4; 
      if (!eg4_phase && eg4 > 0.98) eg4_phase=1; 
      
      
      gain1B = (current2.op3_gain<<1) + (eg3 * ((current2.op3_env-64)<<1));// + keyfollow ; 
      if (gain1B < 0) gain1B = 0; 
      
      gain2B = (current2.op4_env<<1)*eg4; 
  
      //dfreq = portamento*tfreq+(1-portamento)*dfreq; 
      dfreq2=tfreq2; 
      tword_m1B = pow(2,32)*((dfreq2* current2.op3_ratio)/2 * (1+(lfoB*current2.op3_lfo)/256.0))/refclk; 
      tword_m2B = pow(2,32)*((dfreq2* current2.op4_ratio)/2 * (1+(lfoB*current2.op4_lfo)/256.0))/refclk; 
    } 
     
    
  } 
} 
 } 
//****************************************************************** 
// timer setup 


// Serial timer interrupt 
//****************************************************************** 
// Timer2 Interrupt Service at 31372,550 KHz = 32uSec 
// this is the timebase REFCLOCK for the DDS generator 
// FOUT = (M (REFCLK)) / (2 exp 32) 
// runtime : 8 microseconds ( inclusive push and pop) 
volatile int out,out2; 
ISR ( TCC0_OVF_vect ) { 
  // internal timer 
  if(icnt1++ > 31) { // slightly faster than 1ms 
    do_update=1; 
    icnt1=0; 
   }    
  
    // operator 1 
  phaccu1=phaccu1+tword_m1; 
  icnt=phaccu1 >> 24; 
  y1 = pgm_read_byte_near(sine256 + ((icnt+fb1) % 256)); 
  fb1 = fb*(y1 + fb1) >> 8; 

    // operator 2 
  phaccu2=phaccu2+tword_m2; 
  icnt=phaccu2 >> 24;  
  //fb2 = gain1*(y1) >> 8-(gain1>>1); 
  fb2 = ((gain1*y1)>>6)-(gain1>>1); 
  y2 = pgm_read_byte_near(sine256 + ((icnt+fb2)%256));  

    // operator 3
    
  phaccu1B=phaccu1B+tword_m1B; 
  icntB=phaccu1B >> 24; 
  y1B = pgm_read_byte_near(sine256_2 + ((icntB+fb1B) % 256)); 
  fb1B = fbB*(y1B + fb1B) >> 8; 
  
   // operator 4 
  phaccu2B=phaccu2B+tword_m2B; 
  icntB=phaccu2B >> 24;  
  //fb2 = gain1*(y1) >> 8-(gain1>>1); 
  fb2B = ((gain1B*y1B)>>6)-(gain1B>>1); 
  y2B = pgm_read_byte_near(sine256_2 + ((icntB+fb2B)%256));  
    // set the DAC output 

   out = ((gain2*y2)>>8)-(gain2>>1); 
   out2 = ((gain2B*y2B)>>8)-(gain2B>>1); 

    // DC restore and clip output 
   out += 127; 
    out >>=1; 
    if (out<0) out=0; 
    if (out>0xff) out = 0xff; 
    
    out2 += 127; 
    out2 >>=1; 
    if (out2<0) out=0; 
    if (out2>0xff) out2 = 0xff; 
    
    DACB.CH0DATA=(out<<4); 
    DACB.CH1DATA=(out2<<4); 
}
