import hypermedia.net.*;
import java.text.SimpleDateFormat;
PFont small, big;
int PORT_RX=30278;
String HOST_IP = "192.168.1.90";//IP Address of the PC in which this App is running
UDP udp;//Create UDP object for recieving
String wh="";
float temp=0.0;
long timestamp=0;
String timestring="";
String Response;
String emonlink="http://emoncms.org/app?apikey=<read key>#myelectric";
int battery=0;

void setup(){
  size(250,150);
  surface.setTitle("Energy Monitor");
  small = createFont("sansSerif",14);
  big = createFont("sansSerif",32);
  udp= new UDP(this, PORT_RX, HOST_IP);
  udp.log(true);
  udp.listen(true);
  noLoop();
}

void mousePressed() {
  link(emonlink); //Open EmonCMS page when clicked
}

void draw(){
    textFont(big);

background(0);
fill(255);
text("Power="+wh+"W", 5, 30);
text("Temp="+truncate(temp)+"°F", 5, 60);
if(battery == 1) { //Show battery warning
  fill(255,0,0);
  text("BAT",190,60);
}
fill(255);
textFont(small);
text("Last Updated "+timestring, 10, 90);
text("Result "+Response,10,110);
textSize(10);
text("http://emoncms.org/app?apikey=<key 1/2>",10,120);
text("<key 2/2>#myelectric",10,130);
}//end of draw()

float truncate( float x ) {
    return round( x * 100.0f ) / 100.0f;
}

void receive(byte[] data){//, String HOST_IP, int PORT_RX){
  String value=new String(data);
  println(value);
  String[] power = splitTokens(value,"=; ");
  String url="http://emoncms.org/input/post.json?time="+power[15]+"&node=0&csv="+power[5]+","+power[7]+","+power[9]+","+power[11]+","+power[13]+"&apikey=<read/write key>";
  println(url);
  String response[]=loadStrings(url);
 Response=response[0];
  println(Response);
  text("Power="+power[5], 10, 30);
  wh=power[5];
  temp=int(power[9])*1.8+32;
  timestamp = int(power[15]);
  //create new date format
  SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss'Z'"); 
  timestring = format.format(timestamp*1000);
  battery=int(power[11]);
 redraw();
}
