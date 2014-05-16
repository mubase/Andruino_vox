// Processing for Android AndruinoVox code.
// S.Scutt 2014. 
// Uses the Ketai library from Daniel Sauter.
// https://code.google.com/p/ketai/
// Runs on a PIPO M9 Android tablet.

import android.content.Context;                // required imports for sensor data
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import oscP5.*; 
import netP5.*; 
import android.content.Intent; 
import android.os.Bundle; 
import ketai.net.bluetooth.*; 
import ketai.ui.*; 
import ketai.net.*; 
import controlP5.*; 
import ketai.sensors.*;

PFont font;


byte [] dataInt;

PFont fontMy;  //declaring font
PFont fontA;
PFont fontB;

int butCol=color(255,12,67);
// synth screen GUI instance 
ControlP5 gui;
int Sequencer;
// sequencer screen GUI instance.
ControlP5 gui2;  // new controlP5 gui2 instance called"gui2"
//ControlP5 gui3; // new gui for screen 2
ControlWindow controlWindow;
color activeCellStart=color(255, 132, 4);
color activeCell=color(12, 245, 45);
color activeCellSqr=color(230, 45, 178);
color activeCellSaw=color(128, 12, 255);
color activeCellNoise=color(220);
color knobColor=color(255, 12, 45);
color delKnobs=color(173, 216, 230);
color sliderColor=color(192,41,227);
color sliderColor2=color(110,118,108);
color sharpcolor=color(0,20,127);
color whitekeys=color(255,255,255);
color sliderparam=color(114,160,66);
color sliderparam2=color(96,124,67);
Dong[][] d; // Matrix array
public int temp=200;  // tempo initialization value

public int theX, theY;  // the x and y variables for the matrix
int note; // variable for frequency of note being played
Button ontog;   // button for sequencer start
Button ontogsyn; // button for sequencer on synth page (for convienience.)
int nx = 16;  // x co-ord cells
int ny = 16;  // y co-ord cells
int oldval,oldval2;
int oct; //octave for sequencer
int keyOctave;// keyoctave for synth
int lfopress=0;   // lfo wave shape increment
int lfopress2;
boolean Start=false;
boolean battackd = true;       //no permament sending when finger is tap
KetaiBluetooth bt;                  // Create object from BtSerial class
boolean isConfiguring = true;
boolean cont1=false;
boolean cont2=false;
boolean cont3=false;
boolean sendPreset=false;
boolean starton; // boolean for sequencer switch
boolean startonsyn; // sequencer switch on synth page
boolean radX1=false,radX2=false,radX3=false,radX4=false,radX5=false;
byte [] presetData;
String info = "";
KetaiList klist;
ArrayList devicesDiscovered = new ArrayList(); //store in array the discovered device
boolean rectOver = false;
int rec = 0;
Slider slider51;
Knob knob2;
//RadioButton accXBut;
RadioButton accYBut;
Button button1;
Slider slider1;
Slider slider2;
Slider slider3;
Slider slider4;
Slider slider5;
Slider slider6;
Slider slider7;
Slider slider8;
Slider slider9;
Slider slider10;
Slider slider11;
Slider slider12;
Slider slider13;
Slider slider14;
Slider slider15;
Slider slider16;
Slider slider17;
Slider slider18;
Slider slider19;
Slider slider20;
Slider slider21;
Slider slider22;
Slider slider23;
Slider slider24;
Slider slider25;
Slider slider26;
Slider slider27;
Slider slider28;
Slider slider29;
Slider slider30;
Slider slider31;
Slider slider52;
Slider slider32;
Slider slider33;
Button b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15,b16,b17,b18,b19,b20,b21,b22,b23,b24,b25,b26,b27;


//Buttons for the sequencer presets rx=recall, sx=store
Button s1,s2,s3,s4,s5,s6,s7,s8,r1,r2,r3,r4,r5,r6,r7,r8;
//Buttons for the sequencer pattern player
Button sp1,sp2,sp3,sp4,sp5,sp6,sp7,sp8;
// sequencer controls
Button clear,bwav;
//Sequencer preset Array variables and for loop variables
int rowsnumber=16, columnsnumber=16;
int currentrow,currentcolumn;
int selected;  // variable to show nuber of sequence playing
int song[];
int songinc=0;
public boolean value1,value2,value3,value4,value5,value6,value7,value8;
volatile boolean[][] gets1=new boolean[rowsnumber][columnsnumber];
volatile boolean[][] gets2=new boolean[rowsnumber][columnsnumber];
volatile boolean[][] gets3=new boolean[rowsnumber][columnsnumber];
volatile boolean[][] gets4=new boolean[rowsnumber][columnsnumber];
volatile boolean[][] gets5=new boolean[rowsnumber][columnsnumber];
volatile boolean[][] gets6=new boolean[rowsnumber][columnsnumber];
volatile boolean[][] gets7=new boolean[rowsnumber][columnsnumber];
volatile boolean[][] gets8=new boolean[rowsnumber][columnsnumber];
volatile boolean[][] gets9=new boolean[rowsnumber][columnsnumber];
volatile boolean[][] gets10=new boolean[rowsnumber][columnsnumber];
volatile boolean[][] gets11=new boolean[rowsnumber][columnsnumber];
volatile boolean[][] gets12=new boolean[rowsnumber][columnsnumber];
volatile boolean[][] gets13=new boolean[rowsnumber][columnsnumber];
volatile boolean[][] gets14=new boolean[rowsnumber][columnsnumber];
volatile boolean[][] gets15=new boolean[rowsnumber][columnsnumber];
volatile boolean[][] gets16=new boolean[rowsnumber][columnsnumber];

