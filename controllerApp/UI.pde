class UI
{
  color mColor;
  PVector plocation;
  String  mText="";
  float life = frameRate * 3;

  public UI()
  {
    mColor = color(0, 0, 0);
  }

  private void fade()
  {
    color black = color(0,0,0);
    mColor = lerpColor(mColor, black, 1/frameRate,1);
  }
  private void axis()
  {
    pushStyle();
    pushMatrix();
    translate(0.90*width,height-0.1*width);
    strokeWeight(4/50.0);
    scale(width/16);
    //x*cos()-y*sin(),x*sin()+y*cos()
    //cx,cy,cz
    //cy/sqrt(cx*cx+cy*cy),-cx/sqrt(cx*cx+cy*cy),0
    //
    
    float n = sqrt(1+cy*cy/(cx*cx)+(cx*cx*cx*cx+cx*cx*cy*cy+cy*cy*cy*cy)/(cx*cx*cz*cz));
    stroke(255,0,0);
    line(0,0,cx*cos(Angle)-cy*sin(Angle),cx*sin(Angle)+cy*cos(Angle));
    stroke(0,255,0);
    line(0,0,(cy/sqrt(cx*cx+cy*cy))*cos(Angle)+(cx/sqrt(cx*cx+cy*cy))*sin(Angle),(cy/sqrt(cx*cx+cy*cy))*sin(Angle)-(cx/sqrt(cx*cx+cy*cy))*cos(Angle));
    stroke(0,0,255);
    line(0,0,(1/n)*cos(Angle)-(cy/(n*cx))*sin(Angle),(1/n)*sin(Angle)+(cy/(n*cx))*cos(Angle));
    popStyle();
    popMatrix();
  
  }
  public void draw()
  {
    pushStyle();
    background(mColor);
    fade();
    axis();
    //text("Accelerometer: \n" + 
    //  "x: " + nfp(accelerometerX, 1, 3) + "\n" +
     // "y: " + nfp(accelerometerY, 1, 3) + "\n" +
     // "z: " + nfp(accelerometerZ, 1, 3), 0, 0, width, height);

    pushMatrix();
    translate(width/2, height/2);
    rotate(Angle);
    fill(255, 0, 0);
    rect( -Size/2, -Size/2, Size, Size);
    popMatrix();
    fill(255);
    circle(mouseX,mouseY,5);

    //if we have things lets reverse through them 
    //  so we can delete dead ones and draw live ones
    if (things.size() > 0) {
      for (int i = things.size()-1; i >= 0; i--)
      {
        Thing t = things.get(i);
        if (t.isDead())
          things.remove(t);
        else
          t.draw();
      }
    }
    if (ball_waves.size() > 0) {
      for (int i = ball_waves.size()-1; i >= 0; i--)
      {
        BallWave b = ball_waves.get(i);
        if (b.isDead())
          ball_waves.remove(b);
        else
          b.draw();
      }
    }
    popStyle();
    
  }
}
