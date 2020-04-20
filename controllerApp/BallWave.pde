class BallWave
{
  PVector location;
  PVector plocation;
  String  mText="";
  float life = frameRate * 2;

  public BallWave(String _text, float x, float y)
  {
    mText = _text;
    location = new PVector(x, y);
  }

  public BallWave(String _text, float x, float y, float px, float py)
  {
    mText = _text;
    location = new PVector(x, y);
    plocation = new PVector(px, py);
  }

  public void draw()
  {
    pushStyle();
    stroke(0);
    if (life > 0)
      noFill();
      strokeWeight(map(life,frameRate*2,0,20,width/5));
      circle(location.x,location.y,map(life,frameRate*2,0,width/20,4*width));

    if (plocation != null)
      line(location.x, location.y, plocation.x, plocation.y);
    popStyle();
    life--;
  }

  public boolean isDead()
  {
    return(life <= 0);
  }
}
