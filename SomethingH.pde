import processing.sound.*;


MainGame MG = new MainGame(640);
VapourLevel VL = new VapourLevel();
SoundFile music;

boolean MGOn = false;
boolean VLDone = false;

void setup()
{
  size(840, 600, P3D);
  surface.setResizable(false);
  MG.setup();
  VL.setup();
  music = new SoundFile(this, dataPath("SH8.mp3"));
  //music.loop(1,0.5);
}


void draw()
{
  if (MGOn)
  {
    MG.draw();
  } else
  {
    VL.draw();
  }
}

void mousePressed()
{
  if(MGOn)
  {
   MG.mouseClick(mouseButton,this); //Need to pass refrence to this to chage MGOn
   if(MGOn == false)
   {
	   MG.reset();
   }
  }
  else
  {
   VL.mouseClick(mouseButton,this);
  }
}

void keyPressed() {
  if (MGOn)
  {
    MG.setMove(key, true);
  }
}

void keyReleased() {
  if (MGOn)
  {
    MG.setMove(key, false);
  }
}
