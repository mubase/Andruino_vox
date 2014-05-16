// extend the Matrix class since we need to override the Matrix's sequencer
// Matrix and preset store and recall 
int seqn=0;
int stepNum=16;
class CustomMatrix extends Matrix {
 
  // add a list to store some presets
  ArrayList<int[][]> presets = new ArrayList<int[][]>();
  int currentPreset = 0;
  Thread update;
 
  CustomMatrix(ControlP5 cp5, String theName) {
    super(gui2, theName);
    stop(); // stop the default sequencer and
    // create our custom sequencer thread. Here we 
    // check if the sequencer has reached the end and if so
    // we updated to the next preset.
    
    update = new Thread(theName) {
      public void run( ) {
        while ( true ) {
          if (starton || startonsyn ==true || starton==true && startonsyn==false || startonsyn==true && starton==false ){
          cnt++;
          cnt %= _myCellX-_myCellX+stepNum;
          if (cnt==0) {
            // we reached the end and go back to start and 
            // update the preset 
           
            if (seqn>7)
            seqn=0;
           // next();
           // which sequence to play>?????
            switch(sequenceArray[seqn])
    {
       case 0:
     for ( int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval1[currentrow * columnsnumber + currentcolumn] = gets2[currentrow] [currentcolumn];

 value1 =bxval1[currentrow * columnsnumber + currentcolumn];

  gui2.get(CustomMatrix.class, "Sequencer").set(currentrow,currentcolumn,value1);  
  selected=0;
 }
 }
  break;
   case 1:
     for ( int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval2[currentrow * columnsnumber + currentcolumn] = gets4[currentrow] [currentcolumn];

 value2 =bxval2[currentrow * columnsnumber + currentcolumn];

  gui2.get(CustomMatrix.class, "Sequencer").set(currentrow,currentcolumn,value2);  
  selected=1;
 }
 }
  break;
   case 2:
     for ( int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval3[currentrow * columnsnumber + currentcolumn] = gets6[currentrow] [currentcolumn];

 value3 =bxval3[currentrow * columnsnumber + currentcolumn];

  gui2.get(CustomMatrix.class, "Sequencer").set(currentrow,currentcolumn,value3);  
  selected=2;
 }
 }
  break;
  
      case 3:
     for ( int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval4[currentrow * columnsnumber + currentcolumn] = gets8[currentrow] [currentcolumn];

 value4 =bxval4[currentrow * columnsnumber + currentcolumn];

  gui2.get(CustomMatrix.class, "Sequencer").set(currentrow,currentcolumn,value4);  
  selected=3;
 }
 }
  break;
   case 4:
     for ( int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval5[currentrow * columnsnumber + currentcolumn] = gets10[currentrow] [currentcolumn];

 value5 =bxval5[currentrow * columnsnumber + currentcolumn];

  gui2.get(CustomMatrix.class, "Sequencer").set(currentrow,currentcolumn,value5);  
  selected=4;
 }
 }
  break;
   case 5:
     for ( int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval6[currentrow * columnsnumber + currentcolumn] = gets12[currentrow] [currentcolumn];

 value6 =bxval6[currentrow * columnsnumber + currentcolumn];

  gui2.get(CustomMatrix.class, "Sequencer").set(currentrow,currentcolumn,value6);  
  selected=5;
 }
 }
  break;
   case 6:
     for ( int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval7[currentrow * columnsnumber + currentcolumn] = gets14[currentrow] [currentcolumn];

 value7 =bxval7[currentrow * columnsnumber + currentcolumn];

  gui2.get(CustomMatrix.class, "Sequencer").set(currentrow,currentcolumn,value7);  
  selected=6;
 }
 }
  break;
   case 7:
     for ( int currentrow = 0; currentrow < rowsnumber; currentrow++)
 {
 for (int currentcolumn = 0; currentcolumn < columnsnumber; currentcolumn++)
 {
 bxval8[currentrow * columnsnumber + currentcolumn] = gets16[currentrow] [currentcolumn];

 value8 =bxval8[currentrow * columnsnumber + currentcolumn];

  gui2.get(CustomMatrix.class, "Sequencer").set(currentrow,currentcolumn,value8);  
  selected=7;
 }
 }
  break;
  default:
  
  break;

    }
           seqn++;    }
          
          trigger(cnt);
          
          try {
            sleep( _myInterval );
          } 
          catch ( InterruptedException e ) {
          }
          }
        }
      }
    };
 
    update.start();
  }
 
 
  void next() {
 
  
  }
  // initialize some random presets. // not used.
  void initPresets() {
    for (int i=0;i<1;i++) {
     presets.add(createPreset(_myCellX, _myCellY));
      
    }
//   setCells(presets.get(0));
  }
 
  // create a random preset
  int[][] createPreset(int theX, int theY) {
    int[][] preset = new int[theX][theY];
    for (int x=0;x<theX;x++) {
      for (int y=0;y<theY;y++) {
        preset[x][y] = random(1)>0.5 ? 1:0;
      
      }
    }
    return preset;
  }
 
}
