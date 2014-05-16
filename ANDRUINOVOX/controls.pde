
//control functions for sliders, screen buttons etc...

 public void Fil(int val)
{
  
byte[] a= intToByteArray(val);


byte[] ident=intToByteArray(0xB0);
bt.broadcast(ident);
byte[] Cnum=intToByteArray(28);
bt.broadcast(Cnum);
  bt.broadcast(a);
   
  //print(a);
}
 void Rate(int val2)
{
  byte[] ident1={'p'};
byte[] ident=intToByteArray(0xb0);
//bt.broadcast(ident1);
bt.broadcast(ident);
byte[] Cnum=intToByteArray(16);
bt.broadcast(Cnum);
 byte[] b= intToByteArray(val2);
//letter=={'q'};

bt.broadcast(b);
 
}
public void Amt(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(29);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
 void attack(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(114);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void decay(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(115);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void Sustain3(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(59);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void release(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(117);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void OP1(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(41);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void attack2(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(108);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void decay2(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(109);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void Sustain2(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(110);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void release2(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(111);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void detune(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(17);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}

public void Fil2(int val)
{
  
byte[] a= intToByteArray(val);


byte[] ident=intToByteArray(0xB0);
bt.broadcast(ident);
byte[] Cnum=intToByteArray(62);
bt.broadcast(Cnum);
  bt.broadcast(a);
   
  //print(a);
}
 public void Rate2(int val2)
{
//  byte[] ident1={'p'};
byte[] ident=intToByteArray(0xb0);
//bt.broadcast(ident1);
bt.broadcast(ident);
byte[] Cnum=intToByteArray(63);
bt.broadcast(Cnum);
 byte[] b= intToByteArray(val2);
//letter=={'q'};

bt.broadcast(b);
 
}
public void Amt2(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(51);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
 void attack3(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(57);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void decay3(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(58);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void Sustain1(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(116);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void release3(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(60);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void OP3(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(61);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void attack4(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(53);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void decay4(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(54);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void Sustain4(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(55);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void release4(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(56);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void detune2(int val3)
{
 
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(64);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void Gain1(int val3)
{
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(94);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void Gain2(int val3)
{
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(95);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void Gain3(int val3)
{
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(96);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
public void Gain4(int val3)
{
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(97);
   byte[] c= intToByteArray(val3);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);

}
void Octave (int val)
{
  keyOctave=val;
}
public void Init(int val)
{
  byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(234);
   byte[] c= intToByteArray(val);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);
}

void Speed( int val)
{
 gui2.get(Matrix.class, "Sequencer").setInterval( val);
 iSpeed=val*16;
}
void Oct (int val)
{
 oct=val; 
}
public void Off(int val)
{

} 
void Steps (int val)
{
  stepNum=val;
}
public void One (int val)
{
 

}

public void Two (int val)
{

}

public void Three (int val)
{

}

public void Four (int val)
{
 
}

public void Five (int val)
{
  
}

public void Wave (int val)
{
  byte[] ident={'s'};
  bt.broadcast(ident);

//preset();
}
public void Six (int val)
{

}
public void Seven (int val)
{
 
}
public void Eight (int val)
{
 
}
public void Nine (int val)
{
 
}
void CLR()
{
   gui2.get(Matrix.class, "Sequencer").clear();
     byte[] ident2=intToByteArray(0x81);
    bt.broadcast(ident2);
 byte[] noteP2=intToByteArray(0);
  byte[] noteV2=intToByteArray(0);
  bt.broadcast(noteP2);
  bt.broadcast(noteV2);
}
public static final int unsignedShortToInt(byte[] b) 
{
    int i = 0;
    i |= b[0] & 0xFF;
    i <<= 8;
    i |= b[1] & 0xFF;
    return i;
}
public static byte[] intToByteArray(int value) {
byte[] b = new byte[1];
for (int i = 0; i < 1; i++) {
int offset = (b.length - 1 - i) * 8;
b[i] = (byte) ((value >>> offset) & 0xFF);
}
return b;
}

public static int byteArrayToInt(byte[] b) 
{
    return   b[3] & 0xFF |
            (b[2] & 0xFF) << 8 |
            (b[1] & 0xFF) << 16 |
            (b[0] & 0xFF) << 24;
}

void mousePressed()
{
  if(mouseX>270 && mouseX <510 && mouseY >700 && mouseY <740 )
{
  cont1=true;
  cont2=false;
  cont3=false;
}
 if(mouseX>535 && mouseX <775 && mouseY >700 && mouseY <740)
{
  cont1=false;
  cont2=true;
  cont3=false;
}
 if(mouseX>810 && mouseX <1050 && mouseY >700 && mouseY <740)
{
 
  cont1=false;
  cont2=false;
  cont3=true;
}
}

void reset()
{byte[] ccCode=intToByteArray(0xb0);
   byte[] ccNum= intToByteArray(234);
   byte[] c= intToByteArray(0);
bt.broadcast(ccCode);
bt.broadcast(ccNum);
bt.broadcast(c);
}
