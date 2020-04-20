import ketai.sensors.*;
import android.view.MotionEvent;
import ketai.ui.*;

KetaiVibrate vibe;
KetaiGesture gesture;
KetaiSensor sensor;
KetaiKeyboard keyboard;
UI ui;
Net net;

int DELAY = 200;

float accelerometerX = 0;
float accelerometerY = 0;
float accelerometerZ = 0;
float rotation = 0;
float rotationX = 0;
float rotationY = 0;
float rotationZ = 0;

float last_rotation = 0;
float last_accelerometer = 0;
float last_gyroscope = 0;
float last_keyboard = 0;

float cx, cy, cz;
float Size = 400;
float Angle = 3.5;
PImage img;
String code = "a1b2c3";
String text = "";
Boolean keyboard_flag = false;
ArrayList<Thing> things = new ArrayList<Thing>();
ArrayList<BallWave> ball_waves = new ArrayList<BallWave>();


void onDoubleTap(float x, float y)
{
  if (!keyboard_flag) {
    net.sendDoubleTap(x, y);
  }
}

void onTap(float x, float y)
{
  if (!keyboard_flag) {
    ball_waves.add(new BallWave("SINGLE", x, y));
    ui.mColor = color(random(255), random(255), random(255));
    net.sendTap(x, y);
  }
}

void onLongPress(float x, float y)
{
  if (!keyboard_flag) {
    ball_waves.add(new BallWave("LONG", x, y));
    ui.mColor = color(random(255), random(255), random(255));
    vibe.vibrate(50);
    net.sendLongPress(x, y);
  }
}

//the coordinates of the start of the gesture, 
//     end of gesture and velocity in pixels/sec
void onFlick( float x, float y, float px, float py, float v)
{
  //things.add(new Thing("FLICK:"+v, x, y, px, py));
  if (!keyboard_flag) {
    net.sendFlick(x, y, px, py, v);
  }
}

void onPinch(float x, float y, float d)
{
  if (d != 0) {
    Size = constrain(Size+d, 1, 2000);
    net.sendPinch(x, y, d);
  }
}

void onRotate(float x, float y, float ang)
{
  rotation += ang;
  Angle += ang;
  if (millis() - last_rotation > DELAY) {
    last_rotation = millis();
    net.sendRotation(x, y, rotation);
    rotation = 0;
  }
}

//these still work if we forward MotionEvents below
void mouseDragged()
{
  things.add(new Thing(mouseX, mouseY, pmouseX, pmouseY));
}

void mousePressed()
{
}
void keyPressed() {
  last_keyboard = millis();
  if (key == CODED) {
    if (keyCode == BACKSPACE) {
      if (mouseY<0.3*height) {
        if (code.length()>0) {
          code = code.substring(0, code.length() - 1);
        }
      } else {
        if (text.length()>0) {
          text = text.substring(0, text.length() - 1);
        }
      }
    }
  } else {
    if (mouseY<0.15*height) {
      code += str(key);
      code = code.substring(0, min(6, code.length()));
    } else {
      text += str(key);
    }
  }
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
  imageMode(CENTER);
}

void draw()
{
  ui.draw();
  if (Size<=2 && !keyboard_flag) {
    keyboard.show(this);
    keyboard_flag = true;
    text = "";
  } else if (Size>2 && keyboard_flag) {
    keyboard.hide(this);
    keyboard_flag = false;
  }
  if (keyboard_flag) {
    if (mouseY<0.15*height) {
      stroke(0,255,0);
    } else {
      stroke(150,150,150);
    }
    noFill();
    strokeWeight(3);
    rect(width*0.72, width*0.02, width*0.24, width*0.08, width*0.08);
    textSize(height*0.03);
    textAlign(LEFT, CENTER);
    fill(255);
    text("code", 0.56*width, 0.06*width);
    textAlign(CENTER, CENTER);
    text(code, 0.84*width, 0.06*width);
    textSize(height*0.06);
    fill(200, 200, 200);
    textAlign(CENTER, CENTER);
    fill(0, max(0, 255-int((millis()-last_keyboard)/8.0)), 0);
    if (255-int((millis()-last_keyboard)/8.0)<0 && text.length()>0) {
      net.sendText(text);  
      text = "";
    }
    text(text, 0.5*width, 0.35*height);
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

  if (millis()-last_accelerometer > DELAY) {
    last_accelerometer = millis();
    net.sendAccelerometer(accelerometerX, accelerometerY, accelerometerZ);
    accelerometerX = 0;
    accelerometerY = 0;
    accelerometerZ = 0;
  }
}
void onGyroscopeEvent(float x, float y, float z)
{
  rotationX += x;
  rotationY += y;
  rotationZ += z;
  if (millis()-last_gyroscope > DELAY) {
    last_gyroscope = millis();
    net.sendGyroscope(rotationX, rotationY, rotationZ);
    rotationX = 0;
    rotationY = 0;
    rotationZ = 0;
  }
}
