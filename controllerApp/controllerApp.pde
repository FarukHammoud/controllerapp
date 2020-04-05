import ketai.sensors.*;
import android.view.MotionEvent;
import ketai.ui.*;

KetaiVibrate vibe;
KetaiGesture gesture;
KetaiSensor sensor;
KetaiKeyboard keyboard;
UI ui;
Net net;
float accelerometerX, accelerometerY, accelerometerZ;
float rotationX, rotationY, rotationZ;
float cx, cy, cz;
float Size = 10;
float Angle = 0;
PImage img;
String code = "a1b2c3";
Boolean keyboard_flag = false;
ArrayList<Thing> things = new ArrayList<Thing>();
ArrayList<BallWave> ball_waves = new ArrayList<BallWave>();


void onDoubleTap(float x, float y)
{
  net.sendDoubleTap(x, y);
}

void onTap(float x, float y)
{
  ball_waves.add(new BallWave("SINGLE", x, y));
  ui.mColor = color(random(255), random(255), random(255));
  net.sendTap(x, y);
}

void onLongPress(float x, float y)
{
  ball_waves.add(new BallWave("LONG", x, y));
  ui.mColor = color(random(255), random(255), random(255));
  vibe.vibrate(50);
  net.sendLongPress(x, y);
}

//the coordinates of the start of the gesture, 
//     end of gesture and velocity in pixels/sec
void onFlick( float x, float y, float px, float py, float v)
{
  //things.add(new Thing("FLICK:"+v, x, y, px, py));
  net.sendFlick(x, y, px, py, v);
}

void onPinch(float x, float y, float d)
{
  Size = constrain(Size+d, 1, 2000);
  net.sendPinch(x, y, d);
}

void onRotate(float x, float y, float ang)
{
  Angle += ang;
  net.sendRotation(x, y, ang);
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
  keyboard = new KetaiKeyboard();
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
  if (Size<=2 && !keyboard_flag) {
    keyboard.show(this);
    keyboard_flag = true;
  } else if (Size>2 && keyboard_flag) {
    keyboard.hide(this);
    keyboard_flag = false;
  }
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
  net.sendAccelerometer(x, y, z);
}
void onGyroscopeEvent(float x, float y, float z)
{
  rotationX = x;
  rotationY = y;
  rotationZ = z;
  net.sendGyroscope(x, y, z);
}
