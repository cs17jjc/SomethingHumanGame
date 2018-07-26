import processing.sound.*;


MainGame MG = new MainGame();
VapourLevel VL = new VapourLevel();
SoundFile music;

boolean MGOn = true;

void setup()
{
  size(700, 500,P3D);
  MG.setup();
  VL.setup();
  music = new SoundFile(this,dataPath("SH8.mp3"));
  music.play(1,0.02);
}


void draw()
{
  if(MGOn)
  {
  MG.draw();
  }
  else
  {
  VL.draw();
  }
}

void mousePressed()
{
 MGOn = !MGOn; 
}

void keyPressed() {
  if(MGOn)
  {
  MG.setMove(key, true);
  }
  else
  {
    VL.setMove(key, true);
  }
}

void keyReleased() {
  if(MGOn)
  {
  MG.setMove(key, false);
  }
  else
  {
    VL.setMove(key, false);
  }
}
