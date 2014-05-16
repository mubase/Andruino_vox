AndruinoVox: 
Arduino XMEGA FM synthesizer and sequencer. Wirelessly controlled by an Android Tablet over Bluetooth.

Andruinovox is an FM synthesizer and sequencer developed on an XAduino board. XAduino comes in the shape of an Arduino Mega board but uses an ATXMEGA128A3U as its' core. The synthesizer has two voices, one for the synthesizer and one for the sequencer.  The FM code was originally developed by Gordon JC Pearce and can be viewed here:
https://github.com/gordonjcp/gyoza/tree/master/fmtoy

 Each voice has two FM operators. All parameters are controllable by an Android tablet which connects to XAduino via an HC-06 Bluetooth module.
The Android GUI consists of two screens:
1 for the synthesizer consisting of a rudimentary musical keyboard of 2 octaves and a series of sliders for controlling the voice parameters of envelope, LFO, gains and ratio for all 4 FM operators. The sequencer screen contains a 16 x 16 matrix grid. Sequences are programmed by pressing on the cells of the grid, the Y-axis of which denotes the pitch of the note which is mapped on the Y-axis from the bottom upwards. The buttons start and stop the sequencer, and change the wave shape of the LFO. The sliders control the speed, octave and number od sequencer steps.


This program uses the Ketai library from Daniel Sauter and the ControlP5 graphics controller library.

I do intend to port this code to the DUE at some point and maybe the STM32 NUCLEO L152RE....
Any questions, email : defacato@gmail.com
  
