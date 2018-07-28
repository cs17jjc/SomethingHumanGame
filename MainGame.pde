class MainGame
{
  int RoadWidth = 100;
  //TODO Possibly store images in array
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
  int MaxPlasmas = 50;
  float SpeedCount = 0;
  float SpeedInc = 0.1;
  int CurLight = 0;
  boolean[] Keys = new boolean[4];
  boolean[] Lights = new boolean[9];
  String WarpMessage = "";

  MainGame(int Width)
  {
    this.Width = Width;
    this.Height = Width;
  }


  void setup()
  {
    pos = new PVector(Width/2, Height/2);
    //Load assets, should probs put this in initiliser 
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
    rect((Width/2) - (RoadWidth/2), 0, RoadWidth, Height);//draw road
    DrawInterfaces((int)lerp(50, 88, amt), Lights, LightCount, MaxPlasmas, SpeedCount, WarpMessage);//draw UI stuff

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
      } else if (Intersects((int)r.x-WP.width/2 + 3 , (int)r.y-WP.width/2 + 3, 20-6, 20-6, (int)pos.x - car.width/2, (int)(pos.y - yOff - car.height*1.5), 26, 45))
      {
        WarpPlasma.remove(i);
        IncLights();
      } else
      {
        rectMode(CORNER);
        imageMode(CENTER);
        //fill(255, 0, 255);
        //rect((int)r.x-WP.width/2 + 3 , (int)r.y-WP.width/2 + 3, 20-6, 20-6);
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


    pushMatrix();
    //rectMode(CORNER);
    //rect((int)pos.x - car.width/2, pos.y - yOff - car.height*1.5, 26, 45); //Used for showing bounding box
    imageMode(CENTER);
    translate(pos.x, pos.y - yOff - car.height, 1);//translate to car pos

    //Check Keys array
    if (Keys[0])// key a
    {
      pos.x -= (int)lerp(3, 6, amt);
      if(pos.x <= car.width)
      {
       pos.x = car.width; 
      }
      else
      {
      rotate(-HALF_PI/4);
      }
    }
    if (Keys[1])// key d
    {
      pos.x += (int)lerp(3, 6, amt);
      if(pos.x >= Width-car.width)
      {
       pos.x = Width-car.width; 
      }
      else
      {
      rotate(HALF_PI/4);
      }
    }
    if (Keys[2])// key w
    {
      amt += amt+0.1 <= 1 ? 0.1:0;
      if (amt+0.1 > 1.0) amt = 1;
      Speed = lerp(10, 20, amt);
      yOff = (int)lerp(0, height/4, amt);
    } else
    {
      amt -= amt-0.02 >= 0 ? 0.02:0;
      if (amt < 0.0) amt = 0;
      Speed = lerp(10, 20, amt);
      yOff = (int)lerp(0, height/4, amt);
    }
    if (Keys[3])// key s
    {
      amt -= amt-0.1 >= 0 ? 0.1:0;
      if (amt < 0.0) amt = 0;
      Speed = lerp(10, 20, amt);
      yOff = (int)lerp(0, height/4, amt);
    }


    image(car, 0, 0);
    
    popMatrix();
    

    if (LightCount >= MaxPlasmas)
    {
      if ((int)lerp(50, 88, amt) == 88)
      {
        if (SpeedCount < 100)
        {
          WarpMessage = "Keep At 88";
          if (SpeedCount + SpeedInc > 100)
          {
            SpeedCount = 100;
          } else
          {
            SpeedCount += SpeedInc;
          }
        } else
        {
          WarpMessage = "WARP";
        }
      } else
      {
        if (SpeedCount >= 0)
        {
          WarpMessage = "Speed Up";
          if (SpeedCount - SpeedInc < 0)
          {
            SpeedCount = 0;
          } else
          {
            SpeedCount -= SpeedInc;
          }
        }
      }
    } else
    {
      WarpMessage = "Need More Plasma";
    }
  }

  void mouseClick(int Button, SomethingH Parent)
  {
    println("clicked");
    if (Button == LEFT)
    {
      if (Intersects(mouseX, mouseY, 1, 1, Width + 16, height-WD.height + 87, 170, 100))
      {
        //warp drive clicked
        println("Warp Drive Clicked");
        if (LightCount >= MaxPlasmas)
        {
          Parent.MGOn = false;
        }
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

  void DrawInterfaces(int Speed, boolean[] SPDLights, int PlasmaCount, int MaxPlasma, float SpeedCount, String WarpMessage)
  {
    rect(Width, 0, width-Width, height);
    image(WD, width - WD.height/2, height-WD.height/2);
    image(SPD, width - SPD.height/2, SPD.height/2);
    image(Cover, width - WD.height/2, height-WD.height/2);
    image(Cover, width - SPD.height/2, SPD.height/2);
    fill(255, 0, 0);
    textFont(SegF);
    text(Speed + "mph", Width + 20, 53);
    fill(0, 255, 0);
    textSize(9);
    text("Plasma Count: " + PlasmaCount, Width + 22, 106);
    text("Plasma Needed: " + MaxPlasma, Width + 22, 131);

    if (WarpMessage != "WARP")
    {
      textSize(25);
      int LineSpace = 0;
      String[] MsgSplit = WarpMessage.split(" ");
      for (String s : MsgSplit)
      {
        text(s, Width+20, height-85+LineSpace);
        LineSpace += 30;
      }
    } else
    {
      if (Intersects(mouseX, mouseY, 1, 1, Width + 16, height-WD.height + 87, 170, 100))
      {
        fill(255,0,0);
      }
      else
      {
       fill(0,255,0); 
      }
      textSize(40);
      text(WarpMessage,Width+37,height-45);
    }


    for (int i = 0; i < 9; i++)
    {
      if (SpeedCount < (100/9)*i)
      {
        image(LightR, Width + 22  + (i*20), height-130);
      } else
      {
        image(LightG, Width + 22 + (i*20), height-130);
      }
      if (SPDLights[i] == true || PlasmaCount >= MaxPlasma)
      {
        image(LightG, Width + 20  + (i*20), 80);
      } else
      {
        image(LightR, Width + 20 + (i*20), 80);
      }
    }
  }
}
