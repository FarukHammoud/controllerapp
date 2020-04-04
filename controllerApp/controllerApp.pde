import ketai.sensors.*;
import android.view.MotionEvent;
import ketai.ui.*;

KetaiVibrate vibe;
KetaiGesture gesture;
KetaiSensor sensor;
UI ui;
Net net;
float accelerometerX, accelerometerY, accelerometerZ;
float cx, cy, cz;
float Size = 10;
float Angle = 0;
PImage img;
ArrayList<Thing> things = new ArrayList<Thing>();
ArrayList<BallWave> ball_waves = new ArrayList<BallWave>();


void onDoubleTap(float x, float y)
{
  //things.add(new Thing("DOUBLE", x, y));
}

void onTap(float x, float y)
{
  ball_waves.add(new BallWave("SINGLE", x, y));
  ui.mColor = color(random(255), random(255), random(255));
  net.post();
}

void onLongPress(float x, float y)
{
  ball_waves.add(new BallWave("LONG", x, y));
  ui.mColor = color(random(255), random(255), random(255));
  vibe.vibrate(50);
}

//the coordinates of the start of the gesture, 
//     end of gesture and velocity in pixels/sec
void onFlick( float x, float y, float px, float py, float v)
{
  //things.add(new Thing("FLICK:"+v, x, y, px, py));
}

void onPinch(float x, float y, float d)
{
  Size = constrain(Size+d, 10, 2000);
}

void onRotate(float x, float y, float ang)
{
  Angle += ang;
}

//these still work if we forward MotionEvents below
void mouseDragged()
{
  things.add(new Thing(mouseX, mouseY, pmouseX, pmouseY));
}

void mousePressed()
{
}


public boolean surfaceTouchEvent(MotionEvent event) {

  //call to keep mouseX, mouseY, etc updated
  super.surfaceTouchEvent(event);

  //forward event to class for processing
  return gesture.surfaceTouchEvent(event);
}



void setup()
{
  net = new Net();
  sensor = new KetaiSensor(this);
  gesture = new KetaiGesture(this);
  vibe = new KetaiVibrate(this);
  ui = new UI();
  sensor.start();
  orientation(PORTRAIT);
  textAlign(CENTER, CENTER);
  imageMode(CENTER);
  textSize(36);
}

void draw()
{
  ui.draw();
}

void onAccelerometerEvent(float x, float y, float z)
{
  accelerometerX = x;
  accelerometerY = y;
  accelerometerZ = z;
  float n = sqrt(x*x+y*y+z*z);
  cx = x/n;
  cy = y/n;
  cz = z/n;
}
