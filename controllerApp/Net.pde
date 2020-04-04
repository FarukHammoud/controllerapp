import java.io.*;
import java.net.*;
//import javax.net.ssl.HttpsURLConnection;

public void writeStream(OutputStream out) {
  String jsonInputString = "{\"name\": \"Upendra\", \"job\": \"Programmer\"}";
  try {
    out.write(jsonInputString.getBytes());
    out.flush();
    print("flushing");
  }
  catch (IOException error) {
    //Lida com os erros de entra e saída
    println(error);
  }
}
public void post_thread() {
  try {
    println("posting...");
    URL url = new URL("http://localhost/multicast/a1b2c3");  
    HttpURLConnection con = (HttpURLConnection) url.openConnection();
    con.setRequestProperty("Content-Type", "application/json; utf-8");
    con.setRequestProperty("Accept", "application/json");
    con.setRequestMethod("POST");
    con.setRequestProperty("Key", "Value");
    con.setDoOutput(true);
    OutputStream outputPost = new BufferedOutputStream(con.getOutputStream());
    writeStream(outputPost);
    outputPost.flush();
    outputPost.close();
  }
  catch(Exception error) {
    //Handles an incorrectly entered URL
    println(error);
  }
}

class Net
{

  public Net()
  {
  }
  public void post() {
    thread("post_thread");
  }
}
