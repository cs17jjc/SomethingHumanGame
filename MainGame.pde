

class MainGame
{
  int RoadWidth = 100;
  PImage car;
  PImage WD;
  PImage SPD;
  PImage rock;
  PImage Cover;
  PImage LightG;
  PImage LightR;
  PImage WP;
  PFont SegF;
  PVector pos = new PVector(0, 0);
  float Speed = 10;
  float amt = 0;
  ArrayList<PVector> Rocks = new ArrayList<PVector>();
  ArrayList<PVector> RoadLines = new ArrayList<PVector>();
  ArrayList<PVector> WarpPlasma = new ArrayList<PVector>();
  int yOff = -20;
  int Width = 500;
  int Height = 500;
  int LinesCount;
  int LightCount = 0;
  int CurLight = 0;
  boolean[] Keys = new boolean[4];
  boolean[] Lights = new boolean[9];


  void setup()
  {
    pos = new PVector(Width/2, Height/3);
    car = loadImage("CarWIP.png");
    WD = loadImage("WDTemp.png");
    rock = loadImage("Rock.png");
    SPD = loadImage("SPDTemp.png");
    Cover = loadImage("InterfaceCover.png");
    SegF = createFont("SEGF.ttf", 40);
    LightG = loadImage("SPDLiG.png");
    LightR = loadImage("SPDLiR.png");
    WP = loadImage("WarpPlasma.png");
    for (int y = 0; y < height; y+=90)
    {
      RoadLines.add(new PVector(Width/2, y));
    }
  }


  void draw()
  {
    background(250, 180, 50);
    fill(0);
    rect((Width/2) - (RoadWidth/2), 0, RoadWidth, Height);
    DrawInterfaces((int)lerp(50, 93, amt), Lights);

    // Move,Draw and Delete rocks
    for (int i = Rocks.size()-1; i >=0; i--)
    {
      if (Rocks.get(i).y > Width)
      {
        Rocks.remove(i);
      } else
      {
        fill(150, 130, 25);
        PVector r = Rocks.get(i);
        image(rock, r.x, r.y, 20, 20);
        r.y += Speed;
        Rocks.set(i, r);
      }
    }
    //Move,Draw and Delete road lines
    for (int i = RoadLines.size()-1; i >=0; i--)
    {
      PVector n = RoadLines.get(i);
      if (n.y > height + 30)
      {
        RoadLines.remove(i);
      } else
      {
        stroke(255);
        line(n.x, n.y, n.x, n.y+30);
        n.y += Speed;
      }
    }
    //Move,Draw and Delete Warp Plasmas
    for (int i = WarpPlasma.size()-1; i >=0; i--)
    {
      PVector r = WarpPlasma.get(i);
      if (r.y > Width)
      {
        WarpPlasma.remove(i);
      } else if (Intersects((int)r.x, (int)r.y, 20, 20, (int)pos.x, (int)pos.y, 26, 45))
      {
        WarpPlasma.remove(i);
        IncLights();
      } else
      {
        rectMode(CENTER);
        fill(255, 0, 255);
        image(WP, r.x, r.y, 20, 20);
        r.y += Speed;
        WarpPlasma.set(i, r);
        rectMode(CORNER);
      }
    }



    //Keep track of when to add new lines where rate of line adding is proportional to speed
    LinesCount += 1;
    if (LinesCount >= 25 - Speed)
    {
      RoadLines.add(new PVector(Width/2, 0));
      LinesCount = 0;
    }
    //add new rocks
    if (random(100) > 90+ 10 -Speed)
    {
      int x = (int)random(Width-20);
      if (x+20 > (Width/2) - (RoadWidth/2) && x-20 < (Width/2) + (RoadWidth/2))
      {
      } else
      {
        Rocks.add(new PVector(x, 0));
      }
    }
    if (random(100) > 97 + 0.9*(10 -Speed))
    {
      int rl = (int)random(100);
      if (rl >= 50)
      {
        WarpPlasma.add(new PVector((Width/2) - (RoadWidth/4), 0));
      } else
      {
        WarpPlasma.add(new PVector((Width/2) + (RoadWidth/4), 0));
      }
    }



    imageMode(CENTER);
    translate(pos.x, pos.y - yOff);

    //Check Keys array
    if (Keys[0])// key a
    {
      pos.x -= (int)lerp(3, 6, amt);
      rotate(-HALF_PI/4);
    }
    if (Keys[1])// key d
    {
      pos.x += (int)lerp(3, 6, amt);
      rotate(HALF_PI/4);
    }
    if (Keys[2])// key w
    {
      amt += amt+0.1 <= 1 ? 0.1:0;
      Speed = lerp(10, 20, amt);
      yOff = (int)lerp(-40, 30, amt);
    } else
    {
      amt -= amt-0.02 >= 0 ? 0.02:0;
      Speed = lerp(10, 20, amt);
      yOff = (int)lerp(-40, 30, amt);
    }
    if (Keys[3])// key s
    {
      amt -= amt-0.1 >= 0 ? 0.1:0;
      Speed = lerp(10, 20, amt);
      yOff = (int)lerp(-40, 30, amt);
    }


    image(car, 0, 0);
  }

  boolean Intersects(int x1, int y1, int w1, int h1, int x2, int y2, int w2, int h2)
  {
    if (x1 > x2 && x1 < x2 + w2)
    {
      if (y1 > y2 && y1 < y2 + h2)
      {
        //x1y1 is in x2y2
        return true;
      }
    }
    if (x1 + w1 > x2 && x2 + w2 > x1)
    {
      if (y1 + h1 > y2 && y2 + h2 > y1)
      {
        //Intersection
        return true;
      }
    }
    return false;
  }

  void IncLights()
  {
    LightCount += 1;
    String b = binary(LightCount, 9);
    for (int i = 0; i < b.length(); i++)
    {
      if (b.charAt(i) == '1')
      {
        Lights[i] = true;
      } else
      {
        Lights[i] = false;
      }
    }
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

  void DrawInterfaces(int Speed, boolean[] SPDLights)
  {
    rect(Width, 0, width-Width, height);
    image(WD, width - WD.height/2, height-WD.height/2);
    image(SPD, width - SPD.height/2, SPD.height/2);
    image(Cover, width - WD.height/2, height-WD.height/2);
    image(Cover, width - SPD.height/2, SPD.height/2);
    fill(255, 0, 0);
    textFont(SegF);
    text(Speed + "mph", Width + 20, 53);
    for (int i = 0; i < 9; i++)
    {
      if (SPDLights[i] == true)
      {
        image(LightG, Width + 20  + (i*20), 80);
      } else
      {
        image(LightR, Width + 20 + (i*20), 80);
      }
    }
  }
}