boolean[] bxval1=new boolean[rowsnumber*columnsnumber];
boolean[] bxval2=new boolean[rowsnumber*columnsnumber];
boolean[] bxval3=new boolean[rowsnumber*columnsnumber];
boolean[] bxval4=new boolean[rowsnumber*columnsnumber];
boolean[] bxval5=new boolean[rowsnumber*columnsnumber];
boolean[] bxval6=new boolean[rowsnumber*columnsnumber];
boolean[] bxval7=new boolean[rowsnumber*columnsnumber];
boolean[] bxval8=new boolean[rowsnumber*columnsnumber];

// booleans for sequencer patter select
boolean Pt1,Pt2,Pt3,Pt4,Pt5,Pt6,Pt7,Pt8;
int se1=0,se2=0,se3=0,se4=0,se5=0,se6=0,se7=0,se8=0;
boolean toggleValue = false;
int lasttime=millis();
// The following code is required to enable bluetooth at startup.
public void onCreate(Bundle savedInstanceState)
{
super.onCreate(savedInstanceState);
bt = new KetaiBluetooth(this);//create the BtSerial object that will handle the connection
}

public void onActivityResult(int requestCode, int resultCode, Intent data)
 {
bt.onActivityResult(requestCode, resultCode, data);
}//to show the discovered device
void setup()
{
  gui=new ControlP5(this);
 gui2 = new ControlP5(this);  // declaration of gui2 as controlP5s' gui2 for use
//gui3 = new ControlP5(this); 
gui2.hide();
//gui3.hide();
  //accelerometer/gyro stuff
 // sensor = new KetaiSensor(this);
 //  ballX = width/2;                         // start ball in the center
//  ballY = height/2;
//  sensor.start();
  smooth();
  //Initialize sequencer
  CustomMatrix m = new CustomMatrix(gui2, "Sequencer");   // sequencer name
    m.setPosition(295, 130)      // position
      .setSize(700, 500)       // size of sequencer
        .setGrid(nx, ny)       // size of grid (16 x 16)
          .setGap(2, 2)       // gap between blocks
            .setInterval(temp)     // tempo set by temp dial
              .setMode(ControlP5.MULTIPLES)    // multiple blocks can be placed on y axis
                .setColorBackground(activeCellNoise)    
                  .setLabelVisible(false)
                  .setColorActive(activeCellSaw)
                    .setBackground(color(40))
                      ;
                      m.initPresets();
            slider32=gui2.addSlider("Speed",480,10,50,130,60,240); 
           slider32.setColorBackground(delKnobs); 
           slider51=gui2.addSlider("Oct",1,6,130,130,60,240);   
           slider51.setColorBackground(delKnobs);   
           slider52=gui2.addSlider("Steps",1,16,210,130,60,240);
            slider52.setColorBackground(delKnobs); 
     //sequencer preset button instantiations
    r1=gui2.addButton("R1",0,1010,170,50,50); // 
    r2=gui2.addButton("R2",0,1070,170,50,50);
    r3=gui2.addButton("R3",0,1130,170,50,50);
    r4=gui2.addButton("R4",0,1190,170,50,50);
     r5=gui2.addButton("R5",0,1010,230,50,50); 
    r6=gui2.addButton("R6",0,1070,230,50,50);
    r7=gui2.addButton("R7",0,1130,230,50,50);
    r8=gui2.addButton("R8",0,1190,230,50,50);
     s1=gui2.addButton("S1",0,1010,310,50,50); 
    s2=gui2.addButton("S2",0,1070,310,50,50);
    s3=gui2.addButton("S3",0,1130,310,50,50);
    s4=gui2.addButton("S4",0,1190,310,50,50);
     s5=gui2.addButton("S5",0,1010,370,50,50); 
    s6=gui2.addButton("S6",0,1070,370,50,50);
    s7=gui2.addButton("S7",0,1130,370,50,50);
    s8=gui2.addButton("S8",0,1190,370,50,50);
    
   
    
                       d = new Dong[nx][ny];
  for (int x = 0;x<nx;x++) {
    for (int y = 0;y<ny;y++) {
      d[x][y] = new Dong();
     
    
      
    }
  }  
  PImage[] imgs = {loadImage("button_a.png")};
 fontA =loadFont("LilyUPC-48.vlw");
 // fontA =loadFont("Vrinda-48.vlw");
  fontB=loadFont("256Bytes28.vlw");
   textFont(fontA);
fill(127,0,127);
textAlign(CENTER,TOP);
text("FM-Synthesis-Andruino-Style",width/2,10);
   fill(127,23,23);
rect(270,700,240,40);

fill(23,23,127);
rect(810,700,240,40);

   b0=gui.addButton("Init",1,100,640,70,70);    
b1=gui.addButton("One",1,100+90,480,50,150);
b1.setLabelVisible(false);
b1.setColorBackground(whitekeys);
ontog=gui2.addButton("Start", 0,50, 550, 100, 94);
ontogsyn=gui.addButton("Start",0,1100,500,100,94);
ontog.setSwitch(true);
ontogsyn.setSwitch(true);
 ontog.setImages(loadImage("startbutt.png"),loadImage("stopbutt.png"),loadImage("stopbutt.png"));
 ontogsyn.setImages(loadImage("startbutt.png"),loadImage("stopbutt.png"),loadImage("stopbutt.png"));

clear=gui2.addButton("CLR",0,170,550,100,94);
clear.setImages(loadImage("clrbutt.png"),loadImage("clrbutt.png"),loadImage("clrbutt.png"));

ontog.setColorActive(activeCellStart);
clear.setColorActive(activeCellSaw);


 b2=    gui.addButton("Two")
     .setPosition(125+90,480)
     .setSize(40,75)
     .setColorBackground(127)
     
    
     .setLabelVisible(false)
     ;
     
b3=      gui.addButton("Three")
     .setPosition(160+90,480)
     .setSize(50,150)
     .setLabelVisible(false)
     .setColorBackground(whitekeys)
     ;
     
  b4=    gui.addButton("Four")
     .setPosition(185+90,480)
     .setSize(40,75)
     .setColorBackground(127)
      .setLabelVisible(false)
     ;
     
  b5=    gui.addButton("Five")
     .setPosition(220+90,480)
     .setSize(50,150)
     .setLabelVisible(false)
      .setColorBackground(whitekeys)
     ;
  bwav=     gui.addButton("Wave")
     .setPosition(80,485)
      .setImages(loadImage("butt2.png"),loadImage("butt3.png"),loadImage("butt3.png"))
     //.setSize(80,80)
     .updateSize();
     
     ;
      b26=     gui.addButton("LFOWave")
     .setPosition(80,540)
      .setImages(loadImage("lfobutt.png"),loadImage("lfobutt2.png"),loadImage("lfobutt2.png"))
     //.setSize(80,80)
     .updateSize();
     
     ;
      b27=     gui2.addButton("LFOWave")
     .setPosition(130,420)
      .setImages(loadImage("lfobutt.png"),loadImage("lfobutt2.png"),loadImage("lfobutt2.png"))
     //.setSize(80,80)
     .updateSize();
     
     ;
 b6=   gui.addButton("Six")
     .setPosition(280+90,480)
     .setSize(50,150)
    .setLabelVisible(false)
     .setColorBackground(whitekeys)
     ;
     
b7=     gui.addButton("Seven")
     .setPosition(305+90,480)
     .setSize(40,75)
      .setColorBackground(127)
       .setLabelVisible(false)
     ;
     
 b8=    gui.addButton("Eight")
     .setPosition(340+90,480)
     .setSize(50,150)
     .setLabelVisible(false)
      .setColorBackground(whitekeys)
     ;
     
   b9=  gui.addButton("Nine")
     .setPosition(365+90,480)
     .setSize(40,75)
   .setColorBackground(127)
    .setLabelVisible(false)
     ;
     
    b10= gui.addButton("Ten")
     .setPosition(400+90,480)
      .setLabelVisible(false)
       .setColorBackground(whitekeys)
     .setSize(50,150);
     
    b11= gui.addButton("Eleven")
     .setPosition(425+90,480)
     .setSize(40,75)
      .setLabelVisible(false)
     .setColorBackground(127);
     
    b12= gui.addButton("Twelve")
     .setPosition(460+90,480)
      .setLabelVisible(false)
       .setColorBackground(whitekeys)
     .setSize(50,150);
      b13= gui.addButton("Thirteen")
     .setPosition(520+90,480)
      .setLabelVisible(false)
       .setColorBackground(whitekeys)
     .setSize(50,150);
    b14= gui.addButton("Fourteen")
     .setPosition(545+90,480)
     .setSize(40,75)
      .setLabelVisible(false)
     .setColorBackground(127);
     
    b15= gui.addButton("Fifteen")
     .setPosition(580+90,480)
      .setLabelVisible(false)
       .setColorBackground(whitekeys)
     .setSize(50,150);
      b16= gui.addButton("Sixteen")
     .setPosition(605+90,480)
     .setSize(40,75)
       .setLabelVisible(false)
     .setColorBackground(127);
      b17= gui.addButton("Seventeen")
     .setPosition(640+90,480)
      .setLabelVisible(false)
       .setColorBackground(whitekeys)
     .setSize(50,150);
     
      b18= gui.addButton("Eightteen")
     .setPosition(700+90,480)
     .setSize(50,150)
      .setLabelVisible(false)
       .setColorBackground(whitekeys)
     ;
     
      b19= gui.addButton("Nineteen")
     .setPosition(725+90,480)
     .setSize(40,75)
      .setLabelVisible(false)
     .setColorBackground(127);
     
      b20= gui.addButton("Twenty")
     .setPosition(760+90,480)
     .setSize(50,150)
      .setLabelVisible(false)
       .setColorBackground(whitekeys)
     ;
    
      b21= gui.addButton("Twentyone")
     .setPosition(785+90,480)
     .setSize(40,75)
      .setLabelVisible(false)
     .setColorBackground(127);
     
     
      b22= gui.addButton("Twentytwo")
     .setPosition(820+90,480)
      .setLabelVisible(false)
       .setColorBackground(whitekeys)
     .setSize(50,150);
     
      b23= gui.addButton("Twentythree")
     .setPosition(845+90,480)
     .setSize(40,75)
      .setLabelVisible(false)
      .setColorBackground(127);
    
     
      b24= gui.addButton("Twentyfour")
     .setPosition(880+90,480)
     .setSize(50,150)
      .setLabelVisible(false)
       .setColorBackground(whitekeys)
     ;
     
      b25= gui.addButton("Twentyfive")
     .setPosition(940+90,480)
      .setLabelVisible(false)
       .setColorBackground(whitekeys)
     .setSize(50,150);
      
    
  slider1=gui.addSlider("Fil",0,127,100,50,35,180);
  slider2=gui.addSlider("Rate",0,127,145,50,35,180);
  slider3=gui.addSlider("Amt",0,127,190,50,35,180);
  slider4=gui.addSlider("attack",0,127,235,50,35,180);
  slider5=gui.addSlider("decay",0,127,280,50,35,180);
   slider23=gui.addSlider("Sustain1",0,127,325,50,35,180);
  slider6=gui.addSlider("release",0,127,370,50,35,180);
   slider7=gui.addSlider("OP1",0,7,415,50,35,180);
   slider8=gui.addSlider("attack2",0,127,460,50,35,180);
  slider9=gui.addSlider("decay2",0,127,505,50,35,180);
   slider24=gui.addSlider("Sustain2",0,127,550,50,35,180);
  slider10=gui.addSlider("release2",0,127,595,50,35,180);
   slider11=gui.addSlider("detune",0,127,640,50,35,180);
   
   slider27=gui.addSlider("Gain1",0,127,720,50,70,180);
     slider28=gui.addSlider("Gain2",0,127,800,50,70,180);  
   
    slider12=gui.addSlider("Fil2",0,127,100,260,35,180);
  slider13=gui.addSlider("Rate2",0,127,145,260,35,180);
  slider14=gui.addSlider("Amt2",0,127,190,260,35,180);
  slider15=gui.addSlider("attack3",0,127,235,260,35,180);
  slider16=gui.addSlider("decay3",0,127,280,260,35,180);
  slider25=gui.addSlider("Sustain3",0,127,325,260,35,180);
  slider17=gui.addSlider("release3",0,127,370,260,35,180);
   slider18=gui.addSlider("OP3",0,7,415,260,35,180);
    slider19=gui.addSlider("attack4",0,127,460,260,35,180);
  slider20=gui.addSlider("decay4",0,127,505,260,35,180);
   slider26=gui.addSlider("Sustain4",0,127,550,260,35,180);
  slider21=gui.addSlider("release4",0,127,595,260,35,180);
   slider22=gui.addSlider("detune4",0,127,640,260,35,180);
    slider29=gui.addSlider("Gain3",0,127,720,260,70,180);  
       slider30=gui.addSlider("Gain4",0,127,800,260,70,180);  
      slider33=gui.addSlider("Octave",1,5,900,50,70,180);
  
   
  
    
     
  slider1.valueLabel().setVisible(false);
  slider2.valueLabel().setVisible(false);
  slider3.valueLabel().setVisible(false);
 slider1.setColorBackground(sliderparam);
slider2.setColorBackground(sliderparam);
slider3.setColorBackground(sliderparam);
slider4.setColorBackground(sliderparam);
slider5.setColorBackground(sliderparam);
slider6.setColorBackground(sliderparam);
slider7.setColorBackground(sliderparam);
slider8.setColorBackground(sliderparam);
slider9.setColorBackground(sliderparam);
slider10.setColorBackground(sliderparam);
slider11.setColorBackground(sliderparam);
slider12.setColorBackground(sliderparam);
slider13.setColorBackground(sliderparam);
slider14.setColorBackground(sliderparam);
slider15.setColorBackground(sliderparam);
slider16.setColorBackground(sliderparam);
slider17.setColorBackground(sliderparam);
slider18.setColorBackground(sliderparam);
slider19.setColorBackground(sliderparam);
slider20.setColorBackground(sliderparam);
slider21.setColorBackground(sliderparam);
slider22.setColorBackground(sliderparam);
slider23.setColorBackground(sliderparam);
slider24.setColorBackground(sliderparam);
slider25.setColorBackground(sliderparam);
slider26.setColorBackground(sliderparam);
slider27.setColorBackground(sliderparam);
slider28.setColorBackground(sliderparam);
slider29.setColorBackground(sliderparam);
slider30.setColorBackground(sliderparam);
slider33.setColorBackground(sliderparam);
//slider1.setColorActive(sliderparam);
slider1.setColorActive(sliderparam2);
slider2.setColorActive(sliderparam2);
slider3.setColorActive(sliderparam2);
slider4.setColorActive(sliderparam2);
slider5.setColorActive(sliderparam2);
slider6.setColorActive(sliderparam2);
slider7.setColorActive(sliderparam2);
slider8.setColorActive(sliderparam2);
slider9.setColorActive(sliderparam2);
slider10.setColorActive(sliderparam2);
slider11.setColorActive(sliderparam2);
slider12.setColorActive(sliderparam2);
slider13.setColorActive(sliderparam2);
slider14.setColorActive(sliderparam2);
slider15.setColorActive(sliderparam2);
slider16.setColorActive(sliderparam2);
slider17.setColorActive(sliderparam2);
slider18.setColorActive(sliderparam2);
slider19.setColorActive(sliderparam2);
slider20.setColorActive(sliderparam2);
slider21.setColorActive(sliderparam2);
slider22.setColorActive(sliderparam2);
slider23.setColorActive(sliderparam2);
slider24.setColorActive(sliderparam2);
slider25.setColorActive(sliderparam2);
slider26.setColorActive(sliderparam2);
slider27.setColorActive(sliderparam2);
slider28.setColorActive(sliderparam2);
slider29.setColorActive(sliderparam2);
slider30.setColorActive(sliderparam2);
slider33.setColorActive(sliderparam2);

slider1.setColorForeground(sliderparam2);
slider2.setColorForeground(sliderparam2);
slider3.setColorForeground(sliderparam2);
slider4.setColorForeground(sliderparam2);
slider5.setColorForeground(sliderparam2);
slider6.setColorForeground(sliderparam2);
slider7.setColorForeground(sliderparam2);
slider8.setColorForeground(sliderparam2);
slider9.setColorForeground(sliderparam2);
slider10.setColorForeground(sliderparam2);
slider11.setColorForeground(sliderparam2);
slider12.setColorForeground(sliderparam2);
slider13.setColorForeground(sliderparam2);
slider14.setColorForeground(sliderparam2);
slider15.setColorForeground(sliderparam2);
slider16.setColorForeground(sliderparam2);
slider17.setColorForeground(sliderparam2);
slider18.setColorForeground(sliderparam2);
slider19.setColorForeground(sliderparam2);
slider20.setColorForeground(sliderparam2);
slider21.setColorForeground(sliderparam2);
slider22.setColorForeground(sliderparam2);
slider23.setColorForeground(sliderparam2);
slider24.setColorForeground(sliderparam2);
slider25.setColorForeground(sliderparam2);
slider26.setColorForeground(sliderparam2);
slider27.setColorForeground(sliderparam2);
slider28.setColorForeground(sliderparam2);
slider29.setColorForeground(sliderparam2);
slider30.setColorForeground(sliderparam2);
slider33.setColorForeground(sliderparam2);

 slider52.setValue(16); // set initial sequencer pattern length to 16
   slider33.setValue(3);
  slider51.setValue(2); 
    // initial slider positions for voice 1
    slider1.setValue(20);
    slider2.setValue(0);
    slider3.setValue(0);
    slider4.setValue(0);
    slider5.setValue(35);
    slider23.setValue(17);
    slider6.setValue(97);
    slider7.setValue(2);
    slider8.setValue(67);
    slider9.setValue(42);
    slider24.setValue(74);
    slider10.setValue(72);
    slider11.setValue(0);
    slider27.setValue(14);
    slider28.setValue(0);
    slider12.setValue(75);
    slider13.setValue(15);
    slider14.setValue(2);
    slider15.setValue(2);
    slider16.setValue(37);
    slider17.setValue(10);
    slider18.setValue(2);
    slider19.setValue(4);
    slider20.setValue(52);
    slider26.setValue(76);
    slider21.setValue(46);
    slider22.setValue(0);
    slider29.setValue(5);
    slider30.setValue(40);

//The callbacks for the noteon buttons and the preset
  b1.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(27+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
 ); 
 b2.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(28+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
 ); 
  b3.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(29+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
 ); 
  b4.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(30+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
 );
 b5.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(31+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
 );  
  b6.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(32+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
 ); 
  b7.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(33+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
 ); 
  b8.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(34+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
 ); 
  b9.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(35+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
 ); 
  b10.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(36+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
 ); 
  b11.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(37+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
 ); 
  b12.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(38+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
 ); 
  b13.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(39+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
 ); 
 b14.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(40+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
 ); 
 b15.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(41+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
 ); 
 b16.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(42+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
  );
   b17.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(43+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
  );
   b18.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(44+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
  );
   b19.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(45+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
  );
   b20.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(46+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
  );
   b21.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(47+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
  );
   b22.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(48+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
  );
   b23.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(49+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
  );
   b24.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(50+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
  );
   b25.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0x90);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(51+(keyOctave*12));
  byte[] noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  break;
  case (ControlP5.ACTION_RELEASED): 
   byte[] ident2=intToByteArray(0x80);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  break;
    }
    }
  }
  );
  
   b26.addCallback(new CallbackListener(){
     
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0xb0);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(11);
  byte[] noteV=intToByteArray(lfopress);
   bt.broadcast(noteP);
  bt.broadcast(noteV);
  
  break;
  case (ControlP5.ACTION_RELEASED): 
   lfopress++;
  if (lfopress>3)
  lfopress=0;
  break;
    }
    }
  }
  );
   b27.addCallback(new CallbackListener(){
     
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident=intToByteArray(0xb0);
    bt.broadcast(ident);
 byte[] noteP=intToByteArray(12);
  byte[] noteV=intToByteArray(lfopress2);
   bt.broadcast(noteP);
  bt.broadcast(noteV);
  
  break;
  case (ControlP5.ACTION_RELEASED): 
   lfopress2++;
  if (lfopress2>3)
  lfopress2=0;
  break;
    }
    }
  }
  );
  s1.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    for (currentrow=0;currentrow<rowsnumber;currentrow++){
    for (currentcolumn=0;currentcolumn<columnsnumber;currentcolumn++)
gets1[currentrow][currentcolumn]= gui2.get(Matrix.class, "Sequencer").get(currentrow,currentcolumn); 
gets2=gets1;

  for (int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval1[currentrow * columnsnumber + currentcolumn] = gets1[currentrow] [currentcolumn];

 value1 =bxval1[currentrow * columnsnumber + currentcolumn];
 // bval=value;
    //println(value);  
 }
 }
 
 }
 
  break;
  case (ControlP5.ACTION_RELEASED): 
  
  break;
    }
    }
  }
  );
   r1.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
  for (int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval1[currentrow * columnsnumber + currentcolumn] = gets2[currentrow] [currentcolumn];

 value1 =bxval1[currentrow * columnsnumber + currentcolumn];
 // bval=value;
 selected=0;

  gui2.get(Matrix.class, "Sequencer").set(currentrow,currentcolumn,value1);  
 }
 }
  break;
  case (ControlP5.ACTION_RELEASED): 
  
  break;
    }
    }
  }
 ); 
  s2.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    for (currentrow=0;currentrow<rowsnumber;currentrow++){
    for (currentcolumn=0;currentcolumn<columnsnumber;currentcolumn++)
gets3[currentrow][currentcolumn]= gui2.get(Matrix.class, "Sequencer").get(currentrow,currentcolumn); 
gets4=gets3;

  for (int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval2[currentrow * columnsnumber + currentcolumn] = gets3[currentrow] [currentcolumn];

 value2 =bxval2[currentrow * columnsnumber + currentcolumn];
 // bval=value;
    //println(value);  
 }
 }
 
 }
 
  break;
  case (ControlP5.ACTION_RELEASED): 
  
  break;
    }
    }
  }
  );
   r2.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
  for (int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval2[currentrow * columnsnumber + currentcolumn] = gets4[currentrow] [currentcolumn];

 value2 =bxval2[currentrow * columnsnumber + currentcolumn];
selected=1;
  gui2.get(Matrix.class, "Sequencer").set(currentrow,currentcolumn,value2); 
 
 }
 }
  break;
  case (ControlP5.ACTION_RELEASED): 
  
  break;
    }
    }
  }
 ); 
 
  s3.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    for (currentrow=0;currentrow<rowsnumber;currentrow++){
    for (currentcolumn=0;currentcolumn<columnsnumber;currentcolumn++)
gets5[currentrow][currentcolumn]= gui2.get(Matrix.class, "Sequencer").get(currentrow,currentcolumn); 
gets6=gets5;

  for (int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval3[currentrow * columnsnumber + currentcolumn] = gets5[currentrow] [currentcolumn];

 value3 =bxval3[currentrow * columnsnumber + currentcolumn];
  
 }
 }
 
 }
 
  break;
  case (ControlP5.ACTION_RELEASED): 
  
  break;
    }
    }
  }
  );
   r3.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
  for (int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval3[currentrow * columnsnumber + currentcolumn] = gets6[currentrow] [currentcolumn];

 value3 =bxval3[currentrow * columnsnumber + currentcolumn];

  gui2.get(Matrix.class, "Sequencer").set(currentrow,currentcolumn,value3);  
  selected=2;
 
 }
 }
  break;
  case (ControlP5.ACTION_RELEASED): 
  
  break;
    }
    }
  }
 ); 
 
  s4.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    for (currentrow=0;currentrow<rowsnumber;currentrow++){
    for (currentcolumn=0;currentcolumn<columnsnumber;currentcolumn++)
gets7[currentrow][currentcolumn]= gui2.get(Matrix.class, "Sequencer").get(currentrow,currentcolumn); 
gets8=gets7;

  for (int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval4[currentrow * columnsnumber + currentcolumn] = gets1[currentrow] [currentcolumn];

 value4 =bxval4[currentrow * columnsnumber + currentcolumn];  
 }
 }
 
 }
 break;
  case (ControlP5.ACTION_RELEASED): 
  
  break;
    }
    }
  }
  );
   r4.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
  for (int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval4[currentrow * columnsnumber + currentcolumn] = gets8[currentrow] [currentcolumn];

 value4 =bxval4[currentrow * columnsnumber + currentcolumn];

  gui2.get(Matrix.class, "Sequencer").set(currentrow,currentcolumn,value4);  
  selected=3;
 
 }
 }
  break;
  case (ControlP5.ACTION_RELEASED): 
  
  break;
    }
    }
  }
 ); 
 
  s5.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    for (currentrow=0;currentrow<rowsnumber;currentrow++){
    for (currentcolumn=0;currentcolumn<columnsnumber;currentcolumn++)
gets9[currentrow][currentcolumn]= gui2.get(Matrix.class, "Sequencer").get(currentrow,currentcolumn); 
gets10=gets9;

  for (int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval5[currentrow * columnsnumber + currentcolumn] = gets9[currentrow] [currentcolumn];

 value5 =bxval5[currentrow * columnsnumber + currentcolumn];
 
 }
 }
 
 }
 
  break;
  case (ControlP5.ACTION_RELEASED): 
  
  break;
    }
    }
  }
  );
   r5.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
  for (int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval5[currentrow * columnsnumber + currentcolumn] = gets10[currentrow] [currentcolumn];

 value5 =bxval5[currentrow * columnsnumber + currentcolumn];
 
  gui2.get(Matrix.class, "Sequencer").set(currentrow,currentcolumn,value5);  
  selected=4;
 }
 }
  break;
  case (ControlP5.ACTION_RELEASED): 
  
  break;
    }
    }
  }
 ); 
 
  s6.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    for (currentrow=0;currentrow<rowsnumber;currentrow++){
    for (currentcolumn=0;currentcolumn<columnsnumber;currentcolumn++)
gets11[currentrow][currentcolumn]= gui2.get(Matrix.class, "Sequencer").get(currentrow,currentcolumn); 
gets12=gets11;

  for (int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval6[currentrow * columnsnumber + currentcolumn] = gets11[currentrow] [currentcolumn];

 value6 =bxval6[currentrow * columnsnumber + currentcolumn];
 
 }
 }
 
 }
 
  break;
  case (ControlP5.ACTION_RELEASED): 
  
  break;
    }
    }
  }
  );
   r6.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
  for (int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval6[currentrow * columnsnumber + currentcolumn] = gets12[currentrow] [currentcolumn];

 value6 =bxval6[currentrow * columnsnumber + currentcolumn];

  gui2.get(Matrix.class, "Sequencer").set(currentrow,currentcolumn,value6);  
  selected=5;
 
 }
 }
  break;
  case (ControlP5.ACTION_RELEASED): 
  
  break;
    }
    }
  }
 ); 
 
  s7.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    for (currentrow=0;currentrow<rowsnumber;currentrow++){
    for (currentcolumn=0;currentcolumn<columnsnumber;currentcolumn++)
gets13[currentrow][currentcolumn]= gui2.get(Matrix.class, "Sequencer").get(currentrow,currentcolumn); 
gets14=gets13;

  for (int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval7[currentrow * columnsnumber + currentcolumn] = gets13[currentrow] [currentcolumn];

 value7 =bxval7[currentrow * columnsnumber + currentcolumn];
  
 }
 }
 
 }
 
  break;
  case (ControlP5.ACTION_RELEASED): 
  
  break;
    }
    }
  }
  );
   r7.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
  for (int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval7[currentrow * columnsnumber + currentcolumn] = gets14[currentrow] [currentcolumn];

 value7 =bxval7[currentrow * columnsnumber + currentcolumn];

  gui2.get(Matrix.class, "Sequencer").set(currentrow,currentcolumn,value7);  
  selected=6;
 
 }
 }
  break;
  case (ControlP5.ACTION_RELEASED): 
  
  break;
    }
    }
  }
 ); 
 
  s8.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    for (currentrow=0;currentrow<rowsnumber;currentrow++){
    for (currentcolumn=0;currentcolumn<columnsnumber;currentcolumn++)
gets15[currentrow][currentcolumn]= gui2.get(Matrix.class, "Sequencer").get(currentrow,currentcolumn); 
gets16=gets15;

  for (int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval8[currentrow * columnsnumber + currentcolumn] = gets15[currentrow] [currentcolumn];

 value8 =bxval8[currentrow * columnsnumber + currentcolumn];

 }
 }
 
 }
 
  break;
  case (ControlP5.ACTION_RELEASED): 
  
  break;
    }
    }
  }
  );
   r8.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
  for (int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {  
 bxval8[currentrow * columnsnumber + currentcolumn] = gets16[currentrow] [currentcolumn];

 value8 =bxval8[currentrow * columnsnumber + currentcolumn];
 
  //  println(value);
  gui2.get(Matrix.class, "Sequencer").set(currentrow,currentcolumn,value8);  
  selected=7;
 
 }
 }
  break;
  case (ControlP5.ACTION_RELEASED): 
  
  break;
    }
    }
  }
 ); 
 
 bwav.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent theEvent) {
     switch(theEvent.getAction())
    {
     case (ControlP5.ACTION_PRESSED): 
    byte[] ident={'s'};
  bt.broadcast(ident);
    }
    }
 }
 );
    

