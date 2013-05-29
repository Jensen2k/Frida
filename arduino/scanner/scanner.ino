#include <avr/pgmspace.h>

#include <avrpins.h>
#include <max3421e.h>
#include <usbhost.h>
#include <usb_ch9.h>
#include <Usb.h>
#include <usbhub.h>
#include <avr/pgmspace.h>
#include <address.h>
#include <hidboot.h>

#include <printhex.h>
#include <message.h>
#include <hexdump.h>
#include <parsetools.h>

#include <SPI.h>
#include <Ethernet.h>
#include <QueueList.h>

enum FMethod {
    GET,
    POST
};

class FRequest {
  public:
    void setRequest(FMethod method, String path, String data);
    void setContentType(String type);
    String getRequestData();
    void execute();
    String requestData;
    String respondData;
    bool isSendt;

  private:
    FMethod method;
    String path;
    String data;
    String contentType;
    String identifier;
    int getContentLength();
    void build();

};


void FRequest::setRequest(FMethod m, String p, String d) {
  method = m;
  path = p;
  data = d;
  isSendt = false;
  contentType = "application/json";
  identifier = String(random(10, 1000));
  // Build the request
  build();
}

void FRequest::setContentType(String type) {
  contentType = type;
}

int FRequest::getContentLength() {
  return data.length();
}


// Build the request by concatenating strings
void FRequest::build() {

  String methodStr;
  if(method == GET) {
    methodStr = "GET";
  } else {
    methodStr = "POST";
  }

  requestData = methodStr+" "+path+" HTTP/1.1;"
  " Host: www.fridafridge.com;"
  " User-Agent: frida+arduino;"
  " X-Request-Identifier: "+identifier+";"
  " Connection: close;"
  " Content-Type: "+contentType+";"
  " Content-Length: "+getContentLength()+";"
  " ;"
  " {\"test\": \"hello\"};"
  " ;";

}

class FNetwork {
  public:
    FNetwork();
    void sendBarcode(String code);
    void init(IPAddress ip);
    void addRequest(FRequest request);
    void task();
    void executeRequest(FRequest request);
    bool hasRequests();
    FRequest request;

    IPAddress dns;
    byte mac[];

  private:
    QueueList <FRequest> requests;
    FRequest getRequest();

};

class FScanner : public KeyboardReportParser
{
  public:
    FScanner();
    FNetwork networking;

  private:
    String barcode;

  protected:
    virtual void OnKeyDown(uint8_t mod, uint8_t key);
    virtual void OnKeyPressed(uint8_t key);
};

FScanner::FScanner() {
  barcode = "";
}

void FScanner::OnKeyDown(uint8_t mod, uint8_t key)
{
  uint8_t c = OemToAscii(mod, key);

  if (c)
    OnKeyPressed(c);
}


void FScanner::OnKeyPressed(uint8_t key)
{

  static uint32_t next_time = 0;      //watchdog

  if( millis() > next_time ) {
    Serial.println(barcode);
    FRequest req;
    req.setRequest(POST, "/test", "hello, mom");
    networking.addRequest(req);

    barcode = "";
  }

    next_time = millis() + 200;  //reset watchdog
    barcode.concat((char)key);

};



void FNetwork::sendBarcode(String code) {
  Serial.println("Sending: " + code);
}

bool FNetwork::hasRequests() {
  return !requests.isEmpty();
}

FNetwork::FNetwork() {
  byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
  //dns = dns(1,1,1,1);
}

FRequest FNetwork::getRequest() {
  return requests.pop();
}


// Only function called from loop
void FNetwork::task() {

  if(!request.isSendt) {
    Serial.println("Sendingr equest!");
    executeRequest(request);
    request.isSendt = true;
  }
}

void FNetwork::executeRequest(FRequest r) {
  String data = r.requestData;
  Serial.println(data);
  /*while ((str = strtok_r(data, ";", &data)) != NULL) // delimiter is the semicolon
    Serial.println(str);
    */
}

void FNetwork::addRequest(FRequest r) {
  request = request;
}

void FNetwork::init(IPAddress ip) {

  // give the ethernet module time to boot up:
  delay(1000);

  // start the Ethernet connection using a fixed IP address and DNS server:
  Ethernet.begin(mac, ip, dns);

  // print the Ethernet board/shield's IP address:
  Serial.print("My IP address: ");
  Serial.println(Ethernet.localIP());

}


USB  Usb;
HIDBoot<HID_PROTOCOL_KEYBOARD> HidKeyboard(&Usb);
uint32_t next_time;

FScanner scanner;
FNetwork networking;
EthernetClient client;

IPAddress ip(192,168,0,2);
IPAddress server(192, 168,0,1);
unsigned long lastConnectionTime = 0;          // last time you connected to the server, in milliseconds
boolean lastConnected = false;                 // state of the connection last time through the main loop
const unsigned long postingInterval = 15*60*1000;  // delay between updates, in milliseconds


void setup()
{
  Serial.begin( 115200 );
  setupScanner();
  networking.init(ip);

}


void setupScanner() {
  Serial.println("Starting scanner");

  if (Usb.Init() == -1)
    Serial.println("OSC did not start.");

  delay( 200 );
  next_time = millis() + 5000;
  HidKeyboard.SetReportParser(0, (HIDReportParser*)&scanner);
  scanner.networking = networking;
}



void setupNetwork() {


  }



void loop()
{
  Usb.Task();
  networking.task();
}
/*

void httpAction() {
    // if there's incoming data from the net connection.
  // send it out the serial port.  This is for debugging
  // purposes only:
  if (client.available()) {
    char c = client.read();
    Serial.print(c);
  }

  // if there's no net connection, but there was one last time
  // through the loop, then stop the client:
  if (!client.connected() && lastConnected) {
    Serial.println();
    Serial.println("disconnecting.");
    client.stop();
  }

  // if you're not connected, and ten seconds have passed since
  // your last connection, then connect again and send data:
  if(!client.connected() && (millis() - lastConnectionTime > postingInterval)) {
    httpRequest();
  }
  // store the state of the connection for next time through
  // the loop:
  lastConnected = client.connected();
}


// this method makes a HTTP connection to the server:
void httpRequest() {
  // if there's a successful connection:
  float value = analogRead(1);
  float voltage = (value/1024.0)*5.0;
  float temp = (voltage-0.5)*100;
  float temp = 35.0;

  Serial.println(temp);
  char charBuf[15];
  dtostrf(temp, 1, 0, charBuf);
  String tempString = "12";

  if (client.connect(server, 3000)) {
    Serial.println("connecting...");
    // send the HTTP PUT request:
    client.println("POST /fridges/1/temp HTTP/1.1");
    client.println("Host: www.arduino.cc");
    client.println("User-Agent: arduino-ethernet");
    client.println("Connection: close");
    client.println("Content-Type: application/json");
    client.println("Content-Length: 12");
    client.println();
    client.println("{\"temp\": "+tempString+"}");
    client.println();

    // note the time that the connection was made:
    lastConnectionTime = millis();
  }
  else {
    // if you couldn't make a connection:
    Serial.println("connection failed");
    Serial.println("disconnecting.");
    client.stop();
  }
}
*/

