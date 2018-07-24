class VapourLevel
{
  int cols, rows;
  int scl = 20;
  int w = 2000;
  int h = 1600;

  float flying = 0;

  float[][] terrain;

  PImage CarBack;

  PVector CarSize = new PVector(80, 48);
  
  void setup() {
    cols = w / scl;
    rows = h/ scl;
    terrain = new float[cols][rows];
    CarBack = loadImage(dataPath("CarBackRet.png"));
  }


  void draw() {

    flying -= 0.1;

    float yoff = flying;
    for (int y = 0; y < rows; y++) {
      float xoff = 0;
      for (int x = 0; x < cols; x++) {

        terrain[x][y] = noise(xoff, yoff);

        xoff += 0.2;
      }
      yoff += 0.2;
    }



    background(0);
    noFill();



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
    pushMatrix();
    translate(width/2, (height - CarBack.height*2) + CarSize.y/2);
    DrawImge3D(CarBack, 0, 0, 300, (int)CarSize.x, (int)CarSize.y);
    popMatrix();
  }


  void ChangeCarSize(float w)
  {
    //Original size 226 by 136 = 113 : 68 
    //h = (w*68)/113
    CarSize.y = (w*68)/113;
    CarSize.x = w;
  }
}



int ColourConv(float i, int max)
{
  //println(i/max);
  return (int)lerp(0, 255, (float)i/(float)max);
}

void DrawImge3D(PImage img, int x, int y, int z, int w, int h)
{
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