// tablet screen settings
smooth();
frameRate(25);                        //the frame rate of my screen
orientation(LANDSCAPE);        //horizontal
bt.start();                                 //start listening for BT connections
isConfiguring = true;               //at my phone start select device\u2026
fontMy = createFont("SansSerif", 20); //font size
textFont(fontMy);



}
 void controlEvent(ControlEvent theEvent) {
 
}
void draw()
{
  background(54,51,64);
  String selection = "FBT06"; 
//at app start select device
if (isConfiguring)

{
ArrayList names;

//create the BtSerial object that will handle the connection
//with the list of paired devices
klist = new KetaiList(this, bt.getPairedDeviceNames());

isConfiguring = false;  

}
bt.connectToDeviceByName(selection);
 textFont(fontA);
fill(127,23,23);
rect(270,700,240,40);

fill(23,23,127);
rect(810,700,240,40);
 fill(0,0,0);
 text("Synth",385,710);


fill(23,23,127);
rect(810,700,240,40);
 fill(0,0,0);
 text("Sequencer",930,710);
if (cont1==true)
{
  cont2=false;
  cont3=false;
controlScreen(); 
 gui.show();

}

if (cont3==true)
{
 controlScreen3(); 
}

}
public void onKetaiListSelection(KetaiList klist)
{
String selection = "FBT06";            //select the device to connect
bt.connectToDeviceByName(selection);        //connect to the device
klist = null; 

}

//Call back method to manage data received
public void onBluetoothDataEvent(String who, byte[] data)
{
  int test1;
  int sliderV;
 // KetaiOSCMessage m=new KetaiOSCMessage(data);
if (isConfiguring)
return;
//received
info += new String(data);
//
// not used.
KetaiOSCMessage ardRecv= new KetaiOSCMessage(data);

byte cnt;
for (cnt=0;cnt<23;cnt++){
      dataInt=data;
    }
}





class Dong {
  float x, y;
  float s0, s1;


  Dong() {
    float f= random(-PI, PI);
    x = cos(f)*random(100, 150);
    y = sin(f)*random(100, 150);
    s0 = random(2, 10);
   
  }
 void update() {

     oldval2=oldval;
  }
}





