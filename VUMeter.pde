


class VUMeter
{
  PImage VU;
  PVector Pos;
  PVector TargetPoint;
  PVector Point;
  int PInd = 0;
  int TInd = 0;
  boolean NextP;
  ArrayList<PVector> Points = new ArrayList<PVector>();
 VUMeter(PVector Pos,int PCount,ArrayList<PVector> Points)
 {
   VU = loadImage(dataPath("VUM.png"));
   this.Pos = Pos;
   this.Point = Points.get(PCount).copy();
   this.TargetPoint = Points.get(PCount).copy();
   this.Points = Points;
 }
 
 
 void draw()
 {
   pushMatrix();
   translate(Pos.x,Pos.y);
   scale(0.475);
   image(VU,0,0);
   strokeWeight(5);
   stroke(255,0,0);
   line(100,109,Point.x,Point.y);
   strokeWeight(1);
   popMatrix();
 }
  
  void DoLerp()
  {
    if(abs(PInd - TInd)  != 0 && NextP)
    {
      PInd += TInd - PInd >= 0 ? 1:-1;
      NextP = false;
      TargetPoint = Points.get(PInd);
    }
    Point.x = lerp(Point.x,TargetPoint.x,0.15);
    Point.y = lerp(Point.y,TargetPoint.y,0.15);
    if(Point.dist(TargetPoint) < 5)
    {
     NextP = true; 
    }
  }
  
  void ChangeTarget(int i)
  {
    TInd = i;
  }
  
}