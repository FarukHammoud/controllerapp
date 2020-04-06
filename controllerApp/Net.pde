import java.io.*;
import java.net.*;
import java.util.UUID;

class Net
{
  JSONObject jsonParam;
  String uuid;
  
  public Net()
  {
    this.uuid = UUID.randomUUID().toString();
  }
  public void sendTap(float x, float y){
     jsonParam = new JSONObject();
     jsonParam.put("evnType", "Tap");
     jsonParam.put("x", y);
     jsonParam.put("y", x);
     sendPost();
  }
  public void sendLongPress(float x, float y){
     jsonParam = new JSONObject();
     jsonParam.put("evnType", "Long Press");
     jsonParam.put("x", y);
     jsonParam.put("y", x);
     sendPost();
  }
  public void sendRotation(float x, float y,float angle){
     jsonParam = new JSONObject();
     jsonParam.put("evnType", "Rotation");
     jsonParam.put("x", y);
     jsonParam.put("y", x);
     jsonParam.put("angle", angle);
     sendPost();
  }
  public void sendPinch(float x, float y,float d){
     jsonParam = new JSONObject();
     jsonParam.put("evnType", "Pinch");
     jsonParam.put("x", y);
     jsonParam.put("y", x);
     jsonParam.put("d", d);
     sendPost();
  }
  public void sendAccelerometer(float ax, float ay,float az){
     jsonParam = new JSONObject();
     jsonParam.put("evnType", "Accelerometer");
     jsonParam.put("ax", ay);
     jsonParam.put("ay", ax);
     jsonParam.put("az", az);
     sendPost();
  }
  public void sendGyroscope(float gx, float gy,float gz){
     jsonParam = new JSONObject();
     jsonParam.put("evnType", "Gyroscope");
     jsonParam.put("gx", gx);
     jsonParam.put("gy", gy);
     jsonParam.put("gz", gz);
     sendPost();
  }
  public void sendDoubleTap(float x, float y){
     jsonParam = new JSONObject();
     jsonParam.put("evnType", "Double Tap");
     jsonParam.put("x", y);
     jsonParam.put("y", x);
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
     sendPost();
  }
  private void sendPost() {
    
    Thread thread = new Thread(new Runnable() {
      @Override
        public void run() {
        try {
          URL url = new URL("http://controller.viarezo.fr/multicast/"+code);
          HttpURLConnection conn = (HttpURLConnection) url.openConnection();
          conn.setRequestMethod("POST");
          conn.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
          conn.setRequestProperty("Accept", "application/json");
          conn.setDoOutput(true);
          conn.setDoInput(true);
          
          jsonParam.put("id", uuid);
          println("JSON", jsonParam.toString());
          DataOutputStream os = new DataOutputStream(conn.getOutputStream());
          //os.writeBytes(URLEncoder.encode(jsonParam.toString(), "UTF-8"));
          os.writeBytes(jsonParam.toString());

          os.flush();
          os.close();

          println("STATUS", String.valueOf(conn.getResponseCode()));
          println("MSG", conn.getResponseMessage());

          conn.disconnect();
        } 
        catch (Exception e) {
          e.printStackTrace();
        }
      }
    }
    );

    thread.start();
  }
}
