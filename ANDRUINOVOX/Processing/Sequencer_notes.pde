//The matrix function to update the ntoes played along the x axis. The y axis determines the note values

public int Sequencer(int theX, int theY) {

  d[theX][theY].update();
    
   oldval=theX;
 
//int oct;
byte [] ident;
byte [] noteP;
byte [] noteV;
byte []  ident2;
 byte []  noteP2;
 byte []  noteV2;
  int note=theY;
   if (oldval2 !=oldval)
  {
   ident=intToByteArray(0x91);
    bt.broadcast(ident);
  noteP=intToByteArray(0);
   noteV=intToByteArray(0x0);
  bt.broadcast(noteP);
  bt.broadcast(noteV); 
  }
  int next=theX;
// switch case for sequencer note triggering
  switch(note)
  {
case 0:
   
     ident=intToByteArray(0x91); // convert MIDI note on byte to byte array
    bt.broadcast(ident);         // send byte over Bluetooth
  // value of note: Y axis value and octave set by slider
  noteP=intToByteArray(42+(12*oct));
  // value of velocity byte (0x7a)
   noteV=intToByteArray(0x7a);
  // send note value and velocity over bluetooth.
  bt.broadcast(noteP);
  bt.broadcast(noteV); 
 
    break;
    case 1:
     ident=intToByteArray(0x91);
    bt.broadcast(ident);
  noteP=intToByteArray(41+(12*oct));
   noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
 
    break;
    case 2:
     ident=intToByteArray(0x91);
    bt.broadcast(ident);
  noteP=intToByteArray(40+(12*oct));
   noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
  // ident=intToByteArray(0x80);
  //  bt.broadcast(ident);
    break;
    case 3:
     ident=intToByteArray(0x91);
    bt.broadcast(ident);
  noteP=intToByteArray(39+(12*oct));
   noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV); 
 //  ident=intToByteArray(0x80);
 //   bt.broadcast(ident);
 
    break;
    case 4:
        ident=intToByteArray(0x91);
    bt.broadcast(ident);
  noteP=intToByteArray(38+(12*oct));
   noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
 
    break;
    case 5:
     ident=intToByteArray(0x91);
    bt.broadcast(ident);
  noteP=intToByteArray(37+(12*oct));
   noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
 
    break;
    case 6:
     ident=intToByteArray(0x91);
    bt.broadcast(ident);
  noteP=intToByteArray(36+(12*oct));
   noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);

    break;
    case 7:
     ident=intToByteArray(0x91);
    bt.broadcast(ident);
  noteP=intToByteArray(35+(12*oct));
   noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
 
    break;
    case 8:
      ident=intToByteArray(0x91);
    bt.broadcast(ident);
  noteP=intToByteArray(34+(12*oct));
   noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);


    break;
    case 9:
      ident=intToByteArray(0x91);
    bt.broadcast(ident);
  noteP=intToByteArray(33+(12*oct));
   noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
 
    break;
    case 10:
      ident=intToByteArray(0x91);
    bt.broadcast(ident);
  noteP=intToByteArray(32+(12*oct));
   noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
 
    break;
    case 11:   ident=intToByteArray(0x91);
    bt.broadcast(ident);
  noteP=intToByteArray(31+(12*oct));
   noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV); 

    break;
    case 12:
      ident=intToByteArray(0x91);
    bt.broadcast(ident);
  noteP=intToByteArray(30+(12*oct));
   noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
 
    break;
    case 13:
      ident=intToByteArray(0x91);
    bt.broadcast(ident);
  noteP=intToByteArray(29+(12*oct));
   noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);

    break;
    case 14:
      ident=intToByteArray(0x91);
    bt.broadcast(ident);
  noteP=intToByteArray(28+(12*oct));
   noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
 
    break;
    case 15:
      ident=intToByteArray(0x91);
    bt.broadcast(ident);
  noteP=intToByteArray(27+(12*oct));
   noteV=intToByteArray(0x7a);
  bt.broadcast(noteP);
  bt.broadcast(noteV);
 
    break;
   
  }

 return theX+theY;
}
