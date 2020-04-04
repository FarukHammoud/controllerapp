class Thing
{
  PVector location;
  PVector plocation;
  float life = frameRate * 0.5;

  public Thing(float x, float y,float px, float py)
  {
    location = new PVector(x, y);
    plocation = new PVector(px, py);
  }


  public void draw()
  {
    pushStyle();
    strokeWeight(map(life, frameRate/2, 0, 40, 0));
    stroke(255);
    life--;
    if (life > 0)
      line(location.x,location.y,plocation.x,plocation.y);

    popStyle();
  }

  public boolean isDead()
  {
    return(life <= 0);
  }
}
