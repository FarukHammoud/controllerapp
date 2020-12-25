package ml.controllerapp.controllerapp;

import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import ketai.sensors.*;
import android.view.MotionEvent;
import ketai.ui.*;
//import java.io.*;
import java.net.*;
import java.net.URI;
import java.net.URL;
import java.net.HttpURLConnection;
import java.util.UUID;

/*
import io.socket.client.Socket;
import io.socket.client.IO;
import io.socket.client.Manager;
import io.socket.*;
import io.socket.engineio.client.transports.Polling;
import io.socket.engineio.client.transports.WebSocket;


 */

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;
import java.io.DataOutputStream;
import android.os.Bundle;

import com.github.nkzawa.socketio.client.IO;
import com.github.nkzawa.socketio.client.Socket;


public class controllerApp extends PApplet {

  //https://socket.io/blog/native-socket-io-and-android/
  private Socket mSocket;
  {
    try {
      mSocket = IO.socket("http://www.controllerapp.ml");
    } catch (URISyntaxException e) {
      println(e);
    }
  }

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    mSocket.connect();
    mSocket.emit("cast", "Hello World");
  }

  @Override
  public void onDestroy() {
    super.onDestroy();

    mSocket.disconnect();
    //Shut down all listeners
    //mSocket.off("new message", onNewMessage);
  }

  KetaiVibrate vibe;
  KetaiGesture gesture;
  KetaiSensor sensor;
  KetaiKeyboard keyboard;
  UI ui;
  Net net;

  int DELAY = 50;

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
  float last_tap = 0;

  float cx, cy, cz;
  float Size = 400;
  float Angle = 3.5f;
  PImage img;
  String code = "a1b2c3";
  String text = "";
  Boolean keyboard_flag = false;
  ArrayList<Thing> things = new ArrayList<Thing>();
  ArrayList<BallWave> ball_waves = new ArrayList<BallWave>();


  public void onDoubleTap(float x, float y)
  {
    if (!keyboard_flag) {
      net.sendDoubleTap(x, y);
    }
  }

  public void onTap(float x, float y)
  {
    if (millis() - last_tap > 50){
      last_tap = millis();
      if (!keyboard_flag) {
        ball_waves.add(new BallWave("SINGLE", x, y));
        ui.mColor = color(random(255), random(255), random(255));
        net.sendTap(x, y);
      }
    }
  }

  public void onLongPress(float x, float y)
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
  public void onFlick( float x, float y, float px, float py, float v)
  {
    //things.add(new Thing("FLICK:"+v, x, y, px, py));
    if (!keyboard_flag) {
      net.sendFlick(x, y, px, py, v);
    }
  }

  public void onPinch(float x, float y, float d)
  {
    if (d != 0) {
      Size = constrain(Size+d, 1, 2000);
      net.sendPinch(x, y, d);
    }
  }

  public void onRotate(float x, float y, float ang)
  {
    //rotation += ang;
    Angle += ang;
    //if (millis() - last_rotation > DELAY) {
    //  last_rotation = millis();
    //  net.sendRotation(x, y, rotation);
    //  rotation = 0;
    //}
  }

  //these still work if we forward MotionEvents below
  public void mouseDragged()
  {
    things.add(new Thing(mouseX, mouseY, pmouseX, pmouseY));
  }

  public void mousePressed()
  {
    //things.add(new Thing(mouseX, mouseY, pmouseX, pmouseY));
  }
  public void keyPressed() {
    last_keyboard = millis();
    if (key == CODED) {
      if (keyCode == BACKSPACE) {
        if (mouseY<0.3f*height) {
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
      if (mouseY<0.15f*height) {
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



  public void setup()
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

  public void draw()
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
      if (mouseY<0.15f*height) {
        stroke(0,255,0);
      } else {
        stroke(150,150,150);
      }
      noFill();
      strokeWeight(3);
      rect(width*0.72f, width*0.02f, width*0.24f, width*0.08f, width*0.08f);
      textSize(height*0.03f);
      textAlign(LEFT, CENTER);
      fill(255);
      text("code", 0.56f*width, 0.06f*width);
      textAlign(CENTER, CENTER);
      text(code, 0.84f*width, 0.06f*width);
      textSize(height*0.06f);
      fill(200, 200, 200);
      textAlign(CENTER, CENTER);
      fill(0, max(0, 255-PApplet.parseInt((millis()-last_keyboard)/8.0f)), 0);
      if (255-PApplet.parseInt((millis()-last_keyboard)/8.0f)<0 && text.length()>0) {
        net.sendText(text);
        text = "";
      }
      text(text, 0.5f*width, 0.35f*height);
    }
  }

  public void onAccelerometerEvent(float x, float y, float z)
  {
    accelerometerX = x;
    accelerometerY = y;
    accelerometerZ = z;
    float n = sqrt(x*x+y*y+z*z);
    cx = x/n;
    cy = y/n;
    cz = z/n;

//  if (millis()-last_accelerometer > DELAY) {
//   last_accelerometer = millis();
//    net.sendAccelerometer(accelerometerX, accelerometerY, accelerometerZ);
//  }
  }
  public void onGyroscopeEvent(float x, float y, float z)
  {
    rotationX += x;
    rotationY += y;
    rotationZ += z;
    if (millis()-last_gyroscope > DELAY) {
      last_gyroscope = millis();
      net.sendRTD(accelerometerX, accelerometerY, accelerometerZ, rotationX, rotationY, rotationZ, Angle, Size);
      rotationX = 0;
      rotationY = 0;
      rotationZ = 0;
    }
  }
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



  class Net
  {
    JSONObject jsonParam;
    String uuid;
    Socket orderSocket;

    public Net()
    {
      this.uuid = UUID.randomUUID().toString();
    }
    public void sendTap(float x, float y){
      jsonParam = new JSONObject();
      jsonParam.put("evnType", "Tap");
      jsonParam.put("x", y);
      jsonParam.put("y", x);
      jsonParam.put("id", uuid);
      jsonParam.put("code",code);
      sendPost();
    }
    public void sendLongPress(float x, float y){
      jsonParam = new JSONObject();
      jsonParam.put("evnType", "Long Press");
      jsonParam.put("x", y);
      jsonParam.put("y", x);
      jsonParam.put("id", uuid);
      jsonParam.put("code",code);
      sendPost();
    }
    public void sendRotation(float x, float y,float angle){
      jsonParam = new JSONObject();
      jsonParam.put("evnType", "Rotation");
      jsonParam.put("x", y);
      jsonParam.put("y", x);
      jsonParam.put("angle", angle);
      jsonParam.put("id", uuid);
      jsonParam.put("code",code);
      sendPost();
    }
    public void sendPinch(float x, float y,float d){
      jsonParam = new JSONObject();
      jsonParam.put("evnType", "Pinch");
      jsonParam.put("x", y);
      jsonParam.put("y", x);
      jsonParam.put("d", d);
      jsonParam.put("id", uuid);
      jsonParam.put("code",code);
      sendPost();
    }
    public void sendAccelerometer(float ax, float ay,float az){
      jsonParam = new JSONObject();
      jsonParam.put("evnType", "Accelerometer");
      jsonParam.put("ax", ax);
      jsonParam.put("ay", ay);
      jsonParam.put("az", az);
      jsonParam.put("id", uuid);
      jsonParam.put("code",code);
      sendPost();
    }
    public void sendRTD(float ax, float ay,float az, float gx, float gy,float gz, float angle, float Size){
      jsonParam = new JSONObject();
      jsonParam.put("evnType", "RTD");
      jsonParam.put("ax", ax);
      jsonParam.put("ay", ay);
      jsonParam.put("az", az);
      jsonParam.put("gx", gx);
      jsonParam.put("gy", gy);
      jsonParam.put("gz", gz);
      jsonParam.put("angle", angle);
      jsonParam.put("size", Size);
      jsonParam.put("id", uuid);
      jsonParam.put("code",code);
      sendPost();
    }
    public void sendGyroscope(float gx, float gy,float gz){
      jsonParam = new JSONObject();
      jsonParam.put("evnType", "Gyroscope");
      jsonParam.put("gx", gx);
      jsonParam.put("gy", gy);
      jsonParam.put("gz", gz);
      jsonParam.put("id", uuid);
      jsonParam.put("code",code);
      sendPost();
    }
    public void sendDoubleTap(float x, float y){
      jsonParam = new JSONObject();
      jsonParam.put("evnType", "Double Tap");
      jsonParam.put("x", y);
      jsonParam.put("y", x);
      jsonParam.put("id", uuid);
      jsonParam.put("code",code);
      sendPost();
    }
    public void sendFlick(float x, float y,float px, float py,float v){
      jsonParam = new JSONObject();
      jsonParam.put("evnType", "Flick");
      jsonParam.put("x", y);
      jsonParam.put("y", x);
      jsonParam.put("px", px);
      jsonParam.put("py", py);
      jsonParam.put("v", v);
      jsonParam.put("id", uuid);
      jsonParam.put("code",code);
      sendPost();
    }
    public void sendText(String text_){
      jsonParam = new JSONObject();
      jsonParam.put("evnType", "Text");
      jsonParam.put("text", text_);
      jsonParam.put("id", uuid);
      jsonParam.put("code",code);
      sendPost();
    }
    private void sendPost() {

      Thread thread = new Thread(new Runnable() {
        @Override
        public void run() {
          try {
            //println("JSON", jsonParam.toString());
            print(".");
            mSocket.emit("cast", jsonParam.toString());
          }
          catch (Exception e) {
            e.printStackTrace();
          }
        }
      });
      thread.start();
    }
  }
  class Thing
  {
    PVector location;
    PVector plocation;
    float life = frameRate * 0.5f;

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
  class UI
  {
    int mColor;
    PVector plocation;
    String  mText="";
    float life = frameRate * 3;

    public UI()
    {
      mColor = color(0, 0, 0);
    }

    private void fade()
    {
      int black = color(0,0,0);
      mColor = lerpColor(mColor, black, 1/frameRate,1);
    }
    private void axis()
    {
      pushStyle();
      pushMatrix();
      translate(0.90f*width,height-0.1f*width);
      strokeWeight(4/50.0f);
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
      noStroke();
      rect( -Size/2, -Size/2, Size, Size);
      popMatrix();
      //if we have things lets reverse through them
      //  so we can delete dead ones and draw live ones
      print(things.size());
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
}
