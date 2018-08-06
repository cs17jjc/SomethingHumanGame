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
  PImage UpgradeUI;
  PImage VU;
  PImage[] Buttons = new PImage[7];
  PImage[] Icons = new PImage[6];
  PImage[] Lights = new PImage[2];

  int[] DisplayValues = new int[4];
  ArrayList<VUMeter> Display = new ArrayList<VUMeter>();
  ArrayList<PVector> VUP = new ArrayList<PVector>();
  PVector CarSize = new PVector(80, 48);
  PVector CarPos = new PVector(0, 0);
  PVector UILCDMiddle = new PVector(169, 73);
  PVector UILCDSize = new PVector(288, 96);

  int SelectedButton = 0;
  int CurP = 0;
  
  int[][] CarData = new int[6][4];

  void setup() {
    cols = w / scl;
    rows = h/ scl;
    terrain = new float[cols][rows];
    CarBack = loadImage(dataPath("CarBackRet.png"));
    UpgradeUI = loadImage(dataPath("UpgradeUI.png"));
    Lights[0] = loadImage(dataPath("SPDLiG.png"));
    Lights[1] = loadImage(dataPath("SPDLiR.png"));
    AddPoints();

    LoadCar(new int[][]{{0,1,2,0},{3,3,3,3},{2,3,4,5},{0,2,5,6},{3,4,4,3},{5,5,5,5}});

    for (int i = 0; i < DisplayValues.length; i++)
    {
      Display.add(new VUMeter(new PVector(330 + i*105, 20), 0, VUP));
    }

    ChangeCarSize(15);//edit car size
    //load images for buttons and icons
    File folder = new File(dataPath("Buttons"));
    String[] fileNames = folder.list();
    for (int i = 0; i < fileNames.length; i++) 
    {
      Buttons[i] = loadImage(folder.getPath() +"/"+ fileNames[i]);
    }
    folder = new File(dataPath("Mesh"));
    fileNames = folder.list();
    for (int i = 0; i < fileNames.length; i++) 
    {
      Icons[i] = loadImage(folder.getPath() +"/"+ fileNames[i]);
    }
    UpdateValues();
  }


  void draw() {
    background(0);
    DrawPerlin();
    //draw car
    pushMatrix();
    translate(width/2, height/2 + CarSize.y, 85);
    DrawImage3D(CarBack, (int)CarPos.x, (int)CarPos.y, 300, (int)CarSize.x, (int)CarSize.y);
    popMatrix();
    //draw upgrade stuff
    image(UpgradeUI, 0, 0);
    imageMode(CENTER);
    DrawCarPart(SelectedButton);
    imageMode(CORNER);

    PVector ButtonPos = new PVector(25, 135);
    for (int i =0; i<Buttons.length-1; i++)
    {
      image(Buttons[i], ButtonPos.x, ButtonPos.y, 70, 23);
      pushMatrix();
      translate(70+25 + 15, ButtonPos.y + 23/2);
      imageMode(CENTER);
      if (SelectedButton == i)
      {
        image(Lights[0], 0, 0);
      } else
      {
        image(Lights[1], 0, 0);
      }
      imageMode(CORNER);
      popMatrix();

      ButtonPos.y += 25;
    }
    PVector DoneSize = new PVector(70*2.5, 23*2.5);
    image(Buttons[6], width- DoneSize.x - 8, height/2 - DoneSize.y - 8, DoneSize.x, DoneSize.y);

    for (int i = 0; i < Display.size();i++)
    {
      VUMeter V = Display.get(i);
      boolean Intersect = Intersects(mouseX,mouseY,1,1,(int)V.Pos.x,(int)V.Pos.y,(int)(V.VU.width*0.475),(int)(V.VU.height*0.475));
      V.draw(Intersect);
      V.DoLerp();
      if(mousePressed && Intersect)
      {
       println(i); 
      }
    }
  }


  void mouseClick(int Button, SomethingH Parent)
  {
    if (Button == LEFT)
    {
      PVector ButtonPos = new PVector(25, 135);
      for (int i =0; i<Buttons.length-1; i++)
      {
        if (Intersects(mouseX, mouseY, 1, 1, (int)ButtonPos.x, (int)ButtonPos.y, 70, 23))
        {
          SelectedButton = i;
          UpdateValues();
          i = Buttons.length;
        } else
        {
          ButtonPos.y += 25;
        }
      }
      PVector DoneSize = new PVector(70*2.5, 23*2.5);
      if (Intersects(mouseX, mouseY, 1, 1, (int)(width- DoneSize.x - 8), (int)(height/2 - DoneSize.y - 8), (int)DoneSize.x, (int)DoneSize.y))
      {
        //Done with upgrades
        Parent.MGOn = true;
      }
    }
  }

  boolean Intersects(int x1, int y1, int w1, int h1, int x2, int y2, int w2, int h2)
  {

    if (x1 > x2 && x1 < x2 + w2 || x1+w1 > x2 && x1+w1 < x2+w2)
    {
      if (y1 > y2 && y1 < y2+h2 || y1+h1 > y2 && y1+h1 < y2+h2)
      {
        return true;
      }
    }
    return false;
  }

  void DrawCarPart(int Opt1)
  {
    switch(Opt1)
    {
    case 0:
      image(Icons[0], UILCDMiddle.x, UILCDMiddle.y, 276, 64);
      break;
    case 1:
      image(Icons[1], UILCDMiddle.x, UILCDMiddle.y, 132, 64);
      break;
    case 2:
      image(Icons[2], UILCDMiddle.x, UILCDMiddle.y, 271 * 0.3, 269*0.3);
      break;
    case 3:
      image(Icons[3], UILCDMiddle.x, UILCDMiddle.y, 276*0.7, 134*0.7);
      break;
    case 4:
      image(Icons[4], UILCDMiddle.x, UILCDMiddle.y, 85, 85);
      break;
    case 5:
      image(Icons[5], UILCDMiddle.x, UILCDMiddle.y, 70, 70);
      break;
    }
  }


  void ChangeCarSize(float w)
  {
    //Original size 226 by 136 = 113 : 68 
    //h = (w*68)/113
    CarSize.y = (w*68)/113;
    CarSize.x = w;
  }

  void DrawPerlin()
  {
    //generate perlin noise stuff
    //float ff = 1.0/( (float)mouseY +1.0);
    //println(ff);
    flying -= 0.2;//inc perlin counter
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
          vertex(x*scl, y*scl, lerp(-100, 90, terrain[x][y]));
          vertex(x*scl, (y+1)*scl, lerp(-100, 90, terrain[x][y]));
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
  }

  void AddPoints()
  {
    VUP.add(new PVector(41, 51));
    VUP.add(new PVector(58, 38)); 
    VUP.add(new PVector(77, 29)); 
    VUP.add(new PVector(100, 26)); 
    VUP.add(new PVector(123, 29)); 
    VUP.add(new PVector(142, 38)); 
    VUP.add(new PVector(159, 51));
  }

  void UpdateValues()
  {
    DisplayValues = CarData[SelectedButton];
    for (int i = 0; i < DisplayValues.length; i++)
    {
      Display.get(i).ChangeTarget(DisplayValues[i]);
    }
  }
  
  void LoadCar(int[][] CD)
  {
    CarData = CD;
  }
  
  
  //----------------------------------------------------
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