import processing.sound.*;


MainGame MG = new MainGame(640);
VapourLevel VL = new VapourLevel();
SoundFile music;

boolean MGOn = true;

void setup()
{
  size(840, 600, P3D);
  MG.setup();
  VL.setup();
  music = new SoundFile(this, dataPath("SH8.mp3"));
  music.loop(1,0.01);
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
   MG.mouseClick(mouseButton,this); 
  }
}

void keyPressed() {
  if (MGOn)
  {
    MG.setMove(key, true);
  } else
  {
    VL.setMove(key, true);
  }
}

void keyReleased() {
  if (MGOn)
  {
    MG.setMove(key, false);
  } else
  {
    VL.setMove(key, false);
  }
}
