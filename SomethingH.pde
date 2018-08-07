//import processing.sound.*;


MainGame MG = new MainGame(640);
VapourLevel VL = new VapourLevel();
//SoundFile music;

boolean MGOn = true;
boolean VLDone = false;
int[][] CarData = new int[6][4];

void setup()
{
  size(840, 600, P3D);
  surface.setResizable(false);
  loadCarData();
  MG.setup(CarData);
  VL.setup(CarData);
  //music = new SoundFile(this, dataPath("SH8.mp3"));
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
  if (MGOn)
  {
    MG.mouseClick(mouseButton, this); //Need to pass refrence to this to chage MGOn
    if(MGOn == false)
    {
     VL.loadCar(CarData);
    }
  } else
  {
    VL.mouseClick(mouseButton, this);
    if (MGOn == true)
    {
      MG.reset(CarData); // CarData gets changed in VL ExitUpgrade function(not confusing at all but fuck me i guess thats what comments are for)
      saveCarData();
    }
  }
}

void keyPressed() 
{
  if (MGOn)
  {
    MG.setMove(key, true);
  }
}

void keyReleased() 
{
  if (MGOn)
  {
    MG.setMove(key, false);
  }
}

void saveCarData()
{
  String[] SaveFile = new String[]{"", "", "", "", "", ""};
  for (int x = 0; x < CarData.length; x++)
  {
    for (int y = 0; y < CarData[x].length; y++)
    {
      SaveFile[x] += CarData[x][y];
    }
  }
  saveStrings(dataPath("CarData.cd"), SaveFile);
}

void loadCarData()
{
  int[][] parsedData = new int[6][4];
  String[] data = loadStrings(dataPath("CarData.cd")); 
  for (int i = 0; i<data.length; i++)
  {
    for (int j = 0; j<data[i].length(); j++) 
    {
      parsedData[i][j] = int(data[i].charAt(j)) - int('0');
      println(parsedData[i][j]);
    }
  }
  CarData = parsedData;
}