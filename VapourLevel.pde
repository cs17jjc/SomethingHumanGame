class VapourLevel
{
  int cols, rows;
  int scl = 20;
  int w = 2000;
  int h = 1600;
  boolean[] Keys = new boolean[4];
  float flying = 0;

  float[][] terrain;

  PImage CarBack;
  PImage BG;

  PVector CarSize = new PVector(80, 48);
  PVector CarPos = new PVector(0,0);

  void setup() {
    cols = w / scl;
    rows = h/ scl;
    terrain = new float[cols][rows];
    CarBack = loadImage(dataPath("CarBackRet.png"));
    //BG = loadImage(dataPath("VLBack.png"));
    ChangeCarSize(15);
  }


  void draw() {
    background(0);
    
    //generate perlin noise stuff
    flying -= 0.1;//inc perlin counter
    float yoff = flying;
    for (int y = 0; y < rows; y++) {
      float xoff = 0;
      for (int x = 0; x < cols; x++) {

        terrain[x][y] = noise(xoff, yoff);

        xoff += 0.2;
      }
      yoff += 0.2;
    }



    
    noFill();


    //render perlin feild
    pushMatrix();
    translate(width/2, height/2+50);
    rotateX(PI/2);
    translate(-w/2, -h/2);
    fill(100);
    //rect((cols*20)/2 - 45, 0, 90, rows * 20);
    noFill();
    for (int y = 0; y < rows-1; y++) {

      beginShape(TRIANGLE_STRIP);
      for (int x = 0; x < cols; x++) {
        stroke(ColourConv(terrain[x][y], 1)-50, 0, ColourConv(terrain[x][y], 1));
        if (x >= (cols/2) + 4 || x <= (cols/2) - 4)
        {

          vertex(x*scl, y*scl, lerp(-100, 100, terrain[x][y]));
          vertex(x*scl, (y+1)*scl, lerp(-100, 100, terrain[x][y]));
          //rect(x*scl, y*scl, scl, scl);
        } else
        {
          //noStroke();
          vertex(x*scl, y*scl, 0);
          vertex(x*scl, (y+1)*scl, 0);
        }
      }
      endShape();
    }
    popMatrix();
    //draw car
    pushMatrix();
    translate(width/2, height/2 + CarSize.y,85);
    DrawImage3D(CarBack, (int)CarPos.x, (int)CarPos.y, 300, (int)CarSize.x, (int)CarSize.y);
    popMatrix();
    
    
    if (Keys[0])// key a
    {
      CarPos.x -= CarPos.x > -15 ? 3:0;
    }
    if (Keys[1])// key d
    {
      CarPos.x += CarPos.x < 15 ? 3:0;
    }
    
  }


  void ChangeCarSize(float w)
  {
    //Original size 226 by 136 = 113 : 68 
    //h = (w*68)/113
    CarSize.y = (w*68)/113;
    CarSize.x = w;
  }
  boolean setMove(int k, boolean b) {
    switch (k) {
    case 'w':
      return Keys[2] = b;

    case 's':
      return Keys[3] = b;

    case 'a':
      return Keys[0] = b;

    case 'd':
      return Keys[1] = b;

    default:
      return b;
    }
  }
}



int ColourConv(float i, int max)
{
  //println(i/max);
  return (int)lerp(0, 255, (float)i/(float)max);
}

void DrawImage3D(PImage img, int x, int y, int z, int w, int h)
{
  //need to draw as shape to set z pos
  int xC = x - w/2;//x Centered
  noStroke();
  beginShape();
  texture(img);
  vertex(xC, y, z, 0, 0);
  vertex(xC + w, y, z, img.width, 0);
  vertex(xC+w, y+h, z, img.width, img.height);
  vertex(xC, y+h, z, 0, img.height);
  endShape();
}
