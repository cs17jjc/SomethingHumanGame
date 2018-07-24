import processing.sound.*;


MainGame MG = new MainGame();
SoundFile music;

void setup()
{
  size(700, 500);
  MG.setup();
  music = new SoundFile(this,dataPath("SH8.mp3"));
  music.play(1,0.3);
}


void draw()
{
  MG.draw();
}

  void keyPressed() {
    MG.setMove(key, true);
  }

  void keyReleased() {
    MG.setMove(key, false);
  }
