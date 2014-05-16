//seperate screen setups, GUI and some controls
int sequenceArray[]=new int[8];
PVector matposX,matPosY;
//sequencer variables
int oldSecs;
int iSpeed=1;
int trig;
boolean trigg;
int presetSel=0;

// synth control screen call function
 void controlScreen()
{
 gui2.hide();

 gui.show();
 
 background(54,51,64);
 textFont(fontA);
fill(218,213,234);
// GUI elements
textAlign(CENTER,TOP);
text("FM-Synthesis-Andruino-Style",width/2,10);
  fill(127,23,23);
 
rect(270,700,240,40);
 fill(0,0,0);
 text("Synth",385,710);

 fill(0,0,0);
 
fill(23,23,127);
rect(810,700,240,40);
 fill(0,0,0);
 text("Sequencer",930,710);
 fill(86,81,100);
 rect (80,40,1100,210);
 rect (80,250,1100,210);
 fill(218,213,234);
 text("Synth Voice",1070,85);
 text("parameter",1075,120);
 text("controls",1077,155);
 text("Sequencer Voice",1013,280);
 text("parameter",1017,320);
 text("controls",1019,355);
 startonsyn=ontogsyn.isOn();
  if (startonsyn)  
   // sequencer stop/start button
  {
    
 //  gui2.get(CustomMatrix.class, "Sequencer").play();
  
  }
   else {
    gui2.get(CustomMatrix.class, "Sequencer").stop();
   
     byte[] ident2=intToByteArray(0x81);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  }
}


 
// sequencer screen control function call
void controlScreen3()
{
  
  
  
  gui.hide();

  gui2.show();
  textFont(fontA);
  fill(218,213,234);
textAlign(CENTER,TOP);
text("Sequencer",width/2,10);
  fill(127,23,23);
rect(270,700,240,40);

fill(23,23,127);
rect(810,700,240,40);

//preset box
rect(1000,130,250,350,7);
 
 fill(0,0,0);
 
 text("Synth",385,710);
  text("Sequencer",930,710);
fill(30);
rect(1005,135,240,340,7);
  fill(127,0,127);
 textFont(fontA);
 fill(200,200,200);
 text("Presets",1120,100);
 textFont(fontB);
text("Recall",1120,140);
text("Store",1122,290);
text("Selected:",1105,440);
text(selected,1175,440);

// sequential pattern player box
fill(23,23,127);
rect (1000,490,250,130,7);
fill(30);
rect (1005,495,240,120,7);
textFont(fontB);
 fill(0,0,127);

rect(1010,500,50,50);

// pattern player buttons and song storage array structure
if (mousePressed && mouseX >1010 && mouseX <1060 &&mouseY >500 && mouseY <550)
{
  se1++;
  sequenceArray[0]=se1;
  if (se1>7)
  se1=0;
  presetSel=se1;
}
rect(1070,500,50,50);
if (mousePressed && mouseX >1070 && mouseX <1120 &&mouseY >500 && mouseY <550)
{
  se2++;
  sequenceArray[1]=se2;
  if (se2>7)
  se2=0;
   presetSel=se2;
}
 rect(1130,500,50,50);
 if (mousePressed && mouseX >1130 && mouseX <1180 &&mouseY >500 && mouseY <550)
{
  se3++;
  sequenceArray[2]=se3;
  if (se3>7)
  se3=0;
   presetSel=se3;
}
  rect( 1190,500,50,50);
  if (mousePressed && mouseX >1190 && mouseX <1240 &&mouseY >500 && mouseY <550)
{
  se4++;
  sequenceArray[3]=se4;
  if (se4>7)
  se4=0;
   presetSel=se4;
}
  rect(  1010,560,50,50);
  if (mousePressed && mouseX >1010 && mouseX <1060 &&mouseY >560 && mouseY <610)
{
  se5++;
  sequenceArray[4]=se5;
  if (se5>7)
  se5=0;
   presetSel=se5;
}
  rect(  1070,560,50,50);
  if (mousePressed && mouseX >1070 && mouseX <1120 &&mouseY >560 && mouseY <610)
{
  se6++;
  sequenceArray[5]=se6;
  if (se6>7)
  se6=0;
   presetSel=se6;
}
 rect( 1130,560,50,50);
 if (mousePressed && mouseX >1130 && mouseX <1180 &&mouseY >560 && mouseY <610)
{
  se7++;
  sequenceArray[6]=se7;
  if (se7>7)
  se7=0;
   presetSel=se7;
}
 rect(  1190,560,50,50);
 if (mousePressed && mouseX >1190 && mouseX <1240 &&mouseY >560 && mouseY <610)
{
  se8++;
  sequenceArray[7]=se8;
  if (se8>7)
  se8=0;
   presetSel=se8;
}
 textFont(fontB);
 fill(127,0,127);
text(se1,1035,520);
text(se2,1095,520);
text(se3,1155,520);
text(se4,1215,520);
text(se5,1035,580);
text(se6,1095,580);
text(se7,1155,580);
text(se8,1215,580);

// start button
 starton=ontog.isOn();
 
   if (starton)  
   // sequencer stop/start button
  {
    
 //  gui2.get(CustomMatrix.class, "Sequencer").play();
  
  }
   else {
    gui2.get(CustomMatrix.class, "Sequencer").stop();
   
     byte[] ident2=intToByteArray(0x81);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
  }
}

